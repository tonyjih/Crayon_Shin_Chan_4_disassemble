#!/usr/bin/env python3
"""
Batch-extract Shin-chan 4 PrevByteRLE assets referenced by LoadMainGfx/DecodePrevByteRLEGfx.

Run from the mgbdis project root, for example:
  python tools/extract_prev_byte_rle_assets.py --project . --out extracted_rle

Outputs:
  extracted_rle/RLE_EXTRACT_REPORT.md
  extracted_rle/rle_records.json
  extracted_rle/gfx/rle/*.raw2bpp
  extracted_rle/gfx/rle/*.rle
  extracted_rle/png/*_grid_4x.png for VRAM 2bpp candidates
  extracted_rle/rle_assets.mk with rules to rebuild .rle from .raw2bpp
"""
import argparse, json, pathlib, re, shutil, sys
from collections import defaultdict

SCRIPT_DIR = pathlib.Path(__file__).resolve().parent
sys.path.insert(0, str(SCRIPT_DIR))
import gbasm_extract as ge


def load_hardware_consts(project: pathlib.Path):
    hw = project / 'hardware.inc'
    if not hw.exists():
        return
    changed = True
    lines = hw.read_text(errors='ignore').splitlines()
    while changed:
        changed = False
        for line in lines:
            m = re.match(r'\s*DEF\s+(\w+)\s+EQU\s+(.+)', line)
            if not m:
                continue
            name = m.group(1).lower()
            expr = m.group(2).split(';')[0].strip().lower()
            try:
                v = ge.val(expr)
            except Exception:
                continue
            if ge.CONSTS.get(name) != v:
                ge.CONSTS[name] = v
                changed = True


def norm(s: str) -> str:
    return ge.norm(s)


def val(tok: str) -> int:
    return ge.val(tok)


def line_pc_map(path: pathlib.Path):
    pcs = {}
    pc = None
    for lineno, line in enumerate(path.read_text(errors='ignore').splitlines(), 1):
        m = re.search(r'ROM0\[\$([0-9a-fA-F]+)\]|ROMX\[\$([0-9a-fA-F]+)\]', line)
        if m:
            pc = int((m.group(1) or m.group(2)), 16)
            continue
        if pc is None:
            continue
        s = norm(line)
        if not s:
            continue
        pcs[lineno] = pc
        if s.endswith(':') or s.endswith('::'):
            continue
        try:
            bs = ge.assemble(line, pc)
            pc += len(bs)
        except StopIteration:
            mm = re.match(r'\s*INCBIN\s+"([^"]+)"(?:\s*,\s*([^,]+)(?:\s*,\s*([^;]+))?)?', line, re.I)
            if mm:
                inc = path.parent / mm.group(1)
                try:
                    size = inc.stat().st_size
                    if mm.group(3):
                        size = val(mm.group(3))
                    elif mm.group(2):
                        size -= val(mm.group(2))
                    pc += size
                except Exception:
                    pass
        except Exception:
            # PC accuracy after unsupported instructions may degrade, but caller PC is only informational.
            pass
    return pcs


def assemble_map(path: pathlib.Path):
    data = {}
    missing_incbins = []
    errors = []
    pc = None
    for lineno, line in enumerate(path.read_text(errors='ignore').splitlines(), 1):
        raw = line.rstrip('\n')
        m = re.search(r'ROM0\[\$([0-9a-fA-F]+)\]|ROMX\[\$([0-9a-fA-F]+)\]', raw)
        if m:
            pc = int((m.group(1) or m.group(2)), 16)
            continue
        if pc is None:
            continue
        s = norm(raw)
        if not s:
            continue
        if s.endswith(':') or s.endswith('::'):
            continue
        if s.startswith('incbin '):
            mm = re.match(r'\s*INCBIN\s+"([^"]+)"(?:\s*,\s*([^,]+)(?:\s*,\s*([^;]+))?)?', raw, re.I)
            if mm:
                inc = path.parent / mm.group(1)
                if inc.exists():
                    b = inc.read_bytes()
                    off = val(mm.group(2)) if mm.group(2) else 0
                    ln = val(mm.group(3)) if mm.group(3) else len(b) - off
                    for by in b[off:off + ln]:
                        data[pc] = by
                        pc += 1
                else:
                    missing_incbins.append(str(inc))
            continue
        try:
            bs = ge.assemble(raw, pc)
        except Exception as e:
            errors.append({'line': lineno, 'pc': pc, 'text': raw, 'error': str(e)})
            continue
        for by in bs:
            data[pc] = by
            pc += 1
    return data, missing_incbins, errors


def decode_prev_rle(blob: bytes, initial_prev: int = 0):
    if len(blob) < 2:
        raise ValueError('too short')
    groups = blob[0] | (blob[1] << 8)
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


