	.data

fichas: .word 0,0, 0,1, 0,2, 0,3, 0,4, 0,5, 0,6, 1,1, 1,2, 1,3, 1,4, 1,5, 1,6, 2,2, 2,3, 2,4, 2,5, 2,6, 3,3, 3,4, 3,5, 3,6, 4,4, 4,5, 4,6, 5,5, 5,6, 6,6
			
parentesis_izq : .asciiz "("
parentesis_der : .asciiz ")"
espacio : 	 .asciiz " "
jugador_actual : .asciiz "Le toca a: "
coma: 		 .asciiz "," 

introducir_nombre1: .asciiz "Nombre del jugador 1: " 
introducir_nombre2: .asciiz "Nombre del jugador 2: " 
introducir_nombre3: .asciiz "Nombre del jugador 3: " 
introducir_nombre4: .asciiz "Nombre del jugador 4: " 

izquierda_derecha: .asciiz "Introduzca 1 si va a jugar a la izquierda. De lo contrario, 2\n"

elegir_ficha: .asciiz "Elija una ficha\n"

nueva_linea: 	    .asciiz "\n"

va_a_jugar: .asciiz "Escriba 1 si va a jugar. De lo contrario, 2"

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

puntuacion_grupo_1: .asciiz "Puntuacion del grupo 1: "
puntuacion_grupo_2: .asciiz "Puntuacion del grupo 2: "



	.text
	
main:

###################################################################################################
###################################################################################################
				#Programa Principal


	#Se introduce el primer jugador
	la $a0, introducir_nombre1
	li $a1, 40
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
	li $a1, 40
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
	li $a1, 40
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
	li $a1, 40
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
	
	
	# Ahora creo las manos
	
	la $a0, fichas 
	jal crear_mano
	sw $v0, mano_1
	
	la $a0, fichas
	addi $a0, $a0, 56
	jal crear_mano
	sw $v0, mano_2
	
	la $a0, fichas
	addi $a0, $a0, 112
	jal crear_mano
	sw $v0, mano_3
	
	la $a0, fichas
	addi $a0, $a0, 168
	jal crear_mano
	sw $v0, mano_4
	
	# He terminado de crear las manos
	#Fin de asignacion de manos
	
	
	
	#Determino cual mano tiene a la cochina
	
	lw $a0, mano_1
	li $a1, 6
	li $a2, 6
	jal verificar_esta_en_mano #Si la mano1 tiene la cochina
	
	lw $s0, mano_1 #Guarda la mano 
	li $s1, 1
	lw $s2, mano_2 #Siguiente mano
	beq $v0, 1, cochina_encontrada
	
	
	lw $a0, mano_2
	li $a1, 6
	li $a2, 6
	jal verificar_esta_en_mano #Si la mano1 tiene la cochina
	
	lw $s0, mano_2 #Guarda la mano 
	lw $s2, mano_3 #Siguiente mano
	li $s2, 2
	beq $v0, 1, cochina_encontrada
	
	
	lw $a0, mano_3
	li $a1, 6
	li $a2, 6
	jal verificar_esta_en_mano #Si la mano1 tiene la cochina
	
	lw $s0, mano_3 #Guarda la mano 
	lw $s2, mano_4 #Siguiente nabi
	li $s1, 3
	beq $v0, 1, cochina_encontrada
	
	
	
	lw $a0, mano_4
	li $a1, 6
	li $a2, 6
	jal verificar_esta_en_mano #Si la mano1 tiene la cochina
	
	lw $s0, mano_4 #Guarda la mano 
	lw $s2, mano_1 #Siguiente mano
	li $s1, 4

	#Fin de encontrar cochina
		
