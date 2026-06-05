#!/usr/bin/env python3
"""
Assetize Shin-chan 4 LoadMainGfx / PrevByteRLE compressed graphics.

Input:
  - project directory containing bank_000.asm ... bank_007.asm, Makefile
  - original ROM binary, usually game.gb or shin_debug.gb
  - rle_records.json from extract_prev_byte_rle_assets_v2.py

Output:
  - overlay directory containing patched bank_*.asm, Makefile, tools, gfx/rle/*.raw2bpp/*.rle

This script intentionally assetizes only VRAM 2bpp candidates by default:
  dest in $8000-$97ff, raw size multiple of 16.
Non-VRAM data and dynamic call sites are left untouched.
"""
from __future__ import annotations
import argparse, json, re, shutil
from pathlib import Path
from typing import Dict, List, Any

# ---------------- PrevByteRLE ----------------
def decode_prev_byte_rle(data: bytes, initial_prev: int = 0) -> tuple[bytes, int]:
    if len(data) < 2:
        raise ValueError('too short')
    pos = 0
    groups = data[pos] | (data[pos + 1] << 8)
    pos += 2
    out = bytearray()
    prev = initial_prev & 0xff
    for g in range(groups):
        if pos >= len(data):
            raise ValueError(f'truncated at group {g}/{groups}')
        flags = data[pos]
        pos += 1
        for _ in range(8):
            if flags & 0x80:
                value = prev
            else:
                if pos >= len(data):
                    raise ValueError(f'truncated literal at group {g}/{groups}')
                value = data[pos]
                pos += 1
                prev = value
            out.append(value)
            flags = ((flags << 1) & 0xff)
    return bytes(out), pos

def encode_prev_byte_rle(raw: bytes, initial_prev: int = 0, force_first_literal: bool = True) -> bytes:
    if len(raw) % 8 != 0:
        raise ValueError(f'raw length must be multiple of 8, got {len(raw)}')
    groups = len(raw) // 8
    out = bytearray(groups.to_bytes(2, 'little'))
    prev = initial_prev & 0xff
    i = 0
    first = True
    for _ in range(groups):
        flag_pos = len(out)
        out.append(0)
        flags = 0
        for bit in range(8):
            value = raw[i]
            i += 1
            can_repeat = (value == prev) and not (force_first_literal and first)
            if can_repeat:
                flags |= 1 << (7 - bit)
            else:
                out.append(value)
                prev = value
            first = False
        out[flag_pos] = flags
    return bytes(out)

# ---------------- ROM bank helpers ----------------
def rom_offset(bank: int, addr: int) -> int:
    if bank == 0:
        return addr
    return bank * 0x4000 + (addr - 0x4000)

def rom_slice(rom: bytes, bank: int, addr: int, size: int) -> bytes:
    off = rom_offset(bank, addr)
    return rom[off:off + size]

# ---------------- tiny RGBDS line sizing ----------------
CONSTS: Dict[str, int] = {}
reg8=['b','c','d','e','h','l','[hl]','a']
reg16=['bc','de','hl','sp']
reg16stk=['bc','de','hl','af']
cond=['nz','z','nc','c']

def norm(s: str) -> str:
    s=s.split(';')[0].strip().lower()
    s=re.sub(r'\s+', ' ', s)
    return s

def val(tok: str) -> int:
    tok=tok.strip().lower()
    if tok.startswith('-$'):
        return -int(tok[2:],16)
    if tok.startswith('$'):
        return int(tok[1:],16)
    if tok.startswith('%'):
        return int(tok[1:],2)
    if tok.startswith('0x'):
        return int(tok,16)
    if re.fullmatch(r'-?\d+', tok):
        return int(tok)
    if tok in CONSTS:
        return CONSTS[tok]
    m=re.search(r'_([0-9a-f]{3})_([0-9a-f]{4})$', tok, re.I)
    if m:
        return int(m.group(2),16)
    m=re.search(r'_([0-9a-f]{4})$', tok, re.I)
    if m:
        return int(m.group(1),16)
    raise ValueError('val '+tok)