def find_calls(path: pathlib.Path, call_names=('LoadMainGfx', 'DecodePrevByteRLEGfx')):
    lines = path.read_text(errors='ignore').splitlines()
    pcs = line_pc_map(path)
    calls = []
    call_re = re.compile(r'\bcall\s+(' + '|'.join(map(re.escape, call_names)) + r')\b')
    for i, line in enumerate(lines):
        if not call_re.search(line):
            continue
        regs = {}
        for j in range(max(0, i - 16), i):
            s = norm(lines[j])
            m = re.match(r'ld\s+a,\s*(.+)$', s)
            if m:
                try: regs['a'] = val(m.group(1))
                except Exception: pass
            m = re.match(r'ld\s+hl,\s*(.+)$', s)
            if m:
                try: regs['hl'] = val(m.group(1))
                except Exception: pass
            m = re.match(r'ld\s+de,\s*(.+)$', s)
            if m:
                try: regs['de'] = val(m.group(1))
                except Exception: pass
        rec = {'caller_file': path.name, 'caller_line': i + 1, 'caller_pc': pcs.get(i + 1)}
        if all(k in regs for k in ('a', 'hl', 'de')):
            rec.update({'src_bank': regs['a'], 'src_addr': regs['hl'], 'dst_addr': regs['de']})
        else:
            rec.update({'unresolved_regs': regs})
        calls.append(rec)
    return calls


