# Pincha Bien ya
.Object.copy:
lw $t1, 12($fp)
lw $a0, 4($t1)
li $t4, 4
mult $a0, $t4
mflo $a0
addu $a0, $a0, 8
li $v0, 9
syscall
lw $a1, 12($fp)
sw $v0, ($sp)
subu $sp, $sp, 4
move $a3, $v0
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

# Cambiado(Funciona)
.Object.abort:
li $v0, 10
syscall

# Cambiado(Funciona)
.Object.type_name:
lw $t0, 12($fp)
lw $t0, ($t0)
lw $t4, 8($t0)

li $v0, 9
li $a0, 12
syscall
la $t0, String
sw $t0, ($v0)
li $t0, 1
sw $t0, 4($v0)
la $a0, ($t4)
sw $a0, 8($v0)

sw $v0, ($sp)
subu $sp, $sp, 4

jr $ra



#Cambiado(funciona)
.IO.out_string:
li $v0, 4
lw $t0, 16($fp)
lw $a0, 8($t0)
syscall

lw $t0, 12($fp)
sw $t0, ($sp)
subu $sp, $sp, 4

jr $ra

#Cambiado(Funciona)
.IO.out_int:
li $v0, 1
lw $t0, 16($fp)
lw $a0, 8($t0)
syscall

lw $t0, 12($fp)
sw $t0, ($sp)
subu $sp, $sp, 4

jr $ra


.IO.in_string:
la $a0, buffer
li $a1, 65536
li $v0, 8
syscall

li $a1, 1
# Calculate the lenght of the string
_stringlength2.loop:
lb $a2, 0($a0)
beqz $a2, _stringlength2.end
addiu $a0, $a0, 1
addiu $a1, $a1, 1
j _stringlength2.loop
_stringlength2.end:

subu $a1, $a1, 1

# Temp
li $v0, 9
move $a0, $a1
syscall

move $v1, $v0
la $a0, buffer
_in_string.loop:
beqz $a1, _in_string.end
lb $t4, 0($a0)
sb $t4, 0($v1)
addiu $a0, $a0, 1
addiu $v1, $v1, 1
addiu $a1, $a1, -1
j _in_string.loop
_in_string.end:
subu $v1, $v1, 1
sb $zero, 0($v1)

move $t2, $v0

# Creating the new type String
li $v0, 9
li $a0, 12
syscall

la $t0, String
sw $t0, ($v0)
li $t0, 1
sw $t0, 4($v0)
move $a0, $t2
sw $a0, 8($v0)

sw $v0, ($sp)
subu $sp, $sp, 4

jr $ra

# Pincha
.IO.in_int:
li $v0, 5
syscall

move $t3, $v0

li $v0, 9
li $a0, 12
syscall
la $t0, Int
sw $t0, ($v0)
li $t0, 1
sw $t0, 4($v0)
sw $t3, 8($v0)

sw $v0, ($sp)
subu $sp, $sp, 4

jr $ra

.String.length:
lw $a0, 12($fp)
lw $a0, 8($a0)
li $a1, 0
_stringlength.loop:
lb $a2, 0($a0)
beqz $a2, _stringlength.end
addiu $a0, $a0, 1
addiu $a1, $a1, 1
j _stringlength.loop

_stringlength.end:
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

jr $ra

# Pincha
.String.concat:
# pusheando el 1er string para el len
lw $t0, 12($fp)
sw $t0, ($sp)
subu $sp, $sp, 4

# salvando registros para el dispatch
sw $ra, ($sp)
subu $sp, $sp, 4
sw $fp, ($sp)
subu $sp, $sp, 4
move $fp, $sp
jal .String.length

# cogiendo el resultado del 1er len
lw $t7, 4($sp)
lw $t7, 8($t7)
addu $sp, $sp, 4

# restaurando registros
move $sp, $fp
addu $sp, $sp, 4
lw $fp, ($sp)
addu $sp, $sp, 4
lw $ra, ($sp)
addu $sp, $sp, 4

# pusheando el 2do string para el len
lw $t0, 16($fp)
sw $t0, ($sp)
subu $sp, $sp, 4

# salvando registros para el dispatch again
sw $ra, ($sp)
subu $sp, $sp, 4
sw $fp, ($sp)
subu $sp, $sp, 4
move $fp, $sp
jal .String.length

# cogiendo el resultado del 2do len
lw $t8, 4($sp)
lw $t8, 8($t8)
addu $sp, $sp, 4

# restaurando registros
move $sp, $fp
addu $sp, $sp, 4
lw $fp, ($sp)
addu $sp, $sp, 4
lw $ra, ($sp)
addu $sp, $sp, 4

move $v1, $t7
add $v1, $v1, $t8
addi $v1, $v1, 1
li $v0, 9
move $a0, $v1
syscall
move $v1, $v0
lw $a0, 12($fp)
lw $a0, 8($a0)
_stringconcat.loop1:
lb $a1,($a0)
beqz $a1, _stringconcat.end1
sb $a1, ($v1)
addiu $a0, $a0, 1
addiu $v1, $v1, 1
j _stringconcat.loop1
_stringconcat.end1:
lw $a0, 16($fp)
lw $a0, 8($a0)
_stringconcat.loop2:
lb $a1, 0($a0)
beqz $a1, _stringconcat.end2
sb $a1, 0($v1)
addiu $a0, $a0, 1
addiu $v1, $v1, 1
j _stringconcat.loop2
_stringconcat.end2:
sb $zero, 0($v1)

move $t1, $v0
li $v0, 9
li $a0, 12
syscall

la $t0, String
sw $t0, ($v0)

li $t0, 1
sw $t0, 4($v0)

sw $t1, 8($v0)

sw $v0, ($sp)
subu $sp, $sp, 4

jr $ra

# Pincha
.String.substr:

# Cargando indices del substring
lw $t4, 16($fp)
lw $t4, 8($t4)
lw $t3, 20($fp)
lw $t3, 8($t3)

move $a0, $t4
addiu $a0, $a0, 1
li $v0, 9
syscall
move $v1, $v0
move $a2, $a0
subu $a2, $a2, 1

lw $a0, 12($fp)
lw $a0, 8($a0)

_stringsubstr.loop1:
beqz $t3 _stringsubstr.end1
lb $a1, 0($a0)
beqz $a1 _substrexception
addu $a0, $a0, 1
subu $t3, $t3, 1
j _stringsubstr.loop1
_stringsubstr.end1:

_stringsubstr.loop2:
beqz $a2, _stringsubstr.end2
lb $a1, 0($a0)
beqz $a1, _substrexception
sb $a1, 0($v1)
addiu $a0, $a0, 1
addiu $v1, $v1, 1
addiu $a2, $a2, -1
j _stringsubstr.loop2
_stringsubstr.end2:
sb $zero, 0($v1)

move $t1, $v0
li $v0, 9
li $a0, 12
syscall

la $t0, String
sw $t0, ($v0)

li $t0, 1
sw $t0, 4($v0)

sw $t1, 8($v0)

sw $v0, ($sp)
subu $sp, $sp, 4

jr $ra

_substrexception:
la $a0, index_error
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

# equal for str
str_eq:
lw $t0, 4($sp)
addu $sp, $sp,4
lw $t1, 4($sp)
addu $sp, $sp, 4
subu $t0, $t0, 1
subu $t1, $t1, 1
str_eq_loop:
addi $t0, $t0, 1			# $t0 = $t1 + 1
addi $t1, $t1, 1
lb $t3, ($t0)
lb $t4, ($t1)
or $t5, $t3, $t4
beqz $t5, success
beqz $t3, fail
beqz $t4, fail
beq $t3, $t4, str_eq_loop
fail:
li $v0, 9
li $a0, 12
syscall
la $t0, Bool
sw $t0, ($v0)
li $t0, 1
sw $t0, 4($v0)
li $t0, 0
sw $t0, 8($v0)
sw $v0, ($sp)
subu $sp, $sp, 4
jr $ra
success:
la $t0, Bool
sw $t0, ($v0)
li $t0, 1
sw $t0, 4($v0)
sw $t0, 8($v0)
sw $v0, ($sp)
subu $sp, $sp, 4
jr $ra


# Start Mips Generated Code

# Inherithed Method
.inerithed:
lw $a0, 8($sp)
lw $a1, 4($sp)
lw $a0, ($a0)
lw $a2, ($a0)
lw $a3, 4($a0)
lw $a0, ($a1)
lw $a1, 4($a1)
sge $t0, $a2, $a0
sle $t1, $a3, $a1
and $a0, $t0, $t1
sw $a0, ($sp)
subu $sp, $sp, 4
jr $ra


.text
.globl main

# raise exception Method
.raise:
lw $a0, 4($sp)
li $v0, 4
syscall
li $v0, 10
syscall
# Start self.visit(self.main)

main:
li $v0, 9
li $a0, 8
syscall
sw $v0, 0($sp) # new Object
subu $sp, $sp ,4
la $t0, Main
sw $t0, ($v0)
li $t0, 0
sw $t0, 4($v0)
sw $ra, ($sp)
subu $sp, $sp, 4
sw $fp, ($sp)
subu $sp, $sp, 4
move $fp, $sp
jal .Main.Main
addu $sp, $sp, 4
move $sp, $fp
addu $sp, $sp, 4
lw $fp, ($sp)
addu $sp, $sp, 4
lw $ra, ($sp)
# Start self.visit(cil_node.CILDynamicDispatch())

