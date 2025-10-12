# RVX10 Test Plan

For each instruction, we check deterministic results and write 25 to memory[100] at end.

| Instruction | Inputs (rs1, rs2) | Expected rd |
|--------------|------------------|--------------|
| ANDN | 0xF0F0A5A5, 0x0F0FFFFF | 0xF0F00000 |
| ORN | 0x12345678, 0xFFFF0000 | 0xFFFFFFFF |
| XNOR | 0xAAAA5555, 0x5555AAAA | 0x00000000 |
| MIN | -1, 3 | -1 |
| MAX | -1, 3 | 3 |
| MINU | 0xFFFFFFFF, 0x00000001 | 0x00000001 |
| MAXU | 0xFFFFFFFF, 0x00000001 | 0xFFFFFFFF |
| ROL | 0x80000001, 3 | 0x0000000B |
| ROR | 0x80000001, 1 | 0xC0000000 |
| ABS | -128, x0 | 128 |

End condition:  
Store 25 → memory[100]
