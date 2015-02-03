	.data
	
parentesis_izq : .asciiz "("
parentesis_der : .asciiz ")"
espacio : 	 .asciiz " "
jugador_actual : .asciiz "Le toca a: "
coma: 		 .asciiz "," 


	.text
	
main:

###################################################################################################
###################################################################################################
				#Programa Principal


###################################################################################################
###################################################################################################
				#Subrutinas del Tablero

#Crea la cabeza de la lista que representa al tablero
crear_tablero:
	
	li $v0, 9
	li $a0, 8
	syscall
	
	sw $zero, 0($v0)
	sw $zero, 4($v0)
	
	jr $ra

###################################################################################################
###################################################################################################

# $a0 : direccion de la cabeza de la lista que representa al tablero
# $a1 : valor de la izquierda de la ficha que se va a agregar
# $a2 : valor de la derecha de la ficha que se va a agregar	
anadir_ficha_izq:

	lw $t0, 0($a0) #Se guarda la direccioin de la ultima ficha de la izquierda
	
	sw $a0, ($sp) #Conservo a $a0
	addi $sp, $sp, -4
	
	li $v0, 9 #Creo la nueva ficha
	li $a0, 12
	syscall
	
	addi $sp, $sp, 4 #Recupero a $a0
	lw $a0, ($sp)
	
	sw $a1, ($v0) #Guardo el valor de la izquierda de la ficha
	sw $a2, 4($v0) #Guardo el valor de la derecha de la ficha
	sw $t0, 8($v0) #Guardo la direccion de la ultima ficha agregada
	
	sw $v0, ($a0) #La cabeza de la lista apunta al primer elemento de la izquierda
	
	move $v0, $a0 #Guardo el valor de retorno
	
	jr $ra
	
###################################################################################################
###################################################################################################

# $a0 : direccion de la cabeza de la lista que representa al tablero
# $a1 : valor de la izquierda de la ficha que se va a agregar
# $a2 : valor de la derecha de la ficha que se va a agregar
anadir_ficha_der:

	lw $t0, 4($a0) #Se guarda la direccioin de la ultima ficha de la derecha
	
	sw $a0, ($sp) #Conservo a $a0
	addi $sp, $sp, -4
	
	li $v0, 9 #Creo la nueva ficha
	li $a0, 12
	syscall
	
	addi $sp, $sp, 4 #Recupero a $a0
	lw $a0, ($sp)
	
	sw $a1, ($v0) #Guardo el valor de la izquierda de la ficha
	sw $a2, 4($v0) #Guardo el valor de la derecha de la ficha
	sw $zero, 8($v0) #La nueva ficha derecha no apunta a nada
	
	sw $v0, 8($t0) #La ultima ficha derecha apunta a la nueva ficha derecha
	
	sw $v0, 4($a0) #La cabeza de la lista apunta al primer elemento de la izquierda
	
	move $v0, $a0 #Guardo el valor de retorno
	
	jr $ra

###################################################################################################
###################################################################################################

# $a0 : direccion de la cabeza de la lista que representa al tablero
# $a1 : valor de la izquierda de la ficha que se va a agregar
# $a2 : valor de la derecha de la ficha que se va a agregar
# $a3 : 1 si es a la izquierda y 0 si es a la derecha
verificar_movimiento:
	
	beq $a3, 0, verificar_movimiento_der #Si se compara la ficha de la dereha o izquierda
	
	lw $t0, ($a0) #Direccion de ultima ficha izquierda del tablero
	
	lw $t0, ($t0) #Valor izquierdo de la ficha izquierda del tablero
	
	seq $t1, $t0, $a1 #Si los numeros de las fichas coinciden
	
	j verificar_movimiento_fin
	
verificar_movimiento_der:

	lw $t0, 4($a0) #Direccion de la ultima ficha derecha del tablero
	
	lw $t0, 4($t0) #Valor derecho de la ficha derecha del tablero
	
	seq $t1, $t0, $a2 #Si los numeros de las fichas coinciden
	
verificar_movimiento_fin:
	
	jr $ra
	
###################################################################################################
###################################################################################################
				#Subrutinas de las manos


#Creo una mano
# $a0 : Direccion de lista de fichas asignadas
crear_mano:
	
	li $v0, 9
	li $a0, 4 #Reservo 7 espacios de 2 bytes para esta mano
	syscall
	
	move $t2, $v0 
	move $t3, $v0 #Siempre guarda la cabeza de la lista de la mano
		
	move $t0, 7 #Numero de elementos del arreglo que faltan por ver
	
crear_mano_loop:
	
	lw $t1, ($a0) #Guardo el numero izquierdo de la ficha
	sw $t1, ($t2)
	
	addi $a0, $a0, 4 #Siguiente numero
	#addi $t2, $t2, 4
	
	lw $t1, ($a0) #Guardo el numero derecho de la ficha
	sw $t1, 4($t2)
	
	addi $a0, $a0, 4 #Siguiente ficha
	#addi $t2, $t2, 4
	
	addi $t0, $t0, -1
	
	be $t0, 0, crear_mano_fin 
	
	li $v0, 9 #Reservo espacio para la siguiente ficha de la mano
	li $a0, 4
	syscall
	
	sw $v0, 12($t2) #Guardo la direccion del siguiente
	sw $t2, 8($v0) #Guardo la direccion del anterior
	
	j crear_mano_loop

