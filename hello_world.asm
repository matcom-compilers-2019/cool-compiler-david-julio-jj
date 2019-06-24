.Object.copy:
lw $t1, 4($sp)
lw $a0, 4($t1)
li $t4, 4
mult $a0, $t4
mflo $a0
addu $a0, $a0, 8
li $v0, 9
syscall
lw $a1, 4($sp)
move $a3, $v0
sw $a3, 4($sp)
_copy.loop:
lw $a2, 0($a1)
sw $a2, 0($a3)
addiu $a0, $a0, -4
addiu $a1, $a1, 4
addiu $a3, $a3, 4
beq $a0, $zero, _copy.end
j _copy.loop
_copy.end:
jr $ra

#Cambiado(Funciona)
.Object.abort:
li $v0, 10
syscall

#Cambiado(funciona)
.IO.out_string:
li $v0, 4
lw $t0, 16($fp)
lw $a0, 8($t0)
syscall
addu $sp, $sp, 4
lw $fp, ($sp)
addu $sp, $sp, 4
lw $a0, 4($sp)
sw $a0, ($sp)
subu $sp, $sp, 4
jr $ra

#Cambiado(Funciona)
.IO.out_int:
li $v0, 1
lw $t0, 16($fp)
lw $a0, 8($t0)
syscall
addu $sp, $sp, 4
lw $fp, ($sp)
addu $sp, $sp, 4
lw $a0, 4($sp)
sw $a0, ($sp)
subu $sp, $sp, 4
jr $ra


.IO.in_string:
move $a3, $ra
la $a0, buffer
li $a1, 65536
li $v0, 8
syscall
sw $a0, 0($sp)
subu $sp, $sp, 4
jal .String.length
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


.IO.in_int:
li $v0, 5
syscall
jr $ra

.String.length:
lw $a0, 4($sp)
_stringlength.loop:
lb $a1, 0($a0)
beqz $a1, _stringlength.end
addiu $a0, $a0, 1
j _stringlength.loop
_stringlength.end:
lw $a1, 4($sp)
subu $v0, $a0, $a1
jr $ra


.String.concat:
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
.String.substr:
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

# Inherithed Method
.inerithed:
lw $a0, 4($sp)
lw $a1, 8($sp)
lw $a0, ($a0)
lw $a2, ($a0)
lw $a3, 4($a0)
lw $a0, ($a1)
lw $a1, 4($a1)
sge $t0, $a2, $a0
sle $t1, $a1, $a3
and $a0, $t0, $t1
sw $a0, ($sp)
subu $sp, $sp, 4


.text
.globl main

# Start self.visit(self.main)

main:
li $v0, 9
li $a0, 12
syscall
sw $v0, 0($sp)
subu $sp, $sp ,4
li $t0, 1
sw $t0, 4($v0)
li $v0, 9
li $a0, 12
syscall
la $t0, Int
sw $t0, ($v0)
li $t0, 1
sw $t0, 4($v0)
li $a0, 0
sw $a0, 8($v0)
sw $v0, ($sp)
subu $sp, $sp, 4
# Init Attr
lw $t0, 4($sp)
lw $t1, 8($sp)
addi $t1, $t1, 8
sw $t0, 0($t1)
addu $sp, $sp, 4
la $t0, Main
sw $t0, ($v0)
# Start self.visit(cil_node.CILDynamicDispatch())

lw $t0, 4($sp)
lw $t1, ($t0)
lw $t2, 36($t1)
sw $ra, ($sp)
subu $sp, $sp, 4
sw $fp, ($sp)
subu $sp, $sp, 4
move $fp, $sp
jal $t2
lw $t0, 4($sp)
addu $sp, $sp, 8
sw $t0, ($sp)
subu $sp, $sp, 4
.Main.main:
subu $sp, $sp, 0
li $v0, 9
li $a0, 12
syscall
la $t0, Int
sw $t0, ($v0)
li $t0, 1
sw $t0, 4($v0)
li $a0, 5
sw $a0, 8($v0)
sw $v0, ($sp)
subu $sp, $sp, 4
li $v0, 9
li $a0, 12
syscall
la $t0, Int
sw $t0, ($v0)
li $t0, 1
sw $t0, 4($v0)
li $a0, 5
sw $a0, 8($v0)
sw $v0, ($sp)
subu $sp, $sp, 4
lw $t0, 8($sp)
lw $t1, 4($sp)
lw $a0, 8($t0)
lw $a1, 8($t1)
addiu $sp, $sp, 8
mult $a0, $a1
mflo $a1
li $v0, 9
li $a0, 12
syscall
la $t0, Int
sw $t0, ($v0)
li $t0, 1
sw $t0, 4($v0)
sw $a1, 8($v0)
sw $v0, ($sp)
subu $sp, $sp, 4
jal .Object.copy
lw $a0, 12($fp)
sw $a0, 0($sp)
subu $sp, $sp, 4
lw $t0, 4($sp)
lw $t1, ($t0)
lw $t2, 24($t1)
sw $ra, ($sp)
subu $sp, $sp, 4
sw $fp, ($sp)
subu $sp, $sp, 4
move $fp, $sp
jal $t2
lw $t0, 4($sp)
addu $sp, $sp, 12
sw $t0, ($sp)
subu $sp, $sp, 4
move $sp, $fp
addu $sp, $sp, 4
lw $fp, ($sp)
addu $sp, $sp, 4
lw $ra, ($sp)
jr $ra
# Start .data segment (data!)
.data
Object: .word 0, 11, .Object.abort, .Object.type_name, .Object.copy
Int: .word 1, 2, .Object.abort, .Object.type_name, .Object.copy
Bool: .word 3, 4, .Object.abort, .Object.type_name, .Object.copy
String: .word 5, 6, .Object.abort, .Object.type_name, .Object.copy, .String.length, .String.concat, .String.substr
IO: .word 7, 10, .Object.abort, .Object.type_name, .Object.copy, .IO.out_string, .IO.out_int, .IO.in_string, .IO.in_int
Main: .word 8, 9, .Object.abort, .Object.type_name, .Object.copy, .IO.out_string, .IO.out_int, .IO.in_string, .IO.in_int, .Main.main