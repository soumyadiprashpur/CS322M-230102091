# tests/rvx10.s
# Test program for the RVX10 custom instructions

.section .text
.globl _start

_start:
    # [cite_start]Use x28 as our checksum register, initialize to 0 [cite: 94]
    addi  x28, x0, 0

    # ============ TEST 1: ANDN ============
    lui   x6, 0xF0F0A     # Load 0xF0F0A000
    addi  x6, x6, 0x5A5   # x6 = 0xF0F0A5A5
    lui   x7, 0x0F0F0     # Load 0x0F0F0000
    addi  x7, x7, 0xFFF   # x7 = 0x0F0FFFFF
    .word 0x0073028B      # andn x5, x6, x7
    xor   x28, x28, x5

    # ============ TEST 2: ORN =============
    lui   x6, 0xA5A50     # x6 = 0xA5A50000
    lui   x7, 0xFFFF0     # Load 0xFFFF0000
    addi  x7, x7, 0xF0F   # x7 = 0xFFFF0F0F
    .word 0x0073128B      # orn x5, x6, x7
    xor   x28, x28, x5

    # ============ TEST 3: XNOR ============
    lui   x6, 0xFF00F     # Load 0xFF00F000
    addi  x6, x6, 0xF00   # x6 = 0xFF00FF00
    lui   x7, 0x00FFF     # Load 0x00FFF000
    addi  x7, x7, 0xFFF   # x7 = 0x00FFFFFF
    .word 0x0073228B      # xnor x5, x6, x7
    xor   x28, x28, x5

    # ============ TEST 4: MIN =============
    addi  x6, x0, -1      # x6 = -1 (0xFFFFFFFF)
    addi  x7, x0, -100    # x7 = -100 (0xFFFFFF9C)
    .word 0x0273028B      # min x5, x6, x7
    xor   x28, x28, x5

    # ============ TEST 5: MAX =============
    # x6 still contains -1
    addi  x7, x0, 1       # x7 = 1
    .word 0x0273128B      # max x5, x6, x7
    xor   x28, x28, x5

    # ============ TEST 6: MINU ============
    addi  x6, x0, -2      # x6 = 0xFFFFFFFE
    addi  x7, x0, 1       # x7 = 0x00000001
    .word 0x0273228B      # minu x5, x6, x7
    xor   x28, x28, x5

    # ============ TEST 7: MAXU ============
    # x6 still contains 0xFFFFFFFE
    lui   x7, 0x80000     # x7 = 0x80000000
    .word 0x0273328B      # maxu x5, x6, x7
    xor   x28, x28, x5

    # ============ TEST 8: ROL =============
    lui   x6, 0x80000     # Load 0x80000000
    addi  x6, x6, 1       # x6 = 0x80000001
    addi  x7, x0, 3       # x7 = 3 (rotate amount)
    .word 0x0473028B      # rol x5, x6, x7
    xor   x28, x28, x5

    # ============ TEST 9: ROR =============
    lui   x6, 0xC0000     # Load 0xC0000000
    addi  x6, x6, 1       # x6 = 0xC0000001
    addi  x7, x0, 2       # x7 = 2 (rotate amount)
    .word 0x0473128B      # ror x5, x6, x7
    xor   x28, x28, x5

    # ============ TEST 10: ABS ============
    lui   x6, 0x80000     # x6 = 0x80000000 (INT_MIN)
    .word 0x0603028B      # abs x5, x6, x0
    xor   x28, x28, x5

    # ============ VERIFICATION ============
    # Load the golden checksum: 0x5A5A0063
    lui   x5, 0x5A5A0     # x5 = 0x5A5A0000
    addi  x5, x5, 0x63    # x5 = 0x5A5A0063
    
    # Compare and branch to fail if not equal
    bne   x28, x5, fail

pass:
    # [cite_start]Success: Store 25 to address 100 [cite: 10]
    addi  x5, x0, 25      # Value to store
    addi  x6, x0, 100     # Address
    sw    x5, 0(x6)
    # End of test
    j     done

fail:
    # Failure: infinite loop
    j     fail

done:
    # Final infinite loop
    j     done