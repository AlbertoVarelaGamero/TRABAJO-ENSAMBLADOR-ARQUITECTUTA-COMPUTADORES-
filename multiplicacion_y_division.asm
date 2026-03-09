.data
    msg1:    .asciiz "\nIngrese el primer numero: "
    msg2:    .asciiz "Ingrese el segundo numero: "
    msg_op:  .asciiz "Operacion (1:Suma, 2:Resta, 3:Mult, 4:Div): "
    msg_res: .asciiz "El resultado es: "
    msg_res2:.asciiz "\nResto: "
    error:   .asciiz "Operacion no valida."
    err_div: .asciiz "Error: Division por cero."

.text
.globl main

main:
    # --- Lectura de datos ---
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

    li $v0, 4
    la $a0, msg_op
    syscall
    li $v0, 5
    syscall
    move $t2, $v0       # $t2 = Opcion

    # --- Estructura de control (Switch/If) ---
    beq $t2, 1, sumar
    beq $t2, 2, restar
    beq $t2, 3, multiplicar
    beq $t2, 4, dividir

    # Error si no es 1-4
    li $v0, 4
    la $a0, error
    syscall
    j fin

sumar:
    add $t4, $t0, $t1
    j mostrar_simple

restar:
    sub $t4, $t0, $t1
    j mostrar_simple

multiplicar:
    mult $t0, $t1       # Multiplica $t0 * $t1
    mflo $t4            # Mueve el resultado (parte baja) de 'lo' a $t4
    j mostrar_simple

dividir:
    beq $t1, $zero, error_cero # Validar division por cero
    div $t0, $t1        # Divide $t0 / $t1
    mflo $t4            # Cociente se guarda en 'lo'
    mfhi $t5            # Resto se guarda en 'hi'
    j mostrar_division

# --- Salidas de datos ---
mostrar_simple:
    li $v0, 4
    la $a0, msg_res
    syscall
    move $a0, $t4
    li $v0, 1
    syscall
    j fin

mostrar_division:
    li $v0, 4
    la $a0, msg_res
    syscall
    move $a0, $t4       # Imprimir Cociente
    li $v0, 1
    syscall
    
    li $v0, 4
    la $a0, msg_res2
    syscall
    move $a0, $t5       # Imprimir Residuo
    li $v0, 1
    syscall
    j fin

error_cero:
    li $v0, 4
    la $a0, err_div
    syscall

fin:
    li $v0, 10
    syscall