	.data
	
parentesis_izq : .asciiz "("
parentesis_der : .asciiz ")"
espacio : 	 .asciiz " "
jugador_actual : .asciiz "Le toca a: "
coma: 		 .asciiz "," 

introducir_nombre1: .asciiz "Nombre del jugador 1: " 
introducir_nombre2: .asciiz "Nombre del jugador 2: " 
introducir_nombre3: .asciiz "Nombre del jugador 3: " 
introducir_nombre4: .asciiz "Nombre del jugador 4: " 

elegir_ficha: .asciiz "Elija una ficha\n"

nueva_linea: .	    .asciiz "\n"

nombre1: .space 50
nombre2: .space 50
nombre3: .space 50
nombre4: .space 50

puntuacion_team1: .word 0 #Puntuacion de los equipos
puntuacion_team2: .word 0

mano_1: 	 .word 0 #Direccion de la lista de mano
mano_2: 	 .word 0
mano_3: 	 .word 0
mano_4: 	 .word 0

tablero:	 .word 0 #Direccion de la cabeza de la lista del tablero

#fichas: .word 1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28
fichas: .word 0,0, 0,1, 0,2, 0,3, 0,4, 0,5, 0,6, 1,1, 1,2, 1,3, 1,4, 1,5, 1,6, 2,2, 2,3, 2,4, 2,5, 2,6, 3,3, 3,4, 3,5, 3,6, 4,4, 4,5, 4,6, 5,5, 5,6, 6,6


	.text
	
main:

###################################################################################################
###################################################################################################
				#Programa Principal

	#Se introduce el primer jugador
	la $a0, introducir_nombre1
	li $v0, 4
	syscall
	
	la $a0, nombre1
	li $v0, 8
	syscall
	
	la $a0, nueva_linea
	li $v0, 4
	syscall
	
	#Se introduce el segundo jugador
	la $a0, introducir_nombre2
	li $v0, 4
	syscall
	
	la $a0, nombre2
	li $v0, 8
	syscall
	
	la $a0, nueva_linea
	li $v0, 4
	syscall
	
	#Se introduce el tercer jugador
	la $a0, introducir_nombre3
	li $v0, 4
	syscall
	
	la $a0, nombre3
	li $v0, 8
	syscall
	
	la $a0, nueva_linea
	li $v0, 4
	syscall
	
	#Se introduce el cuarto jugador
	la $a0, introducir_nombre4
	li $v0, 4
	syscall
	
	la $a0, nombre4
	li $v0, 8
	syscall
	
	la $a0, nueva_linea
	li $v0, 4
	syscall
	
	#Final de introduccion de nombres
	
	#Se desordenan las fichas
	jal shuffle
	
	#Ahora se asignan las fichas a cada jugador
	
	la $t0, fichas
	
	#Jugador1
	move $a0, $t0
	jal crear_mano
	
	sw $v0, mano1 #Guardo la direccion de la mano1
	
	addi $t0, $t0, 14 #Siguiente grupo de fichas
	
	
	#Jugador2
	move $a0, $t0
	jal crear_mano
	
	sw $v0, mano2 #Guardo la direccion de la mano2
	
	addi $t0, $t0, 14 #Siguiente grupo de fichas
	
	
	#Jugador3
	move $a0, $t0
	jal crear_mano
	
	sw $v0, mano3 #Guardo la direccion de la mano3
	
	addi $t0, $t0, 14 #Siguiente grupo de fichas
	
	
	#Jugador4
	move $a0, $t0
	jal crear_mano
	
	sw $v0, mano4 #Guardo la direccion de la mano4
	
	addi $t0, $t0, 14 #Siguiente grupo de fichas
	
	#Fin de asignacion de manos
	
	
	#Determino cual mano tiene a la cochina
	
	lw $a0, mano1
	li $a1, 6
	li $a2, 6
	jal verificar_esta_en_mano #Si la mano1 tiene la cochina
	
	lw $s0, mano1 #Guarda la mano 
	li $s1, 1
	beq $v0, 1, cochina_encontrada
	
	
	lw $a0, mano2
	li $a1, 6
	li $a2, 6
	jal verificar_esta_en_mano #Si la mano1 tiene la cochina
	
	lw $s0, mano2 #Guarda la mano 
	li $s2, 2
	beq $v0, 1, cochina_encontrada
	
	
	lw $a0, mano3
	li $a1, 6
	li $a2, 6
	jal verificar_esta_en_mano #Si la mano1 tiene la cochina
	
	lw $s0, mano3 #Guarda la mano 
	li $s1, 3
	beq $v0, 1, cochina_encontrada
	
	
	
	lw $a0, mano4
	li $a1, 6
	li $a2, 6
	jal verificar_esta_en_mano #Si la mano1 tiene la cochina
	
	lw $s0, mano4 #Guarda la mano 
	li $s1, 4

	#Fin de encontrar cochina
		