cochina_encontrada:
	
	#En este momento, $s0 tiene la direccion de la mano que comienza
	# $s1 tiene el numero de la mano
	# $s2 tiene la direccion de la siguiente mano
	#Hay que poner la cochina automaticamente
	#Hay que crear el tablero
	
	jal crear_tablero # Tambien pone la cochina
	
	sw $v0, tablero
	
	# Ahora hay que quitar de la mano actual a la cochina
	# Luego le toca al siguiente jugador en el bucle
	
	move $a0, $s0
	li $a1, 6
	li $a2, 6
	
	jal quitar_ficha #Se ha quitado la ficha de la mano
	
	
	#Ahora continua el siguiente jugador
	
	move $s0, $s2 #Siguiente jugador
	move $s5, $s2 # Recuerda cual fue el siguiente jugador por si hay otra ronda
	
	addi $s1, $s1, 1
	
	bgt $s1, 4, volver_primero
	
	j bucle_principal
	
volver_primero:

	li $s1, 1 # Primer jugador
	
	
	
	# $s0 : direccion de la mano que juega
	# $s1 : numero del jugador que juega
	# $s3 : 1 si se ha puesto una pieza, de lo contrario, cero
	# $s4 : numero de veces que no se juega en una ronda de 4 turnos
	# $s5 : recuerda cual jugador debe jugar primero en la segunda ronda
	# $s6 : puntos del equipo 1
	# $s7 : puntos del equipo 2
	# El bucle se detiene si  se tranca el juego o si un equipo suma mas de 100 puntos

	li $s6, 0 #Inicializo
	li $s7, 0
	li $s4, 0

bucle_principal:


	lw $a0, tablero
	jal imprimir_tablero
	
	move $a0, $s1 #Numero del jugador actual
	jal imprimir_asignar_turno #imprime a quien le toca
	
		
	move $a0, $s0     #Imprimo la mano del jugador actual
	jal imprimir_mano # FALLA AQUI. NO TIENE LA MANO COMPLETA AL INICIO
	
	li $v0, 4
	la $a0, nueva_linea
	syscall
	
	beq $s1, 2, bucle_principal_grupo_2
	beq $s1, 4, bucle_principal_grupo_2
	
bucle_principal_grupo_1:

	la $a0, puntuacion_grupo_1 # Mensaje de puntuacion
	li $v0, 4
	syscall
	
	move $a0, $s6 # Puntuacion grupo 1
	li $v0, 1
	syscall
	
	li $v0, 4
	la $a0, nueva_linea
	syscall

	j bucle_principal_despues_puntos
	
bucle_principal_grupo_2:

	la $a0, puntuacion_grupo_2 # Mensaje de puntuacion
	li $v0, 4
	syscall
	
	move $a0, $s7 # Puntuacion grupo 2
	li $v0, 1
	syscall
	
	li $v0, 4
	la $a0, nueva_linea
	syscall

bucle_principal_despues_puntos:
	
	# Le pregunto si va a jugar
	
	la $a0, va_a_jugar
	li $v0, 4
	syscall
	
	li $v0, 4
	la $a0, nueva_linea
	syscall
	
	li $v0, 5
	syscall
	
	# Si el jugador elige no jugar
	li $t0, 0
	seq $t0, $v0, 2
	add $s4, $s4, $t0 # Se suma al numero de veces que no se juega en un turno
	beq $v0, 2, bucle_principal_siguiente_jugador # Si no va a jugar
	
	# Fin preguntar si pasa
	

bucle_principal_elegir_ficha:
			
	li $v0, 4
	la $a0, elegir_ficha
	syscall
	
	li $v0, 4
	la $a0, nueva_linea
	syscall
	
	#Leo los numeros de la ficha seleccionada
	li $v0, 5
	syscall
	
	move $a1, $v0 #Primer numero
	
	li $v0, 5
	syscall
	
	move $a2, $v0 #Segundo numero
	
	move $a0, $s0 #Direccion de la mano actual
	
	addi $sp, $sp, -12
	sw $a0, 12($sp) #Conservo estos registros
	sw $a1, 8($sp)
	sw $a2, 4($sp)
	
	jal verificar_esta_en_mano
	
	lw $a2, 4($sp) #Recupero los registros
	lw $a1, 8($sp)
	lw $a0, 12($sp)
	addi $sp, $sp, 12
	
	addi $sp, $sp, -4 #Conservo el registro
	sw $a0, 4($sp)
	
	bne $v0, 1, bucle_principal_elegir_ficha #No esta en la mano, intentar nuevamente
	

