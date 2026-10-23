"""Build and run the attributed RV32I core against the generated scoreboard."""
from __future__ import annotations

import argparse
import json
import os
from pathlib import Path
import shutil
import subprocess
import sys

ROOT = Path(__file__).resolve().parents[1]
CORE = ROOT / "third_party" / "riscv-simple-sv"
BUILD = ROOT / "build"
LIBRARY = BUILD / "modelsim"


def executable(name: str, bin_dir: Path | None) -> str:
    path = bin_dir / name if bin_dir else shutil.which(name)
    if path is None or not Path(path).exists():
        raise FileNotFoundError(f"Cannot find {name}; set --modelsim-bin to the ModelSim bin directory")
    return str(path)


def run(command: list[str], *, require_pass: bool = False) -> None:
    result = subprocess.run(command, cwd=ROOT, capture_output=True, text=True, errors="replace")
    output = result.stdout + result.stderr
    if result.returncode or (require_pass and "PASS:" not in output):
        print(output, file=sys.stderr)
        raise SystemExit(result.returncode or 1)
    if require_pass:
        for line in output.splitlines():
            if "PASS:" in line:
                print(line.strip().lstrip("# "))
                break


def main() -> None:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--modelsim-bin", type=Path, default=Path(os.environ["MODELSIM_BIN"]) if "MODELSIM_BIN" in os.environ else None)
    args = parser.parse_args()
    BUILD.mkdir(exist_ok=True)
    vlib = executable("vlib.exe" if os.name == "nt" else "vlib", args.modelsim_bin)
    vlog = executable("vlog.exe" if os.name == "nt" else "vlog", args.modelsim_bin)
    vsim = executable("vsim.exe" if os.name == "nt" else "vsim", args.modelsim_bin)
    if not LIBRARY.exists():
        run([vlib, str(LIBRARY)])
    files = sorted(str(path) for path in CORE.glob("*.sv"))
    run([vlog, "-sv", "-work", str(LIBRARY), f"+incdir+{CORE}", *files, str(ROOT / "tb" / "tb_scoreboard.sv")])
    for case in ("directed", "branch_edges", "random_alu"):
        case_dir = BUILD / case
        run([sys.executable, str(ROOT / "tools" / "build_test_vectors.py"),
             "--case", case, "--out", str(case_dir)])
        manifest = json.loads((case_dir / "manifest.json").read_text(encoding="ascii"))
        print(f"{case}: ", end="", flush=True)
        run([vsim, "-c", "-lib", LIBRARY.as_posix(), "tb_scoreboard",
             f"+program={case_dir / 'program.hex'}",
             f"+expected={case_dir / 'writebacks.hex'}",
             f"+memory={case_dir / 'memory.hex'}",
             f"+word_count={manifest['words']}",
             f"+write_count={manifest['writebacks']}",
             f"+sentinel={manifest['sentinel']}",
             "-do", str(ROOT / "tb" / "run.do")], require_pass=True)


if __name__ == "__main__":
    main()
