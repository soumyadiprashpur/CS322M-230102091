# riscvtest.s
# Verify base RV32I and all 10 RVX10 custom instructions.
# Success = store 25 to memory[100]

    .section .text
    .globl main

main:
    addi x2, x0, 5
    addi x3, x0, 12
    addi x7, x3, -9
    or   x4, x7, x2
    and  x5, x3, x4
    add  x5, x5, x4
    beq  x5, x7, end
    slt  x4, x3, x4
    beq  x4, x0, around
    addi x5, x0, 0

around:
    slt  x4, x7, x2
    add  x7, x4, x5
    sub  x7, x7, x2
    sw   x7, 84(x3)
    lw   x2, 96(x0)
    add  x9, x2, x5
    jal  x3, end
    addi x2, x0, 1

end:
    add  x2, x2, x9
    addi x4, x0, 10
    addi x8, x0, 20
    addi x6, x0, -20

    andn x7, x4, x8
    orn  x7, x4, x8
    xnor x7, x4, x8
    min  x7, x4, x6
    max  x7, x4, x6
    minu x7, x4, x6
    maxu x7, x4, x6
    abs  x7, x7, x0

    addi x1, x0, -128
    abs  x1, x1, x0
    abs  x7, x0, x0

    addi x4, x0, 3
    addi x6, x0, 16
    rol  x1, x6, x4
    ror  x1, x6, x4
    ror  x1, x6, x0

    addi x4, x0, 31
    addi x6, x0, 1
    rol  x1, x6, x4
    addi x1, x1, 1
    addi x4, x0, 3
    rol  x1, x1, x4

    sw   x2, 100(x0)

done:
    beq  x2, x2, done
