	addi t4,zero,3
        sw t4,  0(sp)
        addi s7,zero,6
        jal  ra, filltower
        addi t5,zero,7
        lw s0,  0(sp)
        sub a1,s0,a1
        addi a4,zero,14
        filltower:
        addi t6,zero,21
        jalr zero, ra, 0


