.data
    menu_tipo: .asciiz "\n--- CALCULADORA PROFESIONAL MIPS ---\n1. Decimal\n2. Binario\n5. Salir\nElija modo: "
    menu_op:   .asciiz "\n--- OPERACION ---\n1. Suma\n2. Resta\n3. Mult\n4. Div\n5. Factorial (solo primer num)\nElija: "
    msg1:      .asciiz "Ingrese el numero: "
    msg_bin:   .asciiz "Ingrese numero binario (ej. 1010): "
    msg_res:   .asciiz "\nResultado: "
    msg_fact:  .asciiz "\nFactorial de "
    msg_es:    .asciiz " es: "
    buffer:    .space 34
    error_b:   .asciiz "\nError: Caracter no binario.\n"
    err_div:   .asciiz "\nError: Division por cero.\n"
    adios:     .asciiz "\nSaliendo del programa..."

.text
.globl main

main:
    # 1. Modo de entrada
    li $v0, 4
    la $a0, menu_tipo
    syscall
    li $v0, 5
    syscall
    move $s0, $v0       
    
    beq $s0, 5, fin_programa

    # 2. Pedir primer numero
    jal pedir_numero
    move $s1, $v0       # $s1 = Numero 1

    # 3. Elegir operacion
    li $v0, 4
    la $a0, menu_op
    syscall
    li $v0, 5
    syscall
    move $t2, $v0

    # Si es Factorial (5), salta directo
    beq $t2, 5, op_factorial

    # 4. Pedir segundo numero (para operaciones normales)
    jal pedir_numero
    move $s2, $v0       # $s2 = Numero 2

    # --- Selector ---
    beq $t2, 1, op_sumar
    beq $t2, 2, op_restar
    beq $t2, 3, op_multiplicar
    beq $t2, 4, op_dividir
    j main

op_sumar:
    add $t4, $s1, $s2
    j imprimir

op_restar:
    sub $t4, $s1, $s2
    j imprimir

op_multiplicar:
    mult $s1, $s2
    mflo $t4
    j imprimir

op_dividir:
    beq $s2, $zero, error_division
    div $s1, $s2
    mflo $t4
    j imprimir

op_factorial:
    move $a0, $s1       # Pasar numero a calcular
    jal factorial
    move $t4, $v0       # Resultado a $t4
    j imprimir

imprimir:
    li $v0, 4
    la $a0, msg_res
    syscall
    move $a0, $t4
    li $v0, 1
    syscall
    j main

# --- SUBRUTINA RECURSIVA: FACTORIAL (Issue #6) ---
factorial:
    subu $sp, $sp, 8    # Reservar espacio en pila
    sw $ra, 4($sp)      # Guardar dirección de retorno
    sw $a0, 0($sp)      # Guardar el número actual
    
    li $v0, 1
    ble $a0, 1, fact_fin # Caso base: si n <= 1, retorna 1
    
    sub $a0, $a0, 1     # n - 1
    jal factorial       # Llamada recursiva
    
    lw $a0, 0($sp)      # Recuperar n original
    mul $v0, $v0, $a0   # v0 = n * factorial(n-1)

fact_fin:
    lw $ra, 4($sp)      # Restaurar retorno
    addu $sp, $sp, 8    # Limpiar pila
    jr $ra

# --- SUBRUTINAS DE LECTURA ---
pedir_numero:
    beq $s0, 2, leer_binario
    li $v0, 4
    la $a0, msg1
    syscall
    li $v0, 5
    syscall
    jr $ra

leer_binario:
    li $v0, 4
    la $a0, msg_bin
    syscall
    li $v0, 8
    la $a0, buffer
    li $a1, 33
    syscall
    la $t5, buffer
    li $v1, 0
b_loop:
    lb $t6, ($t5)
    beq $t6, 10, b_done
    beq $t6, 0, b_done
    blt $t6, 48, b_error
    bgt $t6, 49, b_error
    sub $t6, $t6, 48
    sll $v1, $v1, 1
    or  $v1, $v1, $t6
    addi $t5, $t5, 1
    j b_loop
b_done:
    move $v0, $v1
    jr $ra

b_error:
    li $v0, 4
    la $a0, error_b
    syscall
    j main

error_division:
    li $v0, 4
    la $a0, err_div
    syscall
    j main

fin_programa:
    li $v0, 4
    la $a0, adios
    syscall
    li $v0, 10
    syscall