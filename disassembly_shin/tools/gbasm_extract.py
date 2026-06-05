import re, sys, pathlib, struct
CONSTS={}

reg8=['b','c','d','e','h','l','[hl]','a']
reg16=['bc','de','hl','sp']
reg16stk=['bc','de','hl','af']
cond=['nz','z','nc','c']

def norm(s):
    s=s.split(';')[0].strip().lower()
    s=re.sub(r'\s+', ' ', s)
    s=s.replace('[hl+]', '[hl+]')
    return s

def val(tok):
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
    # labels like Jump_006_4bc0 / jr_006_4bc0 / Call_000_0f0d / RST_20
    m=re.search(r'_([0-9a-f]{3})_([0-9a-f]{4})$', tok, re.I)
    if m:
        return int(m.group(2),16)
    m=re.search(r'_([0-9a-f]{4})$', tok, re.I)
    if m:
        return int(m.group(1),16)
    raise ValueError('val '+tok)

def split_args(s):
    # split comma not in quotes
    out=[]; cur=''; inq=False
    for ch in s:
        if ch=='"': inq=not inq; cur+=ch
        elif ch==',' and not inq:
            out.append(cur.strip()); cur=''
        else: cur+=ch
    if cur.strip(): out.append(cur.strip())
    return out

def byte(x): return [x & 0xff]
def word(x): return [x & 0xff, (x>>8)&0xff]

# single opcodes map with no operands
single={
'nop':0x00,'stop':0x10,'rlca':0x07,'rrca':0x0f,'rla':0x17,'rra':0x1f,'daa':0x27,'cpl':0x2f,'scf':0x37,'ccf':0x3f,
'halt':0x76,'ret':0xc9,'reti':0xd9,'di':0xf3,'ei':0xfb,
'add hl, bc':0x09,'add hl, de':0x19,'add hl, hl':0x29,'add hl, sp':0x39,
'ld [bc], a':0x02,'ld [de], a':0x12,'ld a, [bc]':0x0a,'ld a, [de]':0x1a,
'ld [hl+], a':0x22,'ld [hli], a':0x22,'ld a, [hl+]':0x2a,'ld a, [hli]':0x2a,
'ld [hl-], a':0x32,'ld [hld], a':0x32,'ld a, [hl-]':0x3a,'ld a, [hld]':0x3a,
'ld sp, hl':0xf9,
'ldh [c], a':0xe2,'ldh a, [c]':0xf2,
}
for i,r in enumerate(reg16):
    single[f'inc {r}'] = 0x03 + i*0x10
    single[f'dec {r}'] = 0x0b + i*0x10
for i,r in enumerate(reg8):
    single[f'inc {r}'] = 0x04 + i*8
    single[f'dec {r}'] = 0x05 + i*8
for i,r1 in enumerate(reg8):
    for j,r2 in enumerate(reg8):
        if r1=='[hl]' and r2=='[hl]': continue
        single[f'ld {r1}, {r2}'] = 0x40 + i*8+j
# alu regs
alu_bases={'add a,':0x80,'add':0x80,'adc a,':0x88,'adc':0x88,'sub':0x90,'sbc a,':0x98,'sbc':0x98,'and':0xa0,'xor':0xa8,'or':0xb0,'cp':0xb8}
for op,base in alu_bases.items():
    for i,r in enumerate(reg8):
        if op.endswith(','):
            single[f'{op} {r}']=base+i
        else:
            single[f'{op} {r}']=base+i
for ci,c in enumerate(cond):
    single[f'ret {c}']=0xc0+ci*8
    single[f'jp {c}, hl'] = None
# pops pushes
for i,r in enumerate(reg16stk):
    single[f'pop {r}']=0xc1+i*0x10
    single[f'push {r}']=0xc5+i*0x10
# rsts
for n,op in [(0,0xc7),(8,0xcf),(0x10,0xd7),(0x18,0xdf),(0x20,0xe7),(0x28,0xef),(0x30,0xf7),(0x38,0xff)]:
    single[f'rst ${n:02x}']=op
    single[f'rst ${n:x}']=op

cb_single={}
ops=['rlc','rrc','rl','rr','sla','sra','swap','srl']
for oi,o in enumerate(ops):
    for ri,r in enumerate(reg8): cb_single[f'{o} {r}']=0x00+oi*8+ri
for bitn in range(8):
    for ri,r in enumerate(reg8):
        cb_single[f'bit {bitn}, {r}']=0x40+bitn*8+ri
        cb_single[f'res {bitn}, {r}']=0x80+bitn*8+ri
        cb_single[f'set {bitn}, {r}']=0xc0+bitn*8+ri

