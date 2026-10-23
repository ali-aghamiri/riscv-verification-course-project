# Coursework map and provenance

This page maps the available files to the original four-stage HDL verification assignment. It was prepared from the student's saved submissions and the local assignment brief; it is a summary rather than a replacement for the submitted reports.

| Stage | Assignment goal | Evidence available | Included here |
| --- | --- | --- | --- |
| 1 | Study the supplied RISC-V core and identify verification scenarios | RISC-V research report and instruction/processor analysis | Summary below; original report omitted because it contains a student ID and course material |
| 2 | Produce directed and constrained-random stimuli | Submitted SystemVerilog generators, testbench, memory sample, and report | Generators and sample instruction memory |
| 3 | Build a golden model and measure coverage | Submitted model, simulator project, and coverage report | Model and archived coverage report |
| 4 | Add checker and scoreboard | No stage-four submission found in the saved course folder | Not represented as completed coursework; a separate post-course trace checker is documented in the README |

## Stage 1: processor and verification plan

The submitted report surveys RV32 instruction formats (R, I, S, B, U, and J), a five-stage pipeline, and the modules of the provided reference design. The proposed checks cover instruction behavior, register and memory operations, branch/jump flow, and data/control hazards. The report is descriptive; it does not provide an executable test suite.

## Stage 2: stimulus generation

The directed generator encodes hand-selected instruction sequences and corner cases. The random generator produces constrained selections across the six instruction formats. The student's stage-two report describes scenarios for arithmetic, shifts, loads/stores, branches/jumps, register transfers, hazards, and boundary values. The original filenames are preserved in `src/` so they remain traceable to the submission.

## Stage 3: reference model and coverage

The golden model interprets instructions from a hexadecimal memory file and records results to a text file. The included coverage report is an archived output from the original simulator run against the supplied RISC-V design. Coverage varies by module; this repository does not claim a single overall coverage number or reproduce the original run without that supplied design.

## What the saved files cannot establish

The local stage-three testbench instantiates the supplied processor but leaves the generator and golden model instantiations commented out. The saved source therefore does not show an automated DUT-versus-model checker or scoreboard. The compiler also reports an out-of-bounds immediate bit in the model. Those issues are tracked in the README and must be resolved before describing this as a complete self-checking verification environment.