bucle_principal_elegir_lado:
			
	la $a0, izquierda_derecha #Pregunto si juega a la izquierda o derecha
	li $v0, 4
	syscall
	
	lw $a0, 4($sp) #Recupero el registro
	addi $sp, $sp, 4
	
	li $v0, 5 #Respuesta del jugador actual
	syscall
	
	move $a3, $v0
	
	lw $a0, tablero
	
	addi $sp, $sp, -16 # Guardo los numeros de la ficha
	sw $a1, 8($sp)
	sw $a2, 4($sp)
	sw $a0, 12($sp)
	sw $a3, 16($sp)
	
	jal verificar_movimiento
	
	lw $a1, 8($sp) # recupero los numeros de la ficha
	lw $a2, 4($sp)
	lw $a0, 12($sp)
	lw $a3, 16($sp)
	addi $sp, $sp, 16
	
	beq $v0, 0, bucle_principal #Si no se puede poner la ficha
	
	move $s3, $v0 # Recuerda que se ha anadido una ficha
	
	#Ahora hay que añadir la ficha al tablero
	
	beq $a3, 2, bucle_principal_anadir_ficha_der # Si la pongo a la derecha
	
bucle_principal_anadir_ficha_izq:

	addi $sp, $sp, -16 # Guardo los numeros de la ficha
	sw $a1, 8($sp)
	sw $a2, 4($sp)
	sw $a0, 12($sp)
	sw $a3, 16($sp)
	
	jal anadir_ficha_izq
	
	lw $a1, 8($sp) # recupero los numeros de la ficha
	lw $a2, 4($sp)
	lw $a0, 12($sp)
	lw $a3, 16($sp)
	addi $sp, $sp, 16
	
	j bucle_principal_continuar
	
bucle_principal_anadir_ficha_der:
		
	addi $sp, $sp, -16 # Guardo los numeros de la ficha
	sw $a1, 8($sp)
	sw $a2, 4($sp)
	sw $a0, 12($sp)
	sw $a3, 16($sp)
	
	jal anadir_ficha_der
	
	lw $a1, 8($sp) # recupero los numeros de la ficha
	lw $a2, 4($sp)
	lw $a0, 12($sp)
	lw $a3, 16($sp)
	addi $sp, $sp, 16
	
bucle_principal_continuar:
	
	# Ya he anadido la ficha al tablero
	
	# Ahora retiro la ficha de la mano
	
	move $a0, $s0 # Direccion de la mano
	
	jal quitar_ficha
	
	# Hay que guardar los cambios de la mano
	
	beq $s1, 2, bucle_principal_quitar_mano_2 # Se encuentra la direccion de la mano actual
	beq $s1, 3, bucle_principal_quitar_mano_3
	beq $s1, 4, bucle_principal_quitar_mano_4
	
bucle_principal_quitar_mano_1:

	sw $v0, mano_1

 	j bucle_principal_quitar_mano_fin

bucle_principal_quitar_mano_2:

	sw $v0, mano_2

	j bucle_principal_quitar_mano_fin
	
bucle_principal_quitar_mano_3:

	sw $v0, mano_3

	j bucle_principal_quitar_mano_fin
	
bucle_principal_quitar_mano_4:

	sw $v0, mano_4

bucle_principal_quitar_mano_fin:
	
	# Condiciones de bucle
	# Determino si le toca al jugador 1
	
	# Falta determinar la condicion de parada
	
bucle_principal_siguiente_jugador:

	#Antes de buscar al otro jugador, se suman los puntos si es menester

	beq $s3, 0, bucle_principal_sin_puntos #No se hizo un movimiento valedero
	
	# Se verifica si se ha vaciado la mano actual
	
	lw $t0, ($s0) # Primera ficha de la mano actual
	lw $t1, 4($s0)
	lw $t2, 8($s0)
	lw $t3, 12($s0)
	add $t0, $t0, $t1 # Se suman para ver si da cero al final
	add $t0, $t0, $t2 # Si da cero al final, significa que la mano esta vacia
	add $t0, $t0, $t3 # Entonces el jugador ha terminado
	
	bne $t0, 0, bucle_principal_sin_puntos # si no se ha vaciado la mano
	
	# Si esta aqui: se ha vaciado la mano actual.
	# Se procede a sumar puntos y a reiniciar
	
	beq $s1, 1, bucle_principal_con_puntos_1 #Primer equipo
	beq $s1, 3, bucle_principal_con_puntos_1
	
	beq $s1, 2, bucle_principal_con_puntos_2 #Segundo equipo
	beq $s1, 4, bucle_principal_con_puntos_2
	
