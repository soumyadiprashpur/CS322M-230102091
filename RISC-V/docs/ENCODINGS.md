# RVX10 Instruction Encodings

| Instruction | opcode | funct7   | funct3 | Type | rs2 usage |
|--------------|--------|----------|--------|------|------------|
| ANDN  | 0x0B | 0000000 | 000 | R | rs2 |
| ORN   | 0x0B | 0000000 | 001 | R | rs2 |
| XNOR  | 0x0B | 0000000 | 010 | R | rs2 |
| MIN   | 0x0B | 0000001 | 000 | R | rs2 |
| MAX   | 0x0B | 0000001 | 001 | R | rs2 |
| MINU  | 0x0B | 0000001 | 010 | R | rs2 |
| MAXU  | 0x0B | 0000001 | 011 | R | rs2 |
| ROL   | 0x0B | 0000010 | 000 | R | rs2[4:0] |
| ROR   | 0x0B | 0000010 | 001 | R | rs2[4:0] |
| ABS   | 0x0B | 0000011 | 000 | R | ignored |

Example Encoding:  
`ANDN x5, x6, x7`  
= `(0x00<<25)|(7<<20)|(6<<15)|(0<<12)|(5<<7)|0x0B`  
= `0x00E3028B`
