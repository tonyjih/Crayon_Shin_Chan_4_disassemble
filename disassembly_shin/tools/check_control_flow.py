#!/usr/bin/env python3
"""Check symbolic branches and dispatch tables without treating ROM data as code."""
from __future__ import annotations

import argparse
from collections import Counter
from pathlib import Path
import re


BRANCH = re.compile(r"^(jp|jr|call)\s+(?:(?:nz|z|nc|c)\s*,\s*)?(.+)$", re.I)
LITERAL = re.compile(r"^\s*\(*\s*(?:\$|0x|%|[0-9@+\-])", re.I)
LABEL = re.compile(r"^[A-Za-z_.][\w.]*::?$")
INSTRUCTION = re.compile(
    r"^(?:adc|add|and|bit|call|ccf|cp|cpl|daa|dec|di|ei|halt|inc|jp|jr|ld|ldh|"
    r"nop|or|pop|push|res|ret|reti|rl|rla|rlc|rlca|rr|rra|rrc|rrca|rst|sbc|scf|"
    r"set|sla|sra|srl|stop|sub|swap|xor)\b", re.I
)


def audit(path: Path, source: str, *, symbolic_memory: bool = False) -> tuple[list[str], Counter]:
    lines = [line.split(";", 1)[0].strip() for line in source.splitlines()]
    errors: list[str] = []
    counts: Counter = Counter()

    def error(index: int, message: str) -> None:
        errors.append(f"{path.name}:{index + 1}: {message}")

    def word_table(index: int) -> None:
        entries = 0
        for row in range(index + 1, len(lines)):
            code = lines[row]
            if not code or LABEL.fullmatch(code):
                continue
            words = re.fullmatch(r"dw\s+(.+)", code, re.I)
            if not words:
                break
            for operand in words[1].split(","):
                if LITERAL.match(operand):
                    error(row, f"dispatch target must use a symbol: {operand.strip()}")
                entries += 1
        if not entries:
            error(index, "dispatch table must contain DW symbols")
        counts["table_entries"] += entries

    previous = ""
    for index, code in enumerate(lines):
        if not code or LABEL.fullmatch(code):
            if re.fullmatch(r"Bank[123]FarCallTable::?", code):
                counts["farcall_tables"] += 1
                word_table(index)
            continue
        if symbolic_memory and re.match(r"ldh?\s", code, re.I):
            if re.search(r"\[\s*\$[0-9a-f]{4}\s*\]", code, re.I):
                error(index, "memory operand must use a symbol or named base + offset")
            if re.match(r"ld\s+(?:hl|de|bc|sp),\s*\$[cd][0-9a-f]{3}\b", code, re.I):
                error(index, "WRAM pointer must use a symbol or named base + offset")
        branch = BRANCH.fullmatch(code)
        if branch:
            operand = branch[2].strip()
            if LITERAL.match(operand):
                error(index, f"branch target must use a symbol: {operand}")
            elif operand.lower() in ("hl", "[hl]"):
                counts["indirect_branches"] += 1
            else:
                counts["symbolic_branches"] += 1
            if operand == "FarCallFromBankTable" and re.fullmatch(
                r"ld\s+hl,\s*(?:\$[0-9a-f]+|0x[0-9a-f]+|\d+)", previous, re.I
            ):
                error(index, "far-call selector must use a named constant")
        if re.fullmatch(r"rst\s+(?:\$0+|0|RST_00)", code, re.I):
            counts["rst00_tables"] += 1
            word_table(index)
        if path.stem in ("bank_005", "bank_006", "bank_007") and INSTRUCTION.match(code):
            error(index, "graphics bank contains an instruction; encode its data bytes")
        previous = code
    return errors, counts


def self_test() -> None:
    code = """rst $00
Table::
    dw Handler, Handler + 2 ; $1234 in a comment is not an operand.
Handler::
    jr z, Handler
    call nz, Other
    jp hl
    rst $38
    ld hl, $9800
    db $c3, $00, $40
"""
    errors, counts = audit(Path("bank_001.asm"), code)
    assert not errors, errors
    assert counts["rst00_tables"] == 1 and counts["table_entries"] == 2
    assert counts["symbolic_branches"] == 2 and counts["indirect_branches"] == 1
    for operand in ("$1234", "0x1234", "4660", "@+$10", "($1234)"):
        assert audit(Path("bank_002.asm"), f"call nc, {operand}")[0], operand
    assert audit(Path("bank_002.asm"), "rst $00\n dw $4567")[0]
    assert audit(Path("bank_002.asm"), "rst $00\n db $67, $45")[0]
    assert audit(Path("bank_002.asm"), "ld hl, $0200\n call FarCallFromBankTable")[0]
    assert audit(Path("bank_005.asm"), "nop")[0]
    assert not audit(Path("bank_005.asm"), "db $00, $c3, $12, $34")[0]
    assert audit(Path("bank_003.asm"), "Bank3FarCallTable::\n dw $418d")[0]
    for code in ("ld a, [$d940]", "ldh [$ffca], a", "ld hl, $d800"):
        assert audit(Path("bank_002.asm"), code, symbolic_memory=True)[0], code
    assert not audit(Path("bank_002.asm"), "ld a, [$d940]")[0]
    for code in ("ld a, [wSharedWork + $140]", "ld hl, -$0100", "db $ea, $40, $d9"):
        assert not audit(Path("bank_002.asm"), code, symbolic_memory=True)[0], code


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--self-test", action="store_true")
    parser.add_argument("--require-symbolic-memory", action="store_true",
                        help="reject raw memory operands and WRAM pointer literals")
    parser.add_argument("--asm-dir", type=Path,
                        default=Path(__file__).resolve().parent.parent)
    args = parser.parse_args()
    if args.self_test:
        self_test()
        print("Control-flow checker self-tests passed.")
        return 0
    errors: list[str] = []
    totals: Counter = Counter()
    paths = sorted(args.asm_dir.glob("bank_*.asm"))
    if not paths:
        parser.error("no bank_*.asm source files found")
    for path in paths:
        found, counts = audit(path, path.read_text(encoding="utf-8-sig"),
                              symbolic_memory=args.require_symbolic_memory)
        errors.extend(found)
        totals.update(counts)
    if errors:
        print("\n".join(errors))
        return 1
    print(
        f"OK: {totals['symbolic_branches']} symbolic branches, "
        f"{totals['indirect_branches']} indirect branches, "
        f"{totals['rst00_tables']} RST $00 tables, "
        f"{totals['farcall_tables']} original far-call tables."
    )
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
