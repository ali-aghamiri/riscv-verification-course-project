# RV32I Processor Verification

A reproducible verification project for a five-stage RV32I processor. It combines
SystemVerilog stimulus work from a master's HDL verification course with a
post-course, self-checking testbench. The testbench runs an attributed teaching
core, compares every nonzero register writeback against an independent Python
instruction-set model, and checks the final data-memory state.

## Verified run

Two directed programs exercise dependent arithmetic, loads and stores,
byte and halfword accesses, sign extension, signed and unsigned comparisons,
taken and untaken branches, JAL, JALR, AUIPC, and shifts. A third,
seeded constrained-random program stresses register dependencies and ALU
operations. On ModelSim SE 10.6d, the 30-word directed program passes 21
writebacks, the 20-word branch/memory program passes 12, and the 82-word
random program passes 80. All three pass full 256-word data-memory
comparisons. Seven Python unit tests pass. A deliberately corrupted expected
writeback causes the SystemVerilog scoreboard to report a mismatch.

## Run it

Requires Python 3.11+ and ModelSim/Questa with `vlib`, `vlog`, and `vsim`.
From the repository root:

```bash
python -m unittest discover -s tests -v
python tools/run_rtl.py --modelsim-bin "C:/path/to/modelsim/win64"
```

If the simulator executables are on `PATH`, omit `--modelsim-bin`. The second
command generates the program and oracle under `build/`, compiles the core
and testbench, then runs the simulation. Success prints:

```text
directed: PASS: 21 writebacks, control flow, data memory
branch_edges: PASS: 12 writebacks, control flow, data memory
random_alu: PASS: 80 writebacks, control flow, data memory
```

`tools/build_test_vectors.py` can generate the vectors independently, and
`tools/rv32i_reference.py` can execute a hexadecimal program and emit a CSV
trace. `tools/compare_traces.py` compares two traces in
`pc,instruction,rd,value` format.

## How the check works

The Python RV32I model produces expected architectural writebacks before
simulation. The SystemVerilog testbench observes the pipelined core's
writeback stage and checks the register number and value in order. It also
models a small byte-enabled data memory and checks its final state. A timeout
fails a run that never reaches the final store. The directed programs contain
wrong-path writes so a failed branch flush is visible to the scoreboard.

The verification compares architectural results, not internal pipeline
cycle timing. The current directed scenario is intentionally bounded rather
than a claim of exhaustive ISA or coverage verification.

## Repository layout

| Path | Purpose |
| --- | --- |
| `src/` | Original course stimulus generators and golden model |
| `tb/` | Post-course self-checking SystemVerilog testbench |
| `tools/` | Independent RV32I model, vector generator, runner, and trace checker |
| `tests/` | Python unit tests |
| `third_party/riscv-simple-sv/` | BSD-3-Clause teaching processor core |
| `examples/` | Saved course memory sample and validated small example |
| `reports/` | Archived simulator coverage report from the course |
| `docs/coursework.md` | Assignment stages and provenance |

The original generators and golden model remain available for inspection.
The self-checking run uses the new Python oracle because the archived
SystemVerilog golden model contains an out-of-bounds immediate bit and other
unreviewed behavior. The saved `examples/instruction_memory.txt` includes an
unsupported word at PC `0x34`; it is preserved as a course artifact, while
`examples/smoke_program.txt` is a validated example.

## Attribution

The processor RTL is the teaching core from
[RISC-V SiMPLE SV](https://github.com/tilk/riscv-simple-sv), distributed under
BSD-3-Clause. Its license and author attribution are retained in
`third_party/riscv-simple-sv/` and [THIRD_PARTY.md](THIRD_PARTY.md). The
processor code is not presented as student-authored work. The original
coursework and the later verification extensions are distinguished in
[docs/coursework.md](docs/coursework.md).
