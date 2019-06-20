Object.copy:
lw $a1, -4($sp)
lw $a0, -8($sp)
li $v0, 9
syscall
lw $a1, -4($sp)
lw $a0, 4($a1)
move $a3, $v0
_copy.loop:
lw $a2, 0($a1)
sw $a2, 0($a3)
addiu $a0, $a0, -1
addiu $a1, $a1, 4
addiu $a3, $a3, 4
beq $a0, $zero, _copy.end
j _copy.loop
_copy.end:
jr $ra

#Cambiado(Funciona)
Object.abort:
li $v0, 10
syscall

#Cambiado(funciona)
IO.out_string:
li $v0, 4
lw $a0, -4($sp)
syscall
jr $ra

#Cambiado(Funciona)
IO.out_int:
li $v0, 1
lw $a0, -4($sp)
syscall
jr $ra


IO.in_string:
move $a3, $ra
la $a0, buffer
li $a1, 65536
li $v0, 8
syscall
addiu $sp, $sp, -4
sw $a0, 0($sp)
jal String.length
addiu $sp, $sp, 4
move $a2, $v0
addiu $a2, $a2, -1
move $a0, $v0
li $v0, 9
syscall
move $v1, $v0
la $a0, buffer
_in_string.loop:
beqz $a2, _in_string.end
lb $a1, 0($a0)
sb $a1, 0($v1)
addiu $a0, $a0, 1
addiu $v1, $v1, 1
addiu $a2, $a2, -1
j _in_string.loop
_in_string.end:
sb $zero, 0($v1)
move $ra, $a3
jr $ra


IO.in_int:
li $v0, 5
syscall
jr $ra

#(Cambiado)
String.length:
lw $a0, -4($sp)
_stringlength.loop:
lb $a1, 0($a0)
beqz $a1, _stringlength.end
addiu $a0, $a0, 1
j _stringlength.loop
_stringlength.end:
lw $a1, -4($sp)
subu $v0, $a0, $a1
jr $ra


String.concat:
move $a2, $ra
jal String.length
move $v1, $v0
addiu $sp, $sp, -4
jal String.length
addiu $sp, $sp, 4
add $v1, $v1, $v0
addi $v1, $v1, 1
li $v0, 9
move $a0, $v1
syscall
move $v1, $v0
lw $a0, 0($sp)
_stringconcat.loop1:
lb $a1, 0($a0)
beqz $a1, _stringconcat.end1
sb $a1, 0($v1)
addiu $a0, $a0, 1
addiu $v1, $v1, 1
j _stringconcat.loop1
_stringconcat.end1:
lw $a0, -4($sp)
_stringconcat.loop2:
lb $a1, 0($a0)
beqz $a1, _stringconcat.end2
sb $a1, 0($v1)
addiu $a0, $a0, 1
addiu $v1, $v1, 1
j _stringconcat.loop2
_stringconcat.end2:
sb $zero, 0($v1)
move $ra, $a2
jr $ra

#(Cambiado)
String.substr:
lw $a0, -12($sp)
addiu $a0, $a0, 1
li $v0, 9
syscall
move $v1, $v0
lw $a0, -4($sp)
lw $a1, -8($sp)
add $a0, $a0, $a1
lw $a2, -12($sp)
_stringsubstr.loop:
beqz $a2, _stringsubstr.end
lb $a1, 0($a0)
beqz $a1, _substrexception
sb $a1, 0($v1)
addiu $a0, $a0, 1
addiu $v1, $v1, 1
addiu $a2, $a2, -1
j _stringsubstr.loop
_stringsubstr.end:
sb $zero, 0($v1)
jr $ra


_substrexception:
la $a0, strsubstrexception
li $v0, 4
syscall
li $v0, 10
syscall


_stringcmp:
li $v0, 1
_stringcmp.loop:
lb $a2, 0($a0)
lb $a3, 0($a1)
beqz $a2, _stringcmp.end
beq $a2, $zero, _stringcmp.end
beq $a3, $zero, _stringcmp.end
bne $a2, $a3, _stringcmp.differents
addiu $a0, $a0, 1
addiu $a1, $a1, 1
j _stringcmp.loop
_stringcmp.end:
beq $a2, $a3, _stringcmp.equals
_stringcmp.differents:
li $v0, 0
jr $ra
_stringcmp.equals:
li $v0, 1
jr $ra
# Start Mips Generated Code

.text
.glob main

lw $t0, ($sp)
la $t1, $t0
la $t2, 4($t1)
subu $sp, $sp, 8addu $sp, $sp, 0
la $t5, msg0
lw $t0, ($sp)
la $t1, $t0
la $t2, 8($t1)
subu $sp, $sp, 8
sw $ra, 8($sp)
sw $fp, 4($sp)
la $fp, $sp
j ($t2)
lw $t0 -4($sp)
addu $sp, $sp, -1
sw $to -4($sp)
lw $t0 -4($sp)
la $sp, $fp
addu $sp, $sp, 8
lw $ra, 8($sp)
lw $fp, 4($sp)
sw $t0, -4($sp)
jr $ra
sw $ra, 8($sp)
sw $fp, 4($sp)
la $fp, $sp
j ($t2)
lw $t0 -4($sp)
addu $sp, $sp, -0
sw $to -4($sp)
.Main.main:
addu $sp, $sp, 0
la $t5, msg0
lw $t0, ($sp)
la $t1, $t0
la $t2, 8($t1)
subu $sp, $sp, 8
sw $ra, 8($sp)
sw $fp, 4($sp)
la $fp, $sp
j ($t2)
lw $t0 -4($sp)
addu $sp, $sp, -1
sw $to -4($sp)
lw $t0 -4($sp)
la $sp, $fp
addu $sp, $sp, 8
lw $ra, 8($sp)
lw $fp, 4($sp)
sw $t0, -4($sp)
jr $ra
# Start .data segment (data!)
.data
msg0:   .asscii     "Hello, World.
"