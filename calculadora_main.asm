.data
    menu:    .asciiz "\n--- CALCULADORA MIPS ---\n1. Sumar\n2. Restar\n3. Multiplicar\n4. Dividir\n5. Salir\nElija opcion: "
    msg1:    .asciiz "Ingrese el primer numero: "
    msg2:    .asciiz "Ingrese el segundo numero: "
    msg_res: .asciiz "El resultado es: "
    msg_res2:.asciiz "\nResto: "
    error:   .asciiz "\nError: Operacion no valida.\n"
    err_div: .asciiz "\nError: Division por cero.\n"
    adios:   .asciiz "\nSaliendo del programa... ¡Hasta luego!"

.text
.globl main

main:
    # --- ETIQUETA DE INICIO DEL BUCLE ---
    # Todo lo que esté debajo de 'inicio:' se repetirá.
inicio:
    # Mostrar el menú
    li $v0, 4
    la $a0, menu
    syscall

    # Leer la opción del usuario
    li $v0, 5
    syscall
    move $t2, $v0       # Guardamos la opción en $t2

    # Comprobar si quiere SALIR (Opción 5)
    beq $t2, 5, fin_programa

    # Validar si la opción es válida (1-5)
    # Si es mayor que 5 o menor que 1, dar error
    li $t3, 5
    bgt $t2, $t3, operacion_no_valida
    li $t3, 1
    blt $t2, $t3, operacion_no_valida

    # Si la opción es válida, pedimos los números
    li $v0, 4
    la $a0, msg1
    syscall
    li $v0, 5
    syscall
    move $t0, $v0       # $t0 = Numero 1

    li $v0, 4
    la $a0, msg2
    syscall
    li $v0, 5
    syscall
    move $t1, $v0       # $t1 = Numero 2

    # --- SELECTOR DE OPERACIONES ---
    beq $t2, 1, op_sumar
    beq $t2, 2, op_restar
    beq $t2, 3, op_multiplicar
    beq $t2, 4, op_dividir

op_sumar:
    add $t4, $t0, $t1
    j imprimir_resultado

op_restar:
    sub $t4, $t0, $t1
    j imprimir_resultado

op_multiplicar:
    mult $t0, $t1
    mflo $t4
    j imprimir_resultado

op_dividir:
    beq $t1, $zero, error_cero
    div $t0, $t1
    mflo $t4            # Cociente
    mfhi $t5            # Resto
    
    # Imprimir Cociente
    li $v0, 4
    la $a0, msg_res
    syscall
    move $a0, $t4
    li $v0, 1
    syscall
    
    # Imprimir Resto
    li $v0, 4
    la $a0, msg_res2
    syscall
    move $a0, $t5
    li $v0, 1
    syscall
    
    j inicio            # VOLVER AL MENÚ

imprimir_resultado:
    li $v0, 4
    la $a0, msg_res
    syscall
    move $a0, $t4
    li $v0, 1
    syscall
    j inicio            # VOLVER AL MENÚ

# --- SECCIÓN DE ERRORES ---
operacion_no_valida:
    li $v0, 4
    la $a0, error
    syscall
    j inicio            # Volver a preguntar

error_cero:
    li $v0, 4
    la $a0, err_div
    syscall
    j inicio            # Volver a preguntar

# --- FIN DEL PROGRAMA ---
fin_programa:
    li $v0, 4
    la $a0, adios
    syscall
    li $v0, 10
    syscall