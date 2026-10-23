# RISC-V Verification Coursework

A SystemVerilog coursework project exploring stimulus generation and a behavioral reference model for a provided RISC-V processor design. The original files were produced for a master's-level HDL verification course.

For a stage-by-stage account of the assignment and saved submissions, see [Coursework map](docs/coursework.md).

## Project scope

The assignment was organized into four stages: study the reference processor, generate verification stimuli, build a golden model and inspect code coverage, then add a checker and scoreboard. This repository contains selected implementation files from stages two and three. The stage-one research report is not included. **A checker and scoreboard are not present in the available submission**, so this is a partial verification environment rather than a complete self-checking testbench.

The deterministic generator encodes selected RISC-V instruction scenarios and corner cases. The random generator creates constrained instruction sequences across R, I, S, U, B, and J formats. Both write hexadecimal machine words to `file_data.txt`. The golden model reads that file and writes `golden_result.txt`. The original SystemVerilog module and file names are retained, including their spelling, to preserve the submitted code.

## Repository layout

```text
src/
  determenstic_stimuli_genrator.sv  # directed instruction scenarios
  random_stimuli_genrator.sv        # constrained random stimuli
  goldenmodel.sv                    # behavioral reference model
examples/
  instruction_memory.txt            # original stage-two sample (contains unsupported words)
  smoke_program.txt                 # validated post-course example
reports/
  coverage-report.txt               # archived simulator coverage output
docs/
  coursework.md                     # assignment stages and provenance
tools/
  rv32i_reference.py                # independent post-course ISA model
  compare_traces.py                 # post-course trace checker
tests/
  test_reference.py                 # model and checker tests
```

## Using the source

The generators and model were written for a SystemVerilog simulator with support for file I/O and `$urandom_range` (the coursework used ModelSim). Run **one** generator in the simulator to create `file_data.txt`, then run `goldenmodel` in the same working directory to produce `golden_result.txt`. The generators are standalone top-level modules; they are not meant to run together because both write to the same file.

For a full processor comparison, the course-provided RISC-V design and its testbench are also required. They are intentionally excluded here because the available coursework does not establish redistribution rights for that reference design. The supplied processor comparison and coverage run have not been reproduced here; the coverage report is an artifact of the original course run.

## Validation and limitations

The three source modules compile in ModelSim SE 10.6d with zero errors and 31 warnings. The deterministic generator ran and produced 116 hexadecimal instruction words. The golden model and processor comparison were not run in this preparation pass. One compiler warning points to an out-of-bounds immediate bit in the golden model (`imm[12]` in a 12-bit vector); its behavior needs further review before treating model outputs as authoritative. The deterministic generator also emits some instruction words that may not represent valid supported instructions. No fresh coverage percentage is claimed.

## Post-course validation extension

The `tools/` directory is a **new addition after the course**, separate from the original SystemVerilog submission. It contains a bounded, instruction-level RV32I reference model and a CSV trace checker. It does not model pipeline timing or replace a DUT-integrated scoreboard. A DUT can be compared only after it exports a matching `pc,instruction,rd,value` trace.

Run the validated example and tests with Python 3.11 or newer:

```bash
python tools/rv32i_reference.py examples/smoke_program.txt --trace trace.csv
python -m unittest discover -s tests -v
```

The archived `examples/instruction_memory.txt` is not a validated RV32I program: the reference model stops at PC `0x34` on unsupported word `0x00ad0e80`. It is retained as evidence of the stage-two submission rather than presented as a passing test. The new smoke example is separate and passes the model tests.

## Status and provenance

The source files and coverage output were selected from the student's stage-three submission. The sample memory file comes from stage two. Simulator-generated databases, waveform files, duplicate archives, course slides, and the supplied processor implementation have been left out. The code remains close to the original submission, so it should be treated as an academic project rather than a maintained verification library.
