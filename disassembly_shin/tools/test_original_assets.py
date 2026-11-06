"""Regression checks for the original asset codecs and build toolchain."""
from contextlib import redirect_stdout
from io import StringIO
import json
from pathlib import Path
import subprocess
import tempfile
import unittest
from unittest.mock import patch

from build_original import build, pack_spawns, rgbds_tools
from extract_original_assets import sound_track_source
from shin_prev_byte_rle import decode as decode_prev, encode as encode_prev
from shin_rleff import decode, encode


class OriginalCodecsTest(unittest.TestCase):
    def test_rgbds_uses_the_version_pin_for_all_four_tools(self):
        with tempfile.TemporaryDirectory() as directory:
            root = Path(directory)
            (root / ".rgbds-version").write_text("9.8.7\n", encoding="ascii")

            def version(command, **kwargs):
                return subprocess.CompletedProcess(command, 0, f"{command[0]} v9.8.7\n", "")

            with patch("build_original.ROOT", root), \
                 patch("build_original.tool", side_effect=lambda name: name), \
                 patch("build_original.subprocess.run", side_effect=version) as run:
                paths = rgbds_tools()
            self.assertEqual(set(paths), {"rgbasm", "rgblink", "rgbfix", "rgbgfx"})
            self.assertEqual({call.args[0][0] for call in run.call_args_list}, set(paths))

    def test_rgbds_rejects_a_mixed_or_unusable_toolchain(self):
        with tempfile.TemporaryDirectory() as directory:
            root = Path(directory)
            (root / ".rgbds-version").write_text("9.8.7\n", encoding="ascii")
            for name in ("rgbasm", "rgblink", "rgbfix", "rgbgfx"):
                for reported, exit_code in ((f"{name} v9.8.8", 0), (f"{name} v9.8.7", 1), ("", 0)):
                    with self.subTest(tool=name, reported=reported, exit_code=exit_code):
                        def version(command, **kwargs):
                            if command[0] == name:
                                return subprocess.CompletedProcess(command, exit_code, reported, "")
                            return subprocess.CompletedProcess(command, 0, f"{command[0]} v9.8.7", "")

                        with patch("build_original.ROOT", root), \
                             patch("build_original.tool", side_effect=lambda tool: tool), \
                             patch("build_original.subprocess.run", side_effect=version):
                            with self.assertRaisesRegex(RuntimeError, f"{name} requires RGBDS v9.8.7"):
                                rgbds_tools()

    def test_original_251_byte_run_limit(self):
        self.assertEqual(encode(bytes(280)), bytes((255, 251, 0, 255, 29, 0)))
        self.assertEqual(encode(bytes(256)), bytes((255, 251, 0, 255, 5, 0)))

    def test_literal_ff_and_short_runs(self):
        raw = bytes((1, 1, 2, 2, 2, 255, 3))
        packed = bytes((1, 1, 255, 3, 2, 255, 1, 255, 3))
        self.assertEqual(encode(raw), packed)
        self.assertEqual(decode(packed, len(raw)), (raw, len(packed)))

    def test_zero_count_and_hardware_output_limit(self):
        self.assertEqual(decode(bytes((255, 0, 9)), 256), (bytes([9]) * 256, 3))
        self.assertEqual(decode(bytes((255, 20, 9)), 5), (bytes([9]) * 5, 3))

    def test_truncated_streams(self):
        for packed in (b"", b"\xff", b"\xff\x01"):
            with self.assertRaises(ValueError):
                decode(packed, 1)

    def test_previous_byte_rle_and_group_boundaries(self):
        for raw in (bytes(8), bytes(range(256)), bytes([17]) * 264):
            packed = encode_prev(raw)
            self.assertEqual(decode_prev(packed), (raw, len(packed)))
        with self.assertRaises(ValueError):
            encode_prev(b"not aligned")

    def test_native_audio_loop_uses_word_index(self):
        data = bytes((0, 0, 15, 0, 253, 254, 0x35, 10, 0xB1, 3, 255))
        source = sound_track_source(data, 0x63A5)
        self.assertIn(".word_03:\n    audio_note $35, $0a", source)
        self.assertIn("audio_repeat $01, (.word_03 - AudioTrack_63a5) / 2", source)
        self.assertTrue(source.endswith("    audio_end\n"))
        with self.assertRaises(ValueError):
            sound_track_source(data[:-1], 0x63A5)

    def test_spawn_preserves_flags_and_y_parameter_bits(self):
        with tempfile.TemporaryDirectory() as directory:
            path = Path(directory) / "spawns.csv"
            path.write_text("type_raw,x,y_raw\n0x83,4660,0x4567\n", encoding="utf-8")
            self.assertEqual(pack_spawns(path), bytes((0x83, 0x34, 0x12, 0x67, 0x45, 255)))
            path.write_text("type_raw,x,y_raw\n0xff,0,0\n", encoding="utf-8")
            with self.assertRaises(ValueError):
                pack_spawns(path)

    def test_test_rom_uses_edited_assets_and_preserves_the_verified_original(self):
        with tempfile.TemporaryDirectory(prefix="rom build ") as directory:
            root = Path(directory)
            source = root / "source"
            source.mkdir()
            (source / "game.asm").write_text(
                'SECTION "Payload", ROM0[$150]\n'
                'INCBIN "assets/payload.bin"\n'
                'SECTION "Last byte", ROMX[$7fff], BANK[7]\n'
                'db $ff\n',
                encoding="ascii",
            )
            manifest = {"assets": [{
                "id": "payload", "source": "payload.bin", "codec": "raw",
                "decoded_size": 1, "stored_size": 1,
            }]}
            manifest_path = source / "assets.json"
            manifest_path.write_text(json.dumps(manifest), encoding="ascii")
            asset = source / "payload.bin"
            asset.write_bytes(b"\x01")

            original = root / "original"
            test = root / "test-rom"
            with patch("build_original.SOURCE", source), redirect_stdout(StringIO()):
                manifest["rom_md5"] = build(test, verify_original=False)
                manifest_path.write_text(json.dumps(manifest), encoding="ascii")
                self.assertEqual(build(original), manifest["rom_md5"])
                baseline = (original / "game.gb").read_bytes()
                self.assertEqual(baseline[0x150], 1)

                asset.write_bytes(b"\x02")
                self.assertNotEqual(build(test, verify_original=False), manifest["rom_md5"])
                self.assertEqual((test / "game.gb").read_bytes()[0x150], 2)
                with self.assertRaisesRegex(ValueError, "ROM verification failed"):
                    build(original)

            self.assertEqual((original / "game.gb").read_bytes(), baseline)
            self.assertEqual((original / "assets/payload.bin").read_bytes(), b"\x01")


if __name__ == "__main__":
    unittest.main()
