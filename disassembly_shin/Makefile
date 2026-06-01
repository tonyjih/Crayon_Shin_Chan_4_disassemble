IMAGE_DEPS = gfx\image_005_4001.2bpp gfx\image_005_4101.2bpp gfx\image_005_58e1.2bpp gfx\image_005_5de1.2bpp gfx\image_005_5ed1.2bpp gfx\image_005_63d1.2bpp gfx\image_005_64e1.2bpp gfx\image_006_50c4.2bpp gfx\image_007_4001.2bpp gfx\image_007_4201.2bpp gfx\image_007_4301.2bpp gfx\image_007_43e1.2bpp gfx\image_007_5fe1.2bpp gfx\image_007_60f1.2bpp gfx\image_007_61f1.2bpp gfx\image_007_620d.2bpp gfx\image_007_6271.2bpp gfx\image_007_6291.2bpp gfx\image_007_62b1.2bpp
RGBASM ?= ../rgbasm.exe
RGBLINK ?= ../rgblink.exe
RGBFIX ?= ../rgbfix.exe
RGBGFX ?= ../rgbgfx.exe

all: game.gb

%.2bpp: %.png
	$(RGBGFX) --colors embedded -o $@ $<

%.1bpp: %.png
	$(RGBGFX) -d 1 -o $@ $<

game.o: game.asm bank_*.asm $(IMAGE_DEPS)
	$(RGBASM) -o game.o game.asm

game.gb: game.o
	$(RGBLINK) -n game.sym -m game.map -o $@ $<
	$(RGBFIX) -v -p 255 $@

	@if which md5sum &>/dev/null; then md5sum $@; else md5 $@; fi

clean:
	rm -f game.o game.gb game.sym game.map
	find . \( -iname '*.1bpp' -o -iname '*.2bpp' \) -exec rm {} +