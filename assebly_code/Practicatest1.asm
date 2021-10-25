	lui  s0,      0x10010
 	ori  s1, s0,  0x24
 	jal ra, prueba
 	
 	addi t4, zero,4
 	addi t3, zero,3
 	sw   t4, 0(s0)
 	lw   t3,  0(s0)
 	addi s2, zero,1
 	addi s3, zero,32
 prueba:
 	slli t0, s2,  4
 	srli t1, s3,  4
 	sll  t5, s2,  t3
 	srl  t6, s3,  t4
 	sub  t2, t0,  t1
 	
