"""Rebuild and check every SDL3 export against its byte-level baseline."""

from hashlib import sha256
import os
from pathlib import Path
import subprocess
import sys
from tempfile import TemporaryDirectory

ROOT = Path(__file__).resolve().parent.parent
PORT = ROOT / "port"


def main() -> int:
    # Preserve native header line endings and the PNG bytes from each reference encoder.
    profile = "windows" if os.name == "nt" else "wsl"
    baseline = PORT / "export-baselines" / f"{profile}.sha256"
    expected = {}
    for line in baseline.read_text(encoding="ascii").splitlines():
        digest, name = line.split("  ", 1)
        expected[name] = digest
    if len(expected) != 78:
        raise ValueError(f"{baseline}: expected 78 reference files")

    with TemporaryDirectory(prefix="shin4-sdl-export-") as temporary:
        output = Path(temporary)
        headers = [output / f"{kind}_data.hpp" for kind in ("stage", "sound", "screen", "color", "sprite")]
        result = subprocess.run([sys.executable, "-B", str(PORT / "export_stage.py"), *map(str, headers)],
                                cwd=ROOT)
        if result.returncode:
            return result.returncode
        actual = {path.relative_to(output).as_posix(): sha256(path.read_bytes()).hexdigest()
                  for path in output.rglob("*") if path.is_file()}

    missing = expected.keys() - actual.keys()
    extra = actual.keys() - expected.keys()
    changed = {name for name in expected.keys() & actual.keys() if expected[name] != actual[name]}
    for status, names in (("Missing", missing), ("Unexpected", extra), ("Changed", changed)):
        for name in sorted(names):
            print(f"{status}: {name}", file=sys.stderr)
    if missing or extra or changed:
        print(f"SDL3 export differs from the {profile} baseline.", file=sys.stderr)
        return 1
    print(f"{len(actual)} SDL3 exported files match the {profile} SHA-256 baseline.")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