lw $t0, 4($sp)
la $t1, void_error
sw $t1, ($sp)
subu $sp, $sp, 4
beqz $t0, .raise
addu $sp, $sp, 4
lw $t1, ($t0)
lw $t2, 80($t1)
sw $ra, ($sp)
subu $sp, $sp, 4
sw $fp, ($sp)
subu $sp, $sp, 4
move $fp, $sp
jal $t2
lw $t0, 4($sp)
addu $sp, $sp, 4
move $sp, $fp
addu $sp, $sp, 4
lw $fp, ($sp)
addu $sp, $sp, 4
lw $ra, ($sp)
addu $sp, $sp, 4
sw $t0, ($sp)
subu $sp, $sp, 4
j .Object.abort
.VarList.isNil:
li $t0, 0 #.VarList.isNil
li $v0, 9
li $a0, 12
syscall
la $t0, Bool
sw $t0, ($v0)
li $t0, 1
sw $t0, 4($v0)
li $a0, 1
sw $a0, 8($v0)
sw $v0, ($sp)
subu $sp, $sp, 4
jr $ra
.VarList.head:
li $t0, 0 #.VarList.head
lw $a0, 12($fp)
sw $a0, 0($sp)
subu $sp, $sp, 4
lw $t0, 4($sp)
la $t1, void_error
sw $t1, ($sp)
subu $sp, $sp, 4
beqz $t0, .raise
addu $sp, $sp, 4
lw $t1, ($t0)
lw $t2, 12($t1)
sw $ra, ($sp)
subu $sp, $sp, 4
sw $fp, ($sp)
subu $sp, $sp, 4
move $fp, $sp
jal $t2
lw $t0, 4($sp)
addu $sp, $sp, 4
move $sp, $fp
addu $sp, $sp, 4
lw $fp, ($sp)
addu $sp, $sp, 4
lw $ra, ($sp)
addu $sp, $sp, 4
sw $t0, ($sp)
subu $sp, $sp, 4
li $v0, 9
li $a0, 12
syscall
sw $v0, 0($sp) # new Object
subu $sp, $sp ,4
la $t0, Variable
sw $t0, ($v0)
li $t0, 1
sw $t0, 4($v0)
sw $ra, ($sp)
subu $sp, $sp, 4
sw $fp, ($sp)
subu $sp, $sp, 4
move $fp, $sp
jal .Variable.Variable
addu $sp, $sp, 4
move $sp, $fp
addu $sp, $sp, 4
lw $fp, ($sp)
addu $sp, $sp, 4
lw $ra, ($sp)
lw $a0, 4($sp)
addu, $sp, $sp, 8
sw $a0, ($sp)
subu, $sp, $sp, 4
jr $ra
.VarList.tail:
li $t0, 0 #.VarList.tail
lw $a0, 12($fp)
sw $a0, 0($sp)
subu $sp, $sp, 4
lw $t0, 4($sp)
la $t1, void_error
sw $t1, ($sp)
subu $sp, $sp, 4
beqz $t0, .raise
addu $sp, $sp, 4
lw $t1, ($t0)
lw $t2, 12($t1)
sw $ra, ($sp)
subu $sp, $sp, 4
sw $fp, ($sp)
subu $sp, $sp, 4
move $fp, $sp
jal $t2
lw $t0, 4($sp)
addu $sp, $sp, 4
move $sp, $fp
addu $sp, $sp, 4
lw $fp, ($sp)
addu $sp, $sp, 4
lw $ra, ($sp)
addu $sp, $sp, 4
sw $t0, ($sp)
subu $sp, $sp, 4
li $v0, 9
li $a0, 8
syscall
sw $v0, 0($sp) # new Object
subu $sp, $sp ,4
la $t0, VarList
sw $t0, ($v0)
li $t0, 0
sw $t0, 4($v0)
sw $ra, ($sp)
subu $sp, $sp, 4
sw $fp, ($sp)
subu $sp, $sp, 4
move $fp, $sp
jal .VarList.VarList
addu $sp, $sp, 4
move $sp, $fp
addu $sp, $sp, 4
lw $fp, ($sp)
addu $sp, $sp, 4
lw $ra, ($sp)
lw $a0, 4($sp)
addu, $sp, $sp, 8
sw $a0, ($sp)
subu, $sp, $sp, 4
jr $ra
.VarList.add:
li $t0, 0 #.VarList.add
lw $t0, 16($fp)
sw $t0, ($sp)
subu $sp, $sp, 4
lw $a0, 12($fp)
sw $a0, 0($sp)
subu $sp, $sp, 4
li $v0, 9
li $a0, 16
syscall
sw $v0, 0($sp) # new Object
subu $sp, $sp ,4
la $t0, VarListNE
sw $t0, ($v0)
li $t0, 2
sw $t0, 4($v0)
sw $ra, ($sp)
subu $sp, $sp, 4
sw $fp, ($sp)
subu $sp, $sp, 4
move $fp, $sp
jal .VarListNE.VarListNE
addu $sp, $sp, 4
move $sp, $fp
addu $sp, $sp, 4
lw $fp, ($sp)
addu $sp, $sp, 4
lw $ra, ($sp)
lw $t0, 4($sp)
la $t1, void_error
sw $t1, ($sp)
subu $sp, $sp, 4
beqz $t0, .raise
addu $sp, $sp, 4
lw $t1, ($t0)
lw $t2, 60($t1)
sw $ra, ($sp)
subu $sp, $sp, 4
sw $fp, ($sp)
subu $sp, $sp, 4
move $fp, $sp
jal $t2
lw $t0, 4($sp)
addu $sp, $sp, 4
move $sp, $fp
addu $sp, $sp, 4
lw $fp, ($sp)
addu $sp, $sp, 4
lw $ra, ($sp)
addu $sp, $sp, 12
sw $t0, ($sp)
subu $sp, $sp, 4
jr $ra
.VarList.print:
li $t0, 0 #.VarList.print
li $v0, 9
li $a0, 12
syscall
la $t0, String
sw $t0, ($v0)
li $t0, 1
sw $t0, 4($v0)
la $a0, msg0
sw $a0, 8($v0)
sw $v0, ($sp)
subu $sp, $sp, 4
lw $a0, 12($fp)
sw $a0, 0($sp)
subu $sp, $sp, 4
lw $t0, 4($sp)
la $t1, void_error
sw $t1, ($sp)
subu $sp, $sp, 4
beqz $t0, .raise
addu $sp, $sp, 4
lw $t1, ($t0)
lw $t2, 24($t1)
sw $ra, ($sp)
subu $sp, $sp, 4
sw $fp, ($sp)
subu $sp, $sp, 4
move $fp, $sp
jal $t2
lw $t0, 4($sp)
addu $sp, $sp, 4
move $sp, $fp
addu $sp, $sp, 4
lw $fp, ($sp)
addu $sp, $sp, 4
lw $ra, ($sp)
addu $sp, $sp, 8
sw $t0, ($sp)
subu $sp, $sp, 4
jr $ra
.VarList.VarList:
li $t0, 0 #.VarList.VarList
lw $a0, 12($fp)
sw $a0, 0($sp)
subu $sp, $sp, 4
lw $a0, 4($sp)
addu, $sp, $sp, 4
sw $a0, ($sp)
subu, $sp, $sp, 4
jr $ra
.VarListNE.isNil:
li $t0, 0 #.VarListNE.isNil
li $v0, 9
li $a0, 12
syscall
la $t0, Bool
sw $t0, ($v0)
li $t0, 1
sw $t0, 4($v0)
li $a0, 0
sw $a0, 8($v0)
sw $v0, ($sp)
subu $sp, $sp, 4
jr $ra
.VarListNE.head:
li $t0, 0 #.VarListNE.head
lw $t0, 12($fp)
la $t1, void_error
sw $t1, ($sp)
subu $sp, $sp, 4
beqz $t0, .raise
addu $sp, $sp, 4
addu $t0, $t0, 8
addu $t0, $t0, 0
lw $t0, ($t0)
sw $t0, ($sp)
subu $sp, $sp, 4
jr $ra
.VarListNE.tail:
li $t0, 0 #.VarListNE.tail
lw $t0, 12($fp)
la $t1, void_error
sw $t1, ($sp)
subu $sp, $sp, 4
beqz $t0, .raise
addu $sp, $sp, 4
addu $t0, $t0, 8
addu $t0, $t0, 4
lw $t0, ($t0)
sw $t0, ($sp)
subu $sp, $sp, 4
jr $ra
.VarListNE.init:
li $t0, 0 #.VarListNE.init
lw $t0, 20($fp)
sw $t0, ($sp)
subu $sp, $sp, 4
lw $t0, 12($fp)
la $t1, void_error
sw $t1, ($sp)
subu $sp, $sp, 4
beqz $t0, .raise
addu $sp, $sp, 4
addu $t0, $t0, 8
addu $t0, $t0, 0
lw $t1, 4($sp)
sw $t1, ($t0)
lw $t0, 16($fp)
sw $t0, ($sp)
subu $sp, $sp, 4
lw $t0, 12($fp)
la $t1, void_error
sw $t1, ($sp)
subu $sp, $sp, 4
beqz $t0, .raise
addu $sp, $sp, 4
addu $t0, $t0, 8
addu $t0, $t0, 4
lw $t1, 4($sp)
sw $t1, ($t0)
lw $a0, 12($fp)
sw $a0, 0($sp)
subu $sp, $sp, 4
lw $a0, 4($sp)
addu, $sp, $sp, 12
sw $a0, ($sp)
subu, $sp, $sp, 4
jr $ra
.VarListNE.print:
li $t0, 0 #.VarListNE.print
lw $t0, 12($fp)
la $t1, void_error
sw $t1, ($sp)
subu $sp, $sp, 4
beqz $t0, .raise
addu $sp, $sp, 4
addu $t0, $t0, 8
addu $t0, $t0, 0
lw $t0, ($t0)
sw $t0, ($sp)
subu $sp, $sp, 4
lw $t0, 4($sp)
la $t1, void_error
sw $t1, ($sp)
subu $sp, $sp, 4
beqz $t0, .raise
addu $sp, $sp, 4
lw $t1, ($t0)
lw $t2, 40($t1)
sw $ra, ($sp)
subu $sp, $sp, 4
sw $fp, ($sp)
subu $sp, $sp, 4
move $fp, $sp
jal $t2
lw $t0, 4($sp)
addu $sp, $sp, 4
move $sp, $fp
addu $sp, $sp, 4
lw $fp, ($sp)
addu $sp, $sp, 4
lw $ra, ($sp)
addu $sp, $sp, 4
sw $t0, ($sp)
subu $sp, $sp, 4
li $v0, 9
li $a0, 12
syscall
la $t0, String
sw $t0, ($v0)
li $t0, 1
sw $t0, 4($v0)
la $a0, msg1
sw $a0, 8($v0)
sw $v0, ($sp)
subu $sp, $sp, 4
lw $a0, 12($fp)
sw $a0, 0($sp)
subu $sp, $sp, 4
lw $t0, 4($sp)
la $t1, void_error
sw $t1, ($sp)
subu $sp, $sp, 4
beqz $t0, .raise
addu $sp, $sp, 4
lw $t1, ($t0)
lw $t2, 24($t1)
sw $ra, ($sp)
subu $sp, $sp, 4
sw $fp, ($sp)
subu $sp, $sp, 4
move $fp, $sp
jal $t2
lw $t0, 4($sp)
addu $sp, $sp, 4
move $sp, $fp
addu $sp, $sp, 4
lw $fp, ($sp)
addu $sp, $sp, 4
lw $ra, ($sp)
addu $sp, $sp, 8
sw $t0, ($sp)
subu $sp, $sp, 4
lw $t0, 12($fp)
la $t1, void_error
sw $t1, ($sp)
subu $sp, $sp, 4
beqz $t0, .raise
addu $sp, $sp, 4
addu $t0, $t0, 8
addu $t0, $t0, 4
lw $t0, ($t0)
sw $t0, ($sp)
subu $sp, $sp, 4
lw $t0, 4($sp)
la $t1, void_error
sw $t1, ($sp)
subu $sp, $sp, 4
beqz $t0, .raise
addu $sp, $sp, 4
lw $t1, ($t0)
lw $t2, 56($t1)
sw $ra, ($sp)
subu $sp, $sp, 4
sw $fp, ($sp)
subu $sp, $sp, 4
move $fp, $sp
jal $t2
lw $t0, 4($sp)
addu $sp, $sp, 4
move $sp, $fp
addu $sp, $sp, 4
lw $fp, ($sp)
addu $sp, $sp, 4
lw $ra, ($sp)
addu $sp, $sp, 4
sw $t0, ($sp)
subu $sp, $sp, 4
lw $a0, 12($fp)
sw $a0, 0($sp)
subu $sp, $sp, 4
lw $a0, 4($sp)
addu, $sp, $sp, 16
sw $a0, ($sp)
subu, $sp, $sp, 4
jr $ra
.VarListNE.VarListNE:
li $t0, 0 #.VarListNE.VarListNE
lw $a0, 12($fp)
sw $a0, 0($sp)
subu $sp, $sp, 4
lw $a0, 4($sp)
addu, $sp, $sp, 4
sw $a0, ($sp)
subu, $sp, $sp, 4
jr $ra
.LambdaList.isNil:
li $t0, 0 #.LambdaList.isNil
li $v0, 9
li $a0, 12
syscall
la $t0, Bool
sw $t0, ($v0)
li $t0, 1
sw $t0, 4($v0)
li $a0, 1
sw $a0, 8($v0)
sw $v0, ($sp)
subu $sp, $sp, 4
jr $ra
.LambdaList.headE:
li $t0, 0 #.LambdaList.headE
lw $a0, 12($fp)
sw $a0, 0($sp)
subu $sp, $sp, 4
lw $t0, 4($sp)
la $t1, void_error
sw $t1, ($sp)
subu $sp, $sp, 4
beqz $t0, .raise
addu $sp, $sp, 4
lw $t1, ($t0)
lw $t2, 12($t1)
sw $ra, ($sp)
subu $sp, $sp, 4
sw $fp, ($sp)
subu $sp, $sp, 4
move $fp, $sp
jal $t2
lw $t0, 4($sp)
addu $sp, $sp, 4
move $sp, $fp
addu $sp, $sp, 4
lw $fp, ($sp)
addu $sp, $sp, 4
lw $ra, ($sp)
addu $sp, $sp, 4
sw $t0, ($sp)
subu $sp, $sp, 4
li $v0, 9
li $a0, 8
syscall
sw $v0, 0($sp) # new Object
subu $sp, $sp ,4
la $t0, VarList
sw $t0, ($v0)
li $t0, 0
sw $t0, 4($v0)
sw $ra, ($sp)
subu $sp, $sp, 4
sw $fp, ($sp)
subu $sp, $sp, 4
move $fp, $sp
jal .VarList.VarList
addu $sp, $sp, 4
move $sp, $fp
addu $sp, $sp, 4
lw $fp, ($sp)
addu $sp, $sp, 4
lw $ra, ($sp)
lw $a0, 4($sp)
addu, $sp, $sp, 8
sw $a0, ($sp)
subu, $sp, $sp, 4
jr $ra
.LambdaList.headC:
li $t0, 0 #.LambdaList.headC
lw $a0, 12($fp)
sw $a0, 0($sp)
subu $sp, $sp, 4
lw $t0, 4($sp)
la $t1, void_error
sw $t1, ($sp)
subu $sp, $sp, 4
beqz $t0, .raise
addu $sp, $sp, 4
lw $t1, ($t0)
lw $t2, 12($t1)
sw $ra, ($sp)
subu $sp, $sp, 4
sw $fp, ($sp)
subu $sp, $sp, 4
move $fp, $sp
jal $t2
lw $t0, 4($sp)
addu $sp, $sp, 4
move $sp, $fp
addu $sp, $sp, 4
lw $fp, ($sp)
addu $sp, $sp, 4
lw $ra, ($sp)
addu $sp, $sp, 4
sw $t0, ($sp)
subu $sp, $sp, 4
li $v0, 9
li $a0, 16
syscall
sw $v0, 0($sp) # new Object
subu $sp, $sp ,4
la $t0, Lambda
sw $t0, ($v0)
li $t0, 2
sw $t0, 4($v0)
sw $ra, ($sp)
subu $sp, $sp, 4
sw $fp, ($sp)
subu $sp, $sp, 4
move $fp, $sp
jal .Lambda.Lambda
addu $sp, $sp, 4
move $sp, $fp
addu $sp, $sp, 4
lw $fp, ($sp)
addu $sp, $sp, 4
lw $ra, ($sp)
lw $a0, 4($sp)
addu, $sp, $sp, 8
sw $a0, ($sp)
subu, $sp, $sp, 4
jr $ra
.LambdaList.headN:
li $t0, 0 #.LambdaList.headN
lw $a0, 12($fp)
sw $a0, 0($sp)
subu $sp, $sp, 4
lw $t0, 4($sp)
la $t1, void_error
sw $t1, ($sp)
subu $sp, $sp, 4
beqz $t0, .raise
addu $sp, $sp, 4
lw $t1, ($t0)
lw $t2, 12($t1)
sw $ra, ($sp)
subu $sp, $sp, 4
sw $fp, ($sp)
subu $sp, $sp, 4
move $fp, $sp
jal $t2
lw $t0, 4($sp)
addu $sp, $sp, 4
move $sp, $fp
addu $sp, $sp, 4
lw $fp, ($sp)
addu $sp, $sp, 4
lw $ra, ($sp)
addu $sp, $sp, 4
sw $t0, ($sp)
subu $sp, $sp, 4
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
lw $a0, 4($sp)
addu, $sp, $sp, 8
sw $a0, ($sp)
subu, $sp, $sp, 4
jr $ra
.LambdaList.tail:
li $t0, 0 #.LambdaList.tail
lw $a0, 12($fp)
sw $a0, 0($sp)
subu $sp, $sp, 4
lw $t0, 4($sp)
la $t1, void_error
sw $t1, ($sp)
subu $sp, $sp, 4
beqz $t0, .raise
addu $sp, $sp, 4
lw $t1, ($t0)
lw $t2, 12($t1)
sw $ra, ($sp)
subu $sp, $sp, 4
sw $fp, ($sp)
subu $sp, $sp, 4
move $fp, $sp
jal $t2
lw $t0, 4($sp)
addu $sp, $sp, 4
move $sp, $fp
addu $sp, $sp, 4
lw $fp, ($sp)
addu $sp, $sp, 4
lw $ra, ($sp)
addu $sp, $sp, 4
sw $t0, ($sp)
subu $sp, $sp, 4
li $v0, 9
li $a0, 8
syscall
sw $v0, 0($sp) # new Object
subu $sp, $sp ,4
la $t0, LambdaList
sw $t0, ($v0)
li $t0, 0
sw $t0, 4($v0)
sw $ra, ($sp)
subu $sp, $sp, 4
sw $fp, ($sp)
subu $sp, $sp, 4
move $fp, $sp
jal .LambdaList.LambdaList
addu $sp, $sp, 4
move $sp, $fp
addu $sp, $sp, 4
lw $fp, ($sp)
addu $sp, $sp, 4
lw $ra, ($sp)
lw $a0, 4($sp)
addu, $sp, $sp, 8
sw $a0, ($sp)
subu, $sp, $sp, 4
jr $ra
.LambdaList.add:
li $t0, 0 #.LambdaList.add
lw $t0, 24($fp)
sw $t0, ($sp)
subu $sp, $sp, 4
lw $t0, 20($fp)
sw $t0, ($sp)
subu $sp, $sp, 4
lw $t0, 16($fp)
sw $t0, ($sp)
subu $sp, $sp, 4
lw $t0, 4($sp)
la $t1, void_error
sw $t1, ($sp)
subu $sp, $sp, 4
beqz $t0, .raise
addu $sp, $sp, 4
lw $t1, ($t0)
lw $t2, 20($t1)
sw $ra, ($sp)
subu $sp, $sp, 4
sw $fp, ($sp)
subu $sp, $sp, 4
move $fp, $sp
jal $t2
lw $t0, 4($sp)
addu $sp, $sp, 4
move $sp, $fp
addu $sp, $sp, 4
lw $fp, ($sp)
addu $sp, $sp, 4
lw $ra, ($sp)
addu $sp, $sp, 4
sw $t0, ($sp)
subu $sp, $sp, 4
lw $a0, 12($fp)
sw $a0, 0($sp)
subu $sp, $sp, 4
li $v0, 9
li $a0, 24
syscall
sw $v0, 0($sp) # new Object
subu $sp, $sp ,4
la $t0, LambdaListNE
sw $t0, ($v0)
li $t0, 4
sw $t0, 4($v0)
sw $ra, ($sp)
subu $sp, $sp, 4
sw $fp, ($sp)
subu $sp, $sp, 4
move $fp, $sp
jal .LambdaListNE.LambdaListNE
addu $sp, $sp, 4
move $sp, $fp
addu $sp, $sp, 4
lw $fp, ($sp)
addu $sp, $sp, 4
lw $ra, ($sp)
lw $t0, 4($sp)
la $t1, void_error
sw $t1, ($sp)
subu $sp, $sp, 4
beqz $t0, .raise
addu $sp, $sp, 4
lw $t1, ($t0)
lw $t2, 48($t1)
sw $ra, ($sp)
subu $sp, $sp, 4
sw $fp, ($sp)
subu $sp, $sp, 4
move $fp, $sp
jal $t2
lw $t0, 4($sp)
addu $sp, $sp, 4
move $sp, $fp
addu $sp, $sp, 4
lw $fp, ($sp)
addu $sp, $sp, 4
lw $ra, ($sp)
addu $sp, $sp, 20
sw $t0, ($sp)
subu $sp, $sp, 4
jr $ra
.LambdaList.LambdaList:
li $t0, 0 #.LambdaList.LambdaList
lw $a0, 12($fp)
sw $a0, 0($sp)
subu $sp, $sp, 4
lw $a0, 4($sp)
addu, $sp, $sp, 4
sw $a0, ($sp)
subu, $sp, $sp, 4
jr $ra
.LambdaListNE.isNil:
li $t0, 0 #.LambdaListNE.isNil
li $v0, 9
li $a0, 12
syscall
la $t0, Bool
sw $t0, ($v0)
li $t0, 1
sw $t0, 4($v0)
li $a0, 0
sw $a0, 8($v0)
sw $v0, ($sp)
subu $sp, $sp, 4
jr $ra
.LambdaListNE.headE:
li $t0, 0 #.LambdaListNE.headE
lw $t0, 12($fp)
la $t1, void_error
sw $t1, ($sp)
subu $sp, $sp, 4
beqz $t0, .raise
addu $sp, $sp, 4
addu $t0, $t0, 8
addu $t0, $t0, 8
lw $t0, ($t0)
sw $t0, ($sp)
subu $sp, $sp, 4
jr $ra
.LambdaListNE.headC:
li $t0, 0 #.LambdaListNE.headC
lw $t0, 12($fp)
la $t1, void_error
sw $t1, ($sp)
subu $sp, $sp, 4
beqz $t0, .raise
addu $sp, $sp, 4
addu $t0, $t0, 8
addu $t0, $t0, 0
lw $t0, ($t0)
sw $t0, ($sp)
subu $sp, $sp, 4
jr $ra
.LambdaListNE.headN:
li $t0, 0 #.LambdaListNE.headN
lw $t0, 12($fp)
la $t1, void_error
sw $t1, ($sp)
subu $sp, $sp, 4
beqz $t0, .raise
addu $sp, $sp, 4
addu $t0, $t0, 8
addu $t0, $t0, 4
lw $t0, ($t0)
sw $t0, ($sp)
subu $sp, $sp, 4
jr $ra
.LambdaListNE.tail:
li $t0, 0 #.LambdaListNE.tail
lw $t0, 12($fp)
la $t1, void_error
sw $t1, ($sp)
subu $sp, $sp, 4
beqz $t0, .raise
addu $sp, $sp, 4
addu $t0, $t0, 8
addu $t0, $t0, 12
lw $t0, ($t0)
sw $t0, ($sp)
subu $sp, $sp, 4
jr $ra
.LambdaListNE.init:
li $t0, 0 #.LambdaListNE.init
lw $t0, 28($fp)
sw $t0, ($sp)
subu $sp, $sp, 4
lw $t0, 12($fp)
la $t1, void_error
sw $t1, ($sp)
subu $sp, $sp, 4
beqz $t0, .raise
addu $sp, $sp, 4
addu $t0, $t0, 8
addu $t0, $t0, 8
lw $t1, 4($sp)
sw $t1, ($t0)
lw $t0, 24($fp)
sw $t0, ($sp)
subu $sp, $sp, 4
lw $t0, 12($fp)
la $t1, void_error
sw $t1, ($sp)
subu $sp, $sp, 4
beqz $t0, .raise
addu $sp, $sp, 4
addu $t0, $t0, 8
addu $t0, $t0, 0
lw $t1, 4($sp)
sw $t1, ($t0)
lw $t0, 20($fp)
sw $t0, ($sp)
subu $sp, $sp, 4
lw $t0, 12($fp)
la $t1, void_error
sw $t1, ($sp)
subu $sp, $sp, 4
beqz $t0, .raise
addu $sp, $sp, 4
addu $t0, $t0, 8
addu $t0, $t0, 4
lw $t1, 4($sp)
sw $t1, ($t0)
lw $t0, 16($fp)
sw $t0, ($sp)
subu $sp, $sp, 4
lw $t0, 12($fp)
la $t1, void_error
sw $t1, ($sp)
subu $sp, $sp, 4
beqz $t0, .raise
addu $sp, $sp, 4
addu $t0, $t0, 8
addu $t0, $t0, 12
lw $t1, 4($sp)
sw $t1, ($t0)
lw $a0, 12($fp)
sw $a0, 0($sp)
subu $sp, $sp, 4
lw $a0, 4($sp)
addu, $sp, $sp, 20
sw $a0, ($sp)
subu, $sp, $sp, 4
jr $ra
.LambdaListNE.LambdaListNE:
li $t0, 0 #.LambdaListNE.LambdaListNE
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
lw $t0, 12($fp)
la $t1, void_error
sw $t1, ($sp)
subu $sp, $sp, 4
beqz $t0, .raise
addu $sp, $sp, 4
addu $t0, $t0, 8
addu $t0, $t0, 4
lw $t1, 4($sp)
sw $t1, ($t0)
lw $a0, 12($fp)
sw $a0, 0($sp)
subu $sp, $sp, 4
lw $a0, 4($sp)
addu, $sp, $sp, 8
sw $a0, ($sp)
subu, $sp, $sp, 4
jr $ra
.LambdaListRef.isNil:
li $t0, 0 #.LambdaListRef.isNil
lw $t0, 12($fp)
la $t1, void_error
sw $t1, ($sp)
subu $sp, $sp, 4
beqz $t0, .raise
addu $sp, $sp, 4
addu $t0, $t0, 8
addu $t0, $t0, 4
lw $t0, ($t0)
sw $t0, ($sp)
subu $sp, $sp, 4
lw $t0, 4($sp)
la $t1, void_error
sw $t1, ($sp)
subu $sp, $sp, 4
beqz $t0, .raise
addu $sp, $sp, 4
lw $t1, ($t0)
lw $t2, 24($t1)
sw $ra, ($sp)
subu $sp, $sp, 4
sw $fp, ($sp)
subu $sp, $sp, 4
move $fp, $sp
jal $t2
lw $t0, 4($sp)
addu $sp, $sp, 4
move $sp, $fp
addu $sp, $sp, 4
lw $fp, ($sp)
addu $sp, $sp, 4
lw $ra, ($sp)
addu $sp, $sp, 4
sw $t0, ($sp)
subu $sp, $sp, 4
jr $ra
.LambdaListRef.headE:
li $t0, 0 #.LambdaListRef.headE
lw $t0, 12($fp)
la $t1, void_error
sw $t1, ($sp)
subu $sp, $sp, 4
beqz $t0, .raise
addu $sp, $sp, 4
addu $t0, $t0, 8
addu $t0, $t0, 4
lw $t0, ($t0)
sw $t0, ($sp)
subu $sp, $sp, 4
lw $t0, 4($sp)
la $t1, void_error
sw $t1, ($sp)
subu $sp, $sp, 4
beqz $t0, .raise
addu $sp, $sp, 4
lw $t1, ($t0)
lw $t2, 28($t1)
sw $ra, ($sp)
subu $sp, $sp, 4
sw $fp, ($sp)
subu $sp, $sp, 4
move $fp, $sp
jal $t2
lw $t0, 4($sp)
addu $sp, $sp, 4
move $sp, $fp
addu $sp, $sp, 4
lw $fp, ($sp)
addu $sp, $sp, 4
lw $ra, ($sp)
addu $sp, $sp, 4
sw $t0, ($sp)
subu $sp, $sp, 4
jr $ra
.LambdaListRef.headC:
li $t0, 0 #.LambdaListRef.headC
lw $t0, 12($fp)
la $t1, void_error
sw $t1, ($sp)
subu $sp, $sp, 4
beqz $t0, .raise
addu $sp, $sp, 4
addu $t0, $t0, 8
addu $t0, $t0, 4
lw $t0, ($t0)
sw $t0, ($sp)
subu $sp, $sp, 4
lw $t0, 4($sp)
la $t1, void_error
sw $t1, ($sp)
subu $sp, $sp, 4
beqz $t0, .raise
addu $sp, $sp, 4
lw $t1, ($t0)
lw $t2, 32($t1)
sw $ra, ($sp)
subu $sp, $sp, 4
sw $fp, ($sp)
subu $sp, $sp, 4
move $fp, $sp
jal $t2
lw $t0, 4($sp)
addu $sp, $sp, 4
move $sp, $fp
addu $sp, $sp, 4
lw $fp, ($sp)
addu $sp, $sp, 4
lw $ra, ($sp)
addu $sp, $sp, 4
sw $t0, ($sp)
subu $sp, $sp, 4
jr $ra
.LambdaListRef.headN:
li $t0, 0 #.LambdaListRef.headN
lw $t0, 12($fp)
la $t1, void_error
sw $t1, ($sp)
subu $sp, $sp, 4
beqz $t0, .raise
addu $sp, $sp, 4
addu $t0, $t0, 8
addu $t0, $t0, 4
lw $t0, ($t0)
sw $t0, ($sp)
subu $sp, $sp, 4
lw $t0, 4($sp)
la $t1, void_error
sw $t1, ($sp)
subu $sp, $sp, 4
beqz $t0, .raise
addu $sp, $sp, 4
lw $t1, ($t0)
lw $t2, 36($t1)
sw $ra, ($sp)
subu $sp, $sp, 4
sw $fp, ($sp)
subu $sp, $sp, 4
move $fp, $sp
jal $t2
lw $t0, 4($sp)
addu $sp, $sp, 4
move $sp, $fp
addu $sp, $sp, 4
lw $fp, ($sp)
addu $sp, $sp, 4
lw $ra, ($sp)
addu $sp, $sp, 4
sw $t0, ($sp)
subu $sp, $sp, 4
jr $ra
.LambdaListRef.reset:
li $t0, 0 #.LambdaListRef.reset
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
lw $t0, 12($fp)
la $t1, void_error
sw $t1, ($sp)
subu $sp, $sp, 4
beqz $t0, .raise
addu $sp, $sp, 4
addu $t0, $t0, 8
addu $t0, $t0, 0
lw $t1, 4($sp)
sw $t1, ($t0)
li $v0, 9
li $a0, 8
syscall
sw $v0, 0($sp) # new Object
subu $sp, $sp ,4
la $t0, LambdaList
sw $t0, ($v0)
li $t0, 0
sw $t0, 4($v0)
sw $ra, ($sp)
subu $sp, $sp, 4
sw $fp, ($sp)
subu $sp, $sp, 4
move $fp, $sp
jal .LambdaList.LambdaList
addu $sp, $sp, 4
move $sp, $fp
addu $sp, $sp, 4
lw $fp, ($sp)
addu $sp, $sp, 4
lw $ra, ($sp)
lw $t0, 12($fp)
la $t1, void_error
sw $t1, ($sp)
subu $sp, $sp, 4
beqz $t0, .raise
addu $sp, $sp, 4
addu $t0, $t0, 8
addu $t0, $t0, 4
lw $t1, 4($sp)
sw $t1, ($t0)
lw $a0, 12($fp)
sw $a0, 0($sp)
subu $sp, $sp, 4
lw $a0, 4($sp)
addu, $sp, $sp, 12
sw $a0, ($sp)
subu, $sp, $sp, 4
jr $ra
.LambdaListRef.add:
li $t0, 0 #.LambdaListRef.add
lw $t0, 20($fp)
sw $t0, ($sp)
subu $sp, $sp, 4
lw $t0, 16($fp)
sw $t0, ($sp)
subu $sp, $sp, 4
lw $t0, 12($fp)
la $t1, void_error
sw $t1, ($sp)
subu $sp, $sp, 4
beqz $t0, .raise
addu $sp, $sp, 4
addu $t0, $t0, 8
addu $t0, $t0, 0
lw $t0, ($t0)
sw $t0, ($sp)
subu $sp, $sp, 4
lw $t0, 4($sp)
la $t1, void_error
sw $t1, ($sp)
subu $sp, $sp, 4
beqz $t0, .raise
addu $sp, $sp, 4
lw $t1, ($t0)
lw $t2, 20($t1)
sw $ra, ($sp)
subu $sp, $sp, 4
sw $fp, ($sp)
subu $sp, $sp, 4
move $fp, $sp
jal $t2
lw $t0, 4($sp)
addu $sp, $sp, 4
move $sp, $fp
addu $sp, $sp, 4
lw $fp, ($sp)
addu $sp, $sp, 4
lw $ra, ($sp)
addu $sp, $sp, 4
sw $t0, ($sp)
subu $sp, $sp, 4
lw $t0, 12($fp)
la $t1, void_error
sw $t1, ($sp)
subu $sp, $sp, 4
beqz $t0, .raise
addu $sp, $sp, 4
addu $t0, $t0, 8
addu $t0, $t0, 4
lw $t0, ($t0)
sw $t0, ($sp)
subu $sp, $sp, 4
lw $t0, 4($sp)
la $t1, void_error
sw $t1, ($sp)
subu $sp, $sp, 4
beqz $t0, .raise
addu $sp, $sp, 4
lw $t1, ($t0)
lw $t2, 44($t1)
sw $ra, ($sp)
subu $sp, $sp, 4
sw $fp, ($sp)
subu $sp, $sp, 4
move $fp, $sp
jal $t2
lw $t0, 4($sp)
addu $sp, $sp, 4
move $sp, $fp
addu $sp, $sp, 4
lw $fp, ($sp)
addu $sp, $sp, 4
lw $ra, ($sp)
addu $sp, $sp, 16
sw $t0, ($sp)
subu $sp, $sp, 4
lw $t0, 12($fp)
la $t1, void_error
sw $t1, ($sp)
subu $sp, $sp, 4
beqz $t0, .raise
addu $sp, $sp, 4
addu $t0, $t0, 8
addu $t0, $t0, 4
lw $t1, 4($sp)
sw $t1, ($t0)
lw $t0, 12($fp)
la $t1, void_error
sw $t1, ($sp)
subu $sp, $sp, 4
beqz $t0, .raise
addu $sp, $sp, 4
addu $t0, $t0, 8
addu $t0, $t0, 0
lw $t0, ($t0)
sw $t0, ($sp)
subu $sp, $sp, 4
li $v0, 9
li $a0, 12
syscall
la $t0, Int
sw $t0, ($v0)
li $t0, 1
sw $t0, 4($v0)
li $a0, 1
sw $a0, 8($v0)
sw $v0, ($sp)
subu $sp, $sp, 4
lw $t0, 8($sp)
lw $t1, 4($sp)
lw $a0, 8($t0)
lw $a1, 8($t1)
addiu $sp, $sp, 8
add $a1, $a0, $a1
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
lw $t0, 12($fp)
la $t1, void_error
sw $t1, ($sp)
subu $sp, $sp, 4
beqz $t0, .raise
addu $sp, $sp, 4
addu $t0, $t0, 8
addu $t0, $t0, 0
lw $t1, 4($sp)
sw $t1, ($t0)
lw $t0, 12($fp)
la $t1, void_error
sw $t1, ($sp)
subu $sp, $sp, 4
beqz $t0, .raise
addu $sp, $sp, 4
addu $t0, $t0, 8
addu $t0, $t0, 0
lw $t0, ($t0)
sw $t0, ($sp)
subu $sp, $sp, 4
li $v0, 9
li $a0, 12
syscall
la $t0, Int
sw $t0, ($v0)
li $t0, 1
sw $t0, 4($v0)
li $a0, 1
sw $a0, 8($v0)
sw $v0, ($sp)
subu $sp, $sp, 4
lw $t0, 8($sp)
lw $t1, 4($sp)
lw $a0, 8($t0)
lw $a1, 8($t1)
addiu $sp, $sp, 8
sub $a1, $a0, $a1
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
lw $a0, 4($sp)
addu, $sp, $sp, 12
sw $a0, ($sp)
subu, $sp, $sp, 4
jr $ra
.LambdaListRef.removeHead:
li $t0, 0 #.LambdaListRef.removeHead
lw $t0, 12($fp)
la $t1, void_error
sw $t1, ($sp)
subu $sp, $sp, 4
beqz $t0, .raise
addu $sp, $sp, 4
addu $t0, $t0, 8
addu $t0, $t0, 4
lw $t0, ($t0)
sw $t0, ($sp)
subu $sp, $sp, 4
lw $t0, 4($sp)
la $t1, void_error
sw $t1, ($sp)
subu $sp, $sp, 4
beqz $t0, .raise
addu $sp, $sp, 4
lw $t1, ($t0)
lw $t2, 40($t1)
sw $ra, ($sp)
subu $sp, $sp, 4
sw $fp, ($sp)
subu $sp, $sp, 4
move $fp, $sp
jal $t2
lw $t0, 4($sp)
addu $sp, $sp, 4
move $sp, $fp
addu $sp, $sp, 4
lw $fp, ($sp)
addu $sp, $sp, 4
lw $ra, ($sp)
addu $sp, $sp, 4
sw $t0, ($sp)
subu $sp, $sp, 4
lw $t0, 12($fp)
la $t1, void_error
sw $t1, ($sp)
subu $sp, $sp, 4
beqz $t0, .raise
addu $sp, $sp, 4
addu $t0, $t0, 8
addu $t0, $t0, 4
lw $t1, 4($sp)
sw $t1, ($t0)
lw $a0, 12($fp)
sw $a0, 0($sp)
subu $sp, $sp, 4
lw $a0, 4($sp)
addu, $sp, $sp, 8
sw $a0, ($sp)
subu, $sp, $sp, 4
jr $ra
.LambdaListRef.LambdaListRef:
li $t0, 0 #.LambdaListRef.LambdaListRef
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
lw $t0, 12($fp)
la $t1, void_error
sw $t1, ($sp)
subu $sp, $sp, 4
beqz $t0, .raise
addu $sp, $sp, 4
addu $t0, $t0, 8
addu $t0, $t0, 0
lw $t1, 4($sp)
sw $t1, ($t0)
lw $a0, 12($fp)
sw $a0, 0($sp)
subu $sp, $sp, 4
lw $a0, 4($sp)
addu, $sp, $sp, 8
sw $a0, ($sp)
subu, $sp, $sp, 4
jr $ra
.Expr.print_self:
li $t0, 0 #.Expr.print_self
li $v0, 9
li $a0, 12
syscall
la $t0, String
sw $t0, ($v0)
li $t0, 1
sw $t0, 4($v0)
la $a0, msg2
sw $a0, 8($v0)
sw $v0, ($sp)
subu $sp, $sp, 4
lw $a0, 12($fp)
sw $a0, 0($sp)
subu $sp, $sp, 4
lw $t0, 4($sp)
la $t1, void_error
sw $t1, ($sp)
subu $sp, $sp, 4
beqz $t0, .raise
addu $sp, $sp, 4
lw $t1, ($t0)
lw $t2, 24($t1)
sw $ra, ($sp)
subu $sp, $sp, 4
sw $fp, ($sp)
subu $sp, $sp, 4
move $fp, $sp
jal $t2
lw $t0, 4($sp)
addu $sp, $sp, 4
move $sp, $fp
addu $sp, $sp, 4
lw $fp, ($sp)
addu $sp, $sp, 4
lw $ra, ($sp)
addu $sp, $sp, 8
sw $t0, ($sp)
subu $sp, $sp, 4
lw $a0, 12($fp)
sw $a0, 0($sp)
subu $sp, $sp, 4
lw $t0, 4($sp)
la $t1, void_error
sw $t1, ($sp)
subu $sp, $sp, 4
beqz $t0, .raise
addu $sp, $sp, 4
lw $t1, ($t0)
lw $t2, 12($t1)
sw $ra, ($sp)
subu $sp, $sp, 4
sw $fp, ($sp)
subu $sp, $sp, 4
move $fp, $sp
jal $t2
lw $t0, 4($sp)
addu $sp, $sp, 4
move $sp, $fp
addu $sp, $sp, 4
lw $fp, ($sp)
addu $sp, $sp, 4
lw $ra, ($sp)
addu $sp, $sp, 4
sw $t0, ($sp)
subu $sp, $sp, 4
lw $a0, 12($fp)
sw $a0, 0($sp)
subu $sp, $sp, 4
lw $a0, 4($sp)
addu, $sp, $sp, 12
sw $a0, ($sp)
subu, $sp, $sp, 4
jr $ra
.Expr.beta:
li $t0, 0 #.Expr.beta
li $v0, 9
li $a0, 12
syscall
la $t0, String
sw $t0, ($v0)
li $t0, 1
sw $t0, 4($v0)
la $a0, msg3
sw $a0, 8($v0)
sw $v0, ($sp)
subu $sp, $sp, 4
lw $a0, 12($fp)
sw $a0, 0($sp)
subu $sp, $sp, 4
lw $t0, 4($sp)
la $t1, void_error
sw $t1, ($sp)
subu $sp, $sp, 4
beqz $t0, .raise
addu $sp, $sp, 4
lw $t1, ($t0)
lw $t2, 24($t1)
sw $ra, ($sp)
subu $sp, $sp, 4
sw $fp, ($sp)
subu $sp, $sp, 4
move $fp, $sp
jal $t2
lw $t0, 4($sp)
addu $sp, $sp, 4
move $sp, $fp
addu $sp, $sp, 4
lw $fp, ($sp)
addu $sp, $sp, 4
lw $ra, ($sp)
addu $sp, $sp, 8
sw $t0, ($sp)
subu $sp, $sp, 4
lw $a0, 12($fp)
sw $a0, 0($sp)
subu $sp, $sp, 4
lw $t0, 4($sp)
la $t1, void_error
sw $t1, ($sp)
subu $sp, $sp, 4
beqz $t0, .raise
addu $sp, $sp, 4
lw $t1, ($t0)
lw $t2, 12($t1)
sw $ra, ($sp)
subu $sp, $sp, 4
sw $fp, ($sp)
subu $sp, $sp, 4
move $fp, $sp
jal $t2
lw $t0, 4($sp)
addu $sp, $sp, 4
move $sp, $fp
addu $sp, $sp, 4
lw $fp, ($sp)
addu $sp, $sp, 4
lw $ra, ($sp)
addu $sp, $sp, 4
sw $t0, ($sp)
subu $sp, $sp, 4
lw $a0, 12($fp)
sw $a0, 0($sp)
subu $sp, $sp, 4
lw $a0, 4($sp)
addu, $sp, $sp, 12
sw $a0, ($sp)
subu, $sp, $sp, 4
jr $ra
.Expr.substitute:
li $t0, 0 #.Expr.substitute
li $v0, 9
li $a0, 12
syscall
la $t0, String
sw $t0, ($v0)
li $t0, 1
sw $t0, 4($v0)
la $a0, msg4
sw $a0, 8($v0)
sw $v0, ($sp)
subu $sp, $sp, 4
lw $a0, 12($fp)
sw $a0, 0($sp)
subu $sp, $sp, 4
lw $t0, 4($sp)
la $t1, void_error
sw $t1, ($sp)
subu $sp, $sp, 4
beqz $t0, .raise
addu $sp, $sp, 4
lw $t1, ($t0)
lw $t2, 24($t1)
sw $ra, ($sp)
subu $sp, $sp, 4
sw $fp, ($sp)
subu $sp, $sp, 4
move $fp, $sp
jal $t2
lw $t0, 4($sp)
addu $sp, $sp, 4
move $sp, $fp
addu $sp, $sp, 4
lw $fp, ($sp)
addu $sp, $sp, 4
lw $ra, ($sp)
addu $sp, $sp, 8
sw $t0, ($sp)
subu $sp, $sp, 4
lw $a0, 12($fp)
sw $a0, 0($sp)
subu $sp, $sp, 4
lw $t0, 4($sp)
la $t1, void_error
sw $t1, ($sp)
subu $sp, $sp, 4
beqz $t0, .raise
addu $sp, $sp, 4
lw $t1, ($t0)
lw $t2, 12($t1)
sw $ra, ($sp)
subu $sp, $sp, 4
sw $fp, ($sp)
subu $sp, $sp, 4
move $fp, $sp
jal $t2
lw $t0, 4($sp)
addu $sp, $sp, 4
move $sp, $fp
addu $sp, $sp, 4
lw $fp, ($sp)
addu $sp, $sp, 4
lw $ra, ($sp)
addu $sp, $sp, 4
sw $t0, ($sp)
subu $sp, $sp, 4
lw $a0, 12($fp)
sw $a0, 0($sp)
subu $sp, $sp, 4
lw $a0, 4($sp)
addu, $sp, $sp, 12
sw $a0, ($sp)
subu, $sp, $sp, 4
jr $ra
.Expr.gen_code:
li $t0, 0 #.Expr.gen_code
li $v0, 9
li $a0, 12
syscall
la $t0, String
sw $t0, ($v0)
li $t0, 1
sw $t0, 4($v0)
la $a0, msg5
sw $a0, 8($v0)
sw $v0, ($sp)
subu $sp, $sp, 4
lw $a0, 12($fp)
sw $a0, 0($sp)
subu $sp, $sp, 4
lw $t0, 4($sp)
la $t1, void_error
sw $t1, ($sp)
subu $sp, $sp, 4
beqz $t0, .raise
addu $sp, $sp, 4
lw $t1, ($t0)
lw $t2, 24($t1)
sw $ra, ($sp)
subu $sp, $sp, 4
sw $fp, ($sp)
subu $sp, $sp, 4
move $fp, $sp
jal $t2
lw $t0, 4($sp)
addu $sp, $sp, 4
move $sp, $fp
addu $sp, $sp, 4
lw $fp, ($sp)
addu $sp, $sp, 4
lw $ra, ($sp)
addu $sp, $sp, 8
sw $t0, ($sp)
subu $sp, $sp, 4
lw $a0, 12($fp)
sw $a0, 0($sp)
subu $sp, $sp, 4
lw $t0, 4($sp)
la $t1, void_error
sw $t1, ($sp)
subu $sp, $sp, 4
beqz $t0, .raise
addu $sp, $sp, 4
lw $t1, ($t0)
lw $t2, 12($t1)
sw $ra, ($sp)
subu $sp, $sp, 4
sw $fp, ($sp)
subu $sp, $sp, 4
move $fp, $sp
jal $t2
lw $t0, 4($sp)
addu $sp, $sp, 4
move $sp, $fp
addu $sp, $sp, 4
lw $fp, ($sp)
addu $sp, $sp, 4
lw $ra, ($sp)
addu $sp, $sp, 4
sw $t0, ($sp)
subu $sp, $sp, 4
lw $a0, 12($fp)
sw $a0, 0($sp)
subu $sp, $sp, 4
lw $a0, 4($sp)
addu, $sp, $sp, 12
sw $a0, ($sp)
subu, $sp, $sp, 4
jr $ra
.Expr.Expr:
li $t0, 0 #.Expr.Expr
lw $a0, 12($fp)
sw $a0, 0($sp)
subu $sp, $sp, 4
lw $a0, 4($sp)
addu, $sp, $sp, 4
sw $a0, ($sp)
subu, $sp, $sp, 4
jr $ra
.Variable.init:
li $t0, 0 #.Variable.init
lw $t0, 16($fp)
sw $t0, ($sp)
subu $sp, $sp, 4
lw $t0, 12($fp)
la $t1, void_error
sw $t1, ($sp)
subu $sp, $sp, 4
beqz $t0, .raise
addu $sp, $sp, 4
addu $t0, $t0, 8
addu $t0, $t0, 0
lw $t1, 4($sp)
sw $t1, ($t0)
lw $a0, 12($fp)
sw $a0, 0($sp)
subu $sp, $sp, 4
lw $a0, 4($sp)
addu, $sp, $sp, 8
sw $a0, ($sp)
subu, $sp, $sp, 4
jr $ra
.Variable.print_self:
li $t0, 0 #.Variable.print_self
lw $t0, 12($fp)
la $t1, void_error
sw $t1, ($sp)
subu $sp, $sp, 4
beqz $t0, .raise
addu $sp, $sp, 4
addu $t0, $t0, 8
addu $t0, $t0, 0
lw $t0, ($t0)
sw $t0, ($sp)
subu $sp, $sp, 4
lw $a0, 12($fp)
sw $a0, 0($sp)
subu $sp, $sp, 4
lw $t0, 4($sp)
la $t1, void_error
sw $t1, ($sp)
subu $sp, $sp, 4
beqz $t0, .raise
addu $sp, $sp, 4
lw $t1, ($t0)
lw $t2, 24($t1)
sw $ra, ($sp)
subu $sp, $sp, 4
sw $fp, ($sp)
subu $sp, $sp, 4
move $fp, $sp
jal $t2
lw $t0, 4($sp)
addu $sp, $sp, 4
move $sp, $fp
addu $sp, $sp, 4
lw $fp, ($sp)
addu $sp, $sp, 4
lw $ra, ($sp)
addu $sp, $sp, 8
sw $t0, ($sp)
subu $sp, $sp, 4
jr $ra
.Variable.beta:
li $t0, 0 #.Variable.beta
lw $a0, 12($fp)
sw $a0, 0($sp)
subu $sp, $sp, 4
jr $ra
.Variable.substitute:
li $t0, 0 #.Variable.substitute
lw $t0, 20($fp)
sw $t0, ($sp)
subu $sp, $sp, 4
lw $a0, 12($fp)
sw $a0, 0($sp)
subu $sp, $sp, 4
lw $a0, 8($sp)
lw $a1, 4($sp)
addiu $sp, $sp, 8
seq $a1, $a0, $a1
li $v0, 9
li $a0, 12
syscall
la $t0, Bool
sw $t0, ($v0)
li $t0, 1
sw $t0, 4($v0)
sw $a1, 8($v0)
sw $v0, ($sp)
subu $sp, $sp, 4
lw $t4, 4($sp) # .if.start.1
lw $t5, 8($t4)
addu $sp, $sp, 4
beqz $t5, .if.start.1
lw $t0, 16($fp)
sw $t0, ($sp)
subu $sp, $sp, 4
j .if.end.1
.if.start.1:
lw $a0, 12($fp)
sw $a0, 0($sp)
subu $sp, $sp, 4
.if.end.1:
jr $ra
.Variable.gen_code:
li $t0, 0 #.Variable.gen_code
sw $t0, ($sp)
subu $sp, $sp, 4
lw $t0, 20($fp)
sw $t0, ($sp)
subu $sp, $sp, 4
lw $t1, 4($sp)
sw $t1, -0($fp)
addu $sp, $sp, 4
.while.start.1:
lw $t0, -0($fp)
sw $t0, ($sp)
subu $sp, $sp, 4
lw $t0, 4($sp)
la $t1, void_error
sw $t1, ($sp)
subu $sp, $sp, 4
beqz $t0, .raise
addu $sp, $sp, 4
lw $t1, ($t0)
lw $t2, 40($t1)
sw $ra, ($sp)
subu $sp, $sp, 4
sw $fp, ($sp)
subu $sp, $sp, 4
move $fp, $sp
jal $t2
lw $t0, 4($sp)
addu $sp, $sp, 4
move $sp, $fp
addu $sp, $sp, 4
lw $fp, ($sp)
addu $sp, $sp, 4
lw $ra, ($sp)
addu $sp, $sp, 4
sw $t0, ($sp)
subu $sp, $sp, 4
lw $t4, 4($sp) # .if.start.2
lw $t5, 8($t4)
addu $sp, $sp, 4
beqz $t5, .if.start.2
li $v0, 9
li $a0, 12
syscall
la $t0, Bool
sw $t0, ($v0)
li $t0, 1
sw $t0, 4($v0)
li $a0, 0
sw $a0, 8($v0)
sw $v0, ($sp)
subu $sp, $sp, 4
j .if.end.2
.if.start.2:
lw $t0, -0($fp)
sw $t0, ($sp)
subu $sp, $sp, 4
lw $t0, 4($sp)
la $t1, void_error
sw $t1, ($sp)
subu $sp, $sp, 4
beqz $t0, .raise
addu $sp, $sp, 4
lw $t1, ($t0)
lw $t2, 44($t1)
sw $ra, ($sp)
subu $sp, $sp, 4
sw $fp, ($sp)
subu $sp, $sp, 4
move $fp, $sp
jal $t2
lw $t0, 4($sp)
addu $sp, $sp, 4
move $sp, $fp
addu $sp, $sp, 4
lw $fp, ($sp)
addu $sp, $sp, 4
lw $ra, ($sp)
addu $sp, $sp, 4
sw $t0, ($sp)
subu $sp, $sp, 4
lw $a0, 12($fp)
sw $a0, 0($sp)
subu $sp, $sp, 4
lw $a0, 8($sp)
lw $a1, 4($sp)
addiu $sp, $sp, 8
seq $a1, $a0, $a1
li $v0, 9
li $a0, 12
syscall
la $t0, Bool
sw $t0, ($v0)
li $t0, 1
sw $t0, 4($v0)
sw $a1, 8($v0)
sw $v0, ($sp)
subu $sp, $sp, 4
lw $t0, 4($sp)
lw $a1, 8($t0)
beqz $a1, .put_one.1
li $a1, 0
j .is_zero.1
.put_one.1:
li $a1, 1
.is_zero.1:
li $v0, 9
li $a0, 12
syscall
la $t0, Bool
sw $t0, ($v0)
li $t0, 1
sw $t0, 4($v0)
sw $a1, 8($v0)
sw $v0, ($sp)
subu $sp, $sp, 4
.if.end.2:
lw $t0, 4($sp)
lw $a0, 8($t0)
addu $sp, $sp, 4
beqz $a0, .while.end.1
li $v0, 9
li $a0, 12
syscall
la $t0, String
sw $t0, ($v0)
li $t0, 1
sw $t0, 4($v0)
la $a0, msg6
sw $a0, 8($v0)
sw $v0, ($sp)
subu $sp, $sp, 4
lw $a0, 12($fp)
sw $a0, 0($sp)
subu $sp, $sp, 4
lw $t0, 4($sp)
la $t1, void_error
sw $t1, ($sp)
subu $sp, $sp, 4
beqz $t0, .raise
addu $sp, $sp, 4
lw $t1, ($t0)
lw $t2, 24($t1)
sw $ra, ($sp)
subu $sp, $sp, 4
sw $fp, ($sp)
subu $sp, $sp, 4
move $fp, $sp
jal $t2
lw $t0, 4($sp)
addu $sp, $sp, 4
move $sp, $fp
addu $sp, $sp, 4
lw $fp, ($sp)
addu $sp, $sp, 4
lw $ra, ($sp)
addu $sp, $sp, 8
sw $t0, ($sp)
subu $sp, $sp, 4
lw $t0, -0($fp)
sw $t0, ($sp)
subu $sp, $sp, 4
lw $t0, 4($sp)
la $t1, void_error
sw $t1, ($sp)
subu $sp, $sp, 4
beqz $t0, .raise
addu $sp, $sp, 4
lw $t1, ($t0)
lw $t2, 48($t1)
sw $ra, ($sp)
subu $sp, $sp, 4
sw $fp, ($sp)
subu $sp, $sp, 4
move $fp, $sp
jal $t2
lw $t0, 4($sp)
addu $sp, $sp, 4
move $sp, $fp
addu $sp, $sp, 4
lw $fp, ($sp)
addu $sp, $sp, 4
lw $ra, ($sp)
addu $sp, $sp, 4
sw $t0, ($sp)
subu $sp, $sp, 4
lw $t0, 4($sp)
sw $t0, -0($fp)
lw $a0, 4($sp)
addu, $sp, $sp, 8
sw $a0, ($sp)
subu, $sp, $sp, 4
j .while.start.1
.while.end.1:
li $t0, 0
sw $t0, 4($sp)
lw $t0, -0($fp)
sw $t0, ($sp)
subu $sp, $sp, 4
lw $t0, 4($sp)
la $t1, void_error
sw $t1, ($sp)
subu $sp, $sp, 4
beqz $t0, .raise
addu $sp, $sp, 4
lw $t1, ($t0)
lw $t2, 40($t1)
sw $ra, ($sp)
subu $sp, $sp, 4
sw $fp, ($sp)
subu $sp, $sp, 4
move $fp, $sp
jal $t2
lw $t0, 4($sp)
addu $sp, $sp, 4
move $sp, $fp
addu $sp, $sp, 4
lw $fp, ($sp)
addu $sp, $sp, 4
lw $ra, ($sp)
addu $sp, $sp, 4
sw $t0, ($sp)
subu $sp, $sp, 4
lw $t4, 4($sp) # .if.start.3
lw $t5, 8($t4)
addu $sp, $sp, 4
beqz $t5, .if.start.3
li $v0, 9
li $a0, 12
syscall
la $t0, String
sw $t0, ($v0)
li $t0, 1
sw $t0, 4($v0)
la $a0, msg7
sw $a0, 8($v0)
sw $v0, ($sp)
subu $sp, $sp, 4
lw $a0, 12($fp)
sw $a0, 0($sp)
subu $sp, $sp, 4
lw $t0, 4($sp)
la $t1, void_error
sw $t1, ($sp)
subu $sp, $sp, 4
beqz $t0, .raise
addu $sp, $sp, 4
lw $t1, ($t0)
lw $t2, 24($t1)
sw $ra, ($sp)
subu $sp, $sp, 4
sw $fp, ($sp)
subu $sp, $sp, 4
move $fp, $sp
jal $t2
lw $t0, 4($sp)
addu $sp, $sp, 4
move $sp, $fp
addu $sp, $sp, 4
lw $fp, ($sp)
addu $sp, $sp, 4
lw $ra, ($sp)
addu $sp, $sp, 8
sw $t0, ($sp)
subu $sp, $sp, 4
lw $a0, 12($fp)
sw $a0, 0($sp)
subu $sp, $sp, 4
lw $t0, 4($sp)
la $t1, void_error
sw $t1, ($sp)
subu $sp, $sp, 4
beqz $t0, .raise
addu $sp, $sp, 4
lw $t1, ($t0)
lw $t2, 40($t1)
sw $ra, ($sp)
subu $sp, $sp, 4
sw $fp, ($sp)
subu $sp, $sp, 4
move $fp, $sp
jal $t2
lw $t0, 4($sp)
addu $sp, $sp, 4
move $sp, $fp
addu $sp, $sp, 4
lw $fp, ($sp)
addu $sp, $sp, 4
lw $ra, ($sp)
addu $sp, $sp, 4
sw $t0, ($sp)
subu $sp, $sp, 4
li $v0, 9
li $a0, 12
syscall
la $t0, String
sw $t0, ($v0)
li $t0, 1
sw $t0, 4($v0)
la $a0, msg8
sw $a0, 8($v0)
sw $v0, ($sp)
subu $sp, $sp, 4
lw $a0, 12($fp)
sw $a0, 0($sp)
subu $sp, $sp, 4
lw $t0, 4($sp)
la $t1, void_error
sw $t1, ($sp)
subu $sp, $sp, 4
beqz $t0, .raise
addu $sp, $sp, 4
lw $t1, ($t0)
lw $t2, 24($t1)
sw $ra, ($sp)
subu $sp, $sp, 4
sw $fp, ($sp)
subu $sp, $sp, 4
move $fp, $sp
jal $t2
lw $t0, 4($sp)
addu $sp, $sp, 4
move $sp, $fp
addu $sp, $sp, 4
lw $fp, ($sp)
addu $sp, $sp, 4
lw $ra, ($sp)
addu $sp, $sp, 8
sw $t0, ($sp)
subu $sp, $sp, 4
lw $a0, 12($fp)
sw $a0, 0($sp)
subu $sp, $sp, 4
lw $t0, 4($sp)
la $t1, void_error
sw $t1, ($sp)
subu $sp, $sp, 4
beqz $t0, .raise
addu $sp, $sp, 4
lw $t1, ($t0)
lw $t2, 12($t1)
sw $ra, ($sp)
subu $sp, $sp, 4
sw $fp, ($sp)
subu $sp, $sp, 4
move $fp, $sp
jal $t2
lw $t0, 4($sp)
addu $sp, $sp, 4
move $sp, $fp
addu $sp, $sp, 4
lw $fp, ($sp)
addu $sp, $sp, 4
lw $ra, ($sp)
addu $sp, $sp, 4
sw $t0, ($sp)
subu $sp, $sp, 4
lw $a0, 12($fp)
sw $a0, 0($sp)
subu $sp, $sp, 4
lw $a0, 4($sp)
addu, $sp, $sp, 20
sw $a0, ($sp)
subu, $sp, $sp, 4
j .if.end.3
.if.start.3:
li $v0, 9
li $a0, 12
syscall
la $t0, String
sw $t0, ($v0)
li $t0, 1
sw $t0, 4($v0)
la $a0, msg9
sw $a0, 8($v0)
sw $v0, ($sp)
subu $sp, $sp, 4
lw $a0, 12($fp)
sw $a0, 0($sp)
subu $sp, $sp, 4
lw $t0, 4($sp)
la $t1, void_error
sw $t1, ($sp)
subu $sp, $sp, 4
beqz $t0, .raise
addu $sp, $sp, 4
lw $t1, ($t0)
lw $t2, 24($t1)
sw $ra, ($sp)
subu $sp, $sp, 4
sw $fp, ($sp)
subu $sp, $sp, 4
move $fp, $sp
jal $t2
lw $t0, 4($sp)
addu $sp, $sp, 4
move $sp, $fp
addu $sp, $sp, 4
lw $fp, ($sp)
addu $sp, $sp, 4
lw $ra, ($sp)
addu $sp, $sp, 8
sw $t0, ($sp)
subu $sp, $sp, 4
.if.end.3:
lw $a0, 4($sp)
addu, $sp, $sp, 8
sw $a0, ($sp)
subu, $sp, $sp, 4
jr $ra
.Variable.Variable:
li $t0, 0 #.Variable.Variable
li $v0, 9
li $a0, 12
syscall
la $t0, String
sw $t0, ($v0)
li $t0, 1
sw $t0, 4($v0)
la $a0, msg10
sw $a0, 8($v0)
sw $v0, ($sp)
subu $sp, $sp, 4
lw $t0, 12($fp)
la $t1, void_error
sw $t1, ($sp)
subu $sp, $sp, 4
beqz $t0, .raise
addu $sp, $sp, 4
addu $t0, $t0, 8
addu $t0, $t0, 0
lw $t1, 4($sp)
sw $t1, ($t0)
lw $a0, 12($fp)
sw $a0, 0($sp)
subu $sp, $sp, 4
lw $a0, 4($sp)
addu, $sp, $sp, 8
sw $a0, ($sp)
subu, $sp, $sp, 4
jr $ra
.Lambda.init:
li $t0, 0 #.Lambda.init
lw $t0, 20($fp)
sw $t0, ($sp)
subu $sp, $sp, 4
lw $t0, 12($fp)
la $t1, void_error
sw $t1, ($sp)
subu $sp, $sp, 4
beqz $t0, .raise
addu $sp, $sp, 4
addu $t0, $t0, 8
addu $t0, $t0, 0
lw $t1, 4($sp)
sw $t1, ($t0)
lw $t0, 16($fp)
sw $t0, ($sp)
subu $sp, $sp, 4
lw $t0, 12($fp)
la $t1, void_error
sw $t1, ($sp)
subu $sp, $sp, 4
beqz $t0, .raise
addu $sp, $sp, 4
addu $t0, $t0, 8
addu $t0, $t0, 4
lw $t1, 4($sp)
sw $t1, ($t0)
lw $a0, 12($fp)
sw $a0, 0($sp)
subu $sp, $sp, 4
lw $a0, 4($sp)
addu, $sp, $sp, 12
sw $a0, ($sp)
subu, $sp, $sp, 4
jr $ra
.Lambda.print_self:
li $t0, 0 #.Lambda.print_self
li $v0, 9
li $a0, 12
syscall
la $t0, String
sw $t0, ($v0)
li $t0, 1
sw $t0, 4($v0)
la $a0, msg11
sw $a0, 8($v0)
sw $v0, ($sp)
subu $sp, $sp, 4
lw $a0, 12($fp)
sw $a0, 0($sp)
subu $sp, $sp, 4
lw $t0, 4($sp)
la $t1, void_error
sw $t1, ($sp)
subu $sp, $sp, 4
beqz $t0, .raise
addu $sp, $sp, 4
lw $t1, ($t0)
lw $t2, 24($t1)
sw $ra, ($sp)
subu $sp, $sp, 4
sw $fp, ($sp)
subu $sp, $sp, 4
move $fp, $sp
jal $t2
lw $t0, 4($sp)
addu $sp, $sp, 4
move $sp, $fp
addu $sp, $sp, 4
lw $fp, ($sp)
addu $sp, $sp, 4
lw $ra, ($sp)
addu $sp, $sp, 8
sw $t0, ($sp)
subu $sp, $sp, 4
lw $t0, 12($fp)
la $t1, void_error
sw $t1, ($sp)
subu $sp, $sp, 4
beqz $t0, .raise
addu $sp, $sp, 4
addu $t0, $t0, 8
addu $t0, $t0, 0
lw $t0, ($t0)
sw $t0, ($sp)
subu $sp, $sp, 4
lw $t0, 4($sp)
la $t1, void_error
sw $t1, ($sp)
subu $sp, $sp, 4
beqz $t0, .raise
addu $sp, $sp, 4
lw $t1, ($t0)
lw $t2, 40($t1)
sw $ra, ($sp)
subu $sp, $sp, 4
sw $fp, ($sp)
subu $sp, $sp, 4
move $fp, $sp
jal $t2
lw $t0, 4($sp)
addu $sp, $sp, 4
move $sp, $fp
addu $sp, $sp, 4
lw $fp, ($sp)
addu $sp, $sp, 4
lw $ra, ($sp)
addu $sp, $sp, 4
sw $t0, ($sp)
subu $sp, $sp, 4
li $v0, 9
li $a0, 12
syscall
la $t0, String
sw $t0, ($v0)
li $t0, 1
sw $t0, 4($v0)
la $a0, msg12
sw $a0, 8($v0)
sw $v0, ($sp)
subu $sp, $sp, 4
lw $a0, 12($fp)
sw $a0, 0($sp)
subu $sp, $sp, 4
lw $t0, 4($sp)
la $t1, void_error
sw $t1, ($sp)
subu $sp, $sp, 4
beqz $t0, .raise
addu $sp, $sp, 4
lw $t1, ($t0)
lw $t2, 24($t1)
sw $ra, ($sp)
subu $sp, $sp, 4
sw $fp, ($sp)
subu $sp, $sp, 4
move $fp, $sp
jal $t2
lw $t0, 4($sp)
addu $sp, $sp, 4
move $sp, $fp
addu $sp, $sp, 4
lw $fp, ($sp)
addu $sp, $sp, 4
lw $ra, ($sp)
addu $sp, $sp, 8
sw $t0, ($sp)
subu $sp, $sp, 4
lw $t0, 12($fp)
la $t1, void_error
sw $t1, ($sp)
subu $sp, $sp, 4
beqz $t0, .raise
addu $sp, $sp, 4
addu $t0, $t0, 8
addu $t0, $t0, 4
lw $t0, ($t0)
sw $t0, ($sp)
subu $sp, $sp, 4
lw $t0, 4($sp)
la $t1, void_error
sw $t1, ($sp)
subu $sp, $sp, 4
beqz $t0, .raise
addu $sp, $sp, 4
lw $t1, ($t0)
lw $t2, 40($t1)
sw $ra, ($sp)
subu $sp, $sp, 4
sw $fp, ($sp)
subu $sp, $sp, 4
move $fp, $sp
jal $t2
lw $t0, 4($sp)
addu $sp, $sp, 4
move $sp, $fp
addu $sp, $sp, 4
lw $fp, ($sp)
addu $sp, $sp, 4
lw $ra, ($sp)
addu $sp, $sp, 4
sw $t0, ($sp)
subu $sp, $sp, 4
lw $a0, 12($fp)
sw $a0, 0($sp)
subu $sp, $sp, 4
lw $a0, 4($sp)
addu, $sp, $sp, 20
sw $a0, ($sp)
subu, $sp, $sp, 4
jr $ra
.Lambda.beta:
li $t0, 0 #.Lambda.beta
lw $a0, 12($fp)
sw $a0, 0($sp)
subu $sp, $sp, 4
jr $ra
.Lambda.apply:
li $t0, 0 #.Lambda.apply
lw $t0, 12($fp)
la $t1, void_error
sw $t1, ($sp)
subu $sp, $sp, 4
beqz $t0, .raise
addu $sp, $sp, 4
addu $t0, $t0, 8
addu $t0, $t0, 0
lw $t0, ($t0)
sw $t0, ($sp)
subu $sp, $sp, 4
lw $t0, 16($fp)
sw $t0, ($sp)
subu $sp, $sp, 4
lw $t0, 12($fp)
la $t1, void_error
sw $t1, ($sp)
subu $sp, $sp, 4
beqz $t0, .raise
addu $sp, $sp, 4
addu $t0, $t0, 8
addu $t0, $t0, 4
lw $t0, ($t0)
sw $t0, ($sp)
subu $sp, $sp, 4
lw $t0, 4($sp)
la $t1, void_error
sw $t1, ($sp)
subu $sp, $sp, 4
beqz $t0, .raise
addu $sp, $sp, 4
lw $t1, ($t0)
lw $t2, 48($t1)
sw $ra, ($sp)
subu $sp, $sp, 4
sw $fp, ($sp)
subu $sp, $sp, 4
move $fp, $sp
jal $t2
lw $t0, 4($sp)
addu $sp, $sp, 4
move $sp, $fp
addu $sp, $sp, 4
lw $fp, ($sp)
addu $sp, $sp, 4
lw $ra, ($sp)
addu $sp, $sp, 12
sw $t0, ($sp)
subu $sp, $sp, 4
jr $ra
.Lambda.substitute:
li $t0, 0 #.Lambda.substitute
sw $t0, ($sp)
subu $sp, $sp, 4
sw $t0, ($sp)
subu $sp, $sp, 4
lw $t0, 20($fp)
sw $t0, ($sp)
subu $sp, $sp, 4
lw $t0, 12($fp)
la $t1, void_error
sw $t1, ($sp)
subu $sp, $sp, 4
beqz $t0, .raise
addu $sp, $sp, 4
addu $t0, $t0, 8
addu $t0, $t0, 0
lw $t0, ($t0)
sw $t0, ($sp)
subu $sp, $sp, 4
lw $a0, 8($sp)
lw $a1, 4($sp)
addiu $sp, $sp, 8
seq $a1, $a0, $a1
li $v0, 9
li $a0, 12
syscall
la $t0, Bool
sw $t0, ($v0)
li $t0, 1
sw $t0, 4($v0)
sw $a1, 8($v0)
sw $v0, ($sp)
subu $sp, $sp, 4
lw $t4, 4($sp) # .if.start.4
lw $t5, 8($t4)
addu $sp, $sp, 4
beqz $t5, .if.start.4
lw $a0, 12($fp)
sw $a0, 0($sp)
subu $sp, $sp, 4
j .if.end.4
.if.start.4:
lw $t0, 20($fp)
sw $t0, ($sp)
subu $sp, $sp, 4
lw $t0, 16($fp)
sw $t0, ($sp)
subu $sp, $sp, 4
lw $t0, 12($fp)
la $t1, void_error
sw $t1, ($sp)
subu $sp, $sp, 4
beqz $t0, .raise
addu $sp, $sp, 4
addu $t0, $t0, 8
addu $t0, $t0, 4
lw $t0, ($t0)
sw $t0, ($sp)
subu $sp, $sp, 4
lw $t0, 4($sp)
la $t1, void_error
sw $t1, ($sp)
subu $sp, $sp, 4
beqz $t0, .raise
addu $sp, $sp, 4
lw $t1, ($t0)
lw $t2, 48($t1)
sw $ra, ($sp)
subu $sp, $sp, 4
sw $fp, ($sp)
subu $sp, $sp, 4
move $fp, $sp
jal $t2
lw $t0, 4($sp)
addu $sp, $sp, 4
move $sp, $fp
addu $sp, $sp, 4
lw $fp, ($sp)
addu $sp, $sp, 4
lw $ra, ($sp)
addu $sp, $sp, 12
sw $t0, ($sp)
subu $sp, $sp, 4
lw $t1, 4($sp)
sw $t1, -0($fp)
addu $sp, $sp, 4
li $v0, 9
li $a0, 16
syscall
sw $v0, 0($sp) # new Object
subu $sp, $sp ,4
la $t0, Lambda
sw $t0, ($v0)
li $t0, 2
sw $t0, 4($v0)
sw $ra, ($sp)
subu $sp, $sp, 4
sw $fp, ($sp)
subu $sp, $sp, 4
move $fp, $sp
jal .Lambda.Lambda
addu $sp, $sp, 4
move $sp, $fp
addu $sp, $sp, 4
lw $fp, ($sp)
addu $sp, $sp, 4
lw $ra, ($sp)
lw $t1, 4($sp)
sw $t1, -4($fp)
addu $sp, $sp, 4
lw $t0, 12($fp)
la $t1, void_error
sw $t1, ($sp)
subu $sp, $sp, 4
beqz $t0, .raise
addu $sp, $sp, 4
addu $t0, $t0, 8
addu $t0, $t0, 0
lw $t0, ($t0)
sw $t0, ($sp)
subu $sp, $sp, 4
lw $t0, -0($fp)
sw $t0, ($sp)
subu $sp, $sp, 4
lw $t0, -4($fp)
sw $t0, ($sp)
subu $sp, $sp, 4
lw $t0, 4($sp)
la $t1, void_error
sw $t1, ($sp)
subu $sp, $sp, 4
beqz $t0, .raise
addu $sp, $sp, 4
lw $t1, ($t0)
lw $t2, 56($t1)
sw $ra, ($sp)
subu $sp, $sp, 4
sw $fp, ($sp)
subu $sp, $sp, 4
move $fp, $sp
jal $t2
lw $t0, 4($sp)
addu $sp, $sp, 4
move $sp, $fp
addu $sp, $sp, 4
lw $fp, ($sp)
addu $sp, $sp, 4
lw $ra, ($sp)
addu $sp, $sp, 12
sw $t0, ($sp)
subu $sp, $sp, 4
.if.end.4:
jr $ra
.Lambda.gen_code:
li $t0, 0 #.Lambda.gen_code
li $v0, 9
li $a0, 12
syscall
la $t0, String
sw $t0, ($v0)
li $t0, 1
sw $t0, 4($v0)
la $a0, msg13
sw $a0, 8($v0)
sw $v0, ($sp)
subu $sp, $sp, 4
lw $a0, 12($fp)
sw $a0, 0($sp)
subu $sp, $sp, 4
lw $t0, 4($sp)
la $t1, void_error
sw $t1, ($sp)
subu $sp, $sp, 4
beqz $t0, .raise
addu $sp, $sp, 4
lw $t1, ($t0)
lw $t2, 24($t1)
sw $ra, ($sp)
subu $sp, $sp, 4
sw $fp, ($sp)
subu $sp, $sp, 4
move $fp, $sp
jal $t2
lw $t0, 4($sp)
addu $sp, $sp, 4
move $sp, $fp
addu $sp, $sp, 4
lw $fp, ($sp)
addu $sp, $sp, 4
lw $ra, ($sp)
addu $sp, $sp, 8
sw $t0, ($sp)
subu $sp, $sp, 4
lw $t0, 20($fp)
sw $t0, ($sp)
subu $sp, $sp, 4
lw $a0, 12($fp)
sw $a0, 0($sp)
subu $sp, $sp, 4
lw $t0, 16($fp)
sw $t0, ($sp)
subu $sp, $sp, 4
lw $t0, 4($sp)
la $t1, void_error
sw $t1, ($sp)
subu $sp, $sp, 4
beqz $t0, .raise
addu $sp, $sp, 4
lw $t1, ($t0)
lw $t2, 44($t1)
sw $ra, ($sp)
subu $sp, $sp, 4
sw $fp, ($sp)
subu $sp, $sp, 4
move $fp, $sp
jal $t2
lw $t0, 4($sp)
addu $sp, $sp, 4
move $sp, $fp
addu $sp, $sp, 4
lw $fp, ($sp)
addu $sp, $sp, 4
lw $ra, ($sp)
addu $sp, $sp, 12
sw $t0, ($sp)
subu $sp, $sp, 4
lw $t0, 4($sp)
la $t1, void_error
sw $t1, ($sp)
subu $sp, $sp, 4
beqz $t0, .raise
addu $sp, $sp, 4
lw $t1, ($t0)
lw $t2, 20($t1)
sw $ra, ($sp)
subu $sp, $sp, 4
sw $fp, ($sp)
subu $sp, $sp, 4
move $fp, $sp
jal $t2
lw $t0, 4($sp)
addu $sp, $sp, 4
move $sp, $fp
addu $sp, $sp, 4
lw $fp, ($sp)
addu $sp, $sp, 4
lw $ra, ($sp)
addu $sp, $sp, 4
sw $t0, ($sp)
subu $sp, $sp, 4
lw $a0, 12($fp)
sw $a0, 0($sp)
subu $sp, $sp, 4
lw $t0, 4($sp)
la $t1, void_error
sw $t1, ($sp)
subu $sp, $sp, 4
beqz $t0, .raise
addu $sp, $sp, 4
lw $t1, ($t0)
lw $t2, 28($t1)
sw $ra, ($sp)
subu $sp, $sp, 4
sw $fp, ($sp)
subu $sp, $sp, 4
move $fp, $sp
jal $t2
lw $t0, 4($sp)
addu $sp, $sp, 4
move $sp, $fp
addu $sp, $sp, 4
lw $fp, ($sp)
addu $sp, $sp, 4
lw $ra, ($sp)
addu $sp, $sp, 8
sw $t0, ($sp)
subu $sp, $sp, 4
li $v0, 9
li $a0, 12
syscall
la $t0, String
sw $t0, ($v0)
li $t0, 1
sw $t0, 4($v0)
la $a0, msg14
sw $a0, 8($v0)
sw $v0, ($sp)
subu $sp, $sp, 4
lw $a0, 12($fp)
sw $a0, 0($sp)
subu $sp, $sp, 4
lw $t0, 4($sp)
la $t1, void_error
sw $t1, ($sp)
subu $sp, $sp, 4
beqz $t0, .raise
addu $sp, $sp, 4
lw $t1, ($t0)
lw $t2, 24($t1)
sw $ra, ($sp)
subu $sp, $sp, 4
sw $fp, ($sp)
subu $sp, $sp, 4
move $fp, $sp
jal $t2
lw $t0, 4($sp)
addu $sp, $sp, 4
move $sp, $fp
addu $sp, $sp, 4
lw $fp, ($sp)
addu $sp, $sp, 4
lw $ra, ($sp)
addu $sp, $sp, 8
sw $t0, ($sp)
subu $sp, $sp, 4
lw $t0, 20($fp)
sw $t0, ($sp)
subu $sp, $sp, 4
lw $t0, 4($sp)
la $t1, void_error
sw $t1, ($sp)
subu $sp, $sp, 4
beqz $t0, .raise
addu $sp, $sp, 4
lw $t1, ($t0)
lw $t2, 40($t1)
sw $ra, ($sp)
subu $sp, $sp, 4
sw $fp, ($sp)
subu $sp, $sp, 4
move $fp, $sp
jal $t2
lw $t0, 4($sp)
addu $sp, $sp, 4
move $sp, $fp
addu $sp, $sp, 4
lw $fp, ($sp)
addu $sp, $sp, 4
lw $ra, ($sp)
addu $sp, $sp, 4
sw $t0, ($sp)
subu $sp, $sp, 4
lw $t4, 4($sp) # .if.start.5
lw $t5, 8($t4)
addu $sp, $sp, 4
beqz $t5, .if.start.5
li $v0, 9
li $a0, 12
syscall
la $t0, String
sw $t0, ($v0)
li $t0, 1
sw $t0, 4($v0)
la $a0, msg15
sw $a0, 8($v0)
sw $v0, ($sp)
subu $sp, $sp, 4
lw $a0, 12($fp)
sw $a0, 0($sp)
subu $sp, $sp, 4
lw $t0, 4($sp)
la $t1, void_error
sw $t1, ($sp)
subu $sp, $sp, 4
beqz $t0, .raise
addu $sp, $sp, 4
lw $t1, ($t0)
lw $t2, 24($t1)
sw $ra, ($sp)
subu $sp, $sp, 4
sw $fp, ($sp)
subu $sp, $sp, 4
move $fp, $sp
jal $t2
lw $t0, 4($sp)
addu $sp, $sp, 4
move $sp, $fp
addu $sp, $sp, 4
lw $fp, ($sp)
addu $sp, $sp, 4
lw $ra, ($sp)
addu $sp, $sp, 8
sw $t0, ($sp)
subu $sp, $sp, 4
j .if.end.5
.if.start.5:
li $v0, 9
li $a0, 12
syscall
la $t0, String
sw $t0, ($v0)
li $t0, 1
sw $t0, 4($v0)
la $a0, msg16
sw $a0, 8($v0)
sw $v0, ($sp)
subu $sp, $sp, 4
lw $a0, 12($fp)
sw $a0, 0($sp)
subu $sp, $sp, 4
lw $t0, 4($sp)
la $t1, void_error
sw $t1, ($sp)
subu $sp, $sp, 4
beqz $t0, .raise
addu $sp, $sp, 4
lw $t1, ($t0)
lw $t2, 24($t1)
sw $ra, ($sp)
subu $sp, $sp, 4
sw $fp, ($sp)
subu $sp, $sp, 4
move $fp, $sp
jal $t2
lw $t0, 4($sp)
addu $sp, $sp, 4
move $sp, $fp
addu $sp, $sp, 4
lw $fp, ($sp)
addu $sp, $sp, 4
lw $ra, ($sp)
addu $sp, $sp, 8
sw $t0, ($sp)
subu $sp, $sp, 4
.if.end.5:
lw $a0, 12($fp)
sw $a0, 0($sp)
subu $sp, $sp, 4
lw $a0, 4($sp)
addu, $sp, $sp, 20
sw $a0, ($sp)
subu, $sp, $sp, 4
jr $ra
.Lambda.gen_closure_code:
li $t0, 0 #.Lambda.gen_closure_code
li $v0, 9
li $a0, 12
syscall
la $t0, String
sw $t0, ($v0)
li $t0, 1
sw $t0, 4($v0)
la $a0, msg17
sw $a0, 8($v0)
sw $v0, ($sp)
subu $sp, $sp, 4
lw $a0, 12($fp)
sw $a0, 0($sp)
subu $sp, $sp, 4
lw $t0, 4($sp)
la $t1, void_error
sw $t1, ($sp)
subu $sp, $sp, 4
beqz $t0, .raise
addu $sp, $sp, 4
lw $t1, ($t0)
lw $t2, 24($t1)
sw $ra, ($sp)
subu $sp, $sp, 4
sw $fp, ($sp)
subu $sp, $sp, 4
move $fp, $sp
jal $t2
lw $t0, 4($sp)
addu $sp, $sp, 4
move $sp, $fp
addu $sp, $sp, 4
lw $fp, ($sp)
addu $sp, $sp, 4
lw $ra, ($sp)
addu $sp, $sp, 8
sw $t0, ($sp)
subu $sp, $sp, 4
lw $t0, 24($fp)
sw $t0, ($sp)
subu $sp, $sp, 4
lw $t0, 4($sp)
la $t1, void_error
sw $t1, ($sp)
subu $sp, $sp, 4
beqz $t0, .raise
addu $sp, $sp, 4
lw $t1, ($t0)
lw $t2, 20($t1)
sw $ra, ($sp)
subu $sp, $sp, 4
sw $fp, ($sp)
subu $sp, $sp, 4
move $fp, $sp
jal $t2
lw $t0, 4($sp)
addu $sp, $sp, 4
move $sp, $fp
addu $sp, $sp, 4
lw $fp, ($sp)
addu $sp, $sp, 4
lw $ra, ($sp)
addu $sp, $sp, 4
sw $t0, ($sp)
subu $sp, $sp, 4
lw $a0, 12($fp)
sw $a0, 0($sp)
subu $sp, $sp, 4
lw $t0, 4($sp)
la $t1, void_error
sw $t1, ($sp)
subu $sp, $sp, 4
beqz $t0, .raise
addu $sp, $sp, 4
lw $t1, ($t0)
lw $t2, 28($t1)
sw $ra, ($sp)
subu $sp, $sp, 4
sw $fp, ($sp)
subu $sp, $sp, 4
move $fp, $sp
jal $t2
lw $t0, 4($sp)
addu $sp, $sp, 4
move $sp, $fp
addu $sp, $sp, 4
lw $fp, ($sp)
addu $sp, $sp, 4
lw $ra, ($sp)
addu $sp, $sp, 8
sw $t0, ($sp)
subu $sp, $sp, 4
li $v0, 9
li $a0, 12
syscall
la $t0, String
sw $t0, ($v0)
li $t0, 1
sw $t0, 4($v0)
la $a0, msg18
sw $a0, 8($v0)
sw $v0, ($sp)
subu $sp, $sp, 4
lw $a0, 12($fp)
sw $a0, 0($sp)
subu $sp, $sp, 4
lw $t0, 4($sp)
la $t1, void_error
sw $t1, ($sp)
subu $sp, $sp, 4
beqz $t0, .raise
addu $sp, $sp, 4
lw $t1, ($t0)
lw $t2, 24($t1)
sw $ra, ($sp)
subu $sp, $sp, 4
sw $fp, ($sp)
subu $sp, $sp, 4
move $fp, $sp
jal $t2
lw $t0, 4($sp)
addu $sp, $sp, 4
move $sp, $fp
addu $sp, $sp, 4
lw $fp, ($sp)
addu $sp, $sp, 4
lw $ra, ($sp)
addu $sp, $sp, 8
sw $t0, ($sp)
subu $sp, $sp, 4
li $v0, 9
li $a0, 12
syscall
la $t0, String
sw $t0, ($v0)
li $t0, 1
sw $t0, 4($v0)
la $a0, msg19
sw $a0, 8($v0)
sw $v0, ($sp)
subu $sp, $sp, 4
lw $a0, 12($fp)
sw $a0, 0($sp)
subu $sp, $sp, 4
lw $t0, 4($sp)
la $t1, void_error
sw $t1, ($sp)
subu $sp, $sp, 4
beqz $t0, .raise
addu $sp, $sp, 4
lw $t1, ($t0)
lw $t2, 24($t1)
sw $ra, ($sp)
subu $sp, $sp, 4
sw $fp, ($sp)
subu $sp, $sp, 4
move $fp, $sp
jal $t2
lw $t0, 4($sp)
addu $sp, $sp, 4
move $sp, $fp
addu $sp, $sp, 4
lw $fp, ($sp)
addu $sp, $sp, 4
lw $ra, ($sp)
addu $sp, $sp, 8
sw $t0, ($sp)
subu $sp, $sp, 4
li $v0, 9
li $a0, 12
syscall
la $t0, String
sw $t0, ($v0)
li $t0, 1
sw $t0, 4($v0)
la $a0, msg20
sw $a0, 8($v0)
sw $v0, ($sp)
subu $sp, $sp, 4
lw $a0, 12($fp)
sw $a0, 0($sp)
subu $sp, $sp, 4
lw $t0, 4($sp)
la $t1, void_error
sw $t1, ($sp)
subu $sp, $sp, 4
beqz $t0, .raise
addu $sp, $sp, 4
lw $t1, ($t0)
lw $t2, 24($t1)
sw $ra, ($sp)
subu $sp, $sp, 4
sw $fp, ($sp)
subu $sp, $sp, 4
move $fp, $sp
jal $t2
lw $t0, 4($sp)
addu $sp, $sp, 4
move $sp, $fp
addu $sp, $sp, 4
lw $fp, ($sp)
addu $sp, $sp, 4
lw $ra, ($sp)
addu $sp, $sp, 8
sw $t0, ($sp)
subu $sp, $sp, 4
lw $t0, 24($fp)
sw $t0, ($sp)
subu $sp, $sp, 4
lw $t0, 4($sp)
la $t1, void_error
sw $t1, ($sp)
subu $sp, $sp, 4
beqz $t0, .raise
addu $sp, $sp, 4
lw $t1, ($t0)
lw $t2, 20($t1)
sw $ra, ($sp)
subu $sp, $sp, 4
sw $fp, ($sp)
subu $sp, $sp, 4
move $fp, $sp
jal $t2
lw $t0, 4($sp)
addu $sp, $sp, 4
move $sp, $fp
addu $sp, $sp, 4
lw $fp, ($sp)
addu $sp, $sp, 4
lw $ra, ($sp)
addu $sp, $sp, 4
sw $t0, ($sp)
subu $sp, $sp, 4
lw $a0, 12($fp)
sw $a0, 0($sp)
subu $sp, $sp, 4
lw $t0, 4($sp)
la $t1, void_error
sw $t1, ($sp)
subu $sp, $sp, 4
beqz $t0, .raise
addu $sp, $sp, 4
lw $t1, ($t0)
lw $t2, 28($t1)
sw $ra, ($sp)
subu $sp, $sp, 4
sw $fp, ($sp)
subu $sp, $sp, 4
move $fp, $sp
jal $t2
lw $t0, 4($sp)
addu $sp, $sp, 4
move $sp, $fp
addu $sp, $sp, 4
lw $fp, ($sp)
addu $sp, $sp, 4
lw $ra, ($sp)
addu $sp, $sp, 8
sw $t0, ($sp)
subu $sp, $sp, 4
li $v0, 9
li $a0, 12
syscall
la $t0, String
sw $t0, ($v0)
li $t0, 1
sw $t0, 4($v0)
la $a0, msg21
sw $a0, 8($v0)
sw $v0, ($sp)
subu $sp, $sp, 4
lw $a0, 12($fp)
sw $a0, 0($sp)
subu $sp, $sp, 4
lw $t0, 4($sp)
la $t1, void_error
sw $t1, ($sp)
subu $sp, $sp, 4
beqz $t0, .raise
addu $sp, $sp, 4
lw $t1, ($t0)
lw $t2, 24($t1)
sw $ra, ($sp)
subu $sp, $sp, 4
sw $fp, ($sp)
subu $sp, $sp, 4
move $fp, $sp
jal $t2
lw $t0, 4($sp)
addu $sp, $sp, 4
move $sp, $fp
addu $sp, $sp, 4
lw $fp, ($sp)
addu $sp, $sp, 4
lw $ra, ($sp)
addu $sp, $sp, 8
sw $t0, ($sp)
subu $sp, $sp, 4
li $v0, 9
li $a0, 12
syscall
la $t0, String
sw $t0, ($v0)
li $t0, 1
sw $t0, 4($v0)
la $a0, msg22
sw $a0, 8($v0)
sw $v0, ($sp)
subu $sp, $sp, 4
lw $a0, 12($fp)
sw $a0, 0($sp)
subu $sp, $sp, 4
lw $t0, 4($sp)
la $t1, void_error
sw $t1, ($sp)
subu $sp, $sp, 4
beqz $t0, .raise
addu $sp, $sp, 4
lw $t1, ($t0)
lw $t2, 24($t1)
sw $ra, ($sp)
subu $sp, $sp, 4
sw $fp, ($sp)
subu $sp, $sp, 4
move $fp, $sp
jal $t2
lw $t0, 4($sp)
addu $sp, $sp, 4
move $sp, $fp
addu $sp, $sp, 4
lw $fp, ($sp)
addu $sp, $sp, 4
lw $ra, ($sp)
addu $sp, $sp, 8
sw $t0, ($sp)
subu $sp, $sp, 4
lw $t0, 12($fp)
la $t1, void_error
sw $t1, ($sp)
subu $sp, $sp, 4
beqz $t0, .raise
addu $sp, $sp, 4
addu $t0, $t0, 8
addu $t0, $t0, 0
lw $t0, ($t0)
sw $t0, ($sp)
subu $sp, $sp, 4
lw $t0, 20($fp)
sw $t0, ($sp)
subu $sp, $sp, 4
lw $t0, 4($sp)
la $t1, void_error
sw $t1, ($sp)
subu $sp, $sp, 4
beqz $t0, .raise
addu $sp, $sp, 4
lw $t1, ($t0)
lw $t2, 52($t1)
sw $ra, ($sp)
subu $sp, $sp, 4
sw $fp, ($sp)
subu $sp, $sp, 4
move $fp, $sp
jal $t2
lw $t0, 4($sp)
addu $sp, $sp, 4
move $sp, $fp
addu $sp, $sp, 4
lw $fp, ($sp)
addu $sp, $sp, 4
lw $ra, ($sp)
addu $sp, $sp, 8
sw $t0, ($sp)
subu $sp, $sp, 4
lw $t0, 16($fp)
sw $t0, ($sp)
subu $sp, $sp, 4
lw $t0, 12($fp)
la $t1, void_error
sw $t1, ($sp)
subu $sp, $sp, 4
beqz $t0, .raise
addu $sp, $sp, 4
addu $t0, $t0, 8
addu $t0, $t0, 4
lw $t0, ($t0)
sw $t0, ($sp)
subu $sp, $sp, 4
lw $t0, 4($sp)
la $t1, void_error
sw $t1, ($sp)
subu $sp, $sp, 4
beqz $t0, .raise
addu $sp, $sp, 4
lw $t1, ($t0)
lw $t2, 52($t1)
sw $ra, ($sp)
subu $sp, $sp, 4
sw $fp, ($sp)
subu $sp, $sp, 4
move $fp, $sp
jal $t2
lw $t0, 4($sp)
addu $sp, $sp, 4
move $sp, $fp
addu $sp, $sp, 4
lw $fp, ($sp)
addu $sp, $sp, 4
lw $ra, ($sp)
addu $sp, $sp, 12
sw $t0, ($sp)
subu $sp, $sp, 4
li $v0, 9
li $a0, 12
syscall
la $t0, String
sw $t0, ($v0)
li $t0, 1
sw $t0, 4($v0)
la $a0, msg23
sw $a0, 8($v0)
sw $v0, ($sp)
subu $sp, $sp, 4
lw $a0, 12($fp)
sw $a0, 0($sp)
subu $sp, $sp, 4
lw $t0, 4($sp)
la $t1, void_error
sw $t1, ($sp)
subu $sp, $sp, 4
beqz $t0, .raise
addu $sp, $sp, 4
lw $t1, ($t0)
lw $t2, 24($t1)
sw $ra, ($sp)
subu $sp, $sp, 4
sw $fp, ($sp)
subu $sp, $sp, 4
move $fp, $sp
jal $t2
lw $t0, 4($sp)
addu $sp, $sp, 4
move $sp, $fp
addu $sp, $sp, 4
lw $fp, ($sp)
addu $sp, $sp, 4
lw $ra, ($sp)
addu $sp, $sp, 8
sw $t0, ($sp)
subu $sp, $sp, 4
li $v0, 9
li $a0, 12
syscall
la $t0, String
sw $t0, ($v0)
li $t0, 1
sw $t0, 4($v0)
la $a0, msg24
sw $a0, 8($v0)
sw $v0, ($sp)
subu $sp, $sp, 4
lw $a0, 12($fp)
sw $a0, 0($sp)
subu $sp, $sp, 4
lw $t0, 4($sp)
la $t1, void_error
sw $t1, ($sp)
subu $sp, $sp, 4
beqz $t0, .raise
addu $sp, $sp, 4
lw $t1, ($t0)
lw $t2, 24($t1)
sw $ra, ($sp)
subu $sp, $sp, 4
sw $fp, ($sp)
subu $sp, $sp, 4
move $fp, $sp
jal $t2
lw $t0, 4($sp)
addu $sp, $sp, 4
move $sp, $fp
addu $sp, $sp, 4
lw $fp, ($sp)
addu $sp, $sp, 4
lw $ra, ($sp)
addu $sp, $sp, 8
sw $t0, ($sp)
subu $sp, $sp, 4
lw $a0, 4($sp)
addu, $sp, $sp, 44
sw $a0, ($sp)
subu, $sp, $sp, 4
jr $ra
.Lambda.Lambda:
li $t0, 0 #.Lambda.Lambda
lw $a0, 12($fp)
sw $a0, 0($sp)
subu $sp, $sp, 4
lw $a0, 4($sp)
addu, $sp, $sp, 4
sw $a0, ($sp)
subu, $sp, $sp, 4
jr $ra
.App.init:
li $t0, 0 #.App.init
lw $t0, 20($fp)
sw $t0, ($sp)
subu $sp, $sp, 4
lw $t0, 12($fp)
la $t1, void_error
sw $t1, ($sp)
subu $sp, $sp, 4
beqz $t0, .raise
addu $sp, $sp, 4
addu $t0, $t0, 8
addu $t0, $t0, 0
lw $t1, 4($sp)
sw $t1, ($t0)
lw $t0, 16($fp)
sw $t0, ($sp)
subu $sp, $sp, 4
lw $t0, 12($fp)
la $t1, void_error
sw $t1, ($sp)
subu $sp, $sp, 4
beqz $t0, .raise
addu $sp, $sp, 4
addu $t0, $t0, 8
addu $t0, $t0, 4
lw $t1, 4($sp)
sw $t1, ($t0)
lw $a0, 12($fp)
sw $a0, 0($sp)
subu $sp, $sp, 4
lw $a0, 4($sp)
addu, $sp, $sp, 12
sw $a0, ($sp)
subu, $sp, $sp, 4
jr $ra
.App.print_self:
li $t0, 0 #.App.print_self
li $v0, 9
li $a0, 12
syscall
la $t0, String
sw $t0, ($v0)
li $t0, 1
sw $t0, 4($v0)
la $a0, msg25
sw $a0, 8($v0)
sw $v0, ($sp)
subu $sp, $sp, 4
lw $a0, 12($fp)
sw $a0, 0($sp)
subu $sp, $sp, 4
lw $t0, 4($sp)
la $t1, void_error
sw $t1, ($sp)
subu $sp, $sp, 4
beqz $t0, .raise
addu $sp, $sp, 4
lw $t1, ($t0)
lw $t2, 24($t1)
sw $ra, ($sp)
subu $sp, $sp, 4
sw $fp, ($sp)
subu $sp, $sp, 4
move $fp, $sp
jal $t2
lw $t0, 4($sp)
addu $sp, $sp, 4
move $sp, $fp
addu $sp, $sp, 4
lw $fp, ($sp)
addu $sp, $sp, 4
lw $ra, ($sp)
addu $sp, $sp, 8
sw $t0, ($sp)
subu $sp, $sp, 4
lw $t0, 12($fp)
la $t1, void_error
sw $t1, ($sp)
subu $sp, $sp, 4
beqz $t0, .raise
addu $sp, $sp, 4
addu $t0, $t0, 8
addu $t0, $t0, 0
lw $t0, ($t0)
sw $t0, ($sp)
subu $sp, $sp, 4
lw $t0, 4($sp)
la $t1, void_error
sw $t1, ($sp)
subu $sp, $sp, 4
beqz $t0, .raise
addu $sp, $sp, 4
lw $t1, ($t0)
lw $t2, 40($t1)
sw $ra, ($sp)
subu $sp, $sp, 4
sw $fp, ($sp)
subu $sp, $sp, 4
move $fp, $sp
jal $t2
lw $t0, 4($sp)
addu $sp, $sp, 4
move $sp, $fp
addu $sp, $sp, 4
lw $fp, ($sp)
addu $sp, $sp, 4
lw $ra, ($sp)
addu $sp, $sp, 4
sw $t0, ($sp)
subu $sp, $sp, 4
li $v0, 9
li $a0, 12
syscall
la $t0, String
sw $t0, ($v0)
li $t0, 1
sw $t0, 4($v0)
la $a0, msg26
sw $a0, 8($v0)
sw $v0, ($sp)
subu $sp, $sp, 4
lw $a0, 12($fp)
sw $a0, 0($sp)
subu $sp, $sp, 4
lw $t0, 4($sp)
la $t1, void_error
sw $t1, ($sp)
subu $sp, $sp, 4
beqz $t0, .raise
addu $sp, $sp, 4
lw $t1, ($t0)
lw $t2, 24($t1)
sw $ra, ($sp)
subu $sp, $sp, 4
sw $fp, ($sp)
subu $sp, $sp, 4
move $fp, $sp
jal $t2
lw $t0, 4($sp)
addu $sp, $sp, 4
move $sp, $fp
addu $sp, $sp, 4
lw $fp, ($sp)
addu $sp, $sp, 4
lw $ra, ($sp)
addu $sp, $sp, 8
sw $t0, ($sp)
subu $sp, $sp, 4
lw $t0, 12($fp)
la $t1, void_error
sw $t1, ($sp)
subu $sp, $sp, 4
beqz $t0, .raise
addu $sp, $sp, 4
addu $t0, $t0, 8
addu $t0, $t0, 4
lw $t0, ($t0)
sw $t0, ($sp)
subu $sp, $sp, 4
lw $t0, 4($sp)
la $t1, void_error
sw $t1, ($sp)
subu $sp, $sp, 4
beqz $t0, .raise
addu $sp, $sp, 4
lw $t1, ($t0)
lw $t2, 40($t1)
sw $ra, ($sp)
subu $sp, $sp, 4
sw $fp, ($sp)
subu $sp, $sp, 4
move $fp, $sp
jal $t2
lw $t0, 4($sp)
addu $sp, $sp, 4
move $sp, $fp
addu $sp, $sp, 4
lw $fp, ($sp)
addu $sp, $sp, 4
lw $ra, ($sp)
addu $sp, $sp, 4
sw $t0, ($sp)
subu $sp, $sp, 4
li $v0, 9
li $a0, 12
syscall
la $t0, String
sw $t0, ($v0)
li $t0, 1
sw $t0, 4($v0)
la $a0, msg27
sw $a0, 8($v0)
sw $v0, ($sp)
subu $sp, $sp, 4
lw $a0, 12($fp)
sw $a0, 0($sp)
subu $sp, $sp, 4
lw $t0, 4($sp)
la $t1, void_error
sw $t1, ($sp)
subu $sp, $sp, 4
beqz $t0, .raise
addu $sp, $sp, 4
lw $t1, ($t0)
lw $t2, 24($t1)
sw $ra, ($sp)
subu $sp, $sp, 4
sw $fp, ($sp)
subu $sp, $sp, 4
move $fp, $sp
jal $t2
lw $t0, 4($sp)
addu $sp, $sp, 4
move $sp, $fp
addu $sp, $sp, 4
lw $fp, ($sp)
addu $sp, $sp, 4
lw $ra, ($sp)
addu $sp, $sp, 8
sw $t0, ($sp)
subu $sp, $sp, 4
lw $a0, 12($fp)
sw $a0, 0($sp)
subu $sp, $sp, 4
lw $a0, 4($sp)
addu, $sp, $sp, 24
sw $a0, ($sp)
subu, $sp, $sp, 4
jr $ra
.App.beta:
li $t0, 0 #.App.beta
sw $t0, ($sp)
subu $sp, $sp, 4
sw $t0, ($sp)
subu $sp, $sp, 4
sw $t0, ($sp)
subu $sp, $sp, 4
sw $t0, ($sp)
subu $sp, $sp, 4
move $t0, $t0 # Case
lw $t0, 12($fp)
la $t1, void_error
sw $t1, ($sp)
subu $sp, $sp, 4
beqz $t0, .raise
addu $sp, $sp, 4
addu $t0, $t0, 8
addu $t0, $t0, 0
lw $t0, ($t0)
sw $t0, ($sp)
subu $sp, $sp, 4
la $t0, void_error
sw $t0, ($sp)
lw $t0, 4($sp)
subu $sp, $sp, 4
beqz $t0, .raise
addu $sp, $sp, 4
la $a0, Lambda #action Lambda
lw $t0, 4($sp)
sw $ra, ($sp)
subu $sp, $sp, 4
sw $t0, ($sp)
subu $sp, $sp, 4
sw $a0, ($sp)
subu $sp, $sp, 4
jal .inerithed
lw $a0, 4($sp)
addu $sp, $sp, 4
li $t0, 0
lw $t0, 4($sp)
addu $sp, $sp, 4
lw $t0, 4($sp)
addu $sp, $sp, 4
lw $ra, 4($sp)
addu $sp, $sp, 4
beqz $a0, action.1
sw $t0, -0($fp)
lw $t0, 12($fp)
la $t1, void_error
sw $t1, ($sp)
subu $sp, $sp, 4
beqz $t0, .raise
addu $sp, $sp, 4
addu $t0, $t0, 8
addu $t0, $t0, 4
lw $t0, ($t0)
sw $t0, ($sp)
subu $sp, $sp, 4
lw $t0, -0($fp)
sw $t0, ($sp)
subu $sp, $sp, 4
lw $t0, 4($sp)
la $t1, void_error
sw $t1, ($sp)
subu $sp, $sp, 4
beqz $t0, .raise
addu $sp, $sp, 4
lw $t1, ($t0)
lw $t2, 60($t1)
sw $ra, ($sp)
subu $sp, $sp, 4
sw $fp, ($sp)
subu $sp, $sp, 4
move $fp, $sp
jal $t2
lw $t0, 4($sp)
addu $sp, $sp, 4
move $sp, $fp
addu $sp, $sp, 4
lw $fp, ($sp)
addu $sp, $sp, 4
lw $ra, ($sp)
addu $sp, $sp, 8
sw $t0, ($sp)
subu $sp, $sp, 4
j case.end.1
action.1:
la $a0, Expr #action Expr
lw $t0, 4($sp)
sw $ra, ($sp)
subu $sp, $sp, 4
sw $t0, ($sp)
subu $sp, $sp, 4
sw $a0, ($sp)
subu $sp, $sp, 4
jal .inerithed
lw $a0, 4($sp)
addu $sp, $sp, 4
li $t0, 0
lw $t0, 4($sp)
addu $sp, $sp, 4
lw $t0, 4($sp)
addu $sp, $sp, 4
lw $ra, 4($sp)
addu $sp, $sp, 4
beqz $a0, action.2
sw $t0, -4($fp)
lw $t0, 12($fp)
la $t1, void_error
sw $t1, ($sp)
subu $sp, $sp, 4
beqz $t0, .raise
addu $sp, $sp, 4
addu $t0, $t0, 8
addu $t0, $t0, 0
lw $t0, ($t0)
sw $t0, ($sp)
subu $sp, $sp, 4
lw $t0, 4($sp)
la $t1, void_error
sw $t1, ($sp)
subu $sp, $sp, 4
beqz $t0, .raise
addu $sp, $sp, 4
lw $t1, ($t0)
lw $t2, 44($t1)
sw $ra, ($sp)
subu $sp, $sp, 4
sw $fp, ($sp)
subu $sp, $sp, 4
move $fp, $sp
jal $t2
lw $t0, 4($sp)
addu $sp, $sp, 4
move $sp, $fp
addu $sp, $sp, 4
lw $fp, ($sp)
addu $sp, $sp, 4
lw $ra, ($sp)
addu $sp, $sp, 4
sw $t0, ($sp)
subu $sp, $sp, 4
lw $t1, 4($sp)
sw $t1, -8($fp)
addu $sp, $sp, 4
li $v0, 9
li $a0, 16
syscall
sw $v0, 0($sp) # new Object
subu $sp, $sp ,4
la $t0, App
sw $t0, ($v0)
li $t0, 2
sw $t0, 4($v0)
sw $ra, ($sp)
subu $sp, $sp, 4
sw $fp, ($sp)
subu $sp, $sp, 4
move $fp, $sp
jal .App.App
addu $sp, $sp, 4
move $sp, $fp
addu $sp, $sp, 4
lw $fp, ($sp)
addu $sp, $sp, 4
lw $ra, ($sp)
lw $t1, 4($sp)
sw $t1, -12($fp)
addu $sp, $sp, 4
lw $t0, -8($fp)
sw $t0, ($sp)
subu $sp, $sp, 4
lw $t0, 12($fp)
la $t1, void_error
sw $t1, ($sp)
subu $sp, $sp, 4
beqz $t0, .raise
addu $sp, $sp, 4
addu $t0, $t0, 8
addu $t0, $t0, 4
lw $t0, ($t0)
sw $t0, ($sp)
subu $sp, $sp, 4
lw $t0, -12($fp)
sw $t0, ($sp)
subu $sp, $sp, 4
lw $t0, 4($sp)
la $t1, void_error
sw $t1, ($sp)
subu $sp, $sp, 4
beqz $t0, .raise
addu $sp, $sp, 4
lw $t1, ($t0)
lw $t2, 56($t1)
sw $ra, ($sp)
subu $sp, $sp, 4
sw $fp, ($sp)
subu $sp, $sp, 4
move $fp, $sp
jal $t2
lw $t0, 4($sp)
addu $sp, $sp, 4
move $sp, $fp
addu $sp, $sp, 4
lw $fp, ($sp)
addu $sp, $sp, 4
lw $ra, ($sp)
addu $sp, $sp, 12
sw $t0, ($sp)
subu $sp, $sp, 4
j case.end.1
action.2:
la $t0, case_error
sw $t0, ($sp)
subu $sp, $sp, 4
j .raise
case.end.1:
jr $ra
.App.substitute:
li $t0, 0 #.App.substitute
sw $t0, ($sp)
subu $sp, $sp, 4
sw $t0, ($sp)
subu $sp, $sp, 4
sw $t0, ($sp)
subu $sp, $sp, 4
lw $t0, 20($fp)
sw $t0, ($sp)
subu $sp, $sp, 4
lw $t0, 16($fp)
sw $t0, ($sp)
subu $sp, $sp, 4
lw $t0, 12($fp)
la $t1, void_error
sw $t1, ($sp)
subu $sp, $sp, 4
beqz $t0, .raise
addu $sp, $sp, 4
addu $t0, $t0, 8
addu $t0, $t0, 0
lw $t0, ($t0)
sw $t0, ($sp)
subu $sp, $sp, 4
lw $t0, 4($sp)
la $t1, void_error
sw $t1, ($sp)
subu $sp, $sp, 4
beqz $t0, .raise
addu $sp, $sp, 4
lw $t1, ($t0)
lw $t2, 48($t1)
sw $ra, ($sp)
subu $sp, $sp, 4
sw $fp, ($sp)
subu $sp, $sp, 4
move $fp, $sp
jal $t2
lw $t0, 4($sp)
addu $sp, $sp, 4
move $sp, $fp
addu $sp, $sp, 4
lw $fp, ($sp)
addu $sp, $sp, 4
lw $ra, ($sp)
addu $sp, $sp, 12
sw $t0, ($sp)
subu $sp, $sp, 4
lw $t1, 4($sp)
sw $t1, -0($fp)
addu $sp, $sp, 4
lw $t0, 20($fp)
sw $t0, ($sp)
subu $sp, $sp, 4
lw $t0, 16($fp)
sw $t0, ($sp)
subu $sp, $sp, 4
lw $t0, 12($fp)
la $t1, void_error
sw $t1, ($sp)
subu $sp, $sp, 4
beqz $t0, .raise
addu $sp, $sp, 4
addu $t0, $t0, 8
addu $t0, $t0, 4
lw $t0, ($t0)
sw $t0, ($sp)
subu $sp, $sp, 4
lw $t0, 4($sp)
la $t1, void_error
sw $t1, ($sp)
subu $sp, $sp, 4
beqz $t0, .raise
addu $sp, $sp, 4
lw $t1, ($t0)
lw $t2, 48($t1)
sw $ra, ($sp)
subu $sp, $sp, 4
sw $fp, ($sp)
subu $sp, $sp, 4
move $fp, $sp
jal $t2
lw $t0, 4($sp)
addu $sp, $sp, 4
move $sp, $fp
addu $sp, $sp, 4
lw $fp, ($sp)
addu $sp, $sp, 4
lw $ra, ($sp)
addu $sp, $sp, 12
sw $t0, ($sp)
subu $sp, $sp, 4
lw $t1, 4($sp)
sw $t1, -4($fp)
addu $sp, $sp, 4
li $v0, 9
li $a0, 16
syscall
sw $v0, 0($sp) # new Object
subu $sp, $sp ,4
la $t0, App
sw $t0, ($v0)
li $t0, 2
sw $t0, 4($v0)
sw $ra, ($sp)
subu $sp, $sp, 4
sw $fp, ($sp)
subu $sp, $sp, 4
move $fp, $sp
jal .App.App
addu $sp, $sp, 4
move $sp, $fp
addu $sp, $sp, 4
lw $fp, ($sp)
addu $sp, $sp, 4
lw $ra, ($sp)
lw $t1, 4($sp)
sw $t1, -8($fp)
addu $sp, $sp, 4
lw $t0, -0($fp)
sw $t0, ($sp)
subu $sp, $sp, 4
lw $t0, -4($fp)
sw $t0, ($sp)
subu $sp, $sp, 4
lw $t0, -8($fp)
sw $t0, ($sp)
subu $sp, $sp, 4
lw $t0, 4($sp)
la $t1, void_error
sw $t1, ($sp)
subu $sp, $sp, 4
beqz $t0, .raise
addu $sp, $sp, 4
lw $t1, ($t0)
lw $t2, 56($t1)
sw $ra, ($sp)
subu $sp, $sp, 4
sw $fp, ($sp)
subu $sp, $sp, 4
move $fp, $sp
jal $t2
lw $t0, 4($sp)
addu $sp, $sp, 4
move $sp, $fp
addu $sp, $sp, 4
lw $fp, ($sp)
addu $sp, $sp, 4
lw $ra, ($sp)
addu $sp, $sp, 12
sw $t0, ($sp)
subu $sp, $sp, 4
jr $ra
.App.gen_code:
li $t0, 0 #.App.gen_code
li $v0, 9
li $a0, 12
syscall
la $t0, String
sw $t0, ($v0)
li $t0, 1
sw $t0, 4($v0)
la $a0, msg28
sw $a0, 8($v0)
sw $v0, ($sp)
subu $sp, $sp, 4
lw $a0, 12($fp)
sw $a0, 0($sp)
subu $sp, $sp, 4
lw $t0, 4($sp)
la $t1, void_error
sw $t1, ($sp)
subu $sp, $sp, 4
beqz $t0, .raise
addu $sp, $sp, 4
lw $t1, ($t0)
lw $t2, 24($t1)
sw $ra, ($sp)
subu $sp, $sp, 4
sw $fp, ($sp)
subu $sp, $sp, 4
move $fp, $sp
jal $t2
lw $t0, 4($sp)
addu $sp, $sp, 4
move $sp, $fp
addu $sp, $sp, 4
lw $fp, ($sp)
addu $sp, $sp, 4
lw $ra, ($sp)
addu $sp, $sp, 8
sw $t0, ($sp)
subu $sp, $sp, 4
lw $t0, 20($fp)
sw $t0, ($sp)
subu $sp, $sp, 4
lw $t0, 16($fp)
sw $t0, ($sp)
subu $sp, $sp, 4
lw $t0, 12($fp)
la $t1, void_error
sw $t1, ($sp)
subu $sp, $sp, 4
beqz $t0, .raise
addu $sp, $sp, 4
addu $t0, $t0, 8
addu $t0, $t0, 0
lw $t0, ($t0)
sw $t0, ($sp)
subu $sp, $sp, 4
lw $t0, 4($sp)
la $t1, void_error
sw $t1, ($sp)
subu $sp, $sp, 4
beqz $t0, .raise
addu $sp, $sp, 4
lw $t1, ($t0)
lw $t2, 52($t1)
sw $ra, ($sp)
subu $sp, $sp, 4
sw $fp, ($sp)
subu $sp, $sp, 4
move $fp, $sp
jal $t2
lw $t0, 4($sp)
addu $sp, $sp, 4
move $sp, $fp
addu $sp, $sp, 4
lw $fp, ($sp)
addu $sp, $sp, 4
lw $ra, ($sp)
addu $sp, $sp, 12
sw $t0, ($sp)
subu $sp, $sp, 4
li $v0, 9
li $a0, 12
syscall
la $t0, String
sw $t0, ($v0)
li $t0, 1
sw $t0, 4($v0)
la $a0, msg29
sw $a0, 8($v0)
sw $v0, ($sp)
subu $sp, $sp, 4
lw $a0, 12($fp)
sw $a0, 0($sp)
subu $sp, $sp, 4
lw $t0, 4($sp)
la $t1, void_error
sw $t1, ($sp)
subu $sp, $sp, 4
beqz $t0, .raise
addu $sp, $sp, 4
lw $t1, ($t0)
lw $t2, 24($t1)
sw $ra, ($sp)
subu $sp, $sp, 4
sw $fp, ($sp)
subu $sp, $sp, 4
move $fp, $sp
jal $t2
lw $t0, 4($sp)
addu $sp, $sp, 4
move $sp, $fp
addu $sp, $sp, 4
lw $fp, ($sp)
addu $sp, $sp, 4
lw $ra, ($sp)
addu $sp, $sp, 8
sw $t0, ($sp)
subu $sp, $sp, 4
li $v0, 9
li $a0, 12
syscall
la $t0, String
sw $t0, ($v0)
li $t0, 1
sw $t0, 4($v0)
la $a0, msg30
sw $a0, 8($v0)
sw $v0, ($sp)
subu $sp, $sp, 4
lw $a0, 12($fp)
sw $a0, 0($sp)
subu $sp, $sp, 4
lw $t0, 4($sp)
la $t1, void_error
sw $t1, ($sp)
subu $sp, $sp, 4
beqz $t0, .raise
addu $sp, $sp, 4
lw $t1, ($t0)
lw $t2, 24($t1)
sw $ra, ($sp)
subu $sp, $sp, 4
sw $fp, ($sp)
subu $sp, $sp, 4
move $fp, $sp
jal $t2
lw $t0, 4($sp)
addu $sp, $sp, 4
move $sp, $fp
addu $sp, $sp, 4
lw $fp, ($sp)
addu $sp, $sp, 4
lw $ra, ($sp)
addu $sp, $sp, 8
sw $t0, ($sp)
subu $sp, $sp, 4
lw $t0, 20($fp)
sw $t0, ($sp)
subu $sp, $sp, 4
lw $t0, 16($fp)
sw $t0, ($sp)
subu $sp, $sp, 4
lw $t0, 12($fp)
la $t1, void_error
sw $t1, ($sp)
subu $sp, $sp, 4
beqz $t0, .raise
addu $sp, $sp, 4
addu $t0, $t0, 8
addu $t0, $t0, 4
lw $t0, ($t0)
sw $t0, ($sp)
subu $sp, $sp, 4
lw $t0, 4($sp)
la $t1, void_error
sw $t1, ($sp)
subu $sp, $sp, 4
beqz $t0, .raise
addu $sp, $sp, 4
lw $t1, ($t0)
lw $t2, 52($t1)
sw $ra, ($sp)
subu $sp, $sp, 4
sw $fp, ($sp)
subu $sp, $sp, 4
move $fp, $sp
jal $t2
lw $t0, 4($sp)
addu $sp, $sp, 4
move $sp, $fp
addu $sp, $sp, 4
lw $fp, ($sp)
addu $sp, $sp, 4
lw $ra, ($sp)
addu $sp, $sp, 12
sw $t0, ($sp)
subu $sp, $sp, 4
li $v0, 9
li $a0, 12
syscall
la $t0, String
sw $t0, ($v0)
li $t0, 1
sw $t0, 4($v0)
la $a0, msg31
sw $a0, 8($v0)
sw $v0, ($sp)
subu $sp, $sp, 4
lw $a0, 12($fp)
sw $a0, 0($sp)
subu $sp, $sp, 4
lw $t0, 4($sp)
la $t1, void_error
sw $t1, ($sp)
subu $sp, $sp, 4
beqz $t0, .raise
addu $sp, $sp, 4
lw $t1, ($t0)
lw $t2, 24($t1)
sw $ra, ($sp)
subu $sp, $sp, 4
sw $fp, ($sp)
subu $sp, $sp, 4
move $fp, $sp
jal $t2
lw $t0, 4($sp)
addu $sp, $sp, 4
move $sp, $fp
addu $sp, $sp, 4
lw $fp, ($sp)
addu $sp, $sp, 4
lw $ra, ($sp)
addu $sp, $sp, 8
sw $t0, ($sp)
subu $sp, $sp, 4
li $v0, 9
li $a0, 12
syscall
la $t0, String
sw $t0, ($v0)
li $t0, 1
sw $t0, 4($v0)
la $a0, msg32
sw $a0, 8($v0)
sw $v0, ($sp)
subu $sp, $sp, 4
lw $a0, 12($fp)
sw $a0, 0($sp)
subu $sp, $sp, 4
lw $t0, 4($sp)
la $t1, void_error
sw $t1, ($sp)
subu $sp, $sp, 4
beqz $t0, .raise
addu $sp, $sp, 4
lw $t1, ($t0)
lw $t2, 24($t1)
sw $ra, ($sp)
subu $sp, $sp, 4
sw $fp, ($sp)
subu $sp, $sp, 4
move $fp, $sp
jal $t2
lw $t0, 4($sp)
addu $sp, $sp, 4
move $sp, $fp
addu $sp, $sp, 4
lw $fp, ($sp)
addu $sp, $sp, 4
lw $ra, ($sp)
addu $sp, $sp, 8
sw $t0, ($sp)
subu $sp, $sp, 4
li $v0, 9
li $a0, 12
syscall
la $t0, String
sw $t0, ($v0)
li $t0, 1
sw $t0, 4($v0)
la $a0, msg33
sw $a0, 8($v0)
sw $v0, ($sp)
subu $sp, $sp, 4
lw $a0, 12($fp)
sw $a0, 0($sp)
subu $sp, $sp, 4
lw $t0, 4($sp)
la $t1, void_error
sw $t1, ($sp)
subu $sp, $sp, 4
beqz $t0, .raise
addu $sp, $sp, 4
lw $t1, ($t0)
lw $t2, 24($t1)
sw $ra, ($sp)
subu $sp, $sp, 4
sw $fp, ($sp)
subu $sp, $sp, 4
move $fp, $sp
jal $t2
lw $t0, 4($sp)
addu $sp, $sp, 4
move $sp, $fp
addu $sp, $sp, 4
lw $fp, ($sp)
addu $sp, $sp, 4
lw $ra, ($sp)
addu $sp, $sp, 8
sw $t0, ($sp)
subu $sp, $sp, 4
li $v0, 9
li $a0, 12
syscall
la $t0, String
sw $t0, ($v0)
li $t0, 1
sw $t0, 4($v0)
la $a0, msg34
sw $a0, 8($v0)
sw $v0, ($sp)
subu $sp, $sp, 4
lw $a0, 12($fp)
sw $a0, 0($sp)
subu $sp, $sp, 4
lw $t0, 4($sp)
la $t1, void_error
sw $t1, ($sp)
subu $sp, $sp, 4
beqz $t0, .raise
addu $sp, $sp, 4
lw $t1, ($t0)
lw $t2, 24($t1)
sw $ra, ($sp)
subu $sp, $sp, 4
sw $fp, ($sp)
subu $sp, $sp, 4
move $fp, $sp
jal $t2
lw $t0, 4($sp)
addu $sp, $sp, 4
move $sp, $fp
addu $sp, $sp, 4
lw $fp, ($sp)
addu $sp, $sp, 4
lw $ra, ($sp)
addu $sp, $sp, 8
sw $t0, ($sp)
subu $sp, $sp, 4
li $v0, 9
li $a0, 12
syscall
la $t0, String
sw $t0, ($v0)
li $t0, 1
sw $t0, 4($v0)
la $a0, msg35
sw $a0, 8($v0)
sw $v0, ($sp)
subu $sp, $sp, 4
lw $a0, 12($fp)
sw $a0, 0($sp)
subu $sp, $sp, 4
lw $t0, 4($sp)
la $t1, void_error
sw $t1, ($sp)
subu $sp, $sp, 4
beqz $t0, .raise
addu $sp, $sp, 4
lw $t1, ($t0)
lw $t2, 24($t1)
sw $ra, ($sp)
subu $sp, $sp, 4
sw $fp, ($sp)
subu $sp, $sp, 4
move $fp, $sp
jal $t2
lw $t0, 4($sp)
addu $sp, $sp, 4
move $sp, $fp
addu $sp, $sp, 4
lw $fp, ($sp)
addu $sp, $sp, 4
lw $ra, ($sp)
addu $sp, $sp, 8
sw $t0, ($sp)
subu $sp, $sp, 4
lw $a0, 4($sp)
addu, $sp, $sp, 40
sw $a0, ($sp)
subu, $sp, $sp, 4
jr $ra
.App.App:
li $t0, 0 #.App.App
lw $a0, 12($fp)
sw $a0, 0($sp)
subu $sp, $sp, 4
lw $a0, 4($sp)
addu, $sp, $sp, 4
sw $a0, ($sp)
subu, $sp, $sp, 4
jr $ra
.Term.var:
li $t0, 0 #.Term.var
sw $t0, ($sp)
subu $sp, $sp, 4
li $v0, 9
li $a0, 12
syscall
sw $v0, 0($sp) # new Object
subu $sp, $sp ,4
la $t0, Variable
sw $t0, ($v0)
li $t0, 1
sw $t0, 4($v0)
sw $ra, ($sp)
subu $sp, $sp, 4
sw $fp, ($sp)
subu $sp, $sp, 4
move $fp, $sp
jal .Variable.Variable
addu $sp, $sp, 4
move $sp, $fp
addu $sp, $sp, 4
lw $fp, ($sp)
addu $sp, $sp, 4
lw $ra, ($sp)
lw $t1, 4($sp)
sw $t1, -0($fp)
addu $sp, $sp, 4
lw $t0, 16($fp)
sw $t0, ($sp)
subu $sp, $sp, 4
lw $t0, -0($fp)
sw $t0, ($sp)
subu $sp, $sp, 4
lw $t0, 4($sp)
la $t1, void_error
sw $t1, ($sp)
subu $sp, $sp, 4
beqz $t0, .raise
addu $sp, $sp, 4
lw $t1, ($t0)
lw $t2, 56($t1)
sw $ra, ($sp)
subu $sp, $sp, 4
sw $fp, ($sp)
subu $sp, $sp, 4
move $fp, $sp
jal $t2
lw $t0, 4($sp)
addu $sp, $sp, 4
move $sp, $fp
addu $sp, $sp, 4
lw $fp, ($sp)
addu $sp, $sp, 4
lw $ra, ($sp)
addu $sp, $sp, 8
sw $t0, ($sp)
subu $sp, $sp, 4
jr $ra
.Term.lam:
li $t0, 0 #.Term.lam
sw $t0, ($sp)
subu $sp, $sp, 4
li $v0, 9
li $a0, 16
syscall
sw $v0, 0($sp) # new Object
subu $sp, $sp ,4
la $t0, Lambda
sw $t0, ($v0)
li $t0, 2
sw $t0, 4($v0)
sw $ra, ($sp)
subu $sp, $sp, 4
sw $fp, ($sp)
subu $sp, $sp, 4
move $fp, $sp
jal .Lambda.Lambda
addu $sp, $sp, 4
move $sp, $fp
addu $sp, $sp, 4
lw $fp, ($sp)
addu $sp, $sp, 4
lw $ra, ($sp)
lw $t1, 4($sp)
sw $t1, -0($fp)
addu $sp, $sp, 4
lw $t0, 20($fp)
sw $t0, ($sp)
subu $sp, $sp, 4
lw $t0, 16($fp)
sw $t0, ($sp)
subu $sp, $sp, 4
lw $t0, -0($fp)
sw $t0, ($sp)
subu $sp, $sp, 4
lw $t0, 4($sp)
la $t1, void_error
sw $t1, ($sp)
subu $sp, $sp, 4
beqz $t0, .raise
addu $sp, $sp, 4
lw $t1, ($t0)
lw $t2, 56($t1)
sw $ra, ($sp)
subu $sp, $sp, 4
sw $fp, ($sp)
subu $sp, $sp, 4
move $fp, $sp
jal $t2
lw $t0, 4($sp)
addu $sp, $sp, 4
move $sp, $fp
addu $sp, $sp, 4
lw $fp, ($sp)
addu $sp, $sp, 4
lw $ra, ($sp)
addu $sp, $sp, 12
sw $t0, ($sp)
subu $sp, $sp, 4
jr $ra
.Term.app:
li $t0, 0 #.Term.app
sw $t0, ($sp)
subu $sp, $sp, 4
li $v0, 9
li $a0, 16
syscall
sw $v0, 0($sp) # new Object
subu $sp, $sp ,4
la $t0, App
sw $t0, ($v0)
li $t0, 2
sw $t0, 4($v0)
sw $ra, ($sp)
subu $sp, $sp, 4
sw $fp, ($sp)
subu $sp, $sp, 4
move $fp, $sp
jal .App.App
addu $sp, $sp, 4
move $sp, $fp
addu $sp, $sp, 4
lw $fp, ($sp)
addu $sp, $sp, 4
lw $ra, ($sp)
lw $t1, 4($sp)
sw $t1, -0($fp)
addu $sp, $sp, 4
lw $t0, 20($fp)
sw $t0, ($sp)
subu $sp, $sp, 4
lw $t0, 16($fp)
sw $t0, ($sp)
subu $sp, $sp, 4
lw $t0, -0($fp)
sw $t0, ($sp)
subu $sp, $sp, 4
lw $t0, 4($sp)
la $t1, void_error
sw $t1, ($sp)
subu $sp, $sp, 4
beqz $t0, .raise
addu $sp, $sp, 4
lw $t1, ($t0)
lw $t2, 56($t1)
sw $ra, ($sp)
subu $sp, $sp, 4
sw $fp, ($sp)
subu $sp, $sp, 4
move $fp, $sp
jal $t2
lw $t0, 4($sp)
addu $sp, $sp, 4
move $sp, $fp
addu $sp, $sp, 4
lw $fp, ($sp)
addu $sp, $sp, 4
lw $ra, ($sp)
addu $sp, $sp, 12
sw $t0, ($sp)
subu $sp, $sp, 4
jr $ra
.Term.i:
li $t0, 0 #.Term.i
sw $t0, ($sp)
subu $sp, $sp, 4
li $v0, 9
li $a0, 12
syscall
la $t0, String
sw $t0, ($v0)
li $t0, 1
sw $t0, 4($v0)
la $a0, msg36
sw $a0, 8($v0)
sw $v0, ($sp)
subu $sp, $sp, 4
lw $a0, 12($fp)
sw $a0, 0($sp)
subu $sp, $sp, 4
lw $t0, 4($sp)
la $t1, void_error
sw $t1, ($sp)
subu $sp, $sp, 4
beqz $t0, .raise
addu $sp, $sp, 4
lw $t1, ($t0)
lw $t2, 40($t1)
sw $ra, ($sp)
subu $sp, $sp, 4
sw $fp, ($sp)
subu $sp, $sp, 4
move $fp, $sp
jal $t2
lw $t0, 4($sp)
addu $sp, $sp, 4
move $sp, $fp
addu $sp, $sp, 4
lw $fp, ($sp)
addu $sp, $sp, 4
lw $ra, ($sp)
addu $sp, $sp, 8
sw $t0, ($sp)
subu $sp, $sp, 4
lw $t1, 4($sp)
sw $t1, -0($fp)
addu $sp, $sp, 4
lw $t0, -0($fp)
sw $t0, ($sp)
subu $sp, $sp, 4
lw $t0, -0($fp)
sw $t0, ($sp)
subu $sp, $sp, 4
lw $a0, 12($fp)
sw $a0, 0($sp)
subu $sp, $sp, 4
lw $t0, 4($sp)
la $t1, void_error
sw $t1, ($sp)
subu $sp, $sp, 4
beqz $t0, .raise
addu $sp, $sp, 4
lw $t1, ($t0)
lw $t2, 44($t1)
sw $ra, ($sp)
subu $sp, $sp, 4
sw $fp, ($sp)
subu $sp, $sp, 4
move $fp, $sp
jal $t2
lw $t0, 4($sp)
addu $sp, $sp, 4
move $sp, $fp
addu $sp, $sp, 4
lw $fp, ($sp)
addu $sp, $sp, 4
lw $ra, ($sp)
addu $sp, $sp, 12
sw $t0, ($sp)
subu $sp, $sp, 4
jr $ra
.Term.k:
li $t0, 0 #.Term.k
sw $t0, ($sp)
subu $sp, $sp, 4
sw $t0, ($sp)
subu $sp, $sp, 4
li $v0, 9
li $a0, 12
syscall
la $t0, String
sw $t0, ($v0)
li $t0, 1
sw $t0, 4($v0)
la $a0, msg37
sw $a0, 8($v0)
sw $v0, ($sp)
subu $sp, $sp, 4
lw $a0, 12($fp)
sw $a0, 0($sp)
subu $sp, $sp, 4
lw $t0, 4($sp)
la $t1, void_error
sw $t1, ($sp)
subu $sp, $sp, 4
beqz $t0, .raise
addu $sp, $sp, 4
lw $t1, ($t0)
lw $t2, 40($t1)
sw $ra, ($sp)
subu $sp, $sp, 4
sw $fp, ($sp)
subu $sp, $sp, 4
move $fp, $sp
jal $t2
lw $t0, 4($sp)
addu $sp, $sp, 4
move $sp, $fp
addu $sp, $sp, 4
lw $fp, ($sp)
addu $sp, $sp, 4
lw $ra, ($sp)
addu $sp, $sp, 8
sw $t0, ($sp)
subu $sp, $sp, 4
lw $t1, 4($sp)
sw $t1, -0($fp)
addu $sp, $sp, 4
li $v0, 9
li $a0, 12
syscall
la $t0, String
sw $t0, ($v0)
li $t0, 1
sw $t0, 4($v0)
la $a0, msg38
sw $a0, 8($v0)
sw $v0, ($sp)
subu $sp, $sp, 4
lw $a0, 12($fp)
sw $a0, 0($sp)
subu $sp, $sp, 4
lw $t0, 4($sp)
la $t1, void_error
sw $t1, ($sp)
subu $sp, $sp, 4
beqz $t0, .raise
addu $sp, $sp, 4
lw $t1, ($t0)
lw $t2, 40($t1)
sw $ra, ($sp)
subu $sp, $sp, 4
sw $fp, ($sp)
subu $sp, $sp, 4
move $fp, $sp
jal $t2
lw $t0, 4($sp)
addu $sp, $sp, 4
move $sp, $fp
addu $sp, $sp, 4
lw $fp, ($sp)
addu $sp, $sp, 4
lw $ra, ($sp)
addu $sp, $sp, 8
sw $t0, ($sp)
subu $sp, $sp, 4
lw $t1, 4($sp)
sw $t1, -4($fp)
addu $sp, $sp, 4
lw $t0, -0($fp)
sw $t0, ($sp)
subu $sp, $sp, 4
lw $t0, -4($fp)
sw $t0, ($sp)
subu $sp, $sp, 4
lw $t0, -0($fp)
sw $t0, ($sp)
subu $sp, $sp, 4
lw $a0, 12($fp)
sw $a0, 0($sp)
subu $sp, $sp, 4
lw $t0, 4($sp)
la $t1, void_error
sw $t1, ($sp)
subu $sp, $sp, 4
beqz $t0, .raise
addu $sp, $sp, 4
lw $t1, ($t0)
lw $t2, 44($t1)
sw $ra, ($sp)
subu $sp, $sp, 4
sw $fp, ($sp)
subu $sp, $sp, 4
move $fp, $sp
jal $t2
lw $t0, 4($sp)
addu $sp, $sp, 4
move $sp, $fp
addu $sp, $sp, 4
lw $fp, ($sp)
addu $sp, $sp, 4
lw $ra, ($sp)
addu $sp, $sp, 12
sw $t0, ($sp)
subu $sp, $sp, 4
lw $a0, 12($fp)
sw $a0, 0($sp)
subu $sp, $sp, 4
lw $t0, 4($sp)
la $t1, void_error
sw $t1, ($sp)
subu $sp, $sp, 4
beqz $t0, .raise
addu $sp, $sp, 4
lw $t1, ($t0)
lw $t2, 44($t1)
sw $ra, ($sp)
subu $sp, $sp, 4
sw $fp, ($sp)
subu $sp, $sp, 4
move $fp, $sp
jal $t2
lw $t0, 4($sp)
addu $sp, $sp, 4
move $sp, $fp
addu $sp, $sp, 4
lw $fp, ($sp)
addu $sp, $sp, 4
lw $ra, ($sp)
addu $sp, $sp, 12
sw $t0, ($sp)
subu $sp, $sp, 4
jr $ra
.Term.s:
li $t0, 0 #.Term.s
sw $t0, ($sp)
subu $sp, $sp, 4
sw $t0, ($sp)
subu $sp, $sp, 4
sw $t0, ($sp)
subu $sp, $sp, 4
li $v0, 9
li $a0, 12
syscall
la $t0, String
sw $t0, ($v0)
li $t0, 1
sw $t0, 4($v0)
la $a0, msg39
sw $a0, 8($v0)
sw $v0, ($sp)
subu $sp, $sp, 4
lw $a0, 12($fp)
sw $a0, 0($sp)
subu $sp, $sp, 4
lw $t0, 4($sp)
la $t1, void_error
sw $t1, ($sp)
subu $sp, $sp, 4
beqz $t0, .raise
addu $sp, $sp, 4
lw $t1, ($t0)
lw $t2, 40($t1)
sw $ra, ($sp)
subu $sp, $sp, 4
sw $fp, ($sp)
subu $sp, $sp, 4
move $fp, $sp
jal $t2
lw $t0, 4($sp)
addu $sp, $sp, 4
move $sp, $fp
addu $sp, $sp, 4
lw $fp, ($sp)
addu $sp, $sp, 4
lw $ra, ($sp)
addu $sp, $sp, 8
sw $t0, ($sp)
subu $sp, $sp, 4
lw $t1, 4($sp)
sw $t1, -0($fp)
addu $sp, $sp, 4
li $v0, 9
li $a0, 12
syscall
la $t0, String
sw $t0, ($v0)
li $t0, 1
sw $t0, 4($v0)
la $a0, msg40
sw $a0, 8($v0)
sw $v0, ($sp)
subu $sp, $sp, 4
lw $a0, 12($fp)
sw $a0, 0($sp)
subu $sp, $sp, 4
lw $t0, 4($sp)
la $t1, void_error
sw $t1, ($sp)
subu $sp, $sp, 4
beqz $t0, .raise
addu $sp, $sp, 4
lw $t1, ($t0)
lw $t2, 40($t1)
sw $ra, ($sp)
subu $sp, $sp, 4
sw $fp, ($sp)
subu $sp, $sp, 4
move $fp, $sp
jal $t2
lw $t0, 4($sp)
addu $sp, $sp, 4
move $sp, $fp
addu $sp, $sp, 4
lw $fp, ($sp)
addu $sp, $sp, 4
lw $ra, ($sp)
addu $sp, $sp, 8
sw $t0, ($sp)
subu $sp, $sp, 4
lw $t1, 4($sp)
sw $t1, -4($fp)
addu $sp, $sp, 4
li $v0, 9
li $a0, 12
syscall
la $t0, String
sw $t0, ($v0)
li $t0, 1
sw $t0, 4($v0)
la $a0, msg41
sw $a0, 8($v0)
sw $v0, ($sp)
subu $sp, $sp, 4
lw $a0, 12($fp)
sw $a0, 0($sp)
subu $sp, $sp, 4
lw $t0, 4($sp)
la $t1, void_error
sw $t1, ($sp)
subu $sp, $sp, 4
beqz $t0, .raise
addu $sp, $sp, 4
lw $t1, ($t0)
lw $t2, 40($t1)
sw $ra, ($sp)
subu $sp, $sp, 4
sw $fp, ($sp)
subu $sp, $sp, 4
move $fp, $sp
jal $t2
lw $t0, 4($sp)
addu $sp, $sp, 4
move $sp, $fp
addu $sp, $sp, 4
lw $fp, ($sp)
addu $sp, $sp, 4
lw $ra, ($sp)
addu $sp, $sp, 8
sw $t0, ($sp)
subu $sp, $sp, 4
lw $t1, 4($sp)
sw $t1, -8($fp)
addu $sp, $sp, 4
lw $t0, -0($fp)
sw $t0, ($sp)
subu $sp, $sp, 4
lw $t0, -4($fp)
sw $t0, ($sp)
subu $sp, $sp, 4
lw $t0, -8($fp)
sw $t0, ($sp)
subu $sp, $sp, 4
lw $t0, -0($fp)
sw $t0, ($sp)
subu $sp, $sp, 4
lw $t0, -8($fp)
sw $t0, ($sp)
subu $sp, $sp, 4
lw $a0, 12($fp)
sw $a0, 0($sp)
subu $sp, $sp, 4
lw $t0, 4($sp)
la $t1, void_error
sw $t1, ($sp)
subu $sp, $sp, 4
beqz $t0, .raise
addu $sp, $sp, 4
lw $t1, ($t0)
lw $t2, 48($t1)
sw $ra, ($sp)
subu $sp, $sp, 4
sw $fp, ($sp)
subu $sp, $sp, 4
move $fp, $sp
jal $t2
lw $t0, 4($sp)
addu $sp, $sp, 4
move $sp, $fp
addu $sp, $sp, 4
lw $fp, ($sp)
addu $sp, $sp, 4
lw $ra, ($sp)
addu $sp, $sp, 12
sw $t0, ($sp)
subu $sp, $sp, 4
lw $t0, -4($fp)
sw $t0, ($sp)
subu $sp, $sp, 4
lw $t0, -8($fp)
sw $t0, ($sp)
subu $sp, $sp, 4
lw $a0, 12($fp)
sw $a0, 0($sp)
subu $sp, $sp, 4
lw $t0, 4($sp)
la $t1, void_error
sw $t1, ($sp)
subu $sp, $sp, 4
beqz $t0, .raise
addu $sp, $sp, 4
lw $t1, ($t0)
lw $t2, 48($t1)
sw $ra, ($sp)
subu $sp, $sp, 4
sw $fp, ($sp)
subu $sp, $sp, 4
move $fp, $sp
jal $t2
lw $t0, 4($sp)
addu $sp, $sp, 4
move $sp, $fp
addu $sp, $sp, 4
lw $fp, ($sp)
addu $sp, $sp, 4
lw $ra, ($sp)
addu $sp, $sp, 12
sw $t0, ($sp)
subu $sp, $sp, 4
lw $a0, 12($fp)
sw $a0, 0($sp)
subu $sp, $sp, 4
lw $t0, 4($sp)
la $t1, void_error
sw $t1, ($sp)
subu $sp, $sp, 4
beqz $t0, .raise
addu $sp, $sp, 4
lw $t1, ($t0)
lw $t2, 48($t1)
sw $ra, ($sp)
subu $sp, $sp, 4
sw $fp, ($sp)
subu $sp, $sp, 4
move $fp, $sp
jal $t2
lw $t0, 4($sp)
addu $sp, $sp, 4
move $sp, $fp
addu $sp, $sp, 4
lw $fp, ($sp)
addu $sp, $sp, 4
lw $ra, ($sp)
addu $sp, $sp, 12
sw $t0, ($sp)
subu $sp, $sp, 4
lw $a0, 12($fp)
sw $a0, 0($sp)
subu $sp, $sp, 4
lw $t0, 4($sp)
la $t1, void_error
sw $t1, ($sp)
subu $sp, $sp, 4
beqz $t0, .raise
addu $sp, $sp, 4
lw $t1, ($t0)
lw $t2, 44($t1)
sw $ra, ($sp)
subu $sp, $sp, 4
sw $fp, ($sp)
subu $sp, $sp, 4
move $fp, $sp
jal $t2
lw $t0, 4($sp)
addu $sp, $sp, 4
move $sp, $fp
addu $sp, $sp, 4
lw $fp, ($sp)
addu $sp, $sp, 4
lw $ra, ($sp)
addu $sp, $sp, 12
sw $t0, ($sp)
subu $sp, $sp, 4
lw $a0, 12($fp)
sw $a0, 0($sp)
subu $sp, $sp, 4
lw $t0, 4($sp)
la $t1, void_error
sw $t1, ($sp)
subu $sp, $sp, 4
beqz $t0, .raise
addu $sp, $sp, 4
lw $t1, ($t0)
lw $t2, 44($t1)
sw $ra, ($sp)
subu $sp, $sp, 4
sw $fp, ($sp)
subu $sp, $sp, 4
move $fp, $sp
jal $t2
lw $t0, 4($sp)
addu $sp, $sp, 4
move $sp, $fp
addu $sp, $sp, 4
lw $fp, ($sp)
addu $sp, $sp, 4
lw $ra, ($sp)
addu $sp, $sp, 12
sw $t0, ($sp)
subu $sp, $sp, 4
lw $a0, 12($fp)
sw $a0, 0($sp)
subu $sp, $sp, 4
lw $t0, 4($sp)
la $t1, void_error
sw $t1, ($sp)
subu $sp, $sp, 4
beqz $t0, .raise
addu $sp, $sp, 4
lw $t1, ($t0)
lw $t2, 44($t1)
sw $ra, ($sp)
subu $sp, $sp, 4
sw $fp, ($sp)
subu $sp, $sp, 4
move $fp, $sp
jal $t2
lw $t0, 4($sp)
addu $sp, $sp, 4
move $sp, $fp
addu $sp, $sp, 4
lw $fp, ($sp)
addu $sp, $sp, 4
lw $ra, ($sp)
addu $sp, $sp, 12
sw $t0, ($sp)
subu $sp, $sp, 4
jr $ra
.Term.Term:
li $t0, 0 #.Term.Term
lw $a0, 12($fp)
sw $a0, 0($sp)
subu $sp, $sp, 4
lw $a0, 4($sp)
addu, $sp, $sp, 4
sw $a0, ($sp)
subu, $sp, $sp, 4
jr $ra
.Main.beta_reduce:
li $t0, 0 #.Main.beta_reduce
sw $t0, ($sp)
subu $sp, $sp, 4
sw $t0, ($sp)
subu $sp, $sp, 4
li $v0, 9
li $a0, 12
syscall
la $t0, String
sw $t0, ($v0)
li $t0, 1
sw $t0, 4($v0)
la $a0, msg42
sw $a0, 8($v0)
sw $v0, ($sp)
subu $sp, $sp, 4
lw $a0, 12($fp)
sw $a0, 0($sp)
subu $sp, $sp, 4
lw $t0, 4($sp)
la $t1, void_error
sw $t1, ($sp)
subu $sp, $sp, 4
beqz $t0, .raise
addu $sp, $sp, 4
lw $t1, ($t0)
lw $t2, 24($t1)
sw $ra, ($sp)
subu $sp, $sp, 4
sw $fp, ($sp)
subu $sp, $sp, 4
move $fp, $sp
jal $t2
lw $t0, 4($sp)
addu $sp, $sp, 4
move $sp, $fp
addu $sp, $sp, 4
lw $fp, ($sp)
addu $sp, $sp, 4
lw $ra, ($sp)
addu $sp, $sp, 8
sw $t0, ($sp)
subu $sp, $sp, 4
lw $t0, 16($fp)
sw $t0, ($sp)
subu $sp, $sp, 4
lw $t0, 4($sp)
la $t1, void_error
sw $t1, ($sp)
subu $sp, $sp, 4
beqz $t0, .raise
addu $sp, $sp, 4
lw $t1, ($t0)
lw $t2, 40($t1)
sw $ra, ($sp)
subu $sp, $sp, 4
sw $fp, ($sp)
subu $sp, $sp, 4
move $fp, $sp
jal $t2
lw $t0, 4($sp)
addu $sp, $sp, 4
move $sp, $fp
addu $sp, $sp, 4
lw $fp, ($sp)
addu $sp, $sp, 4
lw $ra, ($sp)
addu $sp, $sp, 4
sw $t0, ($sp)
subu $sp, $sp, 4
li $v0, 9
li $a0, 12
syscall
la $t0, Bool
sw $t0, ($v0)
li $t0, 1
sw $t0, 4($v0)
li $a0, 0
sw $a0, 8($v0)
sw $v0, ($sp)
subu $sp, $sp, 4
lw $t1, 4($sp)
sw $t1, -0($fp)
addu $sp, $sp, 4
li $t1, 0
sw $t1, -4($fp)
.while.start.2:
lw $t0, -0($fp)
sw $t0, ($sp)
subu $sp, $sp, 4
lw $t0, 4($sp)
lw $a1, 8($t0)
beqz $a1, .put_one.2
li $a1, 0
j .is_zero.2
.put_one.2:
li $a1, 1
.is_zero.2:
li $v0, 9
li $a0, 12
syscall
la $t0, Bool
sw $t0, ($v0)
li $t0, 1
sw $t0, 4($v0)
sw $a1, 8($v0)
sw $v0, ($sp)
subu $sp, $sp, 4
lw $t0, 4($sp)
lw $a0, 8($t0)
addu $sp, $sp, 4
beqz $a0, .while.end.2
lw $t0, 16($fp)
sw $t0, ($sp)
subu $sp, $sp, 4
lw $t0, 4($sp)
la $t1, void_error
sw $t1, ($sp)
subu $sp, $sp, 4
beqz $t0, .raise
addu $sp, $sp, 4
lw $t1, ($t0)
lw $t2, 44($t1)
sw $ra, ($sp)
subu $sp, $sp, 4
sw $fp, ($sp)
subu $sp, $sp, 4
move $fp, $sp
jal $t2
lw $t0, 4($sp)
addu $sp, $sp, 4
move $sp, $fp
addu $sp, $sp, 4
lw $fp, ($sp)
addu $sp, $sp, 4
lw $ra, ($sp)
addu $sp, $sp, 4
sw $t0, ($sp)
subu $sp, $sp, 4
lw $t0, 4($sp)
sw $t0, -4($fp)
lw $t0, -4($fp)
sw $t0, ($sp)
subu $sp, $sp, 4
lw $t0, 16($fp)
sw $t0, ($sp)
subu $sp, $sp, 4
lw $a0, 8($sp)
lw $a1, 4($sp)
addiu $sp, $sp, 8
seq $a1, $a0, $a1
li $v0, 9
li $a0, 12
syscall
la $t0, Bool
sw $t0, ($v0)
li $t0, 1
sw $t0, 4($v0)
sw $a1, 8($v0)
sw $v0, ($sp)
subu $sp, $sp, 4
lw $t4, 4($sp) # .if.start.6
lw $t5, 8($t4)
addu $sp, $sp, 4
beqz $t5, .if.start.6
li $v0, 9
li $a0, 12
syscall
la $t0, Bool
sw $t0, ($v0)
li $t0, 1
sw $t0, 4($v0)
li $a0, 1
sw $a0, 8($v0)
sw $v0, ($sp)
subu $sp, $sp, 4
lw $t0, 4($sp)
sw $t0, -0($fp)
j .if.end.6
.if.start.6:
lw $t0, -4($fp)
sw $t0, ($sp)
subu $sp, $sp, 4
lw $t0, 4($sp)
lw $t0, 16($fp)
li $v0, 9
li $a0, 12
syscall
la $t0, String
sw $t0, ($v0)
li $t0, 1
sw $t0, 4($v0)
la $a0, msg43
sw $a0, 8($v0)
sw $v0, ($sp)
subu $sp, $sp, 4
lw $a0, 12($fp)
sw $a0, 0($sp)
subu $sp, $sp, 4
lw $t0, 4($sp)
la $t1, void_error
sw $t1, ($sp)
subu $sp, $sp, 4
beqz $t0, .raise
addu $sp, $sp, 4
lw $t1, ($t0)
lw $t2, 24($t1)
sw $ra, ($sp)
subu $sp, $sp, 4
sw $fp, ($sp)
subu $sp, $sp, 4
move $fp, $sp
jal $t2
lw $t0, 4($sp)
addu $sp, $sp, 4
move $sp, $fp
addu $sp, $sp, 4
lw $fp, ($sp)
addu $sp, $sp, 4
lw $ra, ($sp)
addu $sp, $sp, 8
sw $t0, ($sp)
subu $sp, $sp, 4
lw $t0, 16($fp)
sw $t0, ($sp)
subu $sp, $sp, 4
lw $t0, 4($sp)
la $t1, void_error
sw $t1, ($sp)
subu $sp, $sp, 4
beqz $t0, .raise
addu $sp, $sp, 4
lw $t1, ($t0)
lw $t2, 40($t1)
sw $ra, ($sp)
subu $sp, $sp, 4
sw $fp, ($sp)
subu $sp, $sp, 4
move $fp, $sp
jal $t2
lw $t0, 4($sp)
addu $sp, $sp, 4
move $sp, $fp
addu $sp, $sp, 4
lw $fp, ($sp)
addu $sp, $sp, 4
lw $ra, ($sp)
addu $sp, $sp, 4
sw $t0, ($sp)
subu $sp, $sp, 4
lw $a0, 4($sp)
addu, $sp, $sp, 12
sw $a0, ($sp)
subu, $sp, $sp, 4
.if.end.6:
lw $a0, 4($sp)
addu, $sp, $sp, 8
sw $a0, ($sp)
subu, $sp, $sp, 4
j .while.start.2
.while.end.2:
li $t0, 0
sw $t0, 4($sp)
li $v0, 9
li $a0, 12
syscall
la $t0, String
sw $t0, ($v0)
li $t0, 1
sw $t0, 4($v0)
la $a0, msg44
sw $a0, 8($v0)
sw $v0, ($sp)
subu $sp, $sp, 4
lw $a0, 12($fp)
sw $a0, 0($sp)
subu $sp, $sp, 4
lw $t0, 4($sp)
la $t1, void_error
sw $t1, ($sp)
subu $sp, $sp, 4
beqz $t0, .raise
addu $sp, $sp, 4
lw $t1, ($t0)
lw $t2, 24($t1)
sw $ra, ($sp)
subu $sp, $sp, 4
sw $fp, ($sp)
subu $sp, $sp, 4
move $fp, $sp
jal $t2
lw $t0, 4($sp)
addu $sp, $sp, 4
move $sp, $fp
addu $sp, $sp, 4
lw $fp, ($sp)
addu $sp, $sp, 4
lw $ra, ($sp)
addu $sp, $sp, 8
sw $t0, ($sp)
subu $sp, $sp, 4
lw $t0, 16($fp)
sw $t0, ($sp)
subu $sp, $sp, 4
lw $a0, 4($sp)
addu, $sp, $sp, 12
sw $a0, ($sp)
subu, $sp, $sp, 4
lw $a0, 4($sp)
addu, $sp, $sp, 12
sw $a0, ($sp)
subu, $sp, $sp, 4
jr $ra
.Main.eval_class:
li $t0, 0 #.Main.eval_class
li $v0, 9
li $a0, 12
syscall
la $t0, String
sw $t0, ($v0)
li $t0, 1
sw $t0, 4($v0)
la $a0, msg45
sw $a0, 8($v0)
sw $v0, ($sp)
subu $sp, $sp, 4
lw $a0, 12($fp)
sw $a0, 0($sp)
subu $sp, $sp, 4
lw $t0, 4($sp)
la $t1, void_error
sw $t1, ($sp)
subu $sp, $sp, 4
beqz $t0, .raise
addu $sp, $sp, 4
lw $t1, ($t0)
lw $t2, 24($t1)
sw $ra, ($sp)
subu $sp, $sp, 4
sw $fp, ($sp)
subu $sp, $sp, 4
move $fp, $sp
jal $t2
lw $t0, 4($sp)
addu $sp, $sp, 4
move $sp, $fp
addu $sp, $sp, 4
lw $fp, ($sp)
addu $sp, $sp, 4
lw $ra, ($sp)
addu $sp, $sp, 8
sw $t0, ($sp)
subu $sp, $sp, 4
li $v0, 9
li $a0, 12
syscall
la $t0, String
sw $t0, ($v0)
li $t0, 1
sw $t0, 4($v0)
la $a0, msg46
sw $a0, 8($v0)
sw $v0, ($sp)
subu $sp, $sp, 4
lw $a0, 12($fp)
sw $a0, 0($sp)
subu $sp, $sp, 4
lw $t0, 4($sp)
la $t1, void_error
sw $t1, ($sp)
subu $sp, $sp, 4
beqz $t0, .raise
addu $sp, $sp, 4
lw $t1, ($t0)
lw $t2, 24($t1)
sw $ra, ($sp)
subu $sp, $sp, 4
sw $fp, ($sp)
subu $sp, $sp, 4
move $fp, $sp
jal $t2
lw $t0, 4($sp)
addu $sp, $sp, 4
move $sp, $fp
addu $sp, $sp, 4
lw $fp, ($sp)
addu $sp, $sp, 4
lw $ra, ($sp)
addu $sp, $sp, 8
sw $t0, ($sp)
subu $sp, $sp, 4
li $v0, 9
li $a0, 12
syscall
la $t0, String
sw $t0, ($v0)
li $t0, 1
sw $t0, 4($v0)
la $a0, msg47
sw $a0, 8($v0)
sw $v0, ($sp)
subu $sp, $sp, 4
lw $a0, 12($fp)
sw $a0, 0($sp)
subu $sp, $sp, 4
lw $t0, 4($sp)
la $t1, void_error
sw $t1, ($sp)
subu $sp, $sp, 4
beqz $t0, .raise
addu $sp, $sp, 4
lw $t1, ($t0)
lw $t2, 24($t1)
sw $ra, ($sp)
subu $sp, $sp, 4
sw $fp, ($sp)
subu $sp, $sp, 4
move $fp, $sp
jal $t2
lw $t0, 4($sp)
addu $sp, $sp, 4
move $sp, $fp
addu $sp, $sp, 4
lw $fp, ($sp)
addu $sp, $sp, 4
lw $ra, ($sp)
addu $sp, $sp, 8
sw $t0, ($sp)
subu $sp, $sp, 4
lw $a0, 4($sp)
addu, $sp, $sp, 12
sw $a0, ($sp)
subu, $sp, $sp, 4
jr $ra
.Main.closure_class:
li $t0, 0 #.Main.closure_class
li $v0, 9
li $a0, 12
syscall
la $t0, String
sw $t0, ($v0)
li $t0, 1
sw $t0, 4($v0)
la $a0, msg48
sw $a0, 8($v0)
sw $v0, ($sp)
subu $sp, $sp, 4
lw $a0, 12($fp)
sw $a0, 0($sp)
subu $sp, $sp, 4
lw $t0, 4($sp)
la $t1, void_error
sw $t1, ($sp)
subu $sp, $sp, 4
beqz $t0, .raise
addu $sp, $sp, 4
lw $t1, ($t0)
lw $t2, 24($t1)
sw $ra, ($sp)
subu $sp, $sp, 4
sw $fp, ($sp)
subu $sp, $sp, 4
move $fp, $sp
jal $t2
lw $t0, 4($sp)
addu $sp, $sp, 4
move $sp, $fp
addu $sp, $sp, 4
lw $fp, ($sp)
addu $sp, $sp, 4
lw $ra, ($sp)
addu $sp, $sp, 8
sw $t0, ($sp)
subu $sp, $sp, 4
li $v0, 9
li $a0, 12
syscall
la $t0, String
sw $t0, ($v0)
li $t0, 1
sw $t0, 4($v0)
la $a0, msg49
sw $a0, 8($v0)
sw $v0, ($sp)
subu $sp, $sp, 4
lw $a0, 12($fp)
sw $a0, 0($sp)
subu $sp, $sp, 4
lw $t0, 4($sp)
la $t1, void_error
sw $t1, ($sp)
subu $sp, $sp, 4
beqz $t0, .raise
addu $sp, $sp, 4
lw $t1, ($t0)
lw $t2, 24($t1)
sw $ra, ($sp)
subu $sp, $sp, 4
sw $fp, ($sp)
subu $sp, $sp, 4
move $fp, $sp
jal $t2
lw $t0, 4($sp)
addu $sp, $sp, 4
move $sp, $fp
addu $sp, $sp, 4
lw $fp, ($sp)
addu $sp, $sp, 4
lw $ra, ($sp)
addu $sp, $sp, 8
sw $t0, ($sp)
subu $sp, $sp, 4
li $v0, 9
li $a0, 12
syscall
la $t0, String
sw $t0, ($v0)
li $t0, 1
sw $t0, 4($v0)
la $a0, msg50
sw $a0, 8($v0)
sw $v0, ($sp)
subu $sp, $sp, 4
lw $a0, 12($fp)
sw $a0, 0($sp)
subu $sp, $sp, 4
lw $t0, 4($sp)
la $t1, void_error
sw $t1, ($sp)
subu $sp, $sp, 4
beqz $t0, .raise
addu $sp, $sp, 4
lw $t1, ($t0)
lw $t2, 24($t1)
sw $ra, ($sp)
subu $sp, $sp, 4
sw $fp, ($sp)
subu $sp, $sp, 4
move $fp, $sp
jal $t2
lw $t0, 4($sp)
addu $sp, $sp, 4
move $sp, $fp
addu $sp, $sp, 4
lw $fp, ($sp)
addu $sp, $sp, 4
lw $ra, ($sp)
addu $sp, $sp, 8
sw $t0, ($sp)
subu $sp, $sp, 4
li $v0, 9
li $a0, 12
syscall
la $t0, String
sw $t0, ($v0)
li $t0, 1
sw $t0, 4($v0)
la $a0, msg51
sw $a0, 8($v0)
sw $v0, ($sp)
subu $sp, $sp, 4
lw $a0, 12($fp)
sw $a0, 0($sp)
subu $sp, $sp, 4
lw $t0, 4($sp)
la $t1, void_error
sw $t1, ($sp)
subu $sp, $sp, 4
beqz $t0, .raise
addu $sp, $sp, 4
lw $t1, ($t0)
lw $t2, 24($t1)
sw $ra, ($sp)
subu $sp, $sp, 4
sw $fp, ($sp)
subu $sp, $sp, 4
move $fp, $sp
jal $t2
lw $t0, 4($sp)
addu $sp, $sp, 4
move $sp, $fp
addu $sp, $sp, 4
lw $fp, ($sp)
addu $sp, $sp, 4
lw $ra, ($sp)
addu $sp, $sp, 8
sw $t0, ($sp)
subu $sp, $sp, 4
li $v0, 9
li $a0, 12
syscall
la $t0, String
sw $t0, ($v0)
li $t0, 1
sw $t0, 4($v0)
la $a0, msg52
sw $a0, 8($v0)
sw $v0, ($sp)
subu $sp, $sp, 4
lw $a0, 12($fp)
sw $a0, 0($sp)
subu $sp, $sp, 4
lw $t0, 4($sp)
la $t1, void_error
sw $t1, ($sp)
subu $sp, $sp, 4
beqz $t0, .raise
addu $sp, $sp, 4
lw $t1, ($t0)
lw $t2, 24($t1)
sw $ra, ($sp)
subu $sp, $sp, 4
sw $fp, ($sp)
subu $sp, $sp, 4
move $fp, $sp
jal $t2
lw $t0, 4($sp)
addu $sp, $sp, 4
move $sp, $fp
addu $sp, $sp, 4
lw $fp, ($sp)
addu $sp, $sp, 4
lw $ra, ($sp)
addu $sp, $sp, 8
sw $t0, ($sp)
subu $sp, $sp, 4
li $v0, 9
li $a0, 12
syscall
la $t0, String
sw $t0, ($v0)
li $t0, 1
sw $t0, 4($v0)
la $a0, msg53
sw $a0, 8($v0)
sw $v0, ($sp)
subu $sp, $sp, 4
lw $a0, 12($fp)
sw $a0, 0($sp)
subu $sp, $sp, 4
lw $t0, 4($sp)
la $t1, void_error
sw $t1, ($sp)
subu $sp, $sp, 4
beqz $t0, .raise
addu $sp, $sp, 4
lw $t1, ($t0)
lw $t2, 24($t1)
sw $ra, ($sp)
subu $sp, $sp, 4
sw $fp, ($sp)
subu $sp, $sp, 4
move $fp, $sp
jal $t2
lw $t0, 4($sp)
addu $sp, $sp, 4
move $sp, $fp
addu $sp, $sp, 4
lw $fp, ($sp)
addu $sp, $sp, 4
lw $ra, ($sp)
addu $sp, $sp, 8
sw $t0, ($sp)
subu $sp, $sp, 4
li $v0, 9
li $a0, 12
syscall
la $t0, String
sw $t0, ($v0)
li $t0, 1
sw $t0, 4($v0)
la $a0, msg54
sw $a0, 8($v0)
sw $v0, ($sp)
subu $sp, $sp, 4
lw $a0, 12($fp)
sw $a0, 0($sp)
subu $sp, $sp, 4
lw $t0, 4($sp)
la $t1, void_error
sw $t1, ($sp)
subu $sp, $sp, 4
beqz $t0, .raise
addu $sp, $sp, 4
lw $t1, ($t0)
lw $t2, 24($t1)
sw $ra, ($sp)
subu $sp, $sp, 4
sw $fp, ($sp)
subu $sp, $sp, 4
move $fp, $sp
jal $t2
lw $t0, 4($sp)
addu $sp, $sp, 4
move $sp, $fp
addu $sp, $sp, 4
lw $fp, ($sp)
addu $sp, $sp, 4
lw $ra, ($sp)
addu $sp, $sp, 8
sw $t0, ($sp)
subu $sp, $sp, 4
li $v0, 9
li $a0, 12
syscall
la $t0, String
sw $t0, ($v0)
li $t0, 1
sw $t0, 4($v0)
la $a0, msg55
sw $a0, 8($v0)
sw $v0, ($sp)
subu $sp, $sp, 4
lw $a0, 12($fp)
sw $a0, 0($sp)
subu $sp, $sp, 4
lw $t0, 4($sp)
la $t1, void_error
sw $t1, ($sp)
subu $sp, $sp, 4
beqz $t0, .raise
addu $sp, $sp, 4
lw $t1, ($t0)
lw $t2, 24($t1)
sw $ra, ($sp)
subu $sp, $sp, 4
sw $fp, ($sp)
subu $sp, $sp, 4
move $fp, $sp
jal $t2
lw $t0, 4($sp)
addu $sp, $sp, 4
move $sp, $fp
addu $sp, $sp, 4
lw $fp, ($sp)
addu $sp, $sp, 4
lw $ra, ($sp)
addu $sp, $sp, 8
sw $t0, ($sp)
subu $sp, $sp, 4
lw $a0, 4($sp)
addu, $sp, $sp, 32
sw $a0, ($sp)
subu, $sp, $sp, 4
jr $ra
.Main.gen_code:
li $t0, 0 #.Main.gen_code
sw $t0, ($sp)
subu $sp, $sp, 4
sw $t0, ($sp)
subu $sp, $sp, 4
sw $t0, ($sp)
subu $sp, $sp, 4
sw $t0, ($sp)
subu $sp, $sp, 4
li $v0, 9
li $a0, 16
syscall
sw $v0, 0($sp) # new Object
subu $sp, $sp ,4
la $t0, LambdaListRef
sw $t0, ($v0)
li $t0, 2
sw $t0, 4($v0)
sw $ra, ($sp)
subu $sp, $sp, 4
sw $fp, ($sp)
subu $sp, $sp, 4
move $fp, $sp
jal .LambdaListRef.LambdaListRef
addu $sp, $sp, 4
move $sp, $fp
addu $sp, $sp, 4
lw $fp, ($sp)
addu $sp, $sp, 4
lw $ra, ($sp)
lw $t0, 4($sp)
la $t1, void_error
sw $t1, ($sp)
subu $sp, $sp, 4
beqz $t0, .raise
addu $sp, $sp, 4
lw $t1, ($t0)
lw $t2, 40($t1)
sw $ra, ($sp)
subu $sp, $sp, 4
sw $fp, ($sp)
subu $sp, $sp, 4
move $fp, $sp
jal $t2
lw $t0, 4($sp)
addu $sp, $sp, 4
move $sp, $fp
addu $sp, $sp, 4
lw $fp, ($sp)
addu $sp, $sp, 4
lw $ra, ($sp)
addu $sp, $sp, 4
sw $t0, ($sp)
subu $sp, $sp, 4
lw $t1, 4($sp)
sw $t1, -0($fp)
addu $sp, $sp, 4
li $v0, 9
li $a0, 12
syscall
la $t0, String
sw $t0, ($v0)
li $t0, 1
sw $t0, 4($v0)
la $a0, msg56
sw $a0, 8($v0)
sw $v0, ($sp)
subu $sp, $sp, 4
lw $a0, 12($fp)
sw $a0, 0($sp)
subu $sp, $sp, 4
lw $t0, 4($sp)
la $t1, void_error
sw $t1, ($sp)
subu $sp, $sp, 4
beqz $t0, .raise
addu $sp, $sp, 4
lw $t1, ($t0)
lw $t2, 24($t1)
sw $ra, ($sp)
subu $sp, $sp, 4
sw $fp, ($sp)
subu $sp, $sp, 4
move $fp, $sp
jal $t2
lw $t0, 4($sp)
addu $sp, $sp, 4
move $sp, $fp
addu $sp, $sp, 4
lw $fp, ($sp)
addu $sp, $sp, 4
lw $ra, ($sp)
addu $sp, $sp, 8
sw $t0, ($sp)
subu $sp, $sp, 4
lw $t0, 16($fp)
sw $t0, ($sp)
subu $sp, $sp, 4
lw $t0, 4($sp)
la $t1, void_error
sw $t1, ($sp)
subu $sp, $sp, 4
beqz $t0, .raise
addu $sp, $sp, 4
lw $t1, ($t0)
lw $t2, 40($t1)
sw $ra, ($sp)
subu $sp, $sp, 4
sw $fp, ($sp)
subu $sp, $sp, 4
move $fp, $sp
jal $t2
lw $t0, 4($sp)
addu $sp, $sp, 4
move $sp, $fp
addu $sp, $sp, 4
lw $fp, ($sp)
addu $sp, $sp, 4
lw $ra, ($sp)
addu $sp, $sp, 4
sw $t0, ($sp)
subu $sp, $sp, 4
li $v0, 9
li $a0, 12
syscall
la $t0, String
sw $t0, ($v0)
li $t0, 1
sw $t0, 4($v0)
la $a0, msg57
sw $a0, 8($v0)
sw $v0, ($sp)
subu $sp, $sp, 4
lw $a0, 12($fp)
sw $a0, 0($sp)
subu $sp, $sp, 4
lw $t0, 4($sp)
la $t1, void_error
sw $t1, ($sp)
subu $sp, $sp, 4
beqz $t0, .raise
addu $sp, $sp, 4
lw $t1, ($t0)
lw $t2, 24($t1)
sw $ra, ($sp)
subu $sp, $sp, 4
sw $fp, ($sp)
subu $sp, $sp, 4
move $fp, $sp
jal $t2
lw $t0, 4($sp)
addu $sp, $sp, 4
move $sp, $fp
addu $sp, $sp, 4
lw $fp, ($sp)
addu $sp, $sp, 4
lw $ra, ($sp)
addu $sp, $sp, 8
sw $t0, ($sp)
subu $sp, $sp, 4
li $v0, 9
li $a0, 12
syscall
la $t0, String
sw $t0, ($v0)
li $t0, 1
sw $t0, 4($v0)
la $a0, msg58
sw $a0, 8($v0)
sw $v0, ($sp)
subu $sp, $sp, 4
lw $a0, 12($fp)
sw $a0, 0($sp)
subu $sp, $sp, 4
lw $t0, 4($sp)
la $t1, void_error
sw $t1, ($sp)
subu $sp, $sp, 4
beqz $t0, .raise
addu $sp, $sp, 4
lw $t1, ($t0)
lw $t2, 24($t1)
sw $ra, ($sp)
subu $sp, $sp, 4
sw $fp, ($sp)
subu $sp, $sp, 4
move $fp, $sp
jal $t2
lw $t0, 4($sp)
addu $sp, $sp, 4
move $sp, $fp
addu $sp, $sp, 4
lw $fp, ($sp)
addu $sp, $sp, 4
lw $ra, ($sp)
addu $sp, $sp, 8
sw $t0, ($sp)
subu $sp, $sp, 4
lw $a0, 12($fp)
sw $a0, 0($sp)
subu $sp, $sp, 4
lw $t0, 4($sp)
la $t1, void_error
sw $t1, ($sp)
subu $sp, $sp, 4
beqz $t0, .raise
addu $sp, $sp, 4
lw $t1, ($t0)
lw $t2, 68($t1)
sw $ra, ($sp)
subu $sp, $sp, 4
sw $fp, ($sp)
subu $sp, $sp, 4
move $fp, $sp
jal $t2
lw $t0, 4($sp)
addu $sp, $sp, 4
move $sp, $fp
addu $sp, $sp, 4
lw $fp, ($sp)
addu $sp, $sp, 4
lw $ra, ($sp)
addu $sp, $sp, 4
sw $t0, ($sp)
subu $sp, $sp, 4
lw $a0, 12($fp)
sw $a0, 0($sp)
subu $sp, $sp, 4
lw $t0, 4($sp)
la $t1, void_error
sw $t1, ($sp)
subu $sp, $sp, 4
beqz $t0, .raise
addu $sp, $sp, 4
lw $t1, ($t0)
lw $t2, 72($t1)
sw $ra, ($sp)
subu $sp, $sp, 4
sw $fp, ($sp)
subu $sp, $sp, 4
move $fp, $sp
jal $t2
lw $t0, 4($sp)
addu $sp, $sp, 4
move $sp, $fp
addu $sp, $sp, 4
lw $fp, ($sp)
addu $sp, $sp, 4
lw $ra, ($sp)
addu $sp, $sp, 4
sw $t0, ($sp)
subu $sp, $sp, 4
li $v0, 9
li $a0, 12
syscall
la $t0, String
sw $t0, ($v0)
li $t0, 1
sw $t0, 4($v0)
la $a0, msg59
sw $a0, 8($v0)
sw $v0, ($sp)
subu $sp, $sp, 4
lw $a0, 12($fp)
sw $a0, 0($sp)
subu $sp, $sp, 4
lw $t0, 4($sp)
la $t1, void_error
sw $t1, ($sp)
subu $sp, $sp, 4
beqz $t0, .raise
addu $sp, $sp, 4
lw $t1, ($t0)
lw $t2, 24($t1)
sw $ra, ($sp)
subu $sp, $sp, 4
sw $fp, ($sp)
subu $sp, $sp, 4
move $fp, $sp
jal $t2
lw $t0, 4($sp)
addu $sp, $sp, 4
move $sp, $fp
addu $sp, $sp, 4
lw $fp, ($sp)
addu $sp, $sp, 4
lw $ra, ($sp)
addu $sp, $sp, 8
sw $t0, ($sp)
subu $sp, $sp, 4
li $v0, 9
li $a0, 12
syscall
la $t0, String
sw $t0, ($v0)
li $t0, 1
sw $t0, 4($v0)
la $a0, msg60
sw $a0, 8($v0)
sw $v0, ($sp)
subu $sp, $sp, 4
lw $a0, 12($fp)
sw $a0, 0($sp)
subu $sp, $sp, 4
lw $t0, 4($sp)
la $t1, void_error
sw $t1, ($sp)
subu $sp, $sp, 4
beqz $t0, .raise
addu $sp, $sp, 4
lw $t1, ($t0)
lw $t2, 24($t1)
sw $ra, ($sp)
subu $sp, $sp, 4
sw $fp, ($sp)
subu $sp, $sp, 4
move $fp, $sp
jal $t2
lw $t0, 4($sp)
addu $sp, $sp, 4
move $sp, $fp
addu $sp, $sp, 4
lw $fp, ($sp)
addu $sp, $sp, 4
lw $ra, ($sp)
addu $sp, $sp, 8
sw $t0, ($sp)
subu $sp, $sp, 4
li $v0, 9
li $a0, 8
syscall
sw $v0, 0($sp) # new Object
subu $sp, $sp ,4
la $t0, VarList
sw $t0, ($v0)
li $t0, 0
sw $t0, 4($v0)
sw $ra, ($sp)
subu $sp, $sp, 4
sw $fp, ($sp)
subu $sp, $sp, 4
move $fp, $sp
jal .VarList.VarList
addu $sp, $sp, 4
move $sp, $fp
addu $sp, $sp, 4
lw $fp, ($sp)
addu $sp, $sp, 4
lw $ra, ($sp)
lw $t0, -0($fp)
sw $t0, ($sp)
subu $sp, $sp, 4
lw $t0, 16($fp)
sw $t0, ($sp)
subu $sp, $sp, 4
lw $t0, 4($sp)
la $t1, void_error
sw $t1, ($sp)
subu $sp, $sp, 4
beqz $t0, .raise
addu $sp, $sp, 4
lw $t1, ($t0)
lw $t2, 52($t1)
sw $ra, ($sp)
subu $sp, $sp, 4
sw $fp, ($sp)
subu $sp, $sp, 4
move $fp, $sp
jal $t2
lw $t0, 4($sp)
addu $sp, $sp, 4
move $sp, $fp
addu $sp, $sp, 4
lw $fp, ($sp)
addu $sp, $sp, 4
lw $ra, ($sp)
addu $sp, $sp, 12
sw $t0, ($sp)
subu $sp, $sp, 4
li $v0, 9
li $a0, 12
syscall
la $t0, String
sw $t0, ($v0)
li $t0, 1
sw $t0, 4($v0)
la $a0, msg61
sw $a0, 8($v0)
sw $v0, ($sp)
subu $sp, $sp, 4
lw $a0, 12($fp)
sw $a0, 0($sp)
subu $sp, $sp, 4
lw $t0, 4($sp)
la $t1, void_error
sw $t1, ($sp)
subu $sp, $sp, 4
beqz $t0, .raise
addu $sp, $sp, 4
lw $t1, ($t0)
lw $t2, 24($t1)
sw $ra, ($sp)
subu $sp, $sp, 4
sw $fp, ($sp)
subu $sp, $sp, 4
move $fp, $sp
jal $t2
lw $t0, 4($sp)
addu $sp, $sp, 4
move $sp, $fp
addu $sp, $sp, 4
lw $fp, ($sp)
addu $sp, $sp, 4
lw $ra, ($sp)
addu $sp, $sp, 8
sw $t0, ($sp)
subu $sp, $sp, 4
.while.start.3:
lw $t0, -0($fp)
sw $t0, ($sp)
subu $sp, $sp, 4
lw $t0, 4($sp)
la $t1, void_error
sw $t1, ($sp)
subu $sp, $sp, 4
beqz $t0, .raise
addu $sp, $sp, 4
lw $t1, ($t0)
lw $t2, 24($t1)
sw $ra, ($sp)
subu $sp, $sp, 4
sw $fp, ($sp)
subu $sp, $sp, 4
move $fp, $sp
jal $t2
lw $t0, 4($sp)
addu $sp, $sp, 4
move $sp, $fp
addu $sp, $sp, 4
lw $fp, ($sp)
addu $sp, $sp, 4
lw $ra, ($sp)
addu $sp, $sp, 4
sw $t0, ($sp)
subu $sp, $sp, 4
lw $t0, 4($sp)
lw $a1, 8($t0)
beqz $a1, .put_one.3
li $a1, 0
j .is_zero.3
.put_one.3:
li $a1, 1
.is_zero.3:
li $v0, 9
li $a0, 12
syscall
la $t0, Bool
sw $t0, ($v0)
li $t0, 1
sw $t0, 4($v0)
sw $a1, 8($v0)
sw $v0, ($sp)
subu $sp, $sp, 4
lw $t0, 4($sp)
lw $a0, 8($t0)
addu $sp, $sp, 4
beqz $a0, .while.end.3
lw $t0, -0($fp)
sw $t0, ($sp)
subu $sp, $sp, 4
lw $t0, 4($sp)
la $t1, void_error
sw $t1, ($sp)
subu $sp, $sp, 4
beqz $t0, .raise
addu $sp, $sp, 4
lw $t1, ($t0)
lw $t2, 28($t1)
sw $ra, ($sp)
subu $sp, $sp, 4
sw $fp, ($sp)
subu $sp, $sp, 4
move $fp, $sp
jal $t2
lw $t0, 4($sp)
addu $sp, $sp, 4
move $sp, $fp
addu $sp, $sp, 4
lw $fp, ($sp)
addu $sp, $sp, 4
lw $ra, ($sp)
addu $sp, $sp, 4
sw $t0, ($sp)
subu $sp, $sp, 4
lw $t1, 4($sp)
sw $t1, -4($fp)
addu $sp, $sp, 4
lw $t0, -0($fp)
sw $t0, ($sp)
subu $sp, $sp, 4
lw $t0, 4($sp)
la $t1, void_error
sw $t1, ($sp)
subu $sp, $sp, 4
beqz $t0, .raise
addu $sp, $sp, 4
lw $t1, ($t0)
lw $t2, 32($t1)
sw $ra, ($sp)
subu $sp, $sp, 4
sw $fp, ($sp)
subu $sp, $sp, 4
move $fp, $sp
jal $t2
lw $t0, 4($sp)
addu $sp, $sp, 4
move $sp, $fp
addu $sp, $sp, 4
lw $fp, ($sp)
addu $sp, $sp, 4
lw $ra, ($sp)
addu $sp, $sp, 4
sw $t0, ($sp)
subu $sp, $sp, 4
lw $t1, 4($sp)
sw $t1, -8($fp)
addu $sp, $sp, 4
lw $t0, -0($fp)
sw $t0, ($sp)
subu $sp, $sp, 4
lw $t0, 4($sp)
la $t1, void_error
sw $t1, ($sp)
subu $sp, $sp, 4
beqz $t0, .raise
addu $sp, $sp, 4
lw $t1, ($t0)
lw $t2, 36($t1)
sw $ra, ($sp)
subu $sp, $sp, 4
sw $fp, ($sp)
subu $sp, $sp, 4
move $fp, $sp
jal $t2
lw $t0, 4($sp)
addu $sp, $sp, 4
move $sp, $fp
addu $sp, $sp, 4
lw $fp, ($sp)
addu $sp, $sp, 4
lw $ra, ($sp)
addu $sp, $sp, 4
sw $t0, ($sp)
subu $sp, $sp, 4
lw $t1, 4($sp)
sw $t1, -12($fp)
addu $sp, $sp, 4
lw $t0, -0($fp)
sw $t0, ($sp)
subu $sp, $sp, 4
lw $t0, 4($sp)
la $t1, void_error
sw $t1, ($sp)
subu $sp, $sp, 4
beqz $t0, .raise
addu $sp, $sp, 4
lw $t1, ($t0)
lw $t2, 48($t1)
sw $ra, ($sp)
subu $sp, $sp, 4
sw $fp, ($sp)
subu $sp, $sp, 4
move $fp, $sp
jal $t2
lw $t0, 4($sp)
addu $sp, $sp, 4
move $sp, $fp
addu $sp, $sp, 4
lw $fp, ($sp)
addu $sp, $sp, 4
lw $ra, ($sp)
addu $sp, $sp, 4
sw $t0, ($sp)
subu $sp, $sp, 4
lw $t0, -12($fp)
sw $t0, ($sp)
subu $sp, $sp, 4
lw $t0, 4($sp)
la $t1, void_error
sw $t1, ($sp)
subu $sp, $sp, 4
beqz $t0, .raise
addu $sp, $sp, 4
lw $t1, ($t0)
lw $t2, 20($t1)
sw $ra, ($sp)
subu $sp, $sp, 4
sw $fp, ($sp)
subu $sp, $sp, 4
move $fp, $sp
jal $t2
lw $t0, 4($sp)
addu $sp, $sp, 4
move $sp, $fp
addu $sp, $sp, 4
lw $fp, ($sp)
addu $sp, $sp, 4
lw $ra, ($sp)
addu $sp, $sp, 4
sw $t0, ($sp)
subu $sp, $sp, 4
lw $t0, -4($fp)
sw $t0, ($sp)
subu $sp, $sp, 4
lw $t0, -0($fp)
sw $t0, ($sp)
subu $sp, $sp, 4
lw $t0, -8($fp)
sw $t0, ($sp)
subu $sp, $sp, 4
lw $t0, 4($sp)
la $t1, void_error
sw $t1, ($sp)
subu $sp, $sp, 4
beqz $t0, .raise
addu $sp, $sp, 4
lw $t1, ($t0)
lw $t2, 64($t1)
sw $ra, ($sp)
subu $sp, $sp, 4
sw $fp, ($sp)
subu $sp, $sp, 4
move $fp, $sp
jal $t2
lw $t0, 4($sp)
addu $sp, $sp, 4
move $sp, $fp
addu $sp, $sp, 4
lw $fp, ($sp)
addu $sp, $sp, 4
lw $ra, ($sp)
addu $sp, $sp, 16
sw $t0, ($sp)
subu $sp, $sp, 4
lw $a0, 4($sp)
addu, $sp, $sp, 8
sw $a0, ($sp)
subu, $sp, $sp, 4
j .while.start.3
.while.end.3:
li $t0, 0
sw $t0, 4($sp)
li $v0, 9
li $a0, 12
syscall
la $t0, String
sw $t0, ($v0)
li $t0, 1
sw $t0, 4($v0)
la $a0, msg62
sw $a0, 8($v0)
sw $v0, ($sp)
subu $sp, $sp, 4
lw $a0, 12($fp)
sw $a0, 0($sp)
subu $sp, $sp, 4
lw $t0, 4($sp)
la $t1, void_error
sw $t1, ($sp)
subu $sp, $sp, 4
beqz $t0, .raise
addu $sp, $sp, 4
lw $t1, ($t0)
lw $t2, 24($t1)
sw $ra, ($sp)
subu $sp, $sp, 4
sw $fp, ($sp)
subu $sp, $sp, 4
move $fp, $sp
jal $t2
lw $t0, 4($sp)
addu $sp, $sp, 4
move $sp, $fp
addu $sp, $sp, 4
lw $fp, ($sp)
addu $sp, $sp, 4
lw $ra, ($sp)
addu $sp, $sp, 8
sw $t0, ($sp)
subu $sp, $sp, 4
lw $a0, 4($sp)
addu, $sp, $sp, 48
sw $a0, ($sp)
subu, $sp, $sp, 4
jr $ra
.Main.main:
li $t0, 0 #.Main.main
lw $a0, 12($fp)
sw $a0, 0($sp)
subu $sp, $sp, 4
lw $t0, 4($sp)
la $t1, void_error
sw $t1, ($sp)
subu $sp, $sp, 4
beqz $t0, .raise
addu $sp, $sp, 4
lw $t1, ($t0)
lw $t2, 52($t1)
sw $ra, ($sp)
subu $sp, $sp, 4
sw $fp, ($sp)
subu $sp, $sp, 4
move $fp, $sp
jal $t2
lw $t0, 4($sp)
addu $sp, $sp, 4
move $sp, $fp
addu $sp, $sp, 4
lw $fp, ($sp)
addu $sp, $sp, 4
lw $ra, ($sp)
addu $sp, $sp, 4
sw $t0, ($sp)
subu $sp, $sp, 4
lw $t0, 4($sp)
la $t1, void_error
sw $t1, ($sp)
subu $sp, $sp, 4
beqz $t0, .raise
addu $sp, $sp, 4
lw $t1, ($t0)
lw $t2, 40($t1)
sw $ra, ($sp)
subu $sp, $sp, 4
sw $fp, ($sp)
subu $sp, $sp, 4
move $fp, $sp
jal $t2
lw $t0, 4($sp)
addu $sp, $sp, 4
move $sp, $fp
addu $sp, $sp, 4
lw $fp, ($sp)
addu $sp, $sp, 4
lw $ra, ($sp)
addu $sp, $sp, 4
sw $t0, ($sp)
subu $sp, $sp, 4
li $v0, 9
li $a0, 12
syscall
la $t0, String
sw $t0, ($v0)
li $t0, 1
sw $t0, 4($v0)
la $a0, msg63
sw $a0, 8($v0)
sw $v0, ($sp)
subu $sp, $sp, 4
lw $a0, 12($fp)
sw $a0, 0($sp)
subu $sp, $sp, 4
lw $t0, 4($sp)
la $t1, void_error
sw $t1, ($sp)
subu $sp, $sp, 4
beqz $t0, .raise
addu $sp, $sp, 4
lw $t1, ($t0)
lw $t2, 24($t1)
sw $ra, ($sp)
subu $sp, $sp, 4
sw $fp, ($sp)
subu $sp, $sp, 4
move $fp, $sp
jal $t2
lw $t0, 4($sp)
addu $sp, $sp, 4
move $sp, $fp
addu $sp, $sp, 4
lw $fp, ($sp)
addu $sp, $sp, 4
lw $ra, ($sp)
addu $sp, $sp, 8
sw $t0, ($sp)
subu $sp, $sp, 4
lw $a0, 12($fp)
sw $a0, 0($sp)
subu $sp, $sp, 4
lw $t0, 4($sp)
la $t1, void_error
sw $t1, ($sp)
subu $sp, $sp, 4
beqz $t0, .raise
addu $sp, $sp, 4
lw $t1, ($t0)
lw $t2, 56($t1)
sw $ra, ($sp)
subu $sp, $sp, 4
sw $fp, ($sp)
subu $sp, $sp, 4
move $fp, $sp
jal $t2
lw $t0, 4($sp)
addu $sp, $sp, 4
move $sp, $fp
addu $sp, $sp, 4
lw $fp, ($sp)
addu $sp, $sp, 4
lw $ra, ($sp)
addu $sp, $sp, 4
sw $t0, ($sp)
subu $sp, $sp, 4
lw $t0, 4($sp)
la $t1, void_error
sw $t1, ($sp)
subu $sp, $sp, 4
beqz $t0, .raise
addu $sp, $sp, 4
lw $t1, ($t0)
lw $t2, 40($t1)
sw $ra, ($sp)
subu $sp, $sp, 4
sw $fp, ($sp)
subu $sp, $sp, 4
move $fp, $sp
jal $t2
lw $t0, 4($sp)
addu $sp, $sp, 4
move $sp, $fp
addu $sp, $sp, 4
lw $fp, ($sp)
addu $sp, $sp, 4
lw $ra, ($sp)
addu $sp, $sp, 4
sw $t0, ($sp)
subu $sp, $sp, 4
li $v0, 9
li $a0, 12
syscall
la $t0, String
sw $t0, ($v0)
li $t0, 1
sw $t0, 4($v0)
la $a0, msg64
sw $a0, 8($v0)
sw $v0, ($sp)
subu $sp, $sp, 4
lw $a0, 12($fp)
sw $a0, 0($sp)
subu $sp, $sp, 4
lw $t0, 4($sp)
la $t1, void_error
sw $t1, ($sp)
subu $sp, $sp, 4
beqz $t0, .raise
addu $sp, $sp, 4
lw $t1, ($t0)
lw $t2, 24($t1)
sw $ra, ($sp)
subu $sp, $sp, 4
sw $fp, ($sp)
subu $sp, $sp, 4
move $fp, $sp
jal $t2
lw $t0, 4($sp)
addu $sp, $sp, 4
move $sp, $fp
addu $sp, $sp, 4
lw $fp, ($sp)
addu $sp, $sp, 4
lw $ra, ($sp)
addu $sp, $sp, 8
sw $t0, ($sp)
subu $sp, $sp, 4
lw $a0, 12($fp)
sw $a0, 0($sp)
subu $sp, $sp, 4
lw $t0, 4($sp)
la $t1, void_error
sw $t1, ($sp)
subu $sp, $sp, 4
beqz $t0, .raise
addu $sp, $sp, 4
lw $t1, ($t0)
lw $t2, 60($t1)
sw $ra, ($sp)
subu $sp, $sp, 4
sw $fp, ($sp)
subu $sp, $sp, 4
move $fp, $sp
jal $t2
lw $t0, 4($sp)
addu $sp, $sp, 4
move $sp, $fp
addu $sp, $sp, 4
lw $fp, ($sp)
addu $sp, $sp, 4
lw $ra, ($sp)
addu $sp, $sp, 4
sw $t0, ($sp)
subu $sp, $sp, 4
lw $t0, 4($sp)
la $t1, void_error
sw $t1, ($sp)
subu $sp, $sp, 4
beqz $t0, .raise
addu $sp, $sp, 4
lw $t1, ($t0)
lw $t2, 40($t1)
sw $ra, ($sp)
subu $sp, $sp, 4
sw $fp, ($sp)
subu $sp, $sp, 4
move $fp, $sp
jal $t2
lw $t0, 4($sp)
addu $sp, $sp, 4
move $sp, $fp
addu $sp, $sp, 4
lw $fp, ($sp)
addu $sp, $sp, 4
lw $ra, ($sp)
addu $sp, $sp, 4
sw $t0, ($sp)
subu $sp, $sp, 4
li $v0, 9
li $a0, 12
syscall
la $t0, String
sw $t0, ($v0)
li $t0, 1
sw $t0, 4($v0)
la $a0, msg65
sw $a0, 8($v0)
sw $v0, ($sp)
subu $sp, $sp, 4
lw $a0, 12($fp)
sw $a0, 0($sp)
subu $sp, $sp, 4
lw $t0, 4($sp)
la $t1, void_error
sw $t1, ($sp)
subu $sp, $sp, 4
beqz $t0, .raise
addu $sp, $sp, 4
lw $t1, ($t0)
lw $t2, 24($t1)
sw $ra, ($sp)
subu $sp, $sp, 4
sw $fp, ($sp)
subu $sp, $sp, 4
move $fp, $sp
jal $t2
lw $t0, 4($sp)
addu $sp, $sp, 4
move $sp, $fp
addu $sp, $sp, 4
lw $fp, ($sp)
addu $sp, $sp, 4
lw $ra, ($sp)
addu $sp, $sp, 8
sw $t0, ($sp)
subu $sp, $sp, 4
lw $a0, 12($fp)
sw $a0, 0($sp)
subu $sp, $sp, 4
lw $t0, 4($sp)
la $t1, void_error
sw $t1, ($sp)
subu $sp, $sp, 4
beqz $t0, .raise
addu $sp, $sp, 4
lw $t1, ($t0)
lw $t2, 60($t1)
sw $ra, ($sp)
subu $sp, $sp, 4
sw $fp, ($sp)
subu $sp, $sp, 4
move $fp, $sp
jal $t2
lw $t0, 4($sp)
addu $sp, $sp, 4
move $sp, $fp
addu $sp, $sp, 4
lw $fp, ($sp)
addu $sp, $sp, 4
lw $ra, ($sp)
addu $sp, $sp, 4
sw $t0, ($sp)
subu $sp, $sp, 4
lw $a0, 12($fp)
sw $a0, 0($sp)
subu $sp, $sp, 4
lw $t0, 4($sp)
la $t1, void_error
sw $t1, ($sp)
subu $sp, $sp, 4
beqz $t0, .raise
addu $sp, $sp, 4
lw $t1, ($t0)
lw $t2, 56($t1)
sw $ra, ($sp)
subu $sp, $sp, 4
sw $fp, ($sp)
subu $sp, $sp, 4
move $fp, $sp
jal $t2
lw $t0, 4($sp)
addu $sp, $sp, 4
move $sp, $fp
addu $sp, $sp, 4
lw $fp, ($sp)
addu $sp, $sp, 4
lw $ra, ($sp)
addu $sp, $sp, 4
sw $t0, ($sp)
subu $sp, $sp, 4
lw $a0, 12($fp)
sw $a0, 0($sp)
subu $sp, $sp, 4
lw $t0, 4($sp)
la $t1, void_error
sw $t1, ($sp)
subu $sp, $sp, 4
beqz $t0, .raise
addu $sp, $sp, 4
lw $t1, ($t0)
lw $t2, 48($t1)
sw $ra, ($sp)
subu $sp, $sp, 4
sw $fp, ($sp)
subu $sp, $sp, 4
move $fp, $sp
jal $t2
lw $t0, 4($sp)
addu $sp, $sp, 4
move $sp, $fp
addu $sp, $sp, 4
lw $fp, ($sp)
addu $sp, $sp, 4
lw $ra, ($sp)
addu $sp, $sp, 12
sw $t0, ($sp)
subu $sp, $sp, 4
lw $a0, 12($fp)
sw $a0, 0($sp)
subu $sp, $sp, 4
lw $t0, 4($sp)
la $t1, void_error
sw $t1, ($sp)
subu $sp, $sp, 4
beqz $t0, .raise
addu $sp, $sp, 4
lw $t1, ($t0)
lw $t2, 52($t1)
sw $ra, ($sp)
subu $sp, $sp, 4
sw $fp, ($sp)
subu $sp, $sp, 4
move $fp, $sp
jal $t2
lw $t0, 4($sp)
addu $sp, $sp, 4
move $sp, $fp
addu $sp, $sp, 4
lw $fp, ($sp)
addu $sp, $sp, 4
lw $ra, ($sp)
addu $sp, $sp, 4
sw $t0, ($sp)
subu $sp, $sp, 4
lw $a0, 12($fp)
sw $a0, 0($sp)
subu $sp, $sp, 4
lw $t0, 4($sp)
la $t1, void_error
sw $t1, ($sp)
subu $sp, $sp, 4
beqz $t0, .raise
addu $sp, $sp, 4
lw $t1, ($t0)
lw $t2, 48($t1)
sw $ra, ($sp)
subu $sp, $sp, 4
sw $fp, ($sp)
subu $sp, $sp, 4
move $fp, $sp
jal $t2
lw $t0, 4($sp)
addu $sp, $sp, 4
move $sp, $fp
addu $sp, $sp, 4
lw $fp, ($sp)
addu $sp, $sp, 4
lw $ra, ($sp)
addu $sp, $sp, 12
sw $t0, ($sp)
subu $sp, $sp, 4
lw $a0, 12($fp)
sw $a0, 0($sp)
subu $sp, $sp, 4
lw $t0, 4($sp)
la $t1, void_error
sw $t1, ($sp)
subu $sp, $sp, 4
beqz $t0, .raise
addu $sp, $sp, 4
lw $t1, ($t0)
lw $t2, 52($t1)
sw $ra, ($sp)
subu $sp, $sp, 4
sw $fp, ($sp)
subu $sp, $sp, 4
move $fp, $sp
jal $t2
lw $t0, 4($sp)
addu $sp, $sp, 4
move $sp, $fp
addu $sp, $sp, 4
lw $fp, ($sp)
addu $sp, $sp, 4
lw $ra, ($sp)
addu $sp, $sp, 4
sw $t0, ($sp)
subu $sp, $sp, 4
lw $a0, 12($fp)
sw $a0, 0($sp)
subu $sp, $sp, 4
lw $t0, 4($sp)
la $t1, void_error
sw $t1, ($sp)
subu $sp, $sp, 4
beqz $t0, .raise
addu $sp, $sp, 4
lw $t1, ($t0)
lw $t2, 48($t1)
sw $ra, ($sp)
subu $sp, $sp, 4
sw $fp, ($sp)
subu $sp, $sp, 4
move $fp, $sp
jal $t2
lw $t0, 4($sp)
addu $sp, $sp, 4
move $sp, $fp
addu $sp, $sp, 4
lw $fp, ($sp)
addu $sp, $sp, 4
lw $ra, ($sp)
addu $sp, $sp, 12
sw $t0, ($sp)
subu $sp, $sp, 4
lw $a0, 12($fp)
sw $a0, 0($sp)
subu $sp, $sp, 4
lw $t0, 4($sp)
la $t1, void_error
sw $t1, ($sp)
subu $sp, $sp, 4
beqz $t0, .raise
addu $sp, $sp, 4
lw $t1, ($t0)
lw $t2, 64($t1)
sw $ra, ($sp)
subu $sp, $sp, 4
sw $fp, ($sp)
subu $sp, $sp, 4
move $fp, $sp
jal $t2
lw $t0, 4($sp)
addu $sp, $sp, 4
move $sp, $fp
addu $sp, $sp, 4
lw $fp, ($sp)
addu $sp, $sp, 4
lw $ra, ($sp)
addu $sp, $sp, 8
sw $t0, ($sp)
subu $sp, $sp, 4
lw $a0, 12($fp)
sw $a0, 0($sp)
subu $sp, $sp, 4
lw $t0, 4($sp)
la $t1, void_error
sw $t1, ($sp)
subu $sp, $sp, 4
beqz $t0, .raise
addu $sp, $sp, 4
lw $t1, ($t0)
lw $t2, 56($t1)
sw $ra, ($sp)
subu $sp, $sp, 4
sw $fp, ($sp)
subu $sp, $sp, 4
move $fp, $sp
jal $t2
lw $t0, 4($sp)
addu $sp, $sp, 4
move $sp, $fp
addu $sp, $sp, 4
lw $fp, ($sp)
addu $sp, $sp, 4
lw $ra, ($sp)
addu $sp, $sp, 4
sw $t0, ($sp)
subu $sp, $sp, 4
lw $a0, 12($fp)
sw $a0, 0($sp)
subu $sp, $sp, 4
lw $t0, 4($sp)
la $t1, void_error
sw $t1, ($sp)
subu $sp, $sp, 4
beqz $t0, .raise
addu $sp, $sp, 4
lw $t1, ($t0)
lw $t2, 52($t1)
sw $ra, ($sp)
subu $sp, $sp, 4
sw $fp, ($sp)
subu $sp, $sp, 4
move $fp, $sp
jal $t2
lw $t0, 4($sp)
addu $sp, $sp, 4
move $sp, $fp
addu $sp, $sp, 4
lw $fp, ($sp)
addu $sp, $sp, 4
lw $ra, ($sp)
addu $sp, $sp, 4
sw $t0, ($sp)
subu $sp, $sp, 4
lw $a0, 12($fp)
sw $a0, 0($sp)
subu $sp, $sp, 4
lw $t0, 4($sp)
la $t1, void_error
sw $t1, ($sp)
subu $sp, $sp, 4
beqz $t0, .raise
addu $sp, $sp, 4
lw $t1, ($t0)
lw $t2, 48($t1)
sw $ra, ($sp)
subu $sp, $sp, 4
sw $fp, ($sp)
subu $sp, $sp, 4
move $fp, $sp
jal $t2
lw $t0, 4($sp)
addu $sp, $sp, 4
move $sp, $fp
addu $sp, $sp, 4
lw $fp, ($sp)
addu $sp, $sp, 4
lw $ra, ($sp)
addu $sp, $sp, 12
sw $t0, ($sp)
subu $sp, $sp, 4
lw $a0, 12($fp)
sw $a0, 0($sp)
subu $sp, $sp, 4
lw $t0, 4($sp)
la $t1, void_error
sw $t1, ($sp)
subu $sp, $sp, 4
beqz $t0, .raise
addu $sp, $sp, 4
lw $t1, ($t0)
lw $t2, 52($t1)
sw $ra, ($sp)
subu $sp, $sp, 4
sw $fp, ($sp)
subu $sp, $sp, 4
move $fp, $sp
jal $t2
lw $t0, 4($sp)
addu $sp, $sp, 4
move $sp, $fp
addu $sp, $sp, 4
lw $fp, ($sp)
addu $sp, $sp, 4
lw $ra, ($sp)
addu $sp, $sp, 4
sw $t0, ($sp)
subu $sp, $sp, 4
lw $a0, 12($fp)
sw $a0, 0($sp)
subu $sp, $sp, 4
lw $t0, 4($sp)
la $t1, void_error
sw $t1, ($sp)
subu $sp, $sp, 4
beqz $t0, .raise
addu $sp, $sp, 4
lw $t1, ($t0)
lw $t2, 48($t1)
sw $ra, ($sp)
subu $sp, $sp, 4
sw $fp, ($sp)
subu $sp, $sp, 4
move $fp, $sp
jal $t2
lw $t0, 4($sp)
addu $sp, $sp, 4
move $sp, $fp
addu $sp, $sp, 4
lw $fp, ($sp)
addu $sp, $sp, 4
lw $ra, ($sp)
addu $sp, $sp, 12
sw $t0, ($sp)
subu $sp, $sp, 4
lw $a0, 12($fp)
sw $a0, 0($sp)
subu $sp, $sp, 4
lw $t0, 4($sp)
la $t1, void_error
sw $t1, ($sp)
subu $sp, $sp, 4
beqz $t0, .raise
addu $sp, $sp, 4
lw $t1, ($t0)
lw $t2, 64($t1)
sw $ra, ($sp)
subu $sp, $sp, 4
sw $fp, ($sp)
subu $sp, $sp, 4
move $fp, $sp
jal $t2
lw $t0, 4($sp)
addu $sp, $sp, 4
move $sp, $fp
addu $sp, $sp, 4
lw $fp, ($sp)
addu $sp, $sp, 4
lw $ra, ($sp)
addu $sp, $sp, 8
sw $t0, ($sp)
subu $sp, $sp, 4
lw $a0, 12($fp)
sw $a0, 0($sp)
subu $sp, $sp, 4
lw $t0, 4($sp)
la $t1, void_error
sw $t1, ($sp)
subu $sp, $sp, 4
beqz $t0, .raise
addu $sp, $sp, 4
lw $t1, ($t0)
lw $t2, 52($t1)
sw $ra, ($sp)
subu $sp, $sp, 4
sw $fp, ($sp)
subu $sp, $sp, 4
move $fp, $sp
jal $t2
lw $t0, 4($sp)
addu $sp, $sp, 4
move $sp, $fp
addu $sp, $sp, 4
lw $fp, ($sp)
addu $sp, $sp, 4
lw $ra, ($sp)
addu $sp, $sp, 4
sw $t0, ($sp)
subu $sp, $sp, 4
lw $a0, 12($fp)
sw $a0, 0($sp)
subu $sp, $sp, 4
lw $t0, 4($sp)
la $t1, void_error
sw $t1, ($sp)
subu $sp, $sp, 4
beqz $t0, .raise
addu $sp, $sp, 4
lw $t1, ($t0)
lw $t2, 52($t1)
sw $ra, ($sp)
subu $sp, $sp, 4
sw $fp, ($sp)
subu $sp, $sp, 4
move $fp, $sp
jal $t2
lw $t0, 4($sp)
addu $sp, $sp, 4
move $sp, $fp
addu $sp, $sp, 4
lw $fp, ($sp)
addu $sp, $sp, 4
lw $ra, ($sp)
addu $sp, $sp, 4
sw $t0, ($sp)
subu $sp, $sp, 4
lw $a0, 12($fp)
sw $a0, 0($sp)
subu $sp, $sp, 4
lw $t0, 4($sp)
la $t1, void_error
sw $t1, ($sp)
subu $sp, $sp, 4
beqz $t0, .raise
addu $sp, $sp, 4
lw $t1, ($t0)
lw $t2, 48($t1)
sw $ra, ($sp)
subu $sp, $sp, 4
sw $fp, ($sp)
subu $sp, $sp, 4
move $fp, $sp
jal $t2
lw $t0, 4($sp)
addu $sp, $sp, 4
move $sp, $fp
addu $sp, $sp, 4
lw $fp, ($sp)
addu $sp, $sp, 4
lw $ra, ($sp)
addu $sp, $sp, 12
sw $t0, ($sp)
subu $sp, $sp, 4
lw $a0, 12($fp)
sw $a0, 0($sp)
subu $sp, $sp, 4
lw $t0, 4($sp)
la $t1, void_error
sw $t1, ($sp)
subu $sp, $sp, 4
beqz $t0, .raise
addu $sp, $sp, 4
lw $t1, ($t0)
lw $t2, 76($t1)
sw $ra, ($sp)
subu $sp, $sp, 4
sw $fp, ($sp)
subu $sp, $sp, 4
move $fp, $sp
jal $t2
lw $t0, 4($sp)
addu $sp, $sp, 4
move $sp, $fp
addu $sp, $sp, 4
lw $fp, ($sp)
addu $sp, $sp, 4
lw $ra, ($sp)
addu $sp, $sp, 8
sw $t0, ($sp)
subu $sp, $sp, 4
lw $a0, 12($fp)
sw $a0, 0($sp)
subu $sp, $sp, 4
lw $t0, 4($sp)
la $t1, void_error
sw $t1, ($sp)
subu $sp, $sp, 4
beqz $t0, .raise
addu $sp, $sp, 4
lw $t1, ($t0)
lw $t2, 60($t1)
sw $ra, ($sp)
subu $sp, $sp, 4
sw $fp, ($sp)
subu $sp, $sp, 4
move $fp, $sp
jal $t2
lw $t0, 4($sp)
addu $sp, $sp, 4
move $sp, $fp
addu $sp, $sp, 4
lw $fp, ($sp)
addu $sp, $sp, 4
lw $ra, ($sp)
addu $sp, $sp, 4
sw $t0, ($sp)
subu $sp, $sp, 4
lw $a0, 12($fp)
sw $a0, 0($sp)
subu $sp, $sp, 4
lw $t0, 4($sp)
la $t1, void_error
sw $t1, ($sp)
subu $sp, $sp, 4
beqz $t0, .raise
addu $sp, $sp, 4
lw $t1, ($t0)
lw $t2, 56($t1)
sw $ra, ($sp)
subu $sp, $sp, 4
sw $fp, ($sp)
subu $sp, $sp, 4
move $fp, $sp
jal $t2
lw $t0, 4($sp)
addu $sp, $sp, 4
move $sp, $fp
addu $sp, $sp, 4
lw $fp, ($sp)
addu $sp, $sp, 4
lw $ra, ($sp)
addu $sp, $sp, 4
sw $t0, ($sp)
subu $sp, $sp, 4
lw $a0, 12($fp)
sw $a0, 0($sp)
subu $sp, $sp, 4
lw $t0, 4($sp)
la $t1, void_error
sw $t1, ($sp)
subu $sp, $sp, 4
beqz $t0, .raise
addu $sp, $sp, 4
lw $t1, ($t0)
lw $t2, 48($t1)
sw $ra, ($sp)
subu $sp, $sp, 4
sw $fp, ($sp)
subu $sp, $sp, 4
move $fp, $sp
jal $t2
lw $t0, 4($sp)
addu $sp, $sp, 4
move $sp, $fp
addu $sp, $sp, 4
lw $fp, ($sp)
addu $sp, $sp, 4
lw $ra, ($sp)
addu $sp, $sp, 12
sw $t0, ($sp)
subu $sp, $sp, 4
lw $a0, 12($fp)
sw $a0, 0($sp)
subu $sp, $sp, 4
lw $t0, 4($sp)
la $t1, void_error
sw $t1, ($sp)
subu $sp, $sp, 4
beqz $t0, .raise
addu $sp, $sp, 4
lw $t1, ($t0)
lw $t2, 52($t1)
sw $ra, ($sp)
subu $sp, $sp, 4
sw $fp, ($sp)
subu $sp, $sp, 4
move $fp, $sp
jal $t2
lw $t0, 4($sp)
addu $sp, $sp, 4
move $sp, $fp
addu $sp, $sp, 4
lw $fp, ($sp)
addu $sp, $sp, 4
lw $ra, ($sp)
addu $sp, $sp, 4
sw $t0, ($sp)
subu $sp, $sp, 4
lw $a0, 12($fp)
sw $a0, 0($sp)
subu $sp, $sp, 4
lw $t0, 4($sp)
la $t1, void_error
sw $t1, ($sp)
subu $sp, $sp, 4
beqz $t0, .raise
addu $sp, $sp, 4
lw $t1, ($t0)
lw $t2, 48($t1)
sw $ra, ($sp)
subu $sp, $sp, 4
sw $fp, ($sp)
subu $sp, $sp, 4
move $fp, $sp
jal $t2
lw $t0, 4($sp)
addu $sp, $sp, 4
move $sp, $fp
addu $sp, $sp, 4
lw $fp, ($sp)
addu $sp, $sp, 4
lw $ra, ($sp)
addu $sp, $sp, 12
sw $t0, ($sp)
subu $sp, $sp, 4
lw $a0, 12($fp)
sw $a0, 0($sp)
subu $sp, $sp, 4
lw $t0, 4($sp)
la $t1, void_error
sw $t1, ($sp)
subu $sp, $sp, 4
beqz $t0, .raise
addu $sp, $sp, 4
lw $t1, ($t0)
lw $t2, 52($t1)
sw $ra, ($sp)
subu $sp, $sp, 4
sw $fp, ($sp)
subu $sp, $sp, 4
move $fp, $sp
jal $t2
lw $t0, 4($sp)
addu $sp, $sp, 4
move $sp, $fp
addu $sp, $sp, 4
lw $fp, ($sp)
addu $sp, $sp, 4
lw $ra, ($sp)
addu $sp, $sp, 4
sw $t0, ($sp)
subu $sp, $sp, 4
lw $a0, 12($fp)
sw $a0, 0($sp)
subu $sp, $sp, 4
lw $t0, 4($sp)
la $t1, void_error
sw $t1, ($sp)
subu $sp, $sp, 4
beqz $t0, .raise
addu $sp, $sp, 4
lw $t1, ($t0)
lw $t2, 48($t1)
sw $ra, ($sp)
subu $sp, $sp, 4
sw $fp, ($sp)
subu $sp, $sp, 4
move $fp, $sp
jal $t2
lw $t0, 4($sp)
addu $sp, $sp, 4
move $sp, $fp
addu $sp, $sp, 4
lw $fp, ($sp)
addu $sp, $sp, 4
lw $ra, ($sp)
addu $sp, $sp, 12
sw $t0, ($sp)
subu $sp, $sp, 4
lw $a0, 12($fp)
sw $a0, 0($sp)
subu $sp, $sp, 4
lw $t0, 4($sp)
la $t1, void_error
sw $t1, ($sp)
subu $sp, $sp, 4
beqz $t0, .raise
addu $sp, $sp, 4
lw $t1, ($t0)
lw $t2, 76($t1)
sw $ra, ($sp)
subu $sp, $sp, 4
sw $fp, ($sp)
subu $sp, $sp, 4
move $fp, $sp
jal $t2
lw $t0, 4($sp)
addu $sp, $sp, 4
move $sp, $fp
addu $sp, $sp, 4
lw $fp, ($sp)
addu $sp, $sp, 4
lw $ra, ($sp)
addu $sp, $sp, 8
sw $t0, ($sp)
subu $sp, $sp, 4
lw $a0, 12($fp)
sw $a0, 0($sp)
subu $sp, $sp, 4
lw $t0, 4($sp)
la $t1, void_error
sw $t1, ($sp)
subu $sp, $sp, 4
beqz $t0, .raise
addu $sp, $sp, 4
lw $t1, ($t0)
lw $t2, 52($t1)
sw $ra, ($sp)
subu $sp, $sp, 4
sw $fp, ($sp)
subu $sp, $sp, 4
move $fp, $sp
jal $t2
lw $t0, 4($sp)
addu $sp, $sp, 4
move $sp, $fp
addu $sp, $sp, 4
lw $fp, ($sp)
addu $sp, $sp, 4
lw $ra, ($sp)
addu $sp, $sp, 4
sw $t0, ($sp)
subu $sp, $sp, 4
lw $a0, 12($fp)
sw $a0, 0($sp)
subu $sp, $sp, 4
lw $t0, 4($sp)
la $t1, void_error
sw $t1, ($sp)
subu $sp, $sp, 4
beqz $t0, .raise
addu $sp, $sp, 4
lw $t1, ($t0)
lw $t2, 56($t1)
sw $ra, ($sp)
subu $sp, $sp, 4
sw $fp, ($sp)
subu $sp, $sp, 4
move $fp, $sp
jal $t2
lw $t0, 4($sp)
addu $sp, $sp, 4
move $sp, $fp
addu $sp, $sp, 4
lw $fp, ($sp)
addu $sp, $sp, 4
lw $ra, ($sp)
addu $sp, $sp, 4
sw $t0, ($sp)
subu $sp, $sp, 4
lw $a0, 12($fp)
sw $a0, 0($sp)
subu $sp, $sp, 4
lw $t0, 4($sp)
la $t1, void_error
sw $t1, ($sp)
subu $sp, $sp, 4
beqz $t0, .raise
addu $sp, $sp, 4
lw $t1, ($t0)
lw $t2, 48($t1)
sw $ra, ($sp)
subu $sp, $sp, 4
sw $fp, ($sp)
subu $sp, $sp, 4
move $fp, $sp
jal $t2
lw $t0, 4($sp)
addu $sp, $sp, 4
move $sp, $fp
addu $sp, $sp, 4
lw $fp, ($sp)
addu $sp, $sp, 4
lw $ra, ($sp)
addu $sp, $sp, 12
sw $t0, ($sp)
subu $sp, $sp, 4
lw $a0, 12($fp)
sw $a0, 0($sp)
subu $sp, $sp, 4
lw $t0, 4($sp)
la $t1, void_error
sw $t1, ($sp)
subu $sp, $sp, 4
beqz $t0, .raise
addu $sp, $sp, 4
lw $t1, ($t0)
lw $t2, 60($t1)
sw $ra, ($sp)
subu $sp, $sp, 4
sw $fp, ($sp)
subu $sp, $sp, 4
move $fp, $sp
jal $t2
lw $t0, 4($sp)
addu $sp, $sp, 4
move $sp, $fp
addu $sp, $sp, 4
lw $fp, ($sp)
addu $sp, $sp, 4
lw $ra, ($sp)
addu $sp, $sp, 4
sw $t0, ($sp)
subu $sp, $sp, 4
lw $a0, 12($fp)
sw $a0, 0($sp)
subu $sp, $sp, 4
lw $t0, 4($sp)
la $t1, void_error
sw $t1, ($sp)
subu $sp, $sp, 4
beqz $t0, .raise
addu $sp, $sp, 4
lw $t1, ($t0)
lw $t2, 48($t1)
sw $ra, ($sp)
subu $sp, $sp, 4
sw $fp, ($sp)
subu $sp, $sp, 4
move $fp, $sp
jal $t2
lw $t0, 4($sp)
addu $sp, $sp, 4
move $sp, $fp
addu $sp, $sp, 4
lw $fp, ($sp)
addu $sp, $sp, 4
lw $ra, ($sp)
addu $sp, $sp, 12
sw $t0, ($sp)
subu $sp, $sp, 4
lw $a0, 12($fp)
sw $a0, 0($sp)
subu $sp, $sp, 4
lw $t0, 4($sp)
la $t1, void_error
sw $t1, ($sp)
subu $sp, $sp, 4
beqz $t0, .raise
addu $sp, $sp, 4
lw $t1, ($t0)
lw $t2, 60($t1)
sw $ra, ($sp)
subu $sp, $sp, 4
sw $fp, ($sp)
subu $sp, $sp, 4
move $fp, $sp
jal $t2
lw $t0, 4($sp)
addu $sp, $sp, 4
move $sp, $fp
addu $sp, $sp, 4
lw $fp, ($sp)
addu $sp, $sp, 4
lw $ra, ($sp)
addu $sp, $sp, 4
sw $t0, ($sp)
subu $sp, $sp, 4
lw $a0, 12($fp)
sw $a0, 0($sp)
subu $sp, $sp, 4
lw $t0, 4($sp)
la $t1, void_error
sw $t1, ($sp)
subu $sp, $sp, 4
beqz $t0, .raise
addu $sp, $sp, 4
lw $t1, ($t0)
lw $t2, 48($t1)
sw $ra, ($sp)
subu $sp, $sp, 4
sw $fp, ($sp)
subu $sp, $sp, 4
move $fp, $sp
jal $t2
lw $t0, 4($sp)
addu $sp, $sp, 4
move $sp, $fp
addu $sp, $sp, 4
lw $fp, ($sp)
addu $sp, $sp, 4
lw $ra, ($sp)
addu $sp, $sp, 12
sw $t0, ($sp)
subu $sp, $sp, 4
lw $a0, 12($fp)
sw $a0, 0($sp)
subu $sp, $sp, 4
lw $t0, 4($sp)
la $t1, void_error
sw $t1, ($sp)
subu $sp, $sp, 4
beqz $t0, .raise
addu $sp, $sp, 4
lw $t1, ($t0)
lw $t2, 56($t1)
sw $ra, ($sp)
subu $sp, $sp, 4
sw $fp, ($sp)
subu $sp, $sp, 4
move $fp, $sp
jal $t2
lw $t0, 4($sp)
addu $sp, $sp, 4
move $sp, $fp
addu $sp, $sp, 4
lw $fp, ($sp)
addu $sp, $sp, 4
lw $ra, ($sp)
addu $sp, $sp, 4
sw $t0, ($sp)
subu $sp, $sp, 4
lw $a0, 12($fp)
sw $a0, 0($sp)
subu $sp, $sp, 4
lw $t0, 4($sp)
la $t1, void_error
sw $t1, ($sp)
subu $sp, $sp, 4
beqz $t0, .raise
addu $sp, $sp, 4
lw $t1, ($t0)
lw $t2, 48($t1)
sw $ra, ($sp)
subu $sp, $sp, 4
sw $fp, ($sp)
subu $sp, $sp, 4
move $fp, $sp
jal $t2
lw $t0, 4($sp)
addu $sp, $sp, 4
move $sp, $fp
addu $sp, $sp, 4
lw $fp, ($sp)
addu $sp, $sp, 4
lw $ra, ($sp)
addu $sp, $sp, 12
sw $t0, ($sp)
subu $sp, $sp, 4
lw $a0, 12($fp)
sw $a0, 0($sp)
subu $sp, $sp, 4
lw $t0, 4($sp)
la $t1, void_error
sw $t1, ($sp)
subu $sp, $sp, 4
beqz $t0, .raise
addu $sp, $sp, 4
lw $t1, ($t0)
lw $t2, 60($t1)
sw $ra, ($sp)
subu $sp, $sp, 4
sw $fp, ($sp)
subu $sp, $sp, 4
move $fp, $sp
jal $t2
lw $t0, 4($sp)
addu $sp, $sp, 4
move $sp, $fp
addu $sp, $sp, 4
lw $fp, ($sp)
addu $sp, $sp, 4
lw $ra, ($sp)
addu $sp, $sp, 4
sw $t0, ($sp)
subu $sp, $sp, 4
lw $a0, 12($fp)
sw $a0, 0($sp)
subu $sp, $sp, 4
lw $t0, 4($sp)
la $t1, void_error
sw $t1, ($sp)
subu $sp, $sp, 4
beqz $t0, .raise
addu $sp, $sp, 4
lw $t1, ($t0)
lw $t2, 48($t1)
sw $ra, ($sp)
subu $sp, $sp, 4
sw $fp, ($sp)
subu $sp, $sp, 4
move $fp, $sp
jal $t2
lw $t0, 4($sp)
addu $sp, $sp, 4
move $sp, $fp
addu $sp, $sp, 4
lw $fp, ($sp)
addu $sp, $sp, 4
lw $ra, ($sp)
addu $sp, $sp, 12
sw $t0, ($sp)
subu $sp, $sp, 4
lw $a0, 12($fp)
sw $a0, 0($sp)
subu $sp, $sp, 4
lw $t0, 4($sp)
la $t1, void_error
sw $t1, ($sp)
subu $sp, $sp, 4
beqz $t0, .raise
addu $sp, $sp, 4
lw $t1, ($t0)
lw $t2, 52($t1)
sw $ra, ($sp)
subu $sp, $sp, 4
sw $fp, ($sp)
subu $sp, $sp, 4
move $fp, $sp
jal $t2
lw $t0, 4($sp)
addu $sp, $sp, 4
move $sp, $fp
addu $sp, $sp, 4
lw $fp, ($sp)
addu $sp, $sp, 4
lw $ra, ($sp)
addu $sp, $sp, 4
sw $t0, ($sp)
subu $sp, $sp, 4
lw $a0, 12($fp)
sw $a0, 0($sp)
subu $sp, $sp, 4
lw $t0, 4($sp)
la $t1, void_error
sw $t1, ($sp)
subu $sp, $sp, 4
beqz $t0, .raise
addu $sp, $sp, 4
lw $t1, ($t0)
lw $t2, 48($t1)
sw $ra, ($sp)
subu $sp, $sp, 4
sw $fp, ($sp)
subu $sp, $sp, 4
move $fp, $sp
jal $t2
lw $t0, 4($sp)
addu $sp, $sp, 4
move $sp, $fp
addu $sp, $sp, 4
lw $fp, ($sp)
addu $sp, $sp, 4
lw $ra, ($sp)
addu $sp, $sp, 12
sw $t0, ($sp)
subu $sp, $sp, 4
lw $a0, 12($fp)
sw $a0, 0($sp)
subu $sp, $sp, 4
lw $t0, 4($sp)
la $t1, void_error
sw $t1, ($sp)
subu $sp, $sp, 4
beqz $t0, .raise
addu $sp, $sp, 4
lw $t1, ($t0)
lw $t2, 56($t1)
sw $ra, ($sp)
subu $sp, $sp, 4
sw $fp, ($sp)
subu $sp, $sp, 4
move $fp, $sp
jal $t2
lw $t0, 4($sp)
addu $sp, $sp, 4
move $sp, $fp
addu $sp, $sp, 4
lw $fp, ($sp)
addu $sp, $sp, 4
lw $ra, ($sp)
addu $sp, $sp, 4
sw $t0, ($sp)
subu $sp, $sp, 4
lw $a0, 12($fp)
sw $a0, 0($sp)
subu $sp, $sp, 4
lw $t0, 4($sp)
la $t1, void_error
sw $t1, ($sp)
subu $sp, $sp, 4
beqz $t0, .raise
addu $sp, $sp, 4
lw $t1, ($t0)
lw $t2, 48($t1)
sw $ra, ($sp)
subu $sp, $sp, 4
sw $fp, ($sp)
subu $sp, $sp, 4
move $fp, $sp
jal $t2
lw $t0, 4($sp)
addu $sp, $sp, 4
move $sp, $fp
addu $sp, $sp, 4
lw $fp, ($sp)
addu $sp, $sp, 4
lw $ra, ($sp)
addu $sp, $sp, 12
sw $t0, ($sp)
subu $sp, $sp, 4
lw $a0, 12($fp)
sw $a0, 0($sp)
subu $sp, $sp, 4
lw $t0, 4($sp)
la $t1, void_error
sw $t1, ($sp)
subu $sp, $sp, 4
beqz $t0, .raise
addu $sp, $sp, 4
lw $t1, ($t0)
lw $t2, 52($t1)
sw $ra, ($sp)
subu $sp, $sp, 4
sw $fp, ($sp)
subu $sp, $sp, 4
move $fp, $sp
jal $t2
lw $t0, 4($sp)
addu $sp, $sp, 4
move $sp, $fp
addu $sp, $sp, 4
lw $fp, ($sp)
addu $sp, $sp, 4
lw $ra, ($sp)
addu $sp, $sp, 4
sw $t0, ($sp)
subu $sp, $sp, 4
lw $a0, 12($fp)
sw $a0, 0($sp)
subu $sp, $sp, 4
lw $t0, 4($sp)
la $t1, void_error
sw $t1, ($sp)
subu $sp, $sp, 4
beqz $t0, .raise
addu $sp, $sp, 4
lw $t1, ($t0)
lw $t2, 48($t1)
sw $ra, ($sp)
subu $sp, $sp, 4
sw $fp, ($sp)
subu $sp, $sp, 4
move $fp, $sp
jal $t2
lw $t0, 4($sp)
addu $sp, $sp, 4
move $sp, $fp
addu $sp, $sp, 4
lw $fp, ($sp)
addu $sp, $sp, 4
lw $ra, ($sp)
addu $sp, $sp, 12
sw $t0, ($sp)
subu $sp, $sp, 4
lw $a0, 12($fp)
sw $a0, 0($sp)
subu $sp, $sp, 4
lw $t0, 4($sp)
la $t1, void_error
sw $t1, ($sp)
subu $sp, $sp, 4
beqz $t0, .raise
addu $sp, $sp, 4
lw $t1, ($t0)
lw $t2, 76($t1)
sw $ra, ($sp)
subu $sp, $sp, 4
sw $fp, ($sp)
subu $sp, $sp, 4
move $fp, $sp
jal $t2
lw $t0, 4($sp)
addu $sp, $sp, 4
move $sp, $fp
addu $sp, $sp, 4
lw $fp, ($sp)
addu $sp, $sp, 4
lw $ra, ($sp)
addu $sp, $sp, 8
sw $t0, ($sp)
subu $sp, $sp, 4
lw $a0, 12($fp)
sw $a0, 0($sp)
subu $sp, $sp, 4
lw $t0, 4($sp)
la $t1, void_error
sw $t1, ($sp)
subu $sp, $sp, 4
beqz $t0, .raise
addu $sp, $sp, 4
lw $t1, ($t0)
lw $t2, 52($t1)
sw $ra, ($sp)
subu $sp, $sp, 4
sw $fp, ($sp)
subu $sp, $sp, 4
move $fp, $sp
jal $t2
lw $t0, 4($sp)
addu $sp, $sp, 4
move $sp, $fp
addu $sp, $sp, 4
lw $fp, ($sp)
addu $sp, $sp, 4
lw $ra, ($sp)
addu $sp, $sp, 4
sw $t0, ($sp)
subu $sp, $sp, 4
lw $a0, 12($fp)
sw $a0, 0($sp)
subu $sp, $sp, 4
lw $t0, 4($sp)
la $t1, void_error
sw $t1, ($sp)
subu $sp, $sp, 4
beqz $t0, .raise
addu $sp, $sp, 4
lw $t1, ($t0)
lw $t2, 56($t1)
sw $ra, ($sp)
subu $sp, $sp, 4
sw $fp, ($sp)
subu $sp, $sp, 4
move $fp, $sp
jal $t2
lw $t0, 4($sp)
addu $sp, $sp, 4
move $sp, $fp
addu $sp, $sp, 4
lw $fp, ($sp)
addu $sp, $sp, 4
lw $ra, ($sp)
addu $sp, $sp, 4
sw $t0, ($sp)
subu $sp, $sp, 4
lw $a0, 12($fp)
sw $a0, 0($sp)
subu $sp, $sp, 4
lw $t0, 4($sp)
la $t1, void_error
sw $t1, ($sp)
subu $sp, $sp, 4
beqz $t0, .raise
addu $sp, $sp, 4
lw $t1, ($t0)
lw $t2, 60($t1)
sw $ra, ($sp)
subu $sp, $sp, 4
sw $fp, ($sp)
subu $sp, $sp, 4
move $fp, $sp
jal $t2
lw $t0, 4($sp)
addu $sp, $sp, 4
move $sp, $fp
addu $sp, $sp, 4
lw $fp, ($sp)
addu $sp, $sp, 4
lw $ra, ($sp)
addu $sp, $sp, 4
sw $t0, ($sp)
subu $sp, $sp, 4
lw $a0, 12($fp)
sw $a0, 0($sp)
subu $sp, $sp, 4
lw $t0, 4($sp)
la $t1, void_error
sw $t1, ($sp)
subu $sp, $sp, 4
beqz $t0, .raise
addu $sp, $sp, 4
lw $t1, ($t0)
lw $t2, 48($t1)
sw $ra, ($sp)
subu $sp, $sp, 4
sw $fp, ($sp)
subu $sp, $sp, 4
move $fp, $sp
jal $t2
lw $t0, 4($sp)
addu $sp, $sp, 4
move $sp, $fp
addu $sp, $sp, 4
lw $fp, ($sp)
addu $sp, $sp, 4
lw $ra, ($sp)
addu $sp, $sp, 12
sw $t0, ($sp)
subu $sp, $sp, 4
lw $a0, 12($fp)
sw $a0, 0($sp)
subu $sp, $sp, 4
lw $t0, 4($sp)
la $t1, void_error
sw $t1, ($sp)
subu $sp, $sp, 4
beqz $t0, .raise
addu $sp, $sp, 4
lw $t1, ($t0)
lw $t2, 48($t1)
sw $ra, ($sp)
subu $sp, $sp, 4
sw $fp, ($sp)
subu $sp, $sp, 4
move $fp, $sp
jal $t2
lw $t0, 4($sp)
addu $sp, $sp, 4
move $sp, $fp
addu $sp, $sp, 4
lw $fp, ($sp)
addu $sp, $sp, 4
lw $ra, ($sp)
addu $sp, $sp, 12
sw $t0, ($sp)
subu $sp, $sp, 4
lw $a0, 12($fp)
sw $a0, 0($sp)
subu $sp, $sp, 4
lw $t0, 4($sp)
la $t1, void_error
sw $t1, ($sp)
subu $sp, $sp, 4
beqz $t0, .raise
addu $sp, $sp, 4
lw $t1, ($t0)
lw $t2, 56($t1)
sw $ra, ($sp)
subu $sp, $sp, 4
sw $fp, ($sp)
subu $sp, $sp, 4
move $fp, $sp
jal $t2
lw $t0, 4($sp)
addu $sp, $sp, 4
move $sp, $fp
addu $sp, $sp, 4
lw $fp, ($sp)
addu $sp, $sp, 4
lw $ra, ($sp)
addu $sp, $sp, 4
sw $t0, ($sp)
subu $sp, $sp, 4
lw $a0, 12($fp)
sw $a0, 0($sp)
subu $sp, $sp, 4
lw $t0, 4($sp)
la $t1, void_error
sw $t1, ($sp)
subu $sp, $sp, 4
beqz $t0, .raise
addu $sp, $sp, 4
lw $t1, ($t0)
lw $t2, 60($t1)
sw $ra, ($sp)
subu $sp, $sp, 4
sw $fp, ($sp)
subu $sp, $sp, 4
move $fp, $sp
jal $t2
lw $t0, 4($sp)
addu $sp, $sp, 4
move $sp, $fp
addu $sp, $sp, 4
lw $fp, ($sp)
addu $sp, $sp, 4
lw $ra, ($sp)
addu $sp, $sp, 4
sw $t0, ($sp)
subu $sp, $sp, 4
lw $a0, 12($fp)
sw $a0, 0($sp)
subu $sp, $sp, 4
lw $t0, 4($sp)
la $t1, void_error
sw $t1, ($sp)
subu $sp, $sp, 4
beqz $t0, .raise
addu $sp, $sp, 4
lw $t1, ($t0)
lw $t2, 60($t1)
sw $ra, ($sp)
subu $sp, $sp, 4
sw $fp, ($sp)
subu $sp, $sp, 4
move $fp, $sp
jal $t2
lw $t0, 4($sp)
addu $sp, $sp, 4
move $sp, $fp
addu $sp, $sp, 4
lw $fp, ($sp)
addu $sp, $sp, 4
lw $ra, ($sp)
addu $sp, $sp, 4
sw $t0, ($sp)
subu $sp, $sp, 4
lw $a0, 12($fp)
sw $a0, 0($sp)
subu $sp, $sp, 4
lw $t0, 4($sp)
la $t1, void_error
sw $t1, ($sp)
subu $sp, $sp, 4
beqz $t0, .raise
addu $sp, $sp, 4
lw $t1, ($t0)
lw $t2, 48($t1)
sw $ra, ($sp)
subu $sp, $sp, 4
sw $fp, ($sp)
subu $sp, $sp, 4
move $fp, $sp
jal $t2
lw $t0, 4($sp)
addu $sp, $sp, 4
move $sp, $fp
addu $sp, $sp, 4
lw $fp, ($sp)
addu $sp, $sp, 4
lw $ra, ($sp)
addu $sp, $sp, 12
sw $t0, ($sp)
subu $sp, $sp, 4
lw $a0, 12($fp)
sw $a0, 0($sp)
subu $sp, $sp, 4
lw $t0, 4($sp)
la $t1, void_error
sw $t1, ($sp)
subu $sp, $sp, 4
beqz $t0, .raise
addu $sp, $sp, 4
lw $t1, ($t0)
lw $t2, 48($t1)
sw $ra, ($sp)
subu $sp, $sp, 4
sw $fp, ($sp)
subu $sp, $sp, 4
move $fp, $sp
jal $t2
lw $t0, 4($sp)
addu $sp, $sp, 4
move $sp, $fp
addu $sp, $sp, 4
lw $fp, ($sp)
addu $sp, $sp, 4
lw $ra, ($sp)
addu $sp, $sp, 12
sw $t0, ($sp)
subu $sp, $sp, 4
lw $a0, 12($fp)
sw $a0, 0($sp)
subu $sp, $sp, 4
lw $t0, 4($sp)
la $t1, void_error
sw $t1, ($sp)
subu $sp, $sp, 4
beqz $t0, .raise
addu $sp, $sp, 4
lw $t1, ($t0)
lw $t2, 48($t1)
sw $ra, ($sp)
subu $sp, $sp, 4
sw $fp, ($sp)
subu $sp, $sp, 4
move $fp, $sp
jal $t2
lw $t0, 4($sp)
addu $sp, $sp, 4
move $sp, $fp
addu $sp, $sp, 4
lw $fp, ($sp)
addu $sp, $sp, 4
lw $ra, ($sp)
addu $sp, $sp, 12
sw $t0, ($sp)
subu $sp, $sp, 4
lw $a0, 12($fp)
sw $a0, 0($sp)
subu $sp, $sp, 4
lw $t0, 4($sp)
la $t1, void_error
sw $t1, ($sp)
subu $sp, $sp, 4
beqz $t0, .raise
addu $sp, $sp, 4
lw $t1, ($t0)
lw $t2, 76($t1)
sw $ra, ($sp)
subu $sp, $sp, 4
sw $fp, ($sp)
subu $sp, $sp, 4
move $fp, $sp
jal $t2
lw $t0, 4($sp)
addu $sp, $sp, 4
move $sp, $fp
addu $sp, $sp, 4
lw $fp, ($sp)
addu $sp, $sp, 4
lw $ra, ($sp)
addu $sp, $sp, 8
sw $t0, ($sp)
subu $sp, $sp, 4
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
lw $a0, 4($sp)
addu, $sp, $sp, 52
sw $a0, ($sp)
subu, $sp, $sp, 4
jr $ra
.Main.Main:
li $t0, 0 #.Main.Main
lw $a0, 12($fp)
sw $a0, 0($sp)
subu $sp, $sp, 4
lw $a0, 4($sp)
addu, $sp, $sp, 4
sw $a0, ($sp)
subu, $sp, $sp, 4
jr $ra
# Start .data segment (data!)
.data
zero_error: .asciiz "Divition by zero exception"
index_error: .asciiz "Invalid index exception"
void_error: .asciiz "Objects must be inizializated before use exception"
case_error: .asciiz "Case expression no match exception"
void_str: .asciiz ""
msg0: .asciiz "
"
msg1: .asciiz " "
msg2: .asciiz "
Error: Expr is pure virtual; can't print self
"
msg3: .asciiz "
Error: Expr is pure virtual; can't beta-reduce
"
msg4: .asciiz "
Error: Expr is pure virtual; can't substitute
"
msg5: .asciiz "
Error: Expr is pure virtual; can't gen_code
"
msg6: .asciiz "get_parent()."
msg7: .asciiz "Error:  free occurrence of "
msg8: .asciiz "
"
msg9: .asciiz "get_x()"
msg10: .asciiz ""
msg11: .asciiz "\"
msg12: .asciiz "."
msg13: .asciiz "((new Closure"
msg14: .asciiz ").init("
msg15: .asciiz "new Closure))"
msg16: .asciiz "self))"
msg17: .asciiz "class Closure"
msg18: .asciiz " inherits Closure {
"
msg19: .asciiz "  apply(y : EvalObject) : EvalObject {
"
msg20: .asciiz "    { out_string("Applying closure "
msg21: .asciiz "\n");
"
msg22: .asciiz "      x <- y;
"
msg23: .asciiz ";}};
"
msg24: .asciiz "};
"
msg25: .asciiz "(("
msg26: .asciiz ")@("
msg27: .asciiz "))"
msg28: .asciiz "(let x : EvalObject <- "
msg29: .asciiz ",
"
msg30: .asciiz "     y : EvalObject <- "
msg31: .asciiz " in
"
msg32: .asciiz "  case x of
"
msg33: .asciiz "    c : Closure => c.apply(y);
"
msg34: .asciiz "    o : Object => { abort(); new EvalObject; };
"
msg35: .asciiz "  esac)"
msg36: .asciiz "x"
msg37: .asciiz "x"
msg38: .asciiz "y"
msg39: .asciiz "x"
msg40: .asciiz "y"
msg41: .asciiz "z"
msg42: .asciiz "beta-reduce: "
msg43: .asciiz " =>
"
msg44: .asciiz "
"
msg45: .asciiz "class EvalObject inherits IO {
"
msg46: .asciiz "  eval() : EvalObject { { abort(); self; } };
"
msg47: .asciiz "};
"
msg48: .asciiz "class Closure inherits EvalObject {
"
msg49: .asciiz "  parent : Closure;
"
msg50: .asciiz "  x : EvalObject;
"
msg51: .asciiz "  get_parent() : Closure { parent };
"
msg52: .asciiz "  get_x() : EvalObject { x };
"
msg53: .asciiz "  init(p : Closure) : Closure {{ parent <- p; self; }};
"
msg54: .asciiz "  apply(y : EvalObject) : EvalObject { { abort(); self; } };
"
msg55: .asciiz "};
"
msg56: .asciiz "Generating code for "
msg57: .asciiz "
------------------cut here------------------
"
msg58: .asciiz "(*Generated by lam.cl (Jeff Foster, March 2000)*)
"
msg59: .asciiz "class Main {
"
msg60: .asciiz "  main() : EvalObject {
"
msg61: .asciiz "
};
};
"
msg62: .asciiz "
------------------cut here------------------
"
msg63: .asciiz "
"
msg64: .asciiz "
"
msg65: .asciiz "
"
buffer: .space 1024
type_str0: .asciiz "Object"
type_str1: .asciiz "Int"
type_str2: .asciiz "Bool"
type_str3: .asciiz "String"
type_str4: .asciiz "IO"
type_str5: .asciiz "VarList"
type_str6: .asciiz "VarListNE"
type_str7: .asciiz "LambdaList"
type_str8: .asciiz "LambdaListNE"
type_str9: .asciiz "LambdaListRef"
type_str10: .asciiz "Expr"
type_str11: .asciiz "Variable"
type_str12: .asciiz "Lambda"
type_str13: .asciiz "App"
type_str14: .asciiz "Term"
type_str15: .asciiz "Main"
Object: .word 0, 31, type_str0, .Object.abort, .Object.type_name, .Object.copy
Int: .word 1, 2, type_str1, .Object.abort, .Object.type_name, .Object.copy
Bool: .word 3, 4, type_str2, .Object.abort, .Object.type_name, .Object.copy
String: .word 5, 6, type_str3, .Object.abort, .Object.type_name, .Object.copy, .String.length, .String.concat, .String.substr
IO: .word 7, 24, type_str4, .Object.abort, .Object.type_name, .Object.copy, .IO.out_string, .IO.out_int, .IO.in_string, .IO.in_int
VarList: .word 8, 11, type_str5, .Object.abort, .Object.type_name, .Object.copy, .IO.out_string, .IO.out_int, .IO.in_string, .IO.in_int, .VarList.isNil, .VarList.head, .VarList.tail, .VarList.add, .VarList.print
VarListNE: .word 9, 10, type_str6, .Object.abort, .Object.type_name, .Object.copy, .IO.out_string, .IO.out_int, .IO.in_string, .IO.in_int, .VarListNE.isNil, .VarListNE.head, .VarListNE.tail, .VarList.add, .VarListNE.print, .VarListNE.init
LambdaList: .word 25, 28, type_str7, .Object.abort, .Object.type_name, .Object.copy, .LambdaList.isNil, .LambdaList.headE, .LambdaList.headC, .LambdaList.headN, .LambdaList.tail, .LambdaList.add
LambdaListNE: .word 26, 27, type_str8, .Object.abort, .Object.type_name, .Object.copy, .LambdaListNE.isNil, .LambdaListNE.headE, .LambdaListNE.headC, .LambdaListNE.headN, .LambdaListNE.tail, .LambdaList.add, .LambdaListNE.init
LambdaListRef: .word 29, 30, type_str9, .Object.abort, .Object.type_name, .Object.copy, .LambdaListRef.isNil, .LambdaListRef.headE, .LambdaListRef.headC, .LambdaListRef.headN, .LambdaListRef.reset, .LambdaListRef.add, .LambdaListRef.removeHead
Expr: .word 12, 19, type_str10, .Object.abort, .Object.type_name, .Object.copy, .IO.out_string, .IO.out_int, .IO.in_string, .IO.in_int, .Expr.print_self, .Expr.beta, .Expr.substitute, .Expr.gen_code
Variable: .word 13, 14, type_str11, .Object.abort, .Object.type_name, .Object.copy, .IO.out_string, .IO.out_int, .IO.in_string, .IO.in_int, .Variable.print_self, .Variable.beta, .Variable.substitute, .Variable.gen_code, .Variable.init
Lambda: .word 15, 16, type_str12, .Object.abort, .Object.type_name, .Object.copy, .IO.out_string, .IO.out_int, .IO.in_string, .IO.in_int, .Lambda.print_self, .Lambda.beta, .Lambda.substitute, .Lambda.gen_code, .Lambda.init, .Lambda.apply, .Lambda.gen_closure_code
App: .word 17, 18, type_str13, .Object.abort, .Object.type_name, .Object.copy, .IO.out_string, .IO.out_int, .IO.in_string, .IO.in_int, .App.print_self, .App.beta, .App.substitute, .App.gen_code, .App.init
Term: .word 20, 23, type_str14, .Object.abort, .Object.type_name, .Object.copy, .IO.out_string, .IO.out_int, .IO.in_string, .IO.in_int, .Term.var, .Term.lam, .Term.app, .Term.i, .Term.k, .Term.s
Main: .word 21, 22, type_str15, .Object.abort, .Object.type_name, .Object.copy, .IO.out_string, .IO.out_int, .IO.in_string, .IO.in_int, .Term.var, .Term.lam, .Term.app, .Term.i, .Term.k, .Term.s, .Main.beta_reduce, .Main.eval_class, .Main.closure_class, .Main.gen_code, .Main.main