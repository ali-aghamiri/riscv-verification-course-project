# RISC-V Verification Coursework

A SystemVerilog coursework project exploring stimulus generation and a behavioral reference model for a provided RISC-V processor design. The work was completed for an HDL verification course during the 2023?2024 academic year.

## Project scope

The assignment was organized into four stages: study the reference processor, generate verification stimuli, build a golden model and inspect code coverage, then add a checker and scoreboard. This repository contains the submitted stimulus generators and golden model from the first three stages. **A checker and scoreboard are not present in the available submission**, so this is a partial verification environment rather than a complete self-checking testbench.

The deterministic generator encodes selected RISC-V instruction scenarios and corner cases. The random generator creates constrained instruction sequences across R, I, S, U, B, and J formats. Both write hexadecimal machine words to `file_data.txt`. The golden model reads that file and writes `golden_result.txt`. The original SystemVerilog module and file names are retained, including their spelling, to preserve the submitted code.

## Repository layout

```text
src/
  determenstic_stimuli_genrator.sv  # directed instruction scenarios
  random_stimuli_genrator.sv        # constrained random stimuli
  goldenmodel.sv                    # behavioral reference model
examples/
  instruction_memory.txt            # small sample from stage 2
reports/
  coverage-report.txt               # archived simulator coverage output
```

## Using the source

The generators and model were written for a SystemVerilog simulator with support for file I/O and `$urandom_range` (the coursework used ModelSim). Run **one** generator in the simulator to create `file_data.txt`, then run `goldenmodel` in the same working directory to produce `golden_result.txt`. The generators are standalone top-level modules; they are not meant to run together because both write to the same file.

For a full processor comparison, the course-provided RISC-V design and its testbench are also required. They are intentionally excluded here because the available coursework does not establish redistribution rights for that reference design. The supplied processor comparison and coverage run have not been reproduced here; the coverage report is an artifact of the original course run.

## Validation and limitations

The three source modules compile in ModelSim SE 10.6d with zero errors and 31 warnings. The deterministic generator ran and produced 116 hexadecimal instruction words. The golden model and processor comparison were not run in this preparation pass. One compiler warning points to an out-of-bounds immediate bit in the golden model (`imm[12]` in a 12-bit vector); its behavior needs further review before treating model outputs as authoritative. The deterministic generator also emits some instruction words that may not represent valid supported instructions. No fresh coverage percentage is claimed.

## Status and provenance

The source files and coverage output were selected from the student's stage-three submission. The sample memory file comes from stage two. Simulator-generated databases, waveform files, duplicate archives, course slides, and the supplied processor implementation have been left out. The code remains close to the original submission, so it should be treated as an academic project rather than a maintained verification library.