def assemble(s, pc):
    s=norm(s)
    if not s: return []
    def tval(x):
        x=x.strip().lower()
        m=re.fullmatch(r'@([+-])(.+)', x)
        if m:
            n=val(m.group(2)); return pc+n if m.group(1)=='+' else pc-n
        return val(x)
    # directives / non-code
    if s.startswith('section ') or s.startswith('include ') or s.startswith('def ') or s.startswith('charmap '): return []
    if s.endswith(':') or s.endswith('::'): return []
    if s.startswith('incbin '):
        raise StopIteration
    if s.startswith('db '):
        args=split_args(s[3:])
        out=[]
        for a in args:
            if a.startswith('"') and a.endswith('"'):
                out.extend(a[1:-1].encode('ascii'))
            else:
                out.append(val(a)&0xff)
        return out
    if s.startswith('dw '):
        out=[]
        for a in split_args(s[3:]): out += word(val(a))
        return out
    if s.startswith('ds '):
        args=split_args(s[3:]); n=val(args[0]); fill=val(args[1]) if len(args)>1 else 0
        return [fill&0xff]*n
    if s in single and single[s] is not None:
        return [single[s]]
    if s in cb_single:
        return [0xcb, cb_single[s]]
    # immediates
    # ld r, n8
    m=re.fullmatch(r'ld (b|c|d|e|h|l|\[hl\]|a), (.+)', s)
    if m and m.group(1) in reg8:
        r=m.group(1); imm=m.group(2)
        # skip reg-reg already handled; immediate if parseable
        try:
            v=val(imm); return [0x06+reg8.index(r)*8, v&0xff]
        except Exception: pass
    m=re.fullmatch(r'ld hl, sp([+-])(.+)', s)
    if m:
        v=val(m.group(2));
        if m.group(1)=='-': v=-v
        return [0xf8, v&0xff]
    m=re.fullmatch(r'ld (bc|de|hl|sp), (.+)', s)
    if m:
        return [0x01+reg16.index(m.group(1))*0x10] + word(val(m.group(2)))
    m=re.fullmatch(r'ld \[(.+)\], sp', s)
    if m:
        return [0x08]+word(val(m.group(1)))
    m=re.fullmatch(r'ld \[(.+)\], a', s)
    if m:
        # a16 handled; [bc]/[de]/[hl+/-] in single
        return [0xea]+word(val(m.group(1)))
    m=re.fullmatch(r'ld a, \[(.+)\]', s)
    if m:
        return [0xfa]+word(val(m.group(1)))
    m=re.fullmatch(r'ldh \[(.+)\], a', s)
    if m:
        v=val(m.group(1)); return [0xe0, v&0xff]
    m=re.fullmatch(r'ldh a, \[(.+)\]', s)
    if m:
        v=val(m.group(1)); return [0xf0, v&0xff]
    m=re.fullmatch(r'ld \[c\], a', s)
    if m: return [0xe2]
    m=re.fullmatch(r'ld a, \[c\]', s)
    if m: return [0xf2]
    m=re.fullmatch(r'add sp, (.+)', s)
    if m: return [0xe8, val(m.group(1))&0xff]
    m=re.fullmatch(r'ld hl, sp([+-])(.+)', s)
    if m:
        v=val(m.group(2));
        if m.group(1)=='-': v=-v
        return [0xf8, v&0xff]
    # alu imm
    immops=[('add a,',0xc6),('add',0xc6),('adc a,',0xce),('adc',0xce),('sub',0xd6),('sbc a,',0xde),('sbc',0xde),('and',0xe6),('xor',0xee),('or',0xf6),('cp',0xfe)]
    for prefix,op in immops:
        if s.startswith(prefix+' '): return [op, val(s[len(prefix)+1:])&0xff]
    # jp/jr/call
    m=re.fullmatch(r'jr (.+)', s)
    if m:
        arg=m.group(1)
        parts=split_args(arg)
        if len(parts)==1:
            target=tval(parts[0]); off=(target-(pc+2)) & 0xff; return [0x18, off]
        c=parts[0]; target=tval(parts[1]); off=(target-(pc+2))&0xff; return [0x20+cond.index(c)*8, off]
    m=re.fullmatch(r'jp hl', s)
    if m: return [0xe9]
    m=re.fullmatch(r'jp (.+)', s)
    if m:
        parts=split_args(m.group(1))
        if len(parts)==1: return [0xc3]+word(tval(parts[0]))
        return [0xc2+cond.index(parts[0])*8]+word(tval(parts[1]))
    m=re.fullmatch(r'call (.+)', s)
    if m:
        parts=split_args(m.group(1))
        if len(parts)==1: return [0xcd]+word(tval(parts[0]))
        return [0xc4+cond.index(parts[0])*8]+word(tval(parts[1]))
    # special ret cond handled single
    raise ValueError(f'unknown asm at {pc:04x}: {s}')

def assemble_file(path):
    data=[]; pc=None
    for lineno,line in enumerate(open(path),1):
        raw=line.strip('\n')
        m=re.search(r'ROMX\[\$([0-9a-fA-F]+)\]', raw)
        if m:
            pc=int(m.group(1),16); continue
        if pc is None: continue
        s=norm(raw)
        if not s: continue
        try:
            bs=assemble(raw, pc)
        except StopIteration:
            break
        except Exception as e:
            print(f'ERROR line {lineno}: {raw}\n  {e}', file=sys.stderr)
            raise
        data.extend(bs); pc += len(bs)
    return bytes(data)

if __name__=='__main__':
    # Load simple DEF constants from hardware.inc if present
    hw=pathlib.Path('/mnt/data/hardware.inc')
    if hw.exists():
        changed=True
        lines=hw.read_text().splitlines()
        while changed:
            changed=False
            for line in lines:
                m=re.match(r'\s*DEF\s+(\w+)\s+EQU\s+(.+)', line)
                if not m: continue
                name=m.group(1).lower(); expr=m.group(2).split(';')[0].strip().lower()
                try:
                    v=val(expr)
                except Exception:
                    continue
                if CONSTS.get(name)!=v:
                    CONSTS[name]=v; changed=True
    b=assemble_file(sys.argv[1])
    print(len(b))
    if len(sys.argv)>2:
        open(sys.argv[2],'wb').write(b)