def render_2bpp(raw: bytes, out_png: pathlib.Path, scale=4, cols=16):
    try:
        from PIL import Image, ImageDraw
    except Exception:
        return False
    tiles = len(raw) // 16
    rows = (tiles + cols - 1) // cols
    img = Image.new('RGB', (cols * 8, rows * 8), (255, 255, 255))
    pix = img.load()
    pal = [(255, 255, 255), (170, 170, 170), (85, 85, 85), (0, 0, 0)]
    for t in range(tiles):
        tx = (t % cols) * 8
        ty = (t // cols) * 8
        base = t * 16
        for y in range(8):
            lo = raw[base + y * 2]
            hi = raw[base + y * 2 + 1]
            for x in range(8):
                bit = 7 - x
                c = ((hi >> bit) & 1) * 2 + ((lo >> bit) & 1)
                pix[tx + x, ty + y] = pal[c]
    if scale != 1:
        img = img.resize((img.width * scale, img.height * scale), Image.Resampling.NEAREST)
    draw = ImageDraw.Draw(img)
    for x in range(0, cols * 8 * scale + 1, 8 * scale):
        draw.line([(x, 0), (x, img.height)], fill=(220, 220, 220))
    for y in range(0, rows * 8 * scale + 1, 8 * scale):
        draw.line([(0, y), (img.width, y)], fill=(220, 220, 220))
    img.save(out_png)
    return True


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument('--project', default='.', help='mgbdis project root')
    ap.add_argument('--out', default='extracted_rle', help='output directory')
    ap.add_argument('--bank0', default='bank_000.asm', help='bank0 asm path relative to project')
    ap.add_argument('--max-read', default='0x4000', help='max bytes to read from source address')
    args = ap.parse_args()

    project = pathlib.Path(args.project).resolve()
    out = pathlib.Path(args.out).resolve()
    max_read = int(args.max_read, 0)
    load_hardware_consts(project)

    bank_paths = {0: project / args.bank0}
    for i in range(1, 8):
        bank_paths[i] = project / f'bank_{i:03d}.asm'
    missing_banks = [str(p) for p in bank_paths.values() if not p.exists()]
    if missing_banks:
        raise SystemExit('Missing bank files:\n' + '\n'.join(missing_banks))

    bank_data = {}
    all_missing_incbins = defaultdict(list)
    for b, p in bank_paths.items():
        bank_data[b], missing, _errors = assemble_map(p)
        for m in missing:
            all_missing_incbins[b].append(m)

    def get_bytes(bank, addr, max_len=max_read):
        data = bank_data[bank]
        outb = []
        for a in range(addr, addr + max_len):
            if a not in data:
                break
            outb.append(data[a])
        return bytes(outb)

    calls = []
    for p in bank_paths.values():
        calls += find_calls(p)

    unique = []
    seen = set()
    for c in calls:
        if 'src_bank' not in c:
            continue
        key = (c['src_bank'], c['src_addr'], c['dst_addr'])
        if key not in seen:
            seen.add(key)
            unique.append(c)

    if out.exists():
        shutil.rmtree(out)
    (out / 'gfx' / 'rle').mkdir(parents=True)
    (out / 'png').mkdir(parents=True)
    (out / 'tools').mkdir(parents=True)
    shutil.copy2(SCRIPT_DIR / 'shin_prev_byte_rle.py', out / 'tools' / 'shin_prev_byte_rle.py')

    records = []
    for idx, c in enumerate(unique):
        sb = c['src_bank']; sa = c['src_addr']; dst = c['dst_addr']
        blob = get_bytes(sb, sa)
        rec = dict(c); rec['id'] = idx
        try:
            raw, used, groups = decode_prev_rle(blob)
            vram = 0x8000 <= dst <= 0x97ff and len(raw) % 16 == 0
            name = f'rle_b{sb:02x}_{sa:04x}_to_{dst:04x}'
            raw_path = out / 'gfx' / 'rle' / f'{name}.raw2bpp'
            rle_path = out / 'gfx' / 'rle' / f'{name}.rle'
            raw_path.write_bytes(raw)
            rle_path.write_bytes(blob[:used])
            rec.update({'ok': True, 'groups': groups, 'raw_size': len(raw), 'compressed_size': used,
                        'tiles': len(raw)//16 if len(raw)%16==0 else None, 'vram_2bpp': vram,
                        'raw_file': str(raw_path.relative_to(out)).replace('\\','/'),
                        'rle_file': str(rle_path.relative_to(out)).replace('\\','/')})
            if vram:
                png_path = out / 'png' / f'{name}_grid_4x.png'
                if render_2bpp(raw, png_path):
                    rec['png_file'] = str(png_path.relative_to(out)).replace('\\','/')
        except Exception as e:
            rec.update({'ok': False, 'error': str(e), 'available_bytes': len(blob)})
        records.append(rec)

    # Makefile fragment
    mk = []
    mk.append('# Auto-generated rules for Shin-chan 4 PrevByteRLE assets')
    mk.append('PYTHON ?= python')
    mk.append('SHIN_RLE_TOOL := tools/shin_prev_byte_rle.py')
    for r in records:
        if r.get('ok'):
            mk.append(f"{r['rle_file']}: {r['raw_file']} $(SHIN_RLE_TOOL)")
            mk.append(f"\t$(PYTHON) $(SHIN_RLE_TOOL) encode {r['raw_file']} {r['rle_file']}")
            mk.append('')
    (out / 'rle_assets.mk').write_text('\n'.join(mk))

    # Report
    lines = []
    lines.append('# Shin-chan 4 LoadMainGfx / PrevByteRLE batch extraction\n')
    lines.append('VRAM destinations `$8000-$97ff` with output size multiple of 16 are rendered as Game Boy 2bpp tile sheets. Non-VRAM destinations are decoded but should be reviewed before treating as graphics.\n')
    lines.append(f'- total call sites: {len(calls)}')
    lines.append(f'- unique targets: {len(unique)}')
    lines.append(f'- successful decodes: {sum(1 for r in records if r.get("ok"))}')
    lines.append(f'- VRAM 2bpp candidates: {sum(1 for r in records if r.get("vram_2bpp"))}')
    if all_missing_incbins:
        lines.append('\n## Missing INCBIN files seen while reconstructing bank bytes')
        lines.append('If some decodes are truncated, make sure your project has these files:')
        for b, ms in all_missing_incbins.items():
            for m in sorted(set(ms))[:50]:
                lines.append(f'- bank {b}: `{m}`')
    lines.append('\n| id | caller | source | dest | raw | cmp | tiles | kind | files / error |')
    lines.append('|---:|---|---|---|---:|---:|---:|---|---|')
    for r in records:
        if not r.get('ok'):
            lines.append(f"| {r['id']} | {r.get('caller_file')}:{r.get('caller_line')} | b{r.get('src_bank',0):02x}:${r.get('src_addr',0):04x} | ${r.get('dst_addr',0):04x} | - | - | - | ERROR | {r.get('error')} ; available={r.get('available_bytes')} |")
        else:
            kind = 'VRAM 2bpp' if r.get('vram_2bpp') else 'non-VRAM / data?'
            files = f"`{r['raw_file']}`, `{r['rle_file']}`"
            if r.get('png_file'):
                files += f", `{r['png_file']}`"
            lines.append(f"| {r['id']} | {r['caller_file']}:{r['caller_line']} | b{r['src_bank']:02x}:${r['src_addr']:04x} | ${r['dst_addr']:04x} | {r['raw_size']} | {r['compressed_size']} | {r.get('tiles') or ''} | {kind} | {files} |")
    (out / 'RLE_EXTRACT_REPORT.md').write_text('\n'.join(lines))
    (out / 'rle_records.json').write_text(json.dumps(records, indent=2))

    print(f'Wrote {out}')
    print(f'Calls: {len(calls)}, unique targets: {len(unique)}, decoded: {sum(1 for r in records if r.get("ok"))}, VRAM 2bpp: {sum(1 for r in records if r.get("vram_2bpp"))}')

if __name__ == '__main__':
    main()