def split_args(s: str) -> List[str]:
    out=[]; cur=''; inq=False
    for ch in s:
        if ch=='"':
            inq=not inq; cur+=ch
        elif ch==',' and not inq:
            out.append(cur.strip()); cur=''
        else:
            cur+=ch
    if cur.strip():
        out.append(cur.strip())
    return out

def word(x:int)->List[int]:
    return [x&0xff,(x>>8)&0xff]

single={
'nop':0x00,'stop':0x10,'rlca':0x07,'rrca':0x0f,'rla':0x17,'rra':0x1f,'daa':0x27,'cpl':0x2f,'scf':0x37,'ccf':0x3f,
'halt':0x76,'ret':0xc9,'reti':0xd9,'di':0xf3,'ei':0xfb,
'add hl, bc':0x09,'add hl, de':0x19,'add hl, hl':0x29,'add hl, sp':0x39,
'ld [bc], a':0x02,'ld [de], a':0x12,'ld a, [bc]':0x0a,'ld a, [de]':0x1a,
'ld [hl+], a':0x22,'ld [hli], a':0x22,'ld a, [hl+]':0x2a,'ld a, [hli]':0x2a,
'ld [hl-], a':0x32,'ld [hld], a':0x32,'ld a, [hl-]':0x3a,'ld a, [hld]':0x3a,
'ld sp, hl':0xf9,'ldh [c], a':0xe2,'ldh a, [c]':0xf2,
}
for i,r in enumerate(reg16):
    single[f'inc {r}']=0x03+i*0x10
    single[f'dec {r}']=0x0b+i*0x10
for i,r in enumerate(reg8):
    single[f'inc {r}']=0x04+i*8
    single[f'dec {r}']=0x05+i*8
for i,r1 in enumerate(reg8):
    for j,r2 in enumerate(reg8):
        if r1=='[hl]' and r2=='[hl]':
            continue
        single[f'ld {r1}, {r2}']=0x40+i*8+j
alu_bases={'add a,':0x80,'add':0x80,'adc a,':0x88,'adc':0x88,'sub':0x90,'sbc a,':0x98,'sbc':0x98,'and':0xa0,'xor':0xa8,'or':0xb0,'cp':0xb8}
for op,base in alu_bases.items():
    for i,r in enumerate(reg8):
        single[f'{op} {r}' if op.endswith(',') else f'{op} {r}']=base+i
for ci,c in enumerate(cond):
    single[f'ret {c}']=0xc0+ci*8
for i,r in enumerate(reg16stk):
    single[f'pop {r}']=0xc1+i*0x10
    single[f'push {r}']=0xc5+i*0x10
for n,op in [(0,0xc7),(8,0xcf),(0x10,0xd7),(0x18,0xdf),(0x20,0xe7),(0x28,0xef),(0x30,0xf7),(0x38,0xff)]:
    single[f'rst ${n:02x}']=op
    single[f'rst ${n:x}']=op
cb_single={}
for oi,o in enumerate(['rlc','rrc','rl','rr','sla','sra','swap','srl']):
    for ri,r in enumerate(reg8):
        cb_single[f'{o} {r}']=oi*8+ri
for bitn in range(8):
    for ri,r in enumerate(reg8):
        cb_single[f'bit {bitn}, {r}']=0x40+bitn*8+ri
        cb_single[f'res {bitn}, {r}']=0x80+bitn*8+ri
        cb_single[f'set {bitn}, {r}']=0xc0+bitn*8+ri