bucle_principal_con_puntos_1:

	lw $a0, mano_2
	lw $a1, mano_4
	jal sumar_puntos
	
	add $s6, $s6, $v0
	
	j bucle_principal_reiniciar
	
bucle_principal_con_puntos_2:	

	lw $a0, mano_1
	lw $a1, mano_3
	jal sumar_puntos

	add $s7, $s7, $v0
	
	j bucle_principal_reiniciar

bucle_principal_sin_puntos:
	
	#Antes de buscar al siguiente jugador, se determina si el bucle ha de parar
	
	bge $s6, 100, bucle_principal_fin #Si alguna de las puntuaciones es mayor que 100
	bge $s7, 100, bucle_principal_fin
	
	bge $s4, 4, bucle_principal_fin # Si se tranco el juego
	
	
	#Ahora si se cambia de jugador
	
	addi $s1, $s1, 1 #Siguiente jugador
	
	bgt $s1, 4, bucle_principal_primer_jugador
	
	move $a0, $s1 # Encuentro la direccion de la mano del jugador actual
	jal asignar_turno
	move $s0, $v0 # Almaceno dicha direccion
	
	j bucle_principal
	
bucle_principal_primer_jugador:
	
	li $s1, 1
	lw $s0, mano_1
	li $s4, 0 #Se reinicia el contador de veces que no se ha jugado
	
	j bucle_principal
	
bucle_principal_reiniciar:

 	jal shuffle
 
 	jal crear_tablero
 	
 	sw $v0, tablero
 
	# Ahora creo las manos
	
	la $a0, fichas 
	jal crear_mano
	sw $v0, mano_1
	
	la $a0, fichas
	addi $a0, $a0, 56
	jal crear_mano
	sw $v0, mano_2
	
	la $a0, fichas
	addi $a0, $a0, 112
	jal crear_mano
	sw $v0, mano_3
	
	la $a0, fichas
	addi $a0, $a0, 168
	jal crear_mano
	sw $v0, mano_4
	
	move $s1, $s5 # Numero del siguiente jugador
	
	move $a0, $s5 # Se buscara la direccion de la mano de este jugador
	jal asignar_turno
	move $s0, $v0 # Direccion de la mano correspondiente al numero del jugador que jugara

j bucle_principal
	
	
bucle_principal_fin:

	li $v0, 10
	syscall
	

###################################################################################################
###################################################################################################
				#Subrutinas del Tablero

#Crea la cabeza de la lista que representa al tablero
# $v0 : direccion del tablero
crear_tablero:
	
	li $v0, 9 #Cabeza de la lista
	li $a0, 8
	syscall
	
	move $t0, $v0 #Respaldo la direccion de la cabeza
	
	
	li $v0, 9 # Nodo de la cochina
	li $a0, 12
	syscall
	
	sw $v0, 0($t0)
	sw $v0, 4($t0)
	
	li $t1, 6 #Guardo valores de la cochina
	sw $t1, ($v0)
	sw $t1, 4($v0)
	sw $zero, 8($v0)
	
	move $v0, $t0
	
	jr $ra

###################################################################################################
###################################################################################################

# $a0 : direccion de la cabeza de la lista que representa al tablero
# $a1 : valor de la izquierda de la ficha que se va a agregar
# $a2 : valor de la derecha de la ficha que se va a agregar	
anadir_ficha_izq:

	sw $fp, ($sp)	#Prologo
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
	
	lw $t1, ($t0) #Valor izquierdo de la ultima ficha izquierda
	bne $t1, $a2, anadir_ficha_izq_al_reves
	
	sw $a1, ($v0) #Guardo el valor de la izquierda de la ficha
	sw $a2, 4($v0) #Guardo el valor de la derecha de la ficha
	j anadir_ficha_izq_seguir
	
