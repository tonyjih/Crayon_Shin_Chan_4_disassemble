#!/usr/bin/env python3
"""
Batch-extract Shin-chan 4 PrevByteRLE assets, v2.

Key differences from v1:
  - Scans LoadMainGfx/DecodePrevByteRLEGfx call sites from asm.
  - Reads compressed bytes directly from a ROM binary instead of reconstructing bank bytes from asm/INCBIN.
  - Uses conservative backward register analysis. If A/HL/DE are modified between their literal load and the call,
    the call site is reported as unresolved instead of being decoded from a bogus address.

Usage:
  python tools/extract_prev_byte_rle_assets_v2.py --project . --rom shin_debug.gb --out extracted_rle_v2

If your original ROM is elsewhere:
  python tools/extract_prev_byte_rle_assets_v2.py --project . --rom D:\\path\\to\\shin_debug.gb --out extracted_rle_v2
"""
from __future__ import annotations
import argparse, json, pathlib, re, shutil, sys
from dataclasses import dataclass
from typing import Optional

try:
    from PIL import Image, ImageDraw
except Exception:
    Image = None
    ImageDraw = None

CALL_NAMES = ("LoadMainGfx", "DecodePrevByteRLEGfx")


def strip_comment(line: str) -> str:
    return line.split(';', 1)[0].strip()


def norm(line: str) -> str:
    return re.sub(r'\s+', ' ', strip_comment(line)).strip().lower()


def val(tok: str) -> int:
    tok = tok.strip().lower()
    if tok.startswith('$'):
        return int(tok[1:], 16)
    if tok.startswith('0x'):
        return int(tok, 16)
    return int(tok, 10)


def decode_prev_rle(blob: bytes, initial_prev: int = 0):
    if len(blob) < 2:
        raise ValueError('too short')
    groups = blob[0] | (blob[1] << 8)
    # sanity: output larger than VRAM is almost certainly a false target for this use case.
    pos = 2
    out = bytearray()
    prev = initial_prev
    for g in range(groups):
        if pos >= len(blob):
            raise ValueError(f'truncated at group {g}/{groups}')
        flags = blob[pos]
        pos += 1
        for _ in range(8):
            if flags & 0x80:
                v = prev
            else:
                if pos >= len(blob):
                    raise ValueError('truncated literal')
                v = blob[pos]
                pos += 1
                prev = v
            out.append(v)
            flags = (flags << 1) & 0xff
    return bytes(out), pos, groups


def rom_slice(rom: bytes, bank: int, addr: int, max_read: int) -> bytes:
    if bank == 0:
        if not 0 <= addr < 0x4000:
            raise ValueError(f'ROM0 address out of range: ${addr:04x}')
        off = addr
    else:
        if not 0x4000 <= addr < 0x8000:
            raise ValueError(f'ROMX address out of range: bank {bank}, ${addr:04x}')
        off = bank * 0x4000 + (addr - 0x4000)
    if off >= len(rom):
        raise ValueError(f'ROM offset beyond file: 0x{off:x}')
    return rom[off: min(len(rom), off + max_read)]