cochina_encontrada:
	
	#En este momento, $s0 tiene la direccion de la mano que comienza
	# $s1 tiene el numero de la mano
	
	
bucle_principal:
	
	jal imprimir_asignar_turno #imprime a quien le toca
	
	
	
	# Condiciones de bucle
	# Determino si le toca al jugador 1
	
	# Falta determinar la condicion de parada
	
	addi $s1, $s1, 1 #Siguiente jugador
	
	bgt $s1, 4, bucle_principal_primer_jugador
	
	move $a0, $s1 # Encuentro la direccion de la mano del jugador actual
	jal asignar_turno
	move $s0, $v0 # Almaceno dicha direccion
	
	j bucle_principal
	
bucle_principal_primer_jugador:
	
	li $s1, 1
	
	j bucle_principal
	

###################################################################################################
###################################################################################################
				#Subrutinas del Tablero

#Crea la cabeza de la lista que representa al tablero
# $v0 : direccion del tablero
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

	sw $fp, $sp	#Prologo
	move $fp, $sp
	addi $sp, $sp, -4

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
	
	lw $fp, 4($sp)	#Epilogo
	addi $sp, $sp, 4
	
	jr $ra
	
###################################################################################################
###################################################################################################

# $a0 : direccion de la cabeza de la lista que representa al tablero
# $a1 : valor de la izquierda de la ficha que se va a agregar
# $a2 : valor de la derecha de la ficha que se va a agregar
anadir_ficha_der:

	sw $fp, $sp	#Prologo
	move $fp, $sp
	addi $sp, $sp, -4

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
	
	lw $fp, 4($sp)	#Epilogo
	addi $sp, $sp, 4
	
	jr $ra

###################################################################################################
###################################################################################################

# $a0 : direccion de la cabeza de la lista que representa al tablero
# $a1 : valor de la izquierda de la ficha que se va a agregar
# $a2 : valor de la derecha de la ficha que se va a agregar
# $a3 : 1 si es a la izquierda y 0 si es a la derecha
# $v0 : 1 si coinciden. De lo contrario, 0
verificar_movimiento:
	
	beq $a3, 0, verificar_movimiento_der #Si se compara la ficha de la dereha o izquierda
	
	lw $t0, ($a0) #Direccion de ultima ficha izquierda del tablero
	
	lw $t0, ($t0) #Valor izquierdo de la ficha izquierda del tablero
	
	seq $t1, $t0, $a1 #Si los numeros de las fichas coinciden
	
	move $v0, $t1
	
	j verificar_movimiento_fin
	
verificar_movimiento_der:

	lw $t0, 4($a0) #Direccion de la ultima ficha derecha del tablero
	
	lw $t0, 4($t0) #Valor derecho de la ficha derecha del tablero
	
	seq $t1, $t0, $a2 #Si los numeros de las fichas coinciden
	
	move $v0, $t1
	
verificar_movimiento_fin:
	
	jr $ra
	