anadir_ficha_izq_al_reves:

	sw $a2, ($v0) #Guardo el valor de la izquierda de la ficha
	sw $a1, 4($v0) #Guardo el valor de la derecha de la ficha

anadir_ficha_izq_seguir:
	
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

	sw $fp, ($sp)	#Prologo
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
	
	lw $t2, 4($t0) #Valor derecho de la ultima ficha derecha
	bne $t2, $a1, anadir_ficha_der_al_reves
	
	sw $a1, ($v0) #Guardo el valor de la izquierda de la ficha
	sw $a2, 4($v0) #Guardo el valor de la derecha de la ficha
	j anadir_ficha_der_seguir
	
anadir_ficha_der_al_reves:
	
	sw $a2, ($v0) #Guardo el valor de la izquierda de la ficha
	sw $a1, 4($v0) #Guardo el valor de la derecha de la ficha
	
anadir_ficha_der_seguir:
	
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
# $a3 : 1 si es a la izquierda y 2 si es a la derecha
# $v0 : 1 si coinciden. De lo contrario, 0
verificar_movimiento:
	
	beq $a3, 2, verificar_movimiento_der #Si se compara la ficha de la dereha o izquierda
	
	lw $t0, ($a0) #Direccion de ultima ficha izquierda del tablero
	
	lw $t0, ($t0) #Valor izquierdo de la ficha izquierda del tablero
	
	seq $t1, $t0, $a1 #Si los numeros de las fichas coinciden
	seq $t2, $t0, $a2
	or $t1, $t1, $t2
	
	move $v0, $t1
	
	j verificar_movimiento_fin
	
verificar_movimiento_der:

	lw $t0, 4($a0) #Direccion de la ultima ficha derecha del tablero
	
	lw $t0, 4($t0) #Valor derecho de la ficha derecha del tablero
	
	seq $t1, $t0, $a2 #Si los numeros de las fichas coinciden
	seq $t2, $t0, $a1
	or $t1, $t1, $t2
	
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
	li $a0, 16 #Reservo espacio para una ficha de la mano
	syscall
	
	move $t2, $v0 
	move $t3, $v0 #Siempre guarda la cabeza de la lista de la mano
		
	li $t0, 7 #Numero de elementos del arreglo que faltan por ver
	
	
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
	
	ble $t0, 0, crear_mano_fin 
	
	li $v0, 9 #Reservo espacio para la siguiente ficha de la mano
	li $a0, 16
	syscall
	
	sw $v0, 12($t2) #Guardo la direccion del siguiente
	sw $t2, 8($v0) #Guardo la direccion del anterior
	
	move $t2, $v0 #Siguiente ficha
	addi $t4, $t4, 8
	
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
	
	lw $t6, 8($a0) #Ficha anterior
	lw $t7, 12($a0) #ficha siguiente 
	
	beq $t4, 1, quitar_ficha_no_siguiente # No hay mas fichas, pero la actual se elimina
	
	j quitar_ficha_fin
	
quitar_ficha_quedan_mas:
	
	#addi, $a0, $a0, 4 #Siguiente ficha de la mano
	move $t8, $a0
	move $a0, $t9
	
	bne $t4, 1, quitar_ficha_loop #Si aun no se ha encontrado, entonces sigo en el bucle
	
	#Termine el bucle
	
	move $a0, $t8 # ficha a eliminar
	
	lw $t6, 8($a0) #Ficha anterior
	lw $t7, 12($a0) #ficha siguiente 
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

	beq $t6, 0, quitar_ficha_no_anterior_siguiente

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
	
	#addi $a0, $a0, 4 #Siguiente de la mano
	move $a0, $t6
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
	
	#addi $t0, $t0, 4 #Siguiente ficha
	move $t0, $t1
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
	li $v0, 42 #Numero aleatorio en el rango dado
	syscall
	move $v0, $a0 #El resultado esta en $a0, no en $v0. Esta rutina es rara
	
	la $t1, fichas
	
