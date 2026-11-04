"""Assemble native text fixtures with the pinned tools, including invalid input."""
from pathlib import Path
import subprocess
import tempfile
import unittest

from build_original import SOURCE, rgbds_tools


class OriginalTextTest(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.rgbds = rgbds_tools()

    def assemble(self, body, expected=None):
        with tempfile.TemporaryDirectory() as directory:
            root = Path(directory)
            source, obj, rom = (root / name for name in ("test.asm", "test.o", "test.gb"))
            code = ('INCLUDE "text/macros.inc"\nINCLUDE "charmap.inc"\n'
                    'SECTION "Text fixture", ROM0[0]\n' + body)
            if expected is not None:
                code += f"\nASSERT @ == {len(expected)}\n"
            source.write_text(code, encoding="utf-8")
            result = subprocess.run([self.rgbds["rgbasm"], "-o", str(obj), str(source)],
                                    cwd=SOURCE, capture_output=True, text=True)
            if expected is None:
                self.assertNotEqual(result.returncode, 0)
                self.assertIn("Unmapped message character", result.stderr)
                return
            self.assertEqual(result.returncode, 0, result.stderr)
            result = subprocess.run([self.rgbds["rgblink"], "-o", str(rom), str(obj)],
                                    capture_output=True, text=True)
            self.assertEqual(result.returncode, 0, result.stderr)
            self.assertEqual(rom.read_bytes()[:len(expected)], expected)

    def test_voiced_kana_icons_controls_and_charmap_scope(self):
        self.assemble('''
    text "がぱベペヴ<DPAD><A><B>"
    line "２レベル<VAR>"
    text "<WRITE>"
    done
    db "A" ; The caller's ASCII charmap is restored.
''', bytes.fromhex("45 15 43 2a 45 2d 43 2d 45 4a 0f 40 7b fe 06 78 45 2d 77 fd fc ff 41"))

    def test_empty_rows_and_shared_substitution_tail(self):
        self.assemble('''
    text "にわと"
SharedTail:
    text "り"
    done
    text ""
    line ""
    line "<FILL_01><TILE_C5>"
    done
''', bytes.fromhex("26 3f 24 35 ff fe fe 01 c5 ff"))

    def test_unmapped_characters_and_misspelled_tokens_fail(self):
        for invalid in ("漢", "A", "が\u3099", "<VRA>"):
            with self.subTest(text=invalid):
                self.assemble(f'    text "{invalid}"\n')


if __name__ == "__main__":
    unittest.main()