def asm_size(line: str, pc: int, project: Path) -> int:
    raw=line.rstrip('\n')
    s=norm(raw)
    if not s:
        return 0
    if s.startswith('section ') or s.startswith('include ') or s.startswith('def ') or s.startswith('charmap '):
        return 0
    if s.endswith(':') or s.endswith('::'):
        return 0
    if s.startswith('incbin '):
        args=split_args(raw.split(None,1)[1])
        p=args[0].strip().strip('"').replace('\\','/')
        f=(project/p)
        offset=0; size=None
        if len(args)>=2:
            offset=val(args[1])
        if len(args)>=3:
            size=val(args[2])
        if size is not None:
            return size
        if f.exists():
            return max(0, f.stat().st_size-offset)
        raise ValueError(f'cannot size INCBIN without file/size: {raw}')
    if s.startswith('db '):
        n=0
        for a in split_args(s[3:]):
            if a.startswith('"') and a.endswith('"'):
                n += len(a[1:-1].encode('ascii'))
            else:
                n += 1
        return n
    if s.startswith('dw '):
        return 2*len(split_args(s[3:]))
    if s.startswith('ds '):
        return val(split_args(s[3:])[0])
    if s in single:
        return 1
    if s in cb_single:
        return 2
    m=re.fullmatch(r'ld (b|c|d|e|h|l|\[hl\]|a), (.+)', s)
    if m:
        try:
            val(m.group(2)); return 2
        except Exception:
            pass
    if re.fullmatch(r'ld hl, sp[+-].+', s):
        return 2
    if re.fullmatch(r'ld (bc|de|hl|sp), .+', s):
        return 3
    if re.fullmatch(r'ld \[.+\], sp', s):
        return 3
    if re.fullmatch(r'ld \[.+\], a', s):
        return 3
    if re.fullmatch(r'ld a, \[.+\]', s):
        return 3
    if re.fullmatch(r'ldh \[.+\], a', s):
        return 2
    if re.fullmatch(r'ldh a, \[.+\]', s):
        return 2
    if re.fullmatch(r'add sp, .+', s):
        return 2
    for prefix in ['add a,','add','adc a,','adc','sub','sbc a,','sbc','and','xor','or','cp']:
        if s.startswith(prefix+' '):
            return 2
    if re.fullmatch(r'jr .+', s):
        return 2
    if re.fullmatch(r'jp hl', s):
        return 1
    if re.fullmatch(r'jp .+', s):
        return 3
    if re.fullmatch(r'call .+', s):
        return 3
    raise ValueError(f'unknown asm size at {pc:04x}: {raw}')

def load_defs(project: Path) -> None:
    hw=project/'hardware.inc'
    if not hw.exists():
        return
    changed=True
    lines=hw.read_text(encoding='utf-8', errors='ignore').splitlines()
    while changed:
        changed=False
        for line in lines:
            m=re.match(r'\s*DEF\s+(\w+)\s+EQU\s+(.+)', line)
            if not m:
                continue
            name=m.group(1).lower(); expr=m.group(2).split(';')[0].strip().lower()
            try:
                v=val(expr)
            except Exception:
                continue
            if CONSTS.get(name)!=v:
                CONSTS[name]=v; changed=True

def map_asm(path: Path, project: Path) -> list[dict[str, Any]]:
    entries=[]; pc=None; bank=None
    for idx,line in enumerate(path.read_text(encoding='utf-8', errors='ignore').splitlines(True)):
        sec=re.search(r'ROMX\[\$([0-9a-fA-F]+)\].*BANK\[\$?([0-9a-fA-F]+)\]', line)
        if sec:
            pc=int(sec.group(1),16); bank=int(sec.group(2),16)
            entries.append({'idx':idx,'line':line,'pc':None,'size':0,'bank':bank})
            continue
        if pc is None:
            entries.append({'idx':idx,'line':line,'pc':None,'size':0,'bank':bank})
            continue
        this_pc=pc
        try:
            size=asm_size(line, pc, project)
        except Exception as e:
            raise RuntimeError(f'{path.name}:{idx+1}: {e}')
        entries.append({'idx':idx,'line':line,'pc':this_pc,'size':size,'bank':bank})
        pc += size
    return entries

