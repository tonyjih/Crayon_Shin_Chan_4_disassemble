PYTHON ?= python

.PHONY: all original check-original check-sdl-export test-rom debug-rom clean clean-original clean-test-rom

all: original

original:
	$(PYTHON) -B tools/build_original.py

test-rom:
	$(PYTHON) -B tools/build_original.py --test-rom

debug-rom:
	$(PYTHON) -B tools/build_original.py --debug-rom

check-original: original
	$(PYTHON) -B tools/test_original_assets.py
	$(PYTHON) -B tools/test_original_macros.py
	$(PYTHON) -B tools/check_control_flow.py --self-test
	$(PYTHON) -B tools/check_control_flow.py --asm-dir original --require-symbolic-memory

check-sdl-export:
	$(PYTHON) -B tools/check_sdl_export.py

clean: clean-original

clean-original:
	$(PYTHON) -B tools/build_original.py --clean

clean-test-rom:
	$(PYTHON) -B tools/build_original.py --test-rom --clean