def render_2bpp(raw: bytes, out_png: pathlib.Path, scale=4, cols=16) -> bool:
    if Image is None:
        return False
    tiles = len(raw) // 16
    rows = (tiles + cols - 1) // cols
    img = Image.new('RGB', (cols * 8, rows * 8), (255, 255, 255))
    pix = img.load()
    pal = [(255,255,255), (170,170,170), (85,85,85), (0,0,0)]
    for t in range(tiles):
        tx = (t % cols) * 8
        ty = (t // cols) * 8
        base = t * 16
        for y in range(8):
            lo = raw[base + y*2]
            hi = raw[base + y*2 + 1]
            for x in range(8):
                bit = 7 - x
                c = (((hi >> bit) & 1) << 1) | ((lo >> bit) & 1)
                pix[tx+x, ty+y] = pal[c]
    if scale != 1:
        img = img.resize((img.width*scale, img.height*scale), Image.Resampling.NEAREST)
    draw = ImageDraw.Draw(img)
    grid = (220,220,220)
    for x in range(0, cols*8*scale + 1, 8*scale):
        draw.line([(x,0),(x,img.height)], fill=grid)
    for y in range(0, rows*8*scale + 1, 8*scale):
        draw.line([(0,y),(img.width,y)], fill=grid)
    img.save(out_png)
    return True


@dataclass
class RegVal:
    value: Optional[int] = None
    line: Optional[int] = None
    tainted: bool = False
    reason: str = ''


def instr_writes_reg(s: str, reg: str) -> bool:
    # Conservative: only simple cases we need for A/HL/DE.
    if not s:
        return False
    if s.startswith(reg + ' ') or s == reg:
        return True
    if re.match(rf'ld\s+{reg}\s*,', s):
        return True
    if reg == 'a':
        return bool(re.match(r'(xor|or|and|cp|add|adc|sub|sbc)\s+a\b', s)) or bool(re.match(r'(xor|or|and|cp|add|adc|sub|sbc)\s+', s)) or s in ('cpl','daa') or s.startswith('ld a,') or s.startswith('ldh a,')
    if reg == 'hl':
        if re.match(r'(inc|dec|add)\s+hl\b', s): return True
        if re.match(r'pop\s+hl\b', s): return True
        if re.match(r'ld\s+h\s*,', s) or re.match(r'ld\s+l\s*,', s): return True
        # project-specific RST_20 computes/loads a pointer through HL in this ROM.
        if s == 'rst $20' or s == 'rst 20h': return True
    if reg == 'de':
        if re.match(r'(inc|dec)\s+de\b', s): return True
        if re.match(r'pop\s+de\b', s): return True
        if re.match(r'ld\s+d\s*,', s) or re.match(r'ld\s+e\s*,', s): return True
        if s == 'rst $30' or s == 'rst 30h': return True
    # Any call/rst can clobber registers unless it is the target call itself handled outside.
    if s.startswith('call ') or s.startswith('rst '):
        return True
    return False


def literal_load(s: str, reg: str) -> Optional[int]:
    m = re.match(rf'ld\s+{reg}\s*,\s*([^,]+)$', s)
    if not m:
        return None
    expr = m.group(1).strip()
    try:
        return val(expr)
    except Exception:
        return None


def resolve_call_args(lines: list[str], call_idx: int, lookback: int = 24):
    regs = {r: RegVal() for r in ('a','hl','de')}
    needed = set(regs)
    # Walk upward from just before the call. First literal load found for an untainted register wins.
    for j in range(call_idx - 1, max(-1, call_idx - lookback - 1), -1):
        s = norm(lines[j])
        if not s or s.endswith(':') or s.endswith('::'):
            continue
        for r in list(needed):
            if instr_writes_reg(s, r):
                v = literal_load(s, r)
                if v is not None:
                    regs[r] = RegVal(v, j+1, False, '')
                    needed.remove(r)
                else:
                    regs[r] = RegVal(None, j+1, True, f'{r.upper()} modified by `{strip_comment(lines[j])}` before literal load')
                    needed.remove(r)
        if not needed:
            break
    unresolved = {r: regs[r].reason or 'not found in lookback window' for r in regs if regs[r].value is None}
    if unresolved:
        return None, unresolved, regs
    return {'src_bank': regs['a'].value, 'src_addr': regs['hl'].value, 'dst_addr': regs['de'].value,
            'arg_lines': {r: regs[r].line for r in regs}}, None, regs


def find_calls(project: pathlib.Path, bank_count: int):
    call_re = re.compile(r'\bcall\s+(' + '|'.join(map(re.escape, CALL_NAMES)) + r')\b', re.I)
    calls = []
    for bank in range(bank_count):
        path = project / f'bank_{bank:03d}.asm'
        if not path.exists():
            continue
        lines = path.read_text(errors='ignore').splitlines()
        for i, line in enumerate(lines):
            if not call_re.search(line):
                continue
            args, unresolved, regs = resolve_call_args(lines, i)
            rec = {'caller_file': path.name, 'caller_line': i+1, 'call_text': strip_comment(line)}
            if args:
                rec.update(args)
            else:
                rec['unresolved'] = unresolved
            calls.append(rec)
    return calls


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument('--project', default='.')
    ap.add_argument('--rom', required=True, help='Original or byte-identical ROM binary to read compressed bytes from')
    ap.add_argument('--out', default='extracted_rle_v2')
    ap.add_argument('--bank-count', type=int, default=8)
    ap.add_argument('--max-read', default='0x4000')
    ap.add_argument('--max-vram-output', default='0x2000', help='sanity limit for VRAM graphic outputs')
    args = ap.parse_args()
    project = pathlib.Path(args.project).resolve()
    rom_path = pathlib.Path(args.rom).resolve()
    out = pathlib.Path(args.out).resolve()
    max_read = int(args.max_read, 0)
    max_vram_output = int(args.max_vram_output, 0)
    rom = rom_path.read_bytes()

    calls = find_calls(project, args.bank_count)
    unique = []
    seen = set()
    unresolved_calls = []
    for c in calls:
        if 'src_bank' not in c:
            unresolved_calls.append(c)
            continue
        key = (c['src_bank'], c['src_addr'], c['dst_addr'])
        if key not in seen:
            seen.add(key); unique.append(c)

    if out.exists():
        shutil.rmtree(out)
    (out/'gfx'/'rle').mkdir(parents=True)
    (out/'png').mkdir(parents=True)
    (out/'tools').mkdir(parents=True)
    tool_src = pathlib.Path(__file__).resolve().parent / 'shin_prev_byte_rle.py'
    if tool_src.exists(): shutil.copy2(tool_src, out/'tools'/'shin_prev_byte_rle.py')

    records = []
    for idx, c in enumerate(unique):
        rec = dict(c); rec['id'] = idx
        sb, sa, dst = c['src_bank'], c['src_addr'], c['dst_addr']
        try:
            blob = rom_slice(rom, sb, sa, max_read)
            raw, used, groups = decode_prev_rle(blob)
            vram = 0x8000 <= dst <= 0x97ff and len(raw) % 16 == 0
            if vram and len(raw) > max_vram_output:
                raise ValueError(f'implausible VRAM output size {len(raw)} bytes ({groups} groups)')
            name = f'rle_b{sb:02x}_{sa:04x}_to_{dst:04x}'
            raw_path = out/'gfx'/'rle'/f'{name}.raw2bpp'
            rle_path = out/'gfx'/'rle'/f'{name}.rle'
            raw_path.write_bytes(raw)
            rle_path.write_bytes(blob[:used])
            rec.update({'ok': True, 'groups': groups, 'raw_size': len(raw), 'compressed_size': used,
                        'tiles': len(raw)//16 if len(raw)%16==0 else None, 'vram_2bpp': vram,
                        'raw_file': str(raw_path.relative_to(out)).replace('\\','/'),
                        'rle_file': str(rle_path.relative_to(out)).replace('\\','/')})
            if vram:
                png_path = out/'png'/f'{name}_grid_4x.png'
                if render_2bpp(raw, png_path):
                    rec['png_file'] = str(png_path.relative_to(out)).replace('\\','/')
        except Exception as e:
            rec.update({'ok': False, 'error': str(e), 'available_bytes': len(rom_slice(rom, sb, sa, max_read)) if 0 <= sb*0x4000 < len(rom) else 0})
        records.append(rec)

    mk = ['# Auto-generated rules for Shin-chan 4 PrevByteRLE assets', 'PYTHON ?= python', 'SHIN_RLE_TOOL := tools/shin_prev_byte_rle.py']
    for r in records:
        if r.get('ok'):
            mk += [f"{r['rle_file']}: {r['raw_file']} $(SHIN_RLE_TOOL)", f"\t$(PYTHON) $(SHIN_RLE_TOOL) encode {r['raw_file']} {r['rle_file']}", '']
    (out/'rle_assets.mk').write_text('\n'.join(mk))

    lines = ['# Shin-chan 4 LoadMainGfx / PrevByteRLE batch extraction v2\n',
             'This version reads compressed bytes directly from the ROM binary and uses conservative call-site argument analysis.\n',
             f'- ROM: `{rom_path}`',
             f'- total call sites: {len(calls)}',
             f'- static unique targets: {len(unique)}',
             f'- unresolved/dynamic call sites: {len(unresolved_calls)}',
             f'- successful decodes: {sum(1 for r in records if r.get("ok"))}',
             f'- VRAM 2bpp candidates: {sum(1 for r in records if r.get("vram_2bpp"))}']
    if unresolved_calls:
        lines += ['\n## Unresolved/dynamic call sites', 'These are intentionally skipped because A/HL/DE are not a simple literal triple immediately before the call.']
        for u in unresolved_calls:
            lines.append(f"- `{u['caller_file']}:{u['caller_line']}` {u.get('unresolved')}")
    lines += ['\n| id | caller | source | dest | raw | cmp | tiles | kind | files / error |',
              '|---:|---|---|---|---:|---:|---:|---|---|']
    for r in records:
        src = f"b{r.get('src_bank',0):02x}:${r.get('src_addr',0):04x}"
        dst = f"${r.get('dst_addr',0):04x}"
        if not r.get('ok'):
            lines.append(f"| {r['id']} | {r.get('caller_file')}:{r.get('caller_line')} | {src} | {dst} | - | - | - | ERROR | {r.get('error')} ; available={r.get('available_bytes')} |")
        else:
            kind = 'VRAM 2bpp' if r.get('vram_2bpp') else 'non-VRAM / data?'
            files = f"`{r['raw_file']}`, `{r['rle_file']}`"
            if r.get('png_file'):
                files += f", `{r['png_file']}`"
            lines.append(f"| {r['id']} | {r['caller_file']}:{r['caller_line']} | {src} | {dst} | {r['raw_size']} | {r['compressed_size']} | {r.get('tiles') or ''} | {kind} | {files} |")
    (out/'RLE_EXTRACT_REPORT.md').write_text('\n'.join(lines))
    (out/'rle_records.json').write_text(json.dumps({'records': records, 'unresolved_calls': unresolved_calls}, indent=2))
    print(f'Wrote {out}')
    print(f'Calls: {len(calls)}, unique static targets: {len(unique)}, unresolved: {len(unresolved_calls)}, decoded: {sum(1 for r in records if r.get("ok"))}')

if __name__ == '__main__':
    main()
