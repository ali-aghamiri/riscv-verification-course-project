# Coursework map and provenance

The original assignment had four stages. This repository preserves the
student's available work from stages two and three and adds a reproducible
self-checking flow after the course. The stage-one report is summarized below
because the saved document contains a student ID and course material.

| Stage | Assignment goal | Saved evidence | Repository treatment |
| --- | --- | --- | --- |
| 1 | Study the supplied core and plan checks | RISC-V research report and processor analysis | Summary below |
| 2 | Generate directed and random stimuli | Submitted generators, testbench, memory sample, report | Source generators and sample in `src/` and `examples/` |
| 3 | Create a reference model and inspect coverage | Submitted model, simulator project, coverage report | Original model in `src/`; archived coverage in `reports/` |
| 4 | Add checker and scoreboard | No stage-four submission in the saved files | A new post-course checker and SystemVerilog scoreboard in `tools/` and `tb/` |

## Stage 1: processor and verification plan

The saved report surveys RV32 instruction formats, the five-stage pipeline,
and modules of the supplied design. It proposes checks for arithmetic,
register and memory operations, branches and jumps, and data/control hazards.

## Stage 2: stimulus generation

The directed and constrained-random SystemVerilog generators are preserved
with their original filenames. The stage-two report describes arithmetic,
shifts, loads/stores, branches/jumps, hazards, and boundary-value scenarios.
The archived memory sample is evidence of the submission, not a passing
RV32I regression vector.

## Stage 3: golden model and coverage

The original golden model interprets hexadecimal instructions and writes a
result file. It is preserved for provenance. It is not the oracle for the new
passing regression because its immediate handling needs correction. The
coverage report is an archived output from the course simulator run; no new
coverage percentage is inferred from it.

## Post-course verification extension

The added Python model independently interprets the directed program. The
new SystemVerilog testbench instantiates the attributed teaching processor,
checks each writeback and memory result, and fails on mismatch or timeout.
These files were developed after the course and are identified as such to
keep the original submission distinguishable from later work.