def db_line(bs: bytes, comment: str='') -> str:
    body=', '.join(f'${b:02x}' for b in bs)
    return f'    db {body}' + (f' ; {comment}' if comment else '') + '\n'

def load_records(path: Path) -> list[dict[str, Any]]:
    obj=json.loads(path.read_text(encoding='utf-8'))
    if isinstance(obj, dict):
        for key in ['records','targets','items']:
            if key in obj and isinstance(obj[key], list):
                return obj[key]
        for _,v in obj.items():
            if isinstance(v, list):
                return v
        raise ValueError('could not find records list in json object')
    if isinstance(obj, list):
        return obj
    raise ValueError('unsupported rle_records.json')

def rec_get(rec: dict[str,Any], *names, default=None):
    for n in names:
        if n in rec:
            return rec[n]
    return default

def parse_intish(v):
    if isinstance(v,int):
        return v
    if isinstance(v,str):
        vv=v.strip().replace('$','')
        if vv.lower().startswith('0x'):
            return int(vv,16)
        if re.fullmatch(r'[0-9a-fA-F]+', vv):
            return int(vv,16)
        return int(vv)
    return v

def normalize_records(records: list[dict[str,Any]]) -> list[dict[str,Any]]:
    """Normalize records from extract_prev_byte_rle_assets_v2.py.

    v2 records look like:
      {ok, src_bank, src_addr, dst_addr, raw_size, compressed_size, vram_2bpp, ...}

    Older reports/tooling used slightly different names, so this accepts both.
    Decode failures are skipped here; assetization should only touch verified records.
    """
    out=[]
    skipped=[]
    for rec in records:
        if rec.get('ok') is False:
            skipped.append((rec.get('id'), 'decode failed'))
            continue
        bank=rec_get(rec,'bank','source_bank','src_bank')
        src=rec_get(rec,'addr','source_addr','src_addr','source')
        dest=rec_get(rec,'dest','dst','dest_addr','dst_addr')
        raw=rec_get(rec,'raw_size','raw','raw_len')
        cmp_size=rec_get(rec,'cmp_size','compressed_size','cmp','used','compressed_len')
        if isinstance(src,str) and ':' in src:
            m=re.search(r'b([0-9a-fA-F]+):\$?([0-9a-fA-F]+)', src)
            if m:
                bank=int(m.group(1),16); src=int(m.group(2),16)
        try:
            bank=parse_intish(bank); src=parse_intish(src); dest=parse_intish(dest); raw=parse_intish(raw); cmp_size=parse_intish(cmp_size)
        except Exception as e:
            skipped.append((rec.get('id'), f'field parse failed: {e}'))
            continue
        if any(x is None for x in [bank,src,dest,raw,cmp_size]):
            skipped.append((rec.get('id'), 'missing required field'))
            continue
        kind=rec_get(rec,'kind',default='') or ''
        caller=rec_get(rec,'caller',default='') or f"{rec.get('caller_file','')}:{rec.get('caller_line','')}"
        out.append({
            'bank':int(bank),'src':int(src),'dest':int(dest),
            'raw':int(raw),'cmp':int(cmp_size),'kind':kind,'caller':caller,
            'ok': bool(rec.get('ok', True)),
            'vram_2bpp': bool(rec.get('vram_2bpp', False)),
        })
    return out

def asset_name(r: dict[str,int]) -> str:
    return f'rle_b{r["bank"]:02x}_{r["src"]:04x}_to_{r["dest"]:04x}'

def is_vram_2bpp(r: dict[str,int]) -> bool:
    return 0x8000 <= r['dest'] <= 0x97ff and r['raw'] % 16 == 0

