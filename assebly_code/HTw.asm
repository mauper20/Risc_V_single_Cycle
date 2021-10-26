#ITESO_Arquitectura_Computacional
#Equipo:Guevara Martínez Adrian
# 	Peralta Osorio Mauricio
#	30/09/2021
.data
.text
	lui s2, 0x10010    # origen tower
	ori s3, s2, 0x40  #  aux tower
	ori s4, s2, 0x80 #  destiny tower
main:
	addi s0, zero, 3  # n dicos 
	add  t2, zero, s0 # t2 guarda n discos para usar depue 
	addi t0, zero, 1  # se usara para comparar el caso base
	addi t1, zero, 0  # comparar en bne
filltower: 
	sw   t2, 0(s2)      # llenaremos nuestra origin tower
	addi t2, t2, -1     
	addi s2, s2, 4
	bne  t2, t1, filltower
	jal  ra, StGameHTw
	jal  zero, end
StGameHTw: #(star game hanoi's towers)
	addi sp, sp, -8 
	sw  ra, 4(sp)    
	sw  s0, 0(sp) 
	bne s0, t0, StGameHTw_recursiva 
	jal ra, StGameHTw_mov #caso base mueve el ultimo disco en la torre origen a la destino
	jal zero, StGameHTw_return
StGameHTw_recursiva:	
	addi s0, s0, -1    #(n-1)
	jal ra, ChangeHTw1 
	jal ra, StGameHTw
	jal ra, ChangeHTw1
	jal ra, StGameHTw_mov
	jal ra, ChangeHTw2
	jal ra, StGameHTw
	jal ra, ChangeHTw2
StGameHTw_return: 
	lw ra,  4(sp) 
	lw s0,  0(sp)
	addi sp, sp, 8
	jalr zero, ra, 0 

ChangeHTw2:
	add t3, zero, s3 # hanoi(n-1,aux, destino, origen)
	add s3, zero, s2 #usaremos t3 para hacer el cambio entre las torres
	add s2, zero, t3
	jalr zero, ra, 0
	
ChangeHTw1:
	add t3, zero, s3 # hanoi(n-1,origen, destino, aux)
	add s3, zero, s4 #usaremos t3 para hacer el cambio entre las torres
	add s4, zero, t3
	jalr zero, ra, 0
	
StGameHTw_mov:           #funcion para mover los discos
	addi a2, a2, 1   #numero movimientos realizados 
	lw   a1, -4(s2)	 #sacamos el valor que esta mas ensima de la torre origen que seria el menor y lo guardamos en a1
	sw   zero, -4(s2)#eliminamos el valor 
	addi s2, s2, -4  # reducimos el tamaño de la torre y borramos el valor que se saco
	sw   a1, 0(s4)   # guardamos el valor sacado en la torre de destino
	addi s4, s4, 4	 #aumentamos la direccion la torre de destino
	jalr zero, ra, 0 
end:
	