shuffle_loop_inner:
	
	addi $t1, $t1, 8  #Siguiente Ficha 
	addi $v0, $v0, -1 #Numero de alementos que queda por recorrer hasta encontrar al importante
	
	bgt $v0, 0, shuffle_loop_inner
	
	
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
	
	bgt $t0 , 0, shuffle_loop
	
	jr $ra
	
	
###################################################################################################
###################################################################################################

# $a0 : numero del jugador
# $v0 : direccion de la mano del jugador correspondiente
asignar_turno:

	beq $a0, 1, asignar_turno_uno
	
	beq $a0, 2, asignar_turno_dos
	
	beq $a0, 3, asignar_turno_tres
	
	lw $v0, mano_4
	
	j asignar_turno_fin
	
asignar_turno_uno:

	lw $v0, mano_1
	
	j asignar_turno_fin
	
asignar_turno_dos:

	lw $v0, mano_2
	
	j asignar_turno_fin
	
asignar_turno_tres:

	lw $v0, mano_3
	
		
asignar_turno_fin:

	jr $ra
	

###################################################################################################
###################################################################################################

# $a0 : numero del jugador actual
imprimir_asignar_turno:

	beq $a0, 1, imprimir_asignar_turno_uno
	
	beq $a0, 2, imprimir_asignar_turno_dos
	
	beq $a0, 3, imprimir_asignar_turno_tres
	
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


###################################################################################################
###################################################################################################

# $a0 : direccion del tablero
imprimir_tablero:
	
	move $t0, $a0
	lw $t1, ($t0) #Ultimo elemento de la izquierda
	
imprimir_tablero_bucle:
	
	li $v0, 4
	la $a0, parentesis_izq
	syscall
	
	li $v0, 1
	lw $a0, ($t1)
	syscall
	
	li $v0, 4
	la $a0, coma
	syscall
	
	li $v0, 1
	lw $a0, 4($t1)
	syscall
	
	li $v0, 4
	la $a0, parentesis_der
	syscall
	
	li $v0, 4
	la $a0, espacio
	syscall
	
	lw $t1, 8($t1) #Siguiente elemento de la lista
	
	bne $t1, 0, imprimir_tablero_bucle
	
	jr $ra
	
	
###################################################################################################
###################################################################################################



# $a0 : direccion de la mano de un jugador
# $a1 : direccion de la mano del companero
sumar_puntos:
	
	move $t0, $a0 # $t0 va a ir cambiando en el bucle
	li $t3, 0  # $t3 se usara para llevar la suma
	
	# Se determina si la mano esta vacia
	
	li $t5, 0
	lw $t4, ($a0)
	add $t5, $t4, $t5
	
	lw $t4, 4($a0)
	add $t5, $t4, $t5
	
	beq $t5, 0, sumar_puntos_companero
	
sumar_puntos_bucle:

	lw $t1, 0($t0) # Numero de la izquierda de la ficha actual
	lw $t2, 4($t0) # Numero de la derecha de la ficha actual
	add $t3, $t3, $t1 # Sumo los numeros de la ficha
	add $t3, $t3, $t2 # Sumo los numeros de la ficha
	
	lw $t0, 12($t0) # Siguiente ficha
	
	bne $t0, 0, sumar_puntos_bucle

sumar_puntos_companero:
			
	move $t0, $a1
	
	# Se determina si la mano esta vacia
	
	li $t5, 0
	lw $t4, ($a1)
	add $t5, $t4, $t5
	
	lw $t4, 4($a1)
	add $t5, $t4, $t5
	
	beq $t5, 0, sumar_puntos_fin
	
sumar_puntos_bucle_companero:

	lw $t1, 0($t0) # Numero de la izquierda de la ficha actual
	lw $t2, 4($t0) # Numero de la derecha de la ficha actual
	add $t3, $t3, $t1 # Sumo los numeros de la ficha
	add $t3, $t3, $t2 # Sumo los numeros de la ficha
	
	lw $t0, 12($t0) # Siguiente ficha
	
	bne $t0, 0, sumar_puntos_bucle_companero
	
sumar_puntos_fin:

	move $v0, $t3
	
	jr $ra
