# RVX10 Test Plan

### [cite_start]Self-Checking Strategy [cite: 93]

The test program (`rvx10.hex`) is self-checking. It works as follows:

1.  A checksum register, `x28`, is initialized to zero.
2.  For each RVX10 instruction, test values are loaded into source registers.
3.  The RVX10 instruction is executed.
4.  [cite_start]The result in the destination register is XORed with the checksum register (`x28`) to accumulate a running checksum[cite: 94].
5.  After all 10 operations are tested, the final value in `x28` is compared against a pre-calculated golden checksum.
6.  [cite_start]If the checksums match, the test is considered passed, and the program stores the value **25** to memory address **100**[cite: 10, 95].
7.  If they do not match, the program enters an infinite loop, causing the simulation to time out, which indicates failure.

### Per-Operation Test Cases

| Op       | Instruction     | `rs1` Value (`reg`)                 | `rs2` Value (`reg`)          | Expected `rd` Result  | Notes                                                                                     |
| -------- | --------------- | ----------------------------------- | ---------------------------- | --------------------- | ----------------------------------------------------------------------------------------- | ------------- | ----------- |
| **ANDN** | `andn x5,x6,x7` | `0xF0F0A5A5` (`x6`)                 | `0x0F0FFFFF` (`x7`)          | `0xF0F00000`          | [cite_start]Tests bitwise logic (`rs1 & ~rs2`). [cite: 73]                                |
| **ORN**  | `orn x5,x6,x7`  | `0xA5A50000` (`x6`)                 | `0xFFFF0F0F` (`x7`)          | `0xA5A5F0F0`          | Tests bitwise logic (`rs1                                                                 | ~rs2`).       |
| **XNOR** | `xnor x5,x6,x7` | `0xFF00FF00` (`x6`)                 | `0x00FFFFFF` (`x7`)          | `0x00FF00FF`          | Tests bitwise logic (`~(rs1 ^ rs2)`).                                                     |
| **MIN**  | `min x5,x6,x7`  | `-1` (`0xFFFFFFFF`) (`x6`)          | `-100` (`0xFFFFFF9C`) (`x7`) | `-100` (`0xFFFFFF9C`) | Tests signed comparison.                                                                  |
| **MAX**  | `max x5,x6,x7`  | `-1` (`0xFFFFFFFF`) (`x6`)          | `1` (`0x00000001`) (`x7`)    | `1` (`0x00000001`)    | Tests signed comparison with positive/negative.                                           |
| **MINU** | `minu x5,x6,x7` | `0xFFFFFFFE` (`x6`)                 | `0x00000001` (`x7`)          | `0x00000001`          | [cite_start]Tests unsigned comparison. [cite: 75]                                         |
| **MAXU** | `maxu x5,x6,x7` | `0xFFFFFFFE` (`x6`)                 | `0x80000000` (`x7`)          | `0xFFFFFFFE`          | Tests unsigned comparison.                                                                |
| **ROL**  | `rol x5,x6,x7`  | `0x80000001` (`x6`)                 | `3` (`0x00000003`) (`x7`)    | `0x0000000F`          | Tests rotate left. [cite_start]Note: PDF example has a typo[cite: 77], correct is `(x<<3) | (x>>29)`=`0x8 | 0x7`=`0xF`. |
| **ROR**  | `ror x5,x6,x7`  | `0xC0000001` (`x6`)                 | `2` (`0x00000002`) (`x7`)    | `0x30000000`          | Tests rotate right.                                                                       |
| **ABS**  | `abs x5,x6,x0`  | `-2147483648` (`0x80000000`) (`x6`) | `0` (`x0`)                   | `0x80000000`          | [cite_start]Tests edge case for `INT_MIN`. [cite: 30, 104]                                |

**Golden Checksum Calculation:**
`0xF0F00000` ^ `0xA5A5F0F0` ^ `0x00FF00FF` ^ `0xFFFFFF9C` ^ `0x00000001` ^ `0x00000001` ^ `0xFFFFFFFE` ^ `0x0000000F` ^ `0x30000000` ^ `0x80000000` = **`0x5A5A0063`**
This is the final value expected in `x28`.
