"""Build a directed RV32I program and independent writeback oracle for RTL simulation."""
from __future__ import annotations

import argparse
import json
import random
from pathlib import Path

if __package__:
    from .rv32i_reference import RV32I
else:
    from rv32i_reference import RV32I

TEXT_BASE = 0x00400000
DATA_BASE = 0x80000000


def r(f7: int, rs2: int, rs1: int, f3: int, rd: int) -> int:
    return f7 << 25 | rs2 << 20 | rs1 << 15 | f3 << 12 | rd << 7 | 0x33


def i(imm: int, rs1: int, f3: int, rd: int, op: int = 0x13) -> int:
    return (imm & 0xFFF) << 20 | rs1 << 15 | f3 << 12 | rd << 7 | op


def s(imm: int, rs2: int, rs1: int, f3: int) -> int:
    imm &= 0xFFF
    return (imm >> 5) << 25 | rs2 << 20 | rs1 << 15 | f3 << 12 | (imm & 31) << 7 | 0x23


def b(imm: int, rs2: int, rs1: int, f3: int) -> int:
    assert imm % 2 == 0 and -4096 <= imm <= 4094
    imm &= 0x1FFF
    return ((imm >> 12) & 1) << 31 | ((imm >> 5) & 63) << 25 | rs2 << 20 | rs1 << 15 | f3 << 12 | ((imm >> 1) & 15) << 8 | ((imm >> 11) & 1) << 7 | 0x63


def u(upper: int, rd: int, op: int) -> int:
    return (upper & 0xFFFFF) << 12 | rd << 7 | op


def j(imm: int, rd: int) -> int:
    assert imm % 2 == 0 and -(1 << 20) <= imm < (1 << 20)
    imm &= 0x1FFFFF
    return ((imm >> 20) & 1) << 31 | ((imm >> 1) & 1023) << 21 | ((imm >> 11) & 1) << 20 | ((imm >> 12) & 255) << 12 | rd << 7 | 0x6F


def directed_program() -> list[int]:
    return [
        u(DATA_BASE >> 12, 1, 0x37),   # x1 = data-memory base
        i(5, 0, 0, 2),                  # x2 = 5
        i(7, 0, 0, 3),                  # x3 = 7
        r(0, 3, 2, 0, 4),               # x4 = 12, dependent arithmetic
        s(0, 4, 1, 2),                  # sw x4, 0(x1)
        i(0, 1, 2, 5, 0x03),            # lw x5, 0(x1)
        b(8, 4, 5, 0),                  # taken beq; skip wrong-path write
        i(99, 0, 0, 6),
        i(1, 0, 0, 6),
        r(0x20, 2, 5, 0, 7),            # x7 = 7
        b(8, 2, 7, 1),                  # taken bne
        i(99, 0, 0, 8),
        i(2, 0, 0, 8),
        j(8, 9),                        # jal x9, +8
        i(99, 0, 0, 10),
        i(3, 0, 0, 10),
        u(0, 11, 0x17),                 # auipc x11, 0
        i(12, 11, 0, 12, 0x67),         # jalr x12, x11 + 12
        i(99, 0, 0, 13),
        i(4, 0, 0, 13),
        i(-1, 0, 0, 14),                # x14 = -1
        i(0, 14, 2, 15),                # signed comparison
        i(1, 14, 3, 16),                # unsigned comparison
        s(8, 14, 1, 0),                 # sb x14, 8(x1)
        i(8, 1, 4, 17, 0x03),           # lbu = 255
        i(8, 1, 0, 18, 0x03),           # lb = -1
        i(15, 14, 7, 19),               # andi = 15
        i(1, 14, 5, 20),                # srli
        i(0x401, 14, 5, 21),            # srai
        s(4, 13, 1, 2),                 # final store: 4 at data[1]
    ]


def branch_edges_program() -> list[int]:
    return [
        u(DATA_BASE >> 12, 1, 0x37),
        i(-8, 0, 0, 2),
        i(3, 0, 0, 3),
        b(8, 3, 2, 4),              # signed BLT taken
        i(99, 0, 0, 4),
        r(0, 3, 2, 2, 4),           # SLT = 1
        b(8, 3, 2, 7),              # unsigned BGEU taken
        i(99, 0, 0, 5),
        r(0, 2, 3, 3, 5),           # SLTU = 1
        i(0, 0, 0, 6),
        b(8, 5, 4, 1),              # BNE not taken
        i(6, 0, 0, 6),
        i(3, 5, 1, 7),              # SLLI = 8
        s(12, 7, 1, 1),             # SH at +12
        i(12, 1, 5, 8, 0x03),      # LHU = 8
        i(-1, 0, 0, 9),
        s(14, 9, 1, 0),             # SB modifies third byte of same word
        i(12, 1, 2, 10, 0x03),     # LW = 0x00ff0008
        i(7, 0, 0, 11),
        s(4, 11, 1, 2),             # final store: 7 at data[1]
    ]


def random_alu_program(seed: int = 20261023) -> list[int]:
    """Deterministic constrained-random ALU stream with initialized sources."""
    rng = random.Random(seed)
    words = [u(DATA_BASE >> 12, 1, 0x37)]
    words.extend(i(reg - 8, 0, 0, reg) for reg in range(2, 16))
    words.append(i(1, 0, 0, 0))  # x0 must ignore a write
    r_ops = [(0, 0), (0x20, 0), (0, 1), (0, 2), (0, 3),
             (0, 4), (0, 5), (0x20, 5), (0, 6), (0, 7)]
    i_ops = [0, 2, 3, 4, 6, 7]
    for _ in range(64):
        rd = rng.randrange(2, 16)
        rs1 = rng.randrange(0, 16)
        if rng.randrange(2):
            f7, f3 = rng.choice(r_ops)
            rs2 = rng.randrange(0, 16)
            words.append(r(f7, rs2, rs1, f3, rd))
        else:
            words.append(i(rng.randrange(-16, 16), rs1, rng.choice(i_ops), rd))
    words.extend([i(9, 0, 0, 16), s(4, 16, 1, 2)])
    return words


def main() -> None:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--out", type=Path, default=Path("build"))
    parser.add_argument("--case", choices=["directed", "branch_edges", "random_alu"], default="directed")
    args = parser.parse_args()
    args.out.mkdir(parents=True, exist_ok=True)
    words = {"directed": directed_program, "branch_edges": branch_edges_program, "random_alu": random_alu_program}[args.case]()
    model = RV32I(words, base=TEXT_BASE)
    trace = model.run()
    (args.out / "program.hex").write_text("".join(f"{word:08x}\n" for word in words), encoding="ascii")
    writes = [(rd, value) for _, _, rd, value in trace if rd]
    (args.out / "writebacks.hex").write_text("".join(f"{rd:08x}{value:08x}\n" for rd, value in writes), encoding="ascii")
    sentinel = {"directed": 4, "branch_edges": 7, "random_alu": 9}[args.case]
    assert model.load(DATA_BASE + 4, 4, False) == sentinel
    (args.out / "memory.hex").write_text("".join(f"{model.load(DATA_BASE + 4*index, 4, False):08x}\n" for index in range(256)), encoding="ascii")
    (args.out / "manifest.json").write_text(json.dumps({"words": len(words), "writebacks": len(writes), "sentinel": sentinel}), encoding="ascii")
    print(f"Generated {args.case}: {len(words)} instructions and {len(writes)} expected writebacks")


if __name__ == "__main__":
    main()
