IMAGE_DEPS = gfx/debugmenu_font_9000.rle gfx/image_005_4001.2bpp gfx/image_005_4101.2bpp gfx/image_005_58e1.2bpp gfx/image_005_5de1.2bpp gfx/image_005_5ed1.2bpp gfx/image_005_63d1.2bpp gfx/image_005_64e1.2bpp gfx/image_006_50c4.2bpp gfx/image_007_4001.2bpp gfx/image_007_4201.2bpp gfx/image_007_4301.2bpp gfx/image_007_43e1.2bpp gfx/image_007_5fe1.2bpp gfx/image_007_60f1.2bpp gfx/image_007_61f1.2bpp gfx/image_007_620d.2bpp gfx/image_007_6271.2bpp gfx/image_007_6291.2bpp gfx/image_007_62b1.2bpp
RLE_DEPS = gfx/rle/rle_b02_7b8e_to_8000.rle gfx/rle/rle_b02_7fe0_to_8800.rle gfx/rle/rle_b03_400f_to_8900.rle gfx/rle/rle_b05_7481_to_8000.rle gfx/rle/rle_b06_4001_to_8000.rle gfx/rle/rle_b06_4bc0_to_9000.rle gfx/rle/rle_b06_5334_to_8130.rle gfx/rle/rle_b06_53ec_to_8300.rle gfx/rle/rle_b06_5556_to_8a00.rle gfx/rle/rle_b06_5851_to_8000.rle gfx/rle/rle_b06_6156_to_8a00.rle gfx/rle/rle_b06_641e_to_8000.rle gfx/rle/rle_b06_663c_to_8800.rle gfx/rle/rle_b06_6839_to_8000.rle gfx/rle/rle_b06_6e44_to_8900.rle gfx/rle/rle_b06_7099_to_8000.rle gfx/rle/rle_b06_7581_to_8900.rle gfx/rle/rle_b06_7700_to_8000.rle
RGBASM ?= ../rgbasm.exe
RGBLINK ?= ../rgblink.exe
RGBFIX ?= ../rgbfix.exe
RGBGFX ?= ../rgbgfx.exe

all: game.gbc

%.2bpp: %.png
	$(RGBGFX) --colors embedded -o $@ $<

# Shin-chan 4 custom previous-byte RLE graphics.
# The .raw2bpp file is source data and should not be deleted by clean.
gfx/debugmenu_font_9000.rle: gfx/debugmenu_font_9000.raw2bpp tools/shin_prev_byte_rle.py
	python tools/shin_prev_byte_rle.py encode gfx/debugmenu_font_9000.raw2bpp gfx/debugmenu_font_9000.rle

%.1bpp: %.png
	$(RGBGFX) -d 1 -o $@ $<

%.rle: %.raw2bpp tools/shin_prev_byte_rle.py
	python tools/shin_prev_byte_rle.py encode $< $@

game.o: game.asm bank_*.asm $(IMAGE_DEPS) $(RLE_DEPS) $(RLE_DEPS)
	$(RGBASM) -o game.o game.asm

game.gbc: game.o
	$(RGBLINK) -n game.sym -m game.map -o $@ $<
	$(RGBFIX) -v -p 255 $@

	@if which md5sum &>/dev/null; then md5sum $@; else md5 $@; fi

clean:
	rm -f game.o game.gbc game.sym game.map
	find . \( -iname '*.1bpp' -o -iname '*.2bpp' -o -iname '*.rle' \) -exec rm {} +