def patch_makefile(src: Path, dst: Path, rle_paths: list[str]) -> None:
    text=src.read_text(encoding='utf-8', errors='ignore')
    rle_line='RLE_DEPS = ' + ' '.join(p.replace('\\','/') for p in rle_paths) + '\n'
    if 'RLE_DEPS =' not in text:
        text=re.sub(r'^(IMAGE_DEPS\s*=.*\n)', r'\1'+rle_line, text, count=1, flags=re.M)
    else:
        text=re.sub(r'^RLE_DEPS\s*=.*$', rle_line.rstrip('\n'), text, flags=re.M)
    if '%.rle: %.raw2bpp' not in text:
        rule="\n%.rle: %.raw2bpp tools/shin_prev_byte_rle.py\n\tpython tools/shin_prev_byte_rle.py encode $< $@\n"
        text=text.replace('\ngame.o:', rule+'\ngame.o:')
    text=re.sub(r'game\.o: game\.asm bank_\*\.asm \$\(IMAGE_DEPS\)', 'game.o: game.asm bank_*.asm $(IMAGE_DEPS) $(RLE_DEPS)', text)
    text=text.replace("find . \\( -iname '*.1bpp' -o -iname '*.2bpp' \\) -exec rm {} +", "find . \\( -iname '*.1bpp' -o -iname '*.2bpp' -o -iname '*.rle' \\) -exec rm {} +")
    dst.write_text(text, encoding='utf-8')