crear_mano_fin:	
		
	jr $ra	
	
###################################################################################################
###################################################################################################
	
#Quita la ficha si se sabe que ella esta en la mano
# $a0 : direccion de la mano
# $a1 : numero1 de la ficha a quitar
# $a2 : numero2 de la ficha a quitar
quitar_ficha:
	
	move $v0, $a0

quitar_ficha_loop:
		
	lw $t0, ($a0)
	lw $t1, 4($a0)
	
	seq $t2, $t0, $a1 #Si la ficha actual coincide con el argumento 
	seq $t3, $t1, $a2
	and $t4, $t3, $t2
	
	seq $t2, $t0, $a2 #Si la ficha actual coincide con el argumento volteado
	seq $t3, $t1, $a1
	and $t5, $t3, $t2
	
	or $t4, $t4, $t5 #Si la ficha es esta, ya sea voltada o no
	
	lw $t9, 12($a0) #Siguiente ficha
	bne $t9, 0, quitar_ficha_quedan_mas
	
	j quitar_ficha_fin
	
quitar_ficha_quedan_mas:
	
	addi, $a0, $a0, 4 #Siguiente ficha de la mano
	
	bne $t4, 1, quitar_ficha_loop #Si aun no se ha encontrado, entonces sigo en el bucle
	
	#Termine el bucle
	
	sw $t6, 8($a0) #Ficha anterior
	sw $t7, 12($a0) #ficha siguiente 
	beq $t6, 0, quitar_ficha_no_anterior #Si la ficha a quitar es la primera
	beq  $t7, 0, quitar_ficha_no_siguiente #Si la ficha a quitar es la ultima
	
	sw $t7, 12($t6) #La ficha anterior apunta a la siguiente
	sw $t6, 8($t7) #El padre de la ficha siguiente es la ficha anterior
	
	
	j quitar_ficha_fin
	
quitar_ficha_no_anterior:

	beq  $t7, 0, quitar_ficha_no_anterior_siguiente #Si la ficha a quitar es la unica
	
	sw $zero, 8($t7) #El nodo actual se deja de apuntar
	move $v0, $t7
	
	j quitar_ficha_fin
	
quitar_ficha_no_siguiente:

	sw $zero, 12($t6)  #El nodo actual se deja de apuntar
	
	j quitar_ficha_fin

quitar_ficha_no_anterior_siguiente:

	sw $zero, ($v0) #solo quedaba una ficha en la mano
	sw $zero, 4($v0)
	sw $zero, 8($v0)
	sw $zero, 12($v0)

quitar_ficha_fin:
	
	jr $ra
	
	
###################################################################################################
###################################################################################################

#Determina si una ficha esta en la mano
# $a0 : direccion de la mano
# $a1 : numero1 de la ficha
# $a2 : numero2 de la ficha
# $v0 : 1 si la ficha esta, de lo contrario, 0
# $v1 : direccion de la ficha encontrada. Si no fue encontrada, 0
verificar_esta_en_mano:

	move $v1, $zero

verificar_esta_en_mano_loop:
	lw $t0, ($a0)
	lw $t1, 4($a0)
	lw $t6, 12($a0) #Siguiente
	
	seq $t2, $t0, $a1 #Si la ficha actual coincide con el argumento 
	seq $t3, $t1, $a2
	and $t4, $t3, $t2
	
	seq $t2, $t0, $a2 #Si la ficha actual coincide con el argumento volteado
	seq $t3, $t1, $a1
	and $t5, $t3, $t2
	
	or $t4, $t4, $t5 #Si la ficha es esta, ya sea voltada o no
	seq $v0, $t4, 1
	
	bne $t6, 0, verificar_esta_en_mano_quedan_mas #Si quedan mas fichas por ver en la mano
	
	j verificar_esta_en_mano_fin #Si no quedan mas fichas en la mano
	
verificar_esta_en_mano_quedan_mas:

	beq $t4, 1, verificar_esta_en_mano_fin #Si la ficha actual es la buscada
	
	addi $a0, $a0, 4 #Siguiente de la mano
	j verificar_esta_en_mano_loop
	
verificar_esta_en_mano_fin:

	move $v1, $a0 #Direccion de la ficha encontrada
	jr $ra	

###################################################################################################
###################################################################################################

#Se imprime la mano si no esta vacia
# $a0 : direccion de la mano a imprimir
imprimir_mano:
	
	move $t0, $a0
	
imprimir_mano_loop:
	
	li $v0, 4 #Imprimo el parentesis izquierdo
	la $a0, parentesis_izq
	syscall
	
	li $v0, 1
	lw $a0, ($t0) #Primer numero1
	syscall
	
	li $v0, 4 #Imprimo coma
	la $a0, coma
	syscall
	
	li $v0, 1
	lw $a0, 4($t0) #Primer numero2
	syscall
	
	li $v0, 4 #Imprimo el parentesis derecho
	la $a0, parentesis_der
	syscall
	
	lw $t1, 12($t0) #Siguiente Ficha
	
	beq $t1, 0, imprimir_mano_fin
	
	addi $t0, $t0, 4 #Siguiente ficha
	
	j imprimir_mano_loop
	
imprimir_mano_fin:
	jr $ra
