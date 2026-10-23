"""Independent post-course RV32I reference for reviewing instruction streams.

This is not part of the original submission and does not model pipeline timing.
"""
from __future__ import annotations

import argparse
import csv
from pathlib import Path

MASK = 0xFFFFFFFF


def signed(value: int, bits: int) -> int:
    value &= (1 << bits) - 1
    return value - (1 << bits) if value & (1 << (bits - 1)) else value


class RV32I:
    def __init__(self, words: list[int]):
        self.words = words
        self.reg = [0] * 32
        self.memory: dict[int, int] = {}
        self.pc = 0

    def load(self, address: int, size: int, sign: bool) -> int:
        value = sum(self.memory.get((address + i) & MASK, 0) << (8 * i) for i in range(size))
        return signed(value, size * 8) & MASK if sign else value

    def store(self, address: int, size: int, value: int) -> None:
        for i in range(size):
            self.memory[(address + i) & MASK] = (value >> (8 * i)) & 0xFF

    def step(self) -> tuple[int, int, int, int]:
        if self.pc % 4 or self.pc < 0 or self.pc // 4 >= len(self.words):
            raise ValueError(f"PC outside instruction stream: 0x{self.pc:08x}")
        old_pc = self.pc
        inst = self.words[old_pc // 4]
        opcode, rd, f3 = inst & 0x7F, (inst >> 7) & 31, (inst >> 12) & 7
        rs1, rs2, f7 = (inst >> 15) & 31, (inst >> 20) & 31, (inst >> 25) & 127
        a, b = self.reg[rs1], self.reg[rs2]
        next_pc = (old_pc + 4) & MASK
        result = None
        i_imm = signed(inst >> 20, 12)
        if opcode == 0x33:  # register arithmetic
            shamt = b & 31
            operations = {
                (0, 0): lambda: a + b, (0, 0x20): lambda: a - b,
                (1, 0): lambda: a << shamt, (2, 0): lambda: int(signed(a, 32) < signed(b, 32)),
                (3, 0): lambda: int(a < b), (4, 0): lambda: a ^ b,
                (5, 0): lambda: a >> shamt, (5, 0x20): lambda: signed(a, 32) >> shamt,
                (6, 0): lambda: a | b, (7, 0): lambda: a & b,
            }
            operation = operations.get((f3, f7))
            if operation is None:
                raise ValueError(f"Unsupported R instruction: 0x{inst:08x}")
            result = operation()
        elif opcode == 0x13:  # immediate arithmetic
            shamt = (inst >> 20) & 31
            if f3 == 0: result = a + i_imm
            elif f3 == 2: result = int(signed(a, 32) < i_imm)
            elif f3 == 3: result = int(a < (i_imm & MASK))
            elif f3 == 4: result = a ^ i_imm
            elif f3 == 6: result = a | i_imm
            elif f3 == 7: result = a & i_imm
            elif f3 == 1 and f7 == 0: result = a << shamt
            elif f3 == 5 and f7 == 0: result = a >> shamt
            elif f3 == 5 and f7 == 0x20: result = signed(a, 32) >> shamt
            else: raise ValueError(f"Unsupported I instruction: 0x{inst:08x}")
        elif opcode == 0x03:  # loads
            sizes = {0: (1, True), 1: (2, True), 2: (4, True), 4: (1, False), 5: (2, False)}
            if f3 not in sizes: raise ValueError(f"Unsupported load: 0x{inst:08x}")
            size, sign = sizes[f3]
            address = (a + i_imm) & MASK
            if address % size: raise ValueError(f"Misaligned load: 0x{address:08x}")
            result = self.load(address, size, sign)
        elif opcode == 0x23:  # stores
            sizes = {0: 1, 1: 2, 2: 4}
            if f3 not in sizes: raise ValueError(f"Unsupported store: 0x{inst:08x}")
            imm = signed(((inst >> 25) << 5) | rd, 12)
            address = (a + imm) & MASK
            if address % sizes[f3]: raise ValueError(f"Misaligned store: 0x{address:08x}")
            self.store(address, sizes[f3], b)
        elif opcode == 0x63:  # branches
            imm = signed((((inst >> 31) & 1) << 12) | (((inst >> 7) & 1) << 11) |
                         (((inst >> 25) & 63) << 5) | (((inst >> 8) & 15) << 1), 13)
            conditions = {0: a == b, 1: a != b, 4: signed(a, 32) < signed(b, 32),
                          5: signed(a, 32) >= signed(b, 32), 6: a < b, 7: a >= b}
            if f3 not in conditions: raise ValueError(f"Unsupported branch: 0x{inst:08x}")
            if conditions[f3]: next_pc = (old_pc + imm) & MASK
        elif opcode == 0x37: result = inst & 0xFFFFF000  # LUI
        elif opcode == 0x17: result = old_pc + (inst & 0xFFFFF000)  # AUIPC
        elif opcode == 0x6F:  # JAL
            imm = signed((((inst >> 31) & 1) << 20) | (((inst >> 12) & 255) << 12) |
                         (((inst >> 20) & 1) << 11) | (((inst >> 21) & 1023) << 1), 21)
            result, next_pc = old_pc + 4, (old_pc + imm) & MASK
        elif opcode == 0x67 and f3 == 0:  # JALR
            result, next_pc = old_pc + 4, ((a + i_imm) & MASK) & ~1
        else:
            raise ValueError(f"Unsupported instruction at PC 0x{old_pc:08x}: 0x{inst:08x}")
        if next_pc % 4: raise ValueError(f"Misaligned next PC: 0x{next_pc:08x}")
        if result is not None and rd != 0: self.reg[rd] = result & MASK
        self.reg[0] = 0
        self.pc = next_pc
        return old_pc, inst, rd if result is not None and rd != 0 else 0, self.reg[rd] if result is not None and rd != 0 else 0

    def run(self, max_steps: int = 10000) -> list[tuple[int, int, int, int]]:
        trace = []
        for _ in range(max_steps):
            if self.pc == len(self.words) * 4: return trace
            trace.append(self.step())
        raise ValueError(f"Step limit reached ({max_steps}); possible loop")


def read_words(path: Path) -> list[int]:
    words = []
    for number, line in enumerate(path.read_text(encoding="utf-8-sig").splitlines(), 1):
        value = line.strip()
        if not value: continue
        if len(value) != 8 or any(c not in "0123456789abcdefABCDEF" for c in value):
            raise ValueError(f"Invalid hex word on line {number}: {value!r}")
        words.append(int(value, 16))
    return words


def main() -> None:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("instructions", type=Path)
    parser.add_argument("--trace", type=Path, help="Write PC/instruction/writeback CSV")
    parser.add_argument("--max-steps", type=int, default=10000)
    args = parser.parse_args()
    model = RV32I(read_words(args.instructions))
    trace = model.run(args.max_steps)
    if args.trace:
        with args.trace.open("w", newline="", encoding="utf-8") as output:
            writer = csv.writer(output)
            writer.writerow(["pc", "instruction", "rd", "value"])
            writer.writerows((f"{pc:08x}", f"{inst:08x}", rd, f"{value:08x}") for pc, inst, rd, value in trace)
    print(f"Executed {len(trace)} instructions; final PC 0x{model.pc:08x}")


if __name__ == "__main__":
    main()
