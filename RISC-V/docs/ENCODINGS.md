# RVX10 Instruction Encodings

[cite_start]All RVX10 instructions use the R-type format with **opcode = `0x0B`** (`CUSTOM-0`)[cite: 12].

### Instruction Format

| Bits  | 31-25    | 24-20 | 19-15 | 14-12    | 11-7 | 6-0      |
| ----- | -------- | ----- | ----- | -------- | ---- | -------- |
| Field | `funct7` | `rs2` | `rs1` | `funct3` | `rd` | `opcode` |

### [cite_start]Encoding Table [cite: 81]

| Instruction | `funct7`    | `funct3` | Semantics (`s = rs2[4:0]`)                     |
| ----------- | ----------- | -------- | ---------------------------------------------- | ---------------- |
| `ANDN`      | `0b0000000` | `0b000`  | `rd = rs1 & ~rs2`                              |
| `ORN`       | `0b0000000` | `0b001`  | `rd = rs1                                      | ~rs2`            |
| `XNOR`      | `0b0000000` | `0b010`  | `rd = ~(rs1 ^ rs2)`                            |
| `MIN`       | `0b0000001` | `0b000`  | `rd = (signed(rs1) < signed(rs2)) ? rs1 : rs2` |
| `MAX`       | `0b0000001` | `0b001`  | `rd = (signed(rs1) > signed(rs2)) ? rs1 : rs2` |
| `MINU`      | `0b0000001` | `0b010`  | `rd = (rs1 < rs2) ? rs1 : rs2`                 |
| `MAXU`      | `0b0000001` | `0b011`  | `rd = (rs1 > rs2) ? rs1 : rs2`                 |
| `ROL`       | `0b0000010` | `0b000`  | `rd = (rs1 << s)                               | (rs1 >> (32-s))` |
| `ROR`       | `0b0000010` | `0b001`  | `rd = (rs1 >> s)                               | (rs1 << (32-s))` |
| `ABS`       | `0b0000011` | `0b000`  | `rd = (signed(rs1) >= 0) ? rs1 : -rs1`         |

### Worked Encoding Examples

The following examples show how to manually encode each instruction into its 32-bit hexadecimal representation.

1.  **`andn x5, x6, x7`**

    - `funct7`=0x00, `rs2`=7, `rs1`=6, `funct3`=0, `rd`=5, `opcode`=0x0B
    - `inst = (0<<25) | (7<<20) | (6<<15) | (0<<12) | (5<<7) | [cite_start]0x0B` [cite: 89]
    - `inst = 0x00000000 | 0x00700000 | 0x0000C000 | 0x00000000 | 0x00000280 | 0x0B`
    - **Result: `0x0073028B`**

2.  **`orn x10, x11, x12`**

    - `funct7`=0x00, `rs2`=12, `rs1`=11, `funct3`=1, `rd`=10, `opcode`=0x0B
    - **Result: `0x00C5950B`**

3.  **`xnor x1, x2, x3`**

    - `funct7`=0x00, `rs2`=3, `rs1`=2, `funct3`=2, `rd`=1, `opcode`=0x0B
    - **Result: `0x0031208B`**

4.  **`min x15, x16, x17`**

    - `funct7`=0x01, `rs2`=17, `rs1`=16, `funct3`=0, `rd`=15, `opcode`=0x0B
    - **Result: `0x0218078B`**

5.  **`max x20, x21, x22`**

    - `funct7`=0x01, `rs2`=22, `rs1`=21, `funct3`=1, `rd`=20, `opcode`=0x0B
    - **Result: `0x036AD98B`**

6.  **`minu x25, x26, x27`**

    - `funct7`=0x01, `rs2`=27, `rs1`=26, `funct3`=2, `rd`=25, `opcode`=0x0B
    - **Result: `0x03BD2C8B`**

7.  **`maxu x30, x31, x5`**

    - `funct7`=0x01, `rs2`=5, `rs1`=31, `funct3`=3, `rd`=30, `opcode`=0x0B
    - **Result: `0x025FBEOB`**

8.  **`rol x8, x9, x10`**

    - `funct7`=0x02, `rs2`=10, `rs1`=9, `funct3`=0, `rd`=8, `opcode`=0x0B
    - **Result: `0x04A4840B`**

9.  **`ror x13, x14, x15`**

    - `funct7`=0x02, `rs2`=15, `rs1`=14, `funct3`=1, `rd`=13, `opcode`=0x0B
    - **Result: `0x04F7168B`**

10. **`abs x18, x19, x0`**
    - `funct7`=0x03, `rs2`=0, `rs1`=19, `funct3`=0, `rd`=18, `opcode`=0x0B
    - **Result: `0x0609890B`**