def main():
    ap=argparse.ArgumentParser()
    ap.add_argument('--project', default='.', type=Path)
    ap.add_argument('--rom', required=True, type=Path)
    ap.add_argument('--records', required=True, type=Path, help='rle_records.json from extractor v2')
    ap.add_argument('--out', default='rle_assetized_overlay', type=Path)
    ap.add_argument('--include-non-vram', action='store_true')
    args=ap.parse_args()
    project=args.project.resolve(); rom_path=args.rom.resolve(); out=args.out.resolve()
    rom=rom_path.read_bytes()
    load_defs(project)
    records=normalize_records(load_records(args.records))
    selected=[]
    for r in records:
        # Prefer the extractor's explicit classification; fall back to address/size check.
        is_asset = r.get('vram_2bpp') or is_vram_2bpp(r)
        if is_asset or args.include_non_vram:
            selected.append(r)
    uniq=[]; seen=set()
    for r in selected:
        key=(r['bank'],r['src'],r['dest'],r['cmp'])
        if key not in seen:
            seen.add(key); uniq.append(r)
    selected=sorted(uniq, key=lambda r:(r['bank'], r['src']))
    print(f'Loaded {len(records)} decoded/static records; selected {len(selected)} for assetization')
    if out.exists():
        shutil.rmtree(out)
    out.mkdir(parents=True)
    (out/'gfx'/'rle').mkdir(parents=True)
    (out/'tools').mkdir(parents=True)
    for name in ['game.asm','hardware.inc']:
        if (project/name).exists():
            shutil.copy(project/name, out/name)
    for i in range(8):
        p=project/f'bank_{i:03d}.asm'
        if p.exists():
            shutil.copy(p, out/p.name)
    shutil.copy(Path(__file__).with_name('shin_prev_byte_rle.py'), out/'tools'/'shin_prev_byte_rle.py')
    manifest=[]
    for r in selected:
        cmp_blob=rom_slice(rom, r['bank'], r['src'], r['cmp'])
        raw, used=decode_prev_byte_rle(cmp_blob)
        if used != r['cmp'] or len(raw)!=r['raw']:
            raise RuntimeError(f'{asset_name(r)} mismatch: used {used}/{r["cmp"]}, raw {len(raw)}/{r["raw"]}')
        reenc=encode_prev_byte_rle(raw)
        if reenc != cmp_blob:
            raise RuntimeError(f'{asset_name(r)} re-encode not byte-identical')
        base=asset_name(r)
        raw_path=out/'gfx'/'rle'/f'{base}.raw2bpp'
        rle_path=out/'gfx'/'rle'/f'{base}.rle'
        raw_path.write_bytes(raw)
        rle_path.write_bytes(cmp_blob)
        r2=dict(r); r2['name']=base; r2['raw_path']=str(raw_path.relative_to(out)).replace('\\','/'); r2['rle_path']=str(rle_path.relative_to(out)).replace('\\','/')
        manifest.append(r2)
    by_bank: Dict[int, List[dict[str,int]]] = {}
    for r in manifest:
        by_bank.setdefault(r['bank'],[]).append(r)
    report=[]
    for bank,ranges in by_bank.items():
        asm_path=project/f'bank_{bank:03d}.asm'
        entries=map_asm(asm_path, project)
        rr=sorted([(r['src'], r['src']+r['cmp'], r) for r in ranges])

        # Labels inside the ranges being turned into INCBIN are almost certainly
        # data labels created by the disassembler.  If code/data outside the
        # ranges still references those names, convert only that outside line
        # back to original bytes instead of preserving fake labels in the asset.
        labels_inside={}
        for e in entries:
            pc=e['pc']; line=e['line']
            if pc is None:
                continue
            if not any(a <= pc < b for a,b,_ in rr):
                continue
            m=re.match(r'\s*([A-Za-z_][\w.]*)::?\s*$', line)
            if m:
                labels_inside[m.group(1)] = pc
        label_re=re.compile(r'\b('+'|'.join(map(re.escape, labels_inside.keys()))+r')\b') if labels_inside else None

        new_lines=[]
        inserted=set()
        replaced_refs=0

        def emit_asset_if_at(pos:int):
            """Emit all assets starting exactly at pos."""
            emitted=False
            for a,b,r in rr:
                if a == pos and (a,b) not in inserted:
                    base=r['name']
                    new_lines.append(f'{base}::\n')
                    new_lines.append(f'    INCBIN "gfx/rle/{base}.rle"\n')
                    inserted.add((a,b))
                    report.append(f'bank {bank:02x}: replaced ${a:04x}-${b-1:04x} with gfx/rle/{base}.rle')
                    emitted=True
            return emitted

        for e in entries:
            pc=e['pc']; size=e['size']; line=e['line']
            if pc is None or size == 0:
                # Keep section/include/labels/comments.  Labels that fall inside
                # an asset range are dropped so they do not survive as fake code
                # labels, except if the label sits exactly at the asset start; in
                # that case emit the asset label instead.
                if pc is not None:
                    if any(a < pc < b for a,b,_ in rr):
                        continue
                    if emit_asset_if_at(pc):
                        continue
                new_lines.append(line)
                continue

            line_start=pc
            line_end=pc+size

            # If this outside line references a fake label inside an asset,
            # preserve its bytes as data.  This handles misdisassembled tables
            # like `call z, Call_006_4e76` that are not real code.
            if label_re and not any(a < line_end and line_start < b for a,b,_ in rr) and label_re.search(line):
                bs=rom_slice(rom, bank, line_start, size)
                new_lines.append(db_line(bs, 'data, was misdisassembled; referenced label inside RLE asset'))
                replaced_refs += 1
                continue

            pos=line_start
            overlapped=False
            for a,b,r in rr:
                if b <= pos or a >= line_end:
                    continue
                overlapped=True
                # bytes before the asset start, when a data directive straddles it
                if pos < a:
                    new_lines.append(db_line(rom_slice(rom, bank, pos, a-pos), 'data before RLE asset'))
                    pos=a
                # the asset itself, even if it starts in the middle of a line
                if pos == a:
                    emit_asset_if_at(a)
                    pos=b
                # bytes after the asset end may be handled below or by later ranges
            if overlapped:
                # Preserve trailing bytes if the original asm line straddled the
                # end of the asset range.  This is the key fix for cases like
                # bank2:$7b8e where the RLE blob begins in the middle of an
                # existing db/data line.
                if pos < line_end:
                    new_lines.append(db_line(rom_slice(rom, bank, pos, line_end-pos), 'data after RLE asset'))
                continue

            # No overlap; if an asset starts at this PC but this line has size,
            # emit it before the line.  Usually redundant, but safe for odd maps.
            if emit_asset_if_at(line_start):
                continue
            new_lines.append(line)

        # If an asset starts in a gap represented only by a label/comment and was
        # not emitted during line iteration, append it here rather than silently
        # dropping it.  This should be rare and will likely break hash, but gives
        # an obvious patch report line.
        for a,b,r in rr:
            if (a,b) not in inserted:
                base=r['name']
                new_lines.append(f'{base}::\n')
                new_lines.append(f'    INCBIN "gfx/rle/{base}.rle"\n')
                inserted.add((a,b))
                report.append(f'bank {bank:02x}: WARNING late-appended ${a:04x}-${b-1:04x} with gfx/rle/{base}.rle')

        (out/f'bank_{bank:03d}.asm').write_text(''.join(new_lines), encoding='utf-8')
        if replaced_refs:
            report.append(f'bank {bank:02x}: converted {replaced_refs} outside false references to db')
    if (project/'Makefile').exists():
        patch_makefile(project/'Makefile', out/'Makefile', [r['rle_path'] for r in manifest])
    (out/'rle_asset_manifest.json').write_text(json.dumps(manifest, indent=2), encoding='utf-8')
    verify='''#!/usr/bin/env python3
import json, argparse
from pathlib import Path
from tools.shin_prev_byte_rle import decode_prev_byte_rle, encode_prev_byte_rle

def rom_offset(bank, addr):
    return addr if bank == 0 else bank * 0x4000 + (addr - 0x4000)

ap=argparse.ArgumentParser()
ap.add_argument('--rom', default='game.gb')
ap.add_argument('--manifest', default='rle_asset_manifest.json')
args=ap.parse_args()
rom=Path(args.rom).read_bytes()
manifest=json.loads(Path(args.manifest).read_text())
fail=0
for r in manifest:
    off=rom_offset(r['bank'], r['src'])
    original=rom[off:off+r['cmp']]
    raw=Path(r['raw_path']).read_bytes()
    rle=Path(r['rle_path']).read_bytes()
    dec, used=decode_prev_byte_rle(rle)
    ok=(original==rle and dec==raw and used==len(rle) and encode_prev_byte_rle(raw)==rle)
    print(f"{r['name']}: {'OK' if ok else 'FAIL'}")
    if not ok:
        fail += 1
raise SystemExit(1 if fail else 0)
'''
    (out/'verify_rle_assets.py').write_text(verify, encoding='utf-8')
    readme=f'''# Shin-chan 4 PrevByteRLE assetized overlay

This overlay converts {len(manifest)} VRAM 2bpp `LoadMainGfx` / PrevByteRLE blobs into explicit assets.

Kept untouched by default:
- non-VRAM destination, e.g. `$c800` data/staging buffer
- dynamic/unresolved `LoadMainGfx` call sites

## Apply

Copy the contents of this folder over your disassembly project root.

Then run:

```bat
python verify_rle_assets.py --rom game.gb
make clean
make
```

If your original ROM is not `game.gb`, pass that path to `--rom`.

## Generated assets

The source assets are `.raw2bpp`; `.rle` files are generated by Makefile using:

```bat
python tools/shin_prev_byte_rle.py encode input.raw2bpp output.rle
```

## Patch report

''' + '\n'.join('- '+x for x in report) + '\n'
    (out/'README_RLE_ASSETIZED_OVERLAY.md').write_text(readme, encoding='utf-8')
    print(f'Wrote overlay: {out}')
    print(f'Assetized {len(manifest)} RLE blobs')

if __name__=='__main__':
    main()