###################################################################################################
###################################################################################################
				#Subrutinas de las manos


#Creo una mano
# $a0 : Direccion de lista de fichas asignadas
# $v0 : Direccion de la lista de mano
crear_mano:
	
	move $t4, $a0
	
	li $v0, 9
	li $a0, 4 #Reservo espacio para una ficha de la mano
	syscall
	
	move $t2, $v0 
	move $t3, $v0 #Siempre guarda la cabeza de la lista de la mano
		
	move $t0, 7 #Numero de elementos del arreglo que faltan por ver
	
crear_mano_loop:
	
	move $a0, $t4
	
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
	
	move $t2, $v0 #Siguiente ficha
	
	j crear_mano_loop

crear_mano_fin:	
	
	move $v0, $t3
				
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

###################################################################################################
###################################################################################################

#Algoritmo que desordena las fichas del domino
shuffle:

	li $t0, 28 #Hay 28 fichas
	la $t2, fichas
	
shuffle_loop:
	
	li $a0, 0 #Seed
	move $a1, $t0 #Cota superior para el numero aleatorio
	li $v0, 42
	syscall
	
	la $t1, fichas
	
shuffle_loop_inner:
	
	addi $t1, $t1, 8  #Siguiente Ficha 
	addi $v0, $v0, -1 #Numero de alementos que queda por recorrer hasta encontrar al importante
	
	bne $v0, 0, shuffle_loop_inner
	
	
	lw $t4, ($t2) #Los elementos izquierdos que voy a intercambiar
	lw $t5, ($t1)
	
	sw $t5, ($t2) #Intercambio
	sw $t4, ($t1)
	
	lw $t4, 4($t2) #Los elementos derechos que voy a intercambiar
	lw $t5, 4($t1)
	
	sw $t5, 4($t2) #Intercambio
	sw $t4, 4($t1)
	
	addi $t0, $t0, -1 #Considero el siguiente elemento
	addi $t2, $t2, 8
	
	bne $t0 , 0, shuffle_loop
	
	jr $ra
	
	
###################################################################################################
###################################################################################################

# $a0 : numero del jugador
# $v0 : direccion de la mano del jugador correspondiente
asignar_turno:

	beq $a0, 1, asignar_turno_uno
	
	beq $a0, 2, asignar_turno_dos
	
	beg $a0, 3, asignar_turno_tres
	
	lw $v0, mano4
	
	j asignar_turno_fin
	
asignar_turno_uno:

	lw $v0, mano1
	
	j asignar_turno_fin
	
asignar_turno_dos:

	lw $v0, mano2
	
	j asignar_turno_fin
	
asignar_turno_tres:

	lw $v0, mano3
	
		
asignar_turno_fin:

	jr $ra
	

###################################################################################################
###################################################################################################

# $a0 : numero del jugador actual
imprimir_asignar_turno:

	beq $a0, 1, imprimir_asignar_turno_uno
	
	beq $a0, 2, imprimir_asignar_turno_dos
	
	beg $a0, 3, imprimir_asignar_turno_tres
	
	li $v0, 4
	la $a0, jugador_actual
	syscall
	
	li $v0, 4
	la $a0, nombre4
	syscall
	
	j imprimir_asignar_turno_fin
	
imprimir_asignar_turno_uno:

	li $v0, 4
	la $a0, jugador_actual
	syscall
	
	li $v0, 4
	la $a0, nombre1
	syscall
	
	j imprimir_asignar_turno_fin
	
imprimir_asignar_turno_dos:

	li $v0, 4
	la $a0, jugador_actual
	syscall
	
	li $v0, 4
	la $a0, nombre2
	syscall
	
	j imprimir_asignar_turno_fin
	
imprimir_asignar_turno_tres:

	li $v0, 4
	la $a0, jugador_actual
	syscall
	
	li $v0, 4
	la $a0, nombre3
	syscall
	
		
imprimir_asignar_turno_fin:

	jr $ra

