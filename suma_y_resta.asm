.data
    msg1:    .asciiz "\nIngrese el primer numero: "
    msg2:    .asciiz "Ingrese el segundo numero: "
    msg_op:  .asciiz "Seleccione operacion (1: Suma, 2: Resta): "
    msg_res: .asciiz "El resultado es: "
    error:   .asciiz "Operacion no valida."

.text
.globl main

main:
    # --- Pedir primer numero ---
    li $v0, 4           # Syscall para imprimir string
    la $a0, msg1
    syscall
    li $v0, 5           # Syscall para leer entero
    syscall
    move $t0, $v0       # Guardar primer numero en $t0

    # --- Pedir segundo numero ---
    li $v0, 4
    la $a0, msg2
    syscall
    li $v0, 5
    syscall
    move $t1, $v0       # Guardar segundo numero en $t1

    # --- Pedir operacion ---
    li $v0, 4
    la $a0, msg_op
    syscall
    li $v0, 5
    syscall
    move $t2, $v0       # Guardar opcion en $t2

    # --- Decidir operacion ---
    li $t3, 1
    beq $t2, $t3, sumar  # Si $t2 == 1, ir a sumar
    li $t3, 2
    beq $t2, $t3, restar # Si $t2 == 2, ir a restar

    # Si no es 1 ni 2, mostrar error
    li $v0, 4
    la $a0, error
    syscall
    j fin

sumar:
    add $t4, $t0, $t1    # $t4 = $t0 + $t1
    j mostrar_resultado

restar:
    sub $t4, $t0, $t1    # $t4 = $t0 - $t1
    j mostrar_resultado

mostrar_resultado:
    # Imprimir mensaje de resultado
    li $v0, 4
    la $a0, msg_res
    syscall
    
    # Imprimir el valor calculado
    move $a0, $t4
    li $v0, 1           # Syscall para imprimir entero
    syscall

fin:
    li $v0, 10          # Salir del programa
    syscall