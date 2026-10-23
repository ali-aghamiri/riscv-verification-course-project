"""Compare a DUT writeback trace with the independent reference trace.

Both CSV files use columns pc,instruction,rd,value. This is a post-course
checker; the supplied processor is not distributed in this repository.
"""
import argparse
import csv
from pathlib import Path


def read_trace(path: Path) -> list[dict[str, str]]:
    with path.open(newline="", encoding="utf-8") as stream:
        reader = csv.DictReader(stream)
        if reader.fieldnames != ["pc", "instruction", "rd", "value"]:
            raise ValueError(f"Unexpected CSV columns in {path}: {reader.fieldnames}")
        return list(reader)


def compare(expected: list[dict[str, str]], observed: list[dict[str, str]]) -> list[str]:
    problems = []
    if len(expected) != len(observed):
        problems.append(f"Length differs: expected {len(expected)}, observed {len(observed)}")
    for index, (left, right) in enumerate(zip(expected, observed), 1):
        if left != right:
            problems.append(f"Step {index}: expected {left}, observed {right}")
    return problems


def main() -> None:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("expected", type=Path)
    parser.add_argument("observed", type=Path)
    args = parser.parse_args()
    problems = compare(read_trace(args.expected), read_trace(args.observed))
    if problems:
        print(chr(10).join(problems[:20]))
        raise SystemExit(1)
    print("Traces match")


if __name__ == "__main__":
    main()
