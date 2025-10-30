# RVX10-P: A Five-Stage Pipelined RISC-V Core

**Repository:** `rvx10p_230102091`

> **Course:** CS322M — Digital Logic and Computer Architecture  
> **Instructor:** Dr. Satyajit Das, IIT Guwahati  
> **Student:** Soumyadip Mandal (230102091)

---

## Overview

RVX10-P is a 32-bit, five-stage pipelined processor core. This project evolves a single-cycle RISC-V design into a high-throughput, pipelined architecture capable of instruction-level parallelism.

The core implements the complete **RV32I** base integer instruction set (including arithmetic, logical, load/store, branch, and jump operations) and is extended with **RVX10**, a custom set of 10 additional ALU operations.

### Supported Instruction Sets

- **Base (RV32I):** The standard 32-bit integer instruction set.
- **Extension (RVX10):** A custom 10-operation extension, including: `ANDN`, `ORN`, `XNOR`, `MIN`, `MAX`, `MINU`, `MAXU`, `ROL`, `ROR`, and `ABS`.

---

## ⚙️ Pipeline Architecture

The processor implements the classic five-stage RISC pipeline to maximize performance by overlapping instruction execution.

|  Stage  |        Name        | Key Operations                                                                                 |
| :-----: | :----------------: | :--------------------------------------------------------------------------------------------- |
| **IF**  | Instruction Fetch  | Fetches the next instruction from `imem` and computes PC + 4.                                  |
| **ID**  | Instruction Decode | Decodes the instruction, reads operands from the `regfile`, and generates the immediate value. |
| **EX**  |      Execute       | Performs the ALU operation or calculates the branch/jump target address.                       |
| **MEM** |   Memory Access    | Reads from or writes to the `dmem` for load/store operations.                                  |
| **WB**  |     Write Back     | Writes the result (from the ALU or `dmem`) back to the `regfile`.                              |

These stages are separated by four sets of pipeline registers: **IF/ID**, **ID/EX**, **EX/MEM**, and **MEM/WB**.

---

## 🧩 Module Organization

The project is partitioned into distinct hardware modules, each with a specific responsibility.

| File                       | Module             | Function                                                                       |
| :------------------------- | :----------------- | :----------------------------------------------------------------------------- |
| `riscvpipeline.sv`         | Top-Level          | Connects datapath, controller, and memories.                                   |
| `datapath.sv`              | Datapath           | Implements all pipeline stages, multiplexers, and pipeline register updates.   |
| `controller.sv`            | Controller         | Generates control signals and coordinates the hazard/forwarding units.         |
| `maindec.sv`               | Main Decoder       | Decodes the instruction's `opcode` to produce primary control lines.           |
| `aludec.sv`                | ALU Decoder        | Decodes `funct3`/`funct7` fields to select the specific ALU operation.         |
| `alu.sv`                   | ALU                | Executes all arithmetic, logical, and custom RVX10 operations.                 |
| `regfile.sv`               | Register File      | 32-register, 32-bit-wide bank with read/write ports (x0 is hardwired to zero). |
| `imem.sv`                  | Instruction Memory | Single-port memory loaded with `tests/rvx10_pipeline.hex`.                     |
| `dmem.sv`                  | Data Memory        | Single-port memory supporting word-level reads and writes.                     |
| `hazard_unit.sv`           | Hazard Detection   | Detects load-use hazards and injects stalls.                                   |
| `forwarding_unit.sv`       | Forwarding Unit    | Resolves data hazards via bypass paths (forwarding).                           |
| `tb/tb_pipeline.sv`        | Testbench          | Simulates the core, loads the test program, and dumps a waveform.              |
| `tests/rvx10_pipeline.hex` | Program            | Hex-formatted machine code for verification.                                   |

---

## 🧠 Control, Forwarding, and Hazard Logic

The core's correct operation under pipeline hazards is managed by dedicated control units.

### Controller

The `controller` and `maindec` modules generate the primary control signals for the datapath:

| Signal     | Function                                                             |
| :--------- | :------------------------------------------------------------------- |
| `RegWrite` | Enables writing to the register file (in the WB stage).              |
| `MemWrite` | Enables writing to the data memory (in the MEM stage).               |
| `MemToReg` | Selects the data source for write-back (ALU result or memory data).  |
| `ALUSrc`   | Selects the ALU's second operand (a register value or an immediate). |
| `Branch`   | Activates branch condition logic in the EX stage.                    |
| `Jump`     | Enables the PC to be updated with a jump target.                     |

### Hazard Management

- **Data Hazards (RAW):** Resolved by a `forwarding_unit` that bypasses results from the EX/MEM and MEM/WB stages directly to the ALU inputs in the EX stage, avoiding stalls.
- **Load-Use Hazards:** A specific case of data hazard where a load is followed by an instruction that uses its result. The `hazard_unit` detects this, stalling the pipeline for one cycle.
- **Control Hazards:** Handled by flushing the IF/ID pipeline register whenever a branch is taken or a jump occurs, discarding the incorrectly fetched (speculative) instructions.

---

## 🧰 Verification

The core is verified using a SystemVerilog testbench (`tb_pipeline.sv`) that simulates the execution of a test program.

### Testbench Behavior

- Instantiates the top-level `riscvpipeline` module.
- Loads the test program (`tests/rvx10_pipeline.hex`) into the instruction memory using `$readmemh`.
- Generates a clock and reset signal.
- Runs the simulation for a fixed duration (2000 ns).
- Generates a VCD (Value Change Dump) file (`dump.vcd`) for waveform analysis.
- Monitors memory write operations (`MEM[...] <= ...`) to self-check for correct program execution.
- Terminates the simulation using `$finish`.

### Test Program

The test program loaded into `imem` is a simple sequence to verify basic operations, register writes, and memory access:

```asm
# Initialize registers
addi x1, x0, 0      # x1 = 0
addi x2, x0, 1      # x2 = 1

# Perform ALU operations
add  x3, x1, x2     # x3 = x1 + x2 = 1
add  x4, x2, x3     # x4 = x2 + x3 = 2

# Perform memory operation
sw   x4, 100(x0)    # Store x4 (value 2) at memory address 100

# Infinite loop
jal  x0, 0          # Jump to address 0 (and loop)
```
