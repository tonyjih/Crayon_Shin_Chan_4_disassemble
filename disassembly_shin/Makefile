PYTHON ?= python

.PHONY: all original check-original test-rom clean clean-original clean-test-rom

all: original

original:
	$(PYTHON) -B tools/build_original.py

test-rom:
	$(PYTHON) -B tools/build_original.py --test-rom

check-original: original
	$(PYTHON) -B tools/test_original_assets.py
	$(PYTHON) -B tools/test_original_macros.py
	$(PYTHON) -B tools/check_control_flow.py --self-test
	$(PYTHON) -B tools/check_control_flow.py --asm-dir original --require-symbolic-memory

clean: clean-original

clean-original:
	$(PYTHON) -B tools/build_original.py --clean

clean-test-rom:
	$(PYTHON) -B tools/build_original.py --test-rom --clean
