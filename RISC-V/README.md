# RVX10: Custom RISC-V ISA Extension

This project implements the RVX10 instruction set extension for a single-cycle RV32I processor, as specified in the assignment.

### Project Structure

-   `src/riscvsingle.sv`: The modified SystemVerilog source code containing the decode and ALU logic for the 10 new instructions.
-   `docs/ENCODINGS.md`: Detailed information on the machine code encoding for each new instruction, including worked examples.
-   `docs/TESTPLAN.md`: A description of the self-checking test strategy and the specific test cases used to validate each instruction.
-   `tests/rvx10.hex`: A memory image file in `$readmemh` format that contains the compiled test program.
-   `README.md`: This file.

### How to Build and Run

This project assumes you have a SystemVerilog simulator like Icarus Verilog (`iverilog`) or a commercial tool.

1.  **Compile the design:**
    Compile your testbench file along with the modified `riscvsingle.sv` core.
    ```sh
    iverilog -o sim -s your_testbench_toplevel.sv src/riscvsingle.sv
    ```

2.  **Run the simulation:**
    Execute the compiled simulation object. The testbench should be designed to load `tests/rvx10.hex` into its memory model.
    ```sh
    vvp sim
    ```

3.  **Check the result:**
    The simulation is successful if the testbench prints **"Simulation succeeded"**. [cite_start]This message is triggered when the test program correctly writes the value `25` to memory address `100`[cite: 10]. If the simulation times out or a different message appears, the test has failed.

### Notes

-   [cite_start]The `ABS` instruction correctly handles the two's complement `INT_MIN` case (`0x80000000`) by returning the same value, as specified[cite: 30, 104].
-   [cite_start]Rotate instructions (`ROL`, `ROR`) handle a rotate amount of zero by returning the original `rs1` value, preventing a shift by 32 bits[cite: 29, 103].
-   [cite_start]All unary operations (just `ABS` in this set) are encoded as R-type instructions with `rs2` set to `x0`[cite: 28].