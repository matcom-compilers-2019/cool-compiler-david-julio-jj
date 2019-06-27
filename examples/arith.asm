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
li $a0, 24
syscall
sw $v0, 0($sp) # new Object
subu $sp, $sp ,4
la $t0, Main
sw $t0, ($v0)
li $t0, 4
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
addu $sp, $sp, 4
sw $t0, ($sp)
subu $sp, $sp, 4
j .Object.abort
.A.value:
li $t0, 0 #.A.value
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
.A.set_var:
li $t0, 0 #.A.set_var
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
.A.method1:
li $t0, 0 #.A.method1
lw $a0, 12($fp)
sw $a0, 0($sp)
subu $sp, $sp, 4
jr $ra
.A.method2:
li $t0, 0 #.A.method2
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
lw $t1, 4($sp)
sw $t1, -0($fp)
addu $sp, $sp, 4
lw $t0, 20($fp)
sw $t0, ($sp)
subu $sp, $sp, 4
lw $t0, 16($fp)
sw $t0, ($sp)
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
lw $t0, 4($sp)
sw $t0, -0($fp)
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
li $v0, 9
li $a0, 12
syscall
sw $v0, 0($sp) # new Object
subu $sp, $sp ,4
la $t0, B
sw $t0, ($v0)
li $t0, 1
sw $t0, 4($v0)
sw $ra, ($sp)
subu $sp, $sp, 4
sw $fp, ($sp)
subu $sp, $sp, 4
move $fp, $sp
jal .B.B
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
lw $a0, 4($sp)
addu, $sp, $sp, 8
sw $a0, ($sp)
subu, $sp, $sp, 4
jr $ra
.A.method3:
li $t0, 0 #.A.method3
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
lw $t1, 4($sp)
sw $t1, -0($fp)
addu $sp, $sp, 4
lw $t0, 16($fp)
sw $t0, ($sp)
subu $sp, $sp, 4
lw $t0, 4($sp)
lw $a0, 8($t0)
not $a1, $a0
addi $a1, $a1, 1
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
lw $t0, 4($sp)
sw $t0, -0($fp)
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
li $v0, 9
li $a0, 12
syscall
sw $v0, 0($sp) # new Object
subu $sp, $sp ,4
la $t0, C
sw $t0, ($v0)
li $t0, 1
sw $t0, 4($v0)
sw $ra, ($sp)
subu $sp, $sp, 4
sw $fp, ($sp)
subu $sp, $sp, 4
move $fp, $sp
jal .C.C
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
lw $a0, 4($sp)
addu, $sp, $sp, 8
sw $a0, ($sp)
subu, $sp, $sp, 4
jr $ra
.A.method4:
li $t0, 0 #.A.method4
sw $t0, ($sp)
subu $sp, $sp, 4
sw $t0, ($sp)
subu $sp, $sp, 4
lw $t0, 16($fp)
sw $t0, ($sp)
subu $sp, $sp, 4
lw $t0, 20($fp)
sw $t0, ($sp)
subu $sp, $sp, 4
lw $t0, 8($sp)
lw $t1, 4($sp)
lw $a0, 8($t0)
lw $a1, 8($t1)
addiu $sp, $sp, 8
slt $a1, $a0, $a1
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
lw $t1, 4($sp)
sw $t1, -0($fp)
addu $sp, $sp, 4
lw $t0, 20($fp)
sw $t0, ($sp)
subu $sp, $sp, 4
lw $t0, 16($fp)
sw $t0, ($sp)
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
lw $t0, 4($sp)
sw $t0, -0($fp)
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
li $v0, 9
li $a0, 12
syscall
sw $v0, 0($sp) # new Object
subu $sp, $sp ,4
la $t0, D
sw $t0, ($v0)
li $t0, 1
sw $t0, 4($v0)
sw $ra, ($sp)
subu $sp, $sp, 4
sw $fp, ($sp)
subu $sp, $sp, 4
move $fp, $sp
jal .D.D
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
lw $a0, 4($sp)
addu, $sp, $sp, 8
sw $a0, ($sp)
subu, $sp, $sp, 4
j .if.end.1
.if.start.1:
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
lw $t1, 4($sp)
sw $t1, -4($fp)
addu $sp, $sp, 4
lw $t0, 16($fp)
sw $t0, ($sp)
subu $sp, $sp, 4
lw $t0, 20($fp)
sw $t0, ($sp)
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
lw $t0, 4($sp)
sw $t0, -4($fp)
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
li $v0, 9
li $a0, 12
syscall
sw $v0, 0($sp) # new Object
subu $sp, $sp ,4
la $t0, D
sw $t0, ($v0)
li $t0, 1
sw $t0, 4($v0)
sw $ra, ($sp)
subu $sp, $sp, 4
sw $fp, ($sp)
subu $sp, $sp, 4
move $fp, $sp
jal .D.D
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
lw $a0, 4($sp)
addu, $sp, $sp, 8
sw $a0, ($sp)
subu, $sp, $sp, 4
.if.end.1:
jr $ra
.A.method5:
li $t0, 0 #.A.method5
sw $t0, ($sp)
subu $sp, $sp, 4
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
lw $t1, 4($sp)
sw $t1, -0($fp)
addu $sp, $sp, 4
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
lw $t1, 4($sp)
sw $t1, -4($fp)
addu $sp, $sp, 4
.while.start.1:
lw $t0, -4($fp)
sw $t0, ($sp)
subu $sp, $sp, 4
lw $t0, 16($fp)
sw $t0, ($sp)
subu $sp, $sp, 4
lw $t0, 8($sp)
lw $t1, 4($sp)
lw $a0, 8($t0)
lw $a1, 8($t1)
addiu $sp, $sp, 8
sle $a1, $a0, $a1
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
beqz $a0, .while.end.1
lw $t0, -0($fp)
sw $t0, ($sp)
subu $sp, $sp, 4
lw $t0, -4($fp)
sw $t0, ($sp)
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
lw $t0, 4($sp)
sw $t0, -0($fp)
lw $t0, -4($fp)
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
lw $t0, 4($sp)
sw $t0, -4($fp)
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
li $v0, 9
li $a0, 12
syscall
sw $v0, 0($sp) # new Object
subu $sp, $sp ,4
la $t0, E
sw $t0, ($v0)
li $t0, 1
sw $t0, 4($v0)
sw $ra, ($sp)
subu $sp, $sp, 4
sw $fp, ($sp)
subu $sp, $sp, 4
move $fp, $sp
jal .E.E
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
lw $a0, 4($sp)
addu, $sp, $sp, 8
sw $a0, ($sp)
subu, $sp, $sp, 4
jr $ra
.A.A:
li $t0, 0 #.A.A
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
.B.method5:
li $t0, 0 #.B.method5
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
lw $t1, 4($sp)
sw $t1, -0($fp)
addu $sp, $sp, 4
lw $t0, 16($fp)
sw $t0, ($sp)
subu $sp, $sp, 4
lw $t0, 16($fp)
sw $t0, ($sp)
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
lw $t0, 4($sp)
sw $t0, -0($fp)
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
li $v0, 9
li $a0, 12
syscall
sw $v0, 0($sp) # new Object
subu $sp, $sp ,4
la $t0, E
sw $t0, ($v0)
li $t0, 1
sw $t0, 4($v0)
sw $ra, ($sp)
subu $sp, $sp, 4
sw $fp, ($sp)
subu $sp, $sp, 4
move $fp, $sp
jal .E.E
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
lw $a0, 4($sp)
addu, $sp, $sp, 8
sw $a0, ($sp)
subu, $sp, $sp, 4
jr $ra
.B.B:
li $t0, 0 #.B.B
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
.C.method6:
li $t0, 0 #.C.method6
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
lw $t1, 4($sp)
sw $t1, -0($fp)
addu $sp, $sp, 4
lw $t0, 16($fp)
sw $t0, ($sp)
subu $sp, $sp, 4
lw $t0, 4($sp)
lw $a0, 8($t0)
not $a1, $a0
addi $a1, $a1, 1
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
lw $t0, 4($sp)
sw $t0, -0($fp)
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
li $v0, 9
li $a0, 12
syscall
sw $v0, 0($sp) # new Object
subu $sp, $sp ,4
la $t0, A
sw $t0, ($v0)
li $t0, 1
sw $t0, 4($v0)
sw $ra, ($sp)
subu $sp, $sp, 4
sw $fp, ($sp)
subu $sp, $sp, 4
move $fp, $sp
jal .A.A
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
lw $a0, 4($sp)
addu, $sp, $sp, 8
sw $a0, ($sp)
subu, $sp, $sp, 4
jr $ra
.C.method5:
li $t0, 0 #.C.method5
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
lw $t1, 4($sp)
sw $t1, -0($fp)
addu $sp, $sp, 4
lw $t0, 16($fp)
sw $t0, ($sp)
subu $sp, $sp, 4
lw $t0, 16($fp)
sw $t0, ($sp)
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
lw $t0, 16($fp)
sw $t0, ($sp)
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
lw $t0, 4($sp)
sw $t0, -0($fp)
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
li $v0, 9
li $a0, 12
syscall
sw $v0, 0($sp) # new Object
subu $sp, $sp ,4
la $t0, E
sw $t0, ($v0)
li $t0, 1
sw $t0, 4($v0)
sw $ra, ($sp)
subu $sp, $sp, 4
sw $fp, ($sp)
subu $sp, $sp, 4
move $fp, $sp
jal .E.E
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
lw $a0, 4($sp)
addu, $sp, $sp, 8
sw $a0, ($sp)
subu, $sp, $sp, 4
jr $ra
.C.C:
li $t0, 0 #.C.C
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
.D.method7:
li $t0, 0 #.D.method7
sw $t0, ($sp)
subu $sp, $sp, 4
lw $t0, 16($fp)
sw $t0, ($sp)
subu $sp, $sp, 4
lw $t1, 4($sp)
sw $t1, -0($fp)
addu $sp, $sp, 4
lw $t0, -0($fp)
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
lw $t0, 8($sp)
lw $t1, 4($sp)
lw $a0, 8($t0)
lw $a1, 8($t1)
addiu $sp, $sp, 8
slt $a1, $a0, $a1
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
lw $t4, 4($sp) # .if.start.5
lw $t5, 8($t4)
addu $sp, $sp, 4
beqz $t5, .if.start.5
lw $t0, -0($fp)
sw $t0, ($sp)
subu $sp, $sp, 4
lw $t0, 4($sp)
lw $a0, 8($t0)
not $a1, $a0
addi $a1, $a1, 1
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
j .if.end.5
.if.start.5:
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
lw $t0, -0($fp)
sw $t0, ($sp)
subu $sp, $sp, 4
lw $t0, 8($sp)
lw $t1, 4($sp)
lw $a0, 8($t0)
lw $a1, 8($t1)
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
j .if.end.4
.if.start.4:
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
lw $t0, -0($fp)
sw $t0, ($sp)
subu $sp, $sp, 4
lw $t0, 8($sp)
lw $t1, 4($sp)
lw $a0, 8($t0)
lw $a1, 8($t1)
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
lw $t4, 4($sp) # .if.start.3
lw $t5, 8($t4)
addu $sp, $sp, 4
beqz $t5, .if.start.3
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
j .if.end.3
.if.start.3:
li $v0, 9
li $a0, 12
syscall
la $t0, Int
sw $t0, ($v0)
li $t0, 1
sw $t0, 4($v0)
li $a0, 2
sw $a0, 8($v0)
sw $v0, ($sp)
subu $sp, $sp, 4
lw $t0, -0($fp)
sw $t0, ($sp)
subu $sp, $sp, 4
lw $t0, 8($sp)
lw $t1, 4($sp)
lw $a0, 8($t0)
lw $a1, 8($t1)
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
li $v0, 9
li $a0, 12
syscall
la $t0, Int
sw $t0, ($v0)
li $t0, 1
sw $t0, 4($v0)
li $a0, 3
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
.if.end.2:
.if.end.3:
.if.end.4:
.if.end.5:
jr $ra
.D.D:
li $t0, 0 #.D.D
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
.E.method6:
li $t0, 0 #.E.method6
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
lw $t1, 4($sp)
sw $t1, -0($fp)
addu $sp, $sp, 4
lw $t0, 16($fp)
sw $t0, ($sp)
subu $sp, $sp, 4
li $v0, 9
li $a0, 12
syscall
la $t0, Int
sw $t0, ($v0)
li $t0, 1
sw $t0, 4($v0)
li $a0, 8
sw $a0, 8($v0)
sw $v0, ($sp)
subu $sp, $sp, 4
lw $t0, 8($sp)
lw $t1, 4($sp)
lw $a0, 8($t0)
lw $a1, 8($t1)
addiu $sp, $sp, 8
la $t0, zero_error
sw $t0, ($sp)
subu $sp, $sp, 4
beqz $a1, .raise
addu $sp, $sp, 4
div $a0, $a1
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
lw $t0, 4($sp)
sw $t0, -0($fp)
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
li $v0, 9
li $a0, 12
syscall
sw $v0, 0($sp) # new Object
subu $sp, $sp ,4
la $t0, A
sw $t0, ($v0)
li $t0, 1
sw $t0, 4($v0)
sw $ra, ($sp)
subu $sp, $sp, 4
sw $fp, ($sp)
subu $sp, $sp, 4
move $fp, $sp
jal .A.A
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
lw $a0, 4($sp)
addu, $sp, $sp, 8
sw $a0, ($sp)
subu, $sp, $sp, 4
jr $ra
.E.E:
li $t0, 0 #.E.E
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
.A2I.c2i:
li $t0, 0 #.A2I.c2i
lw $t0, 16($fp)
sw $t0, ($sp)
subu $sp, $sp, 4
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
lw $t0, 8($sp)
lw $t1, 4($sp)
lw $a0, 8($t0)
lw $a1, 8($t1)
addiu $sp, $sp, 8
sw $ra, ($sp)
subu $sp, $sp, 4
sw $a0, ($sp)
subu $sp, $sp, 4
sw $a1, ($sp)
subu $sp, $sp, 4
jal str_eq
lw $t0, 4($sp)
addu $sp, $sp, 4
lw $ra, 4($sp)
addu $sp, $sp, 4
sw $t0, ($sp)
subu $sp, $sp, 4
lw $t4, 4($sp) # .if.start.15
lw $t5, 8($t4)
addu $sp, $sp, 4
beqz $t5, .if.start.15
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
j .if.end.15
.if.start.15:
lw $t0, 16($fp)
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
lw $t0, 8($sp)
lw $t1, 4($sp)
lw $a0, 8($t0)
lw $a1, 8($t1)
addiu $sp, $sp, 8
sw $ra, ($sp)
subu $sp, $sp, 4
sw $a0, ($sp)
subu $sp, $sp, 4
sw $a1, ($sp)
subu $sp, $sp, 4
jal str_eq
lw $t0, 4($sp)
addu $sp, $sp, 4
lw $ra, 4($sp)
addu $sp, $sp, 4
sw $t0, ($sp)
subu $sp, $sp, 4
lw $t4, 4($sp) # .if.start.14
lw $t5, 8($t4)
addu $sp, $sp, 4
beqz $t5, .if.start.14
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
j .if.end.14
.if.start.14:
lw $t0, 16($fp)
sw $t0, ($sp)
subu $sp, $sp, 4
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
lw $t0, 8($sp)
lw $t1, 4($sp)
lw $a0, 8($t0)
lw $a1, 8($t1)
addiu $sp, $sp, 8
sw $ra, ($sp)
subu $sp, $sp, 4
sw $a0, ($sp)
subu $sp, $sp, 4
sw $a1, ($sp)
subu $sp, $sp, 4
jal str_eq
lw $t0, 4($sp)
addu $sp, $sp, 4
lw $ra, 4($sp)
addu $sp, $sp, 4
sw $t0, ($sp)
subu $sp, $sp, 4
lw $t4, 4($sp) # .if.start.13
lw $t5, 8($t4)
addu $sp, $sp, 4
beqz $t5, .if.start.13
li $v0, 9
li $a0, 12
syscall
la $t0, Int
sw $t0, ($v0)
li $t0, 1
sw $t0, 4($v0)
li $a0, 2
sw $a0, 8($v0)
sw $v0, ($sp)
subu $sp, $sp, 4
j .if.end.13
.if.start.13:
lw $t0, 16($fp)
sw $t0, ($sp)
subu $sp, $sp, 4
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
lw $t0, 8($sp)
lw $t1, 4($sp)
lw $a0, 8($t0)
lw $a1, 8($t1)
addiu $sp, $sp, 8
sw $ra, ($sp)
subu $sp, $sp, 4
sw $a0, ($sp)
subu $sp, $sp, 4
sw $a1, ($sp)
subu $sp, $sp, 4
jal str_eq
lw $t0, 4($sp)
addu $sp, $sp, 4
lw $ra, 4($sp)
addu $sp, $sp, 4
sw $t0, ($sp)
subu $sp, $sp, 4
lw $t4, 4($sp) # .if.start.12
lw $t5, 8($t4)
addu $sp, $sp, 4
beqz $t5, .if.start.12
li $v0, 9
li $a0, 12
syscall
la $t0, Int
sw $t0, ($v0)
li $t0, 1
sw $t0, 4($v0)
li $a0, 3
sw $a0, 8($v0)
sw $v0, ($sp)
subu $sp, $sp, 4
j .if.end.12
.if.start.12:
lw $t0, 16($fp)
sw $t0, ($sp)
subu $sp, $sp, 4
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
lw $t0, 8($sp)
lw $t1, 4($sp)
lw $a0, 8($t0)
lw $a1, 8($t1)
addiu $sp, $sp, 8
sw $ra, ($sp)
subu $sp, $sp, 4
sw $a0, ($sp)
subu $sp, $sp, 4
sw $a1, ($sp)
subu $sp, $sp, 4
jal str_eq
lw $t0, 4($sp)
addu $sp, $sp, 4
lw $ra, 4($sp)
addu $sp, $sp, 4
sw $t0, ($sp)
subu $sp, $sp, 4
lw $t4, 4($sp) # .if.start.11
lw $t5, 8($t4)
addu $sp, $sp, 4
beqz $t5, .if.start.11
li $v0, 9
li $a0, 12
syscall
la $t0, Int
sw $t0, ($v0)
li $t0, 1
sw $t0, 4($v0)
li $a0, 4
sw $a0, 8($v0)
sw $v0, ($sp)
subu $sp, $sp, 4
j .if.end.11
.if.start.11:
lw $t0, 16($fp)
sw $t0, ($sp)
subu $sp, $sp, 4
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
lw $t0, 8($sp)
lw $t1, 4($sp)
lw $a0, 8($t0)
lw $a1, 8($t1)
addiu $sp, $sp, 8
sw $ra, ($sp)
subu $sp, $sp, 4
sw $a0, ($sp)
subu $sp, $sp, 4
sw $a1, ($sp)
subu $sp, $sp, 4
jal str_eq
lw $t0, 4($sp)
addu $sp, $sp, 4
lw $ra, 4($sp)
addu $sp, $sp, 4
sw $t0, ($sp)
subu $sp, $sp, 4
lw $t4, 4($sp) # .if.start.10
lw $t5, 8($t4)
addu $sp, $sp, 4
beqz $t5, .if.start.10
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
j .if.end.10
.if.start.10:
lw $t0, 16($fp)
sw $t0, ($sp)
subu $sp, $sp, 4
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
lw $t0, 8($sp)
lw $t1, 4($sp)
lw $a0, 8($t0)
lw $a1, 8($t1)
addiu $sp, $sp, 8
sw $ra, ($sp)
subu $sp, $sp, 4
sw $a0, ($sp)
subu $sp, $sp, 4
sw $a1, ($sp)
subu $sp, $sp, 4
jal str_eq
lw $t0, 4($sp)
addu $sp, $sp, 4
lw $ra, 4($sp)
addu $sp, $sp, 4
sw $t0, ($sp)
subu $sp, $sp, 4
lw $t4, 4($sp) # .if.start.9
lw $t5, 8($t4)
addu $sp, $sp, 4
beqz $t5, .if.start.9
li $v0, 9
li $a0, 12
syscall
la $t0, Int
sw $t0, ($v0)
li $t0, 1
sw $t0, 4($v0)
li $a0, 6
sw $a0, 8($v0)
sw $v0, ($sp)
subu $sp, $sp, 4
j .if.end.9
.if.start.9:
lw $t0, 16($fp)
sw $t0, ($sp)
subu $sp, $sp, 4
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
lw $t0, 8($sp)
lw $t1, 4($sp)
lw $a0, 8($t0)
lw $a1, 8($t1)
addiu $sp, $sp, 8
sw $ra, ($sp)
subu $sp, $sp, 4
sw $a0, ($sp)
subu $sp, $sp, 4
sw $a1, ($sp)
subu $sp, $sp, 4
jal str_eq
lw $t0, 4($sp)
addu $sp, $sp, 4
lw $ra, 4($sp)
addu $sp, $sp, 4
sw $t0, ($sp)
subu $sp, $sp, 4
lw $t4, 4($sp) # .if.start.8
lw $t5, 8($t4)
addu $sp, $sp, 4
beqz $t5, .if.start.8
li $v0, 9
li $a0, 12
syscall
la $t0, Int
sw $t0, ($v0)
li $t0, 1
sw $t0, 4($v0)
li $a0, 7
sw $a0, 8($v0)
sw $v0, ($sp)
subu $sp, $sp, 4
j .if.end.8
.if.start.8:
lw $t0, 16($fp)
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
lw $t0, 8($sp)
lw $t1, 4($sp)
lw $a0, 8($t0)
lw $a1, 8($t1)
addiu $sp, $sp, 8
sw $ra, ($sp)
subu $sp, $sp, 4
sw $a0, ($sp)
subu $sp, $sp, 4
sw $a1, ($sp)
subu $sp, $sp, 4
jal str_eq
lw $t0, 4($sp)
addu $sp, $sp, 4
lw $ra, 4($sp)
addu $sp, $sp, 4
sw $t0, ($sp)
subu $sp, $sp, 4
lw $t4, 4($sp) # .if.start.7
lw $t5, 8($t4)
addu $sp, $sp, 4
beqz $t5, .if.start.7
li $v0, 9
li $a0, 12
syscall
la $t0, Int
sw $t0, ($v0)
li $t0, 1
sw $t0, 4($v0)
li $a0, 8
sw $a0, 8($v0)
sw $v0, ($sp)
subu $sp, $sp, 4
j .if.end.7
.if.start.7:
lw $t0, 16($fp)
sw $t0, ($sp)
subu $sp, $sp, 4
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
lw $t0, 8($sp)
lw $t1, 4($sp)
lw $a0, 8($t0)
lw $a1, 8($t1)
addiu $sp, $sp, 8
sw $ra, ($sp)
subu $sp, $sp, 4
sw $a0, ($sp)
subu $sp, $sp, 4
sw $a1, ($sp)
subu $sp, $sp, 4
jal str_eq
lw $t0, 4($sp)
addu $sp, $sp, 4
lw $ra, 4($sp)
addu $sp, $sp, 4
sw $t0, ($sp)
subu $sp, $sp, 4
lw $t4, 4($sp) # .if.start.6
lw $t5, 8($t4)
addu $sp, $sp, 4
beqz $t5, .if.start.6
li $v0, 9
li $a0, 12
syscall
la $t0, Int
sw $t0, ($v0)
li $t0, 1
sw $t0, 4($v0)
li $a0, 9
sw $a0, 8($v0)
sw $v0, ($sp)
subu $sp, $sp, 4
j .if.end.6
.if.start.6:
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
.if.end.6:
.if.end.7:
.if.end.8:
.if.end.9:
.if.end.10:
.if.end.11:
.if.end.12:
.if.end.13:
.if.end.14:
.if.end.15:
jr $ra
.A2I.i2c:
li $t0, 0 #.A2I.i2c
lw $t0, 16($fp)
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
lw $t0, 8($sp)
lw $t1, 4($sp)
lw $a0, 8($t0)
lw $a1, 8($t1)
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
lw $t4, 4($sp) # .if.start.25
lw $t5, 8($t4)
addu $sp, $sp, 4
beqz $t5, .if.start.25
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
j .if.end.25
.if.start.25:
lw $t0, 16($fp)
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
lw $t4, 4($sp) # .if.start.24
lw $t5, 8($t4)
addu $sp, $sp, 4
beqz $t5, .if.start.24
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
j .if.end.24
.if.start.24:
lw $t0, 16($fp)
sw $t0, ($sp)
subu $sp, $sp, 4
li $v0, 9
li $a0, 12
syscall
la $t0, Int
sw $t0, ($v0)
li $t0, 1
sw $t0, 4($v0)
li $a0, 2
sw $a0, 8($v0)
sw $v0, ($sp)
subu $sp, $sp, 4
lw $t0, 8($sp)
lw $t1, 4($sp)
lw $a0, 8($t0)
lw $a1, 8($t1)
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
lw $t4, 4($sp) # .if.start.23
lw $t5, 8($t4)
addu $sp, $sp, 4
beqz $t5, .if.start.23
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
j .if.end.23
.if.start.23:
lw $t0, 16($fp)
sw $t0, ($sp)
subu $sp, $sp, 4
li $v0, 9
li $a0, 12
syscall
la $t0, Int
sw $t0, ($v0)
li $t0, 1
sw $t0, 4($v0)
li $a0, 3
sw $a0, 8($v0)
sw $v0, ($sp)
subu $sp, $sp, 4
lw $t0, 8($sp)
lw $t1, 4($sp)
lw $a0, 8($t0)
lw $a1, 8($t1)
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
lw $t4, 4($sp) # .if.start.22
lw $t5, 8($t4)
addu $sp, $sp, 4
beqz $t5, .if.start.22
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
j .if.end.22
.if.start.22:
lw $t0, 16($fp)
sw $t0, ($sp)
subu $sp, $sp, 4
li $v0, 9
li $a0, 12
syscall
la $t0, Int
sw $t0, ($v0)
li $t0, 1
sw $t0, 4($v0)
li $a0, 4
sw $a0, 8($v0)
sw $v0, ($sp)
subu $sp, $sp, 4
lw $t0, 8($sp)
lw $t1, 4($sp)
lw $a0, 8($t0)
lw $a1, 8($t1)
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
lw $t4, 4($sp) # .if.start.21
lw $t5, 8($t4)
addu $sp, $sp, 4
beqz $t5, .if.start.21
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
j .if.end.21
.if.start.21:
lw $t0, 16($fp)
sw $t0, ($sp)
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
lw $t4, 4($sp) # .if.start.20
lw $t5, 8($t4)
addu $sp, $sp, 4
beqz $t5, .if.start.20
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
j .if.end.20
.if.start.20:
lw $t0, 16($fp)
sw $t0, ($sp)
subu $sp, $sp, 4
li $v0, 9
li $a0, 12
syscall
la $t0, Int
sw $t0, ($v0)
li $t0, 1
sw $t0, 4($v0)
li $a0, 6
sw $a0, 8($v0)
sw $v0, ($sp)
subu $sp, $sp, 4
lw $t0, 8($sp)
lw $t1, 4($sp)
lw $a0, 8($t0)
lw $a1, 8($t1)
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
lw $t4, 4($sp) # .if.start.19
lw $t5, 8($t4)
addu $sp, $sp, 4
beqz $t5, .if.start.19
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
j .if.end.19
.if.start.19:
lw $t0, 16($fp)
sw $t0, ($sp)
subu $sp, $sp, 4
li $v0, 9
li $a0, 12
syscall
la $t0, Int
sw $t0, ($v0)
li $t0, 1
sw $t0, 4($v0)
li $a0, 7
sw $a0, 8($v0)
sw $v0, ($sp)
subu $sp, $sp, 4
lw $t0, 8($sp)
lw $t1, 4($sp)
lw $a0, 8($t0)
lw $a1, 8($t1)
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
lw $t4, 4($sp) # .if.start.18
lw $t5, 8($t4)
addu $sp, $sp, 4
beqz $t5, .if.start.18
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
j .if.end.18
.if.start.18:
lw $t0, 16($fp)
sw $t0, ($sp)
subu $sp, $sp, 4
li $v0, 9
li $a0, 12
syscall
la $t0, Int
sw $t0, ($v0)
li $t0, 1
sw $t0, 4($v0)
li $a0, 8
sw $a0, 8($v0)
sw $v0, ($sp)
subu $sp, $sp, 4
lw $t0, 8($sp)
lw $t1, 4($sp)
lw $a0, 8($t0)
lw $a1, 8($t1)
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
lw $t4, 4($sp) # .if.start.17
lw $t5, 8($t4)
addu $sp, $sp, 4
beqz $t5, .if.start.17
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
j .if.end.17
.if.start.17:
lw $t0, 16($fp)
sw $t0, ($sp)
subu $sp, $sp, 4
li $v0, 9
li $a0, 12
syscall
la $t0, Int
sw $t0, ($v0)
li $t0, 1
sw $t0, 4($v0)
li $a0, 9
sw $a0, 8($v0)
sw $v0, ($sp)
subu $sp, $sp, 4
lw $t0, 8($sp)
lw $t1, 4($sp)
lw $a0, 8($t0)
lw $a1, 8($t1)
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
lw $t4, 4($sp) # .if.start.16
lw $t5, 8($t4)
addu $sp, $sp, 4
beqz $t5, .if.start.16
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
j .if.end.16
.if.start.16:
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
la $t0, String
sw $t0, ($v0)
li $t0, 1
sw $t0, 4($v0)
la $a0, msg20
sw $a0, 8($v0)
sw $v0, ($sp)
subu $sp, $sp, 4
lw $a0, 4($sp)
addu, $sp, $sp, 8
sw $a0, ($sp)
subu, $sp, $sp, 4
.if.end.16:
.if.end.17:
.if.end.18:
.if.end.19:
.if.end.20:
.if.end.21:
.if.end.22:
.if.end.23:
.if.end.24:
.if.end.25:
jr $ra
.A2I.a2i:
li $t0, 0 #.A2I.a2i
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
lw $t0, 8($sp)
lw $t1, 4($sp)
lw $a0, 8($t0)
lw $a1, 8($t1)
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
lw $t4, 4($sp) # .if.start.28
lw $t5, 8($t4)
addu $sp, $sp, 4
beqz $t5, .if.start.28
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
j .if.end.28
.if.start.28:
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
la $a0, msg21
sw $a0, 8($v0)
sw $v0, ($sp)
subu $sp, $sp, 4
lw $t0, 8($sp)
lw $t1, 4($sp)
lw $a0, 8($t0)
lw $a1, 8($t1)
addiu $sp, $sp, 8
sw $ra, ($sp)
subu $sp, $sp, 4
sw $a0, ($sp)
subu $sp, $sp, 4
sw $a1, ($sp)
subu $sp, $sp, 4
jal str_eq
lw $t0, 4($sp)
addu $sp, $sp, 4
lw $ra, 4($sp)
addu $sp, $sp, 4
sw $t0, ($sp)
subu $sp, $sp, 4
lw $t4, 4($sp) # .if.start.27
lw $t5, 8($t4)
addu $sp, $sp, 4
beqz $t5, .if.start.27
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
addu $sp, $sp, 8
sw $t0, ($sp)
subu $sp, $sp, 4
lw $t0, 4($sp)
lw $a0, 8($t0)
not $a1, $a0
addi $a1, $a1, 1
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
j .if.end.27
.if.start.27:
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
la $a0, msg22
sw $a0, 8($v0)
sw $v0, ($sp)
subu $sp, $sp, 4
lw $t0, 8($sp)
lw $t1, 4($sp)
lw $a0, 8($t0)
lw $a1, 8($t1)
addiu $sp, $sp, 8
sw $ra, ($sp)
subu $sp, $sp, 4
sw $a0, ($sp)
subu $sp, $sp, 4
sw $a1, ($sp)
subu $sp, $sp, 4
jal str_eq
lw $t0, 4($sp)
addu $sp, $sp, 4
lw $ra, 4($sp)
addu $sp, $sp, 4
sw $t0, ($sp)
subu $sp, $sp, 4
lw $t4, 4($sp) # .if.start.26
lw $t5, 8($t4)
addu $sp, $sp, 4
beqz $t5, .if.start.26
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
addu $sp, $sp, 8
sw $t0, ($sp)
subu $sp, $sp, 4
j .if.end.26
.if.start.26:
lw $t0, 16($fp)
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
addu $sp, $sp, 8
sw $t0, ($sp)
subu $sp, $sp, 4
.if.end.26:
.if.end.27:
.if.end.28:
jr $ra
.A2I.a2i_aux:
li $t0, 0 #.A2I.a2i_aux
sw $t0, ($sp)
subu $sp, $sp, 4
sw $t0, ($sp)
subu $sp, $sp, 4
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
lw $t1, 4($sp)
sw $t1, -0($fp)
addu $sp, $sp, 4
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
lw $t1, 4($sp)
sw $t1, -4($fp)
addu $sp, $sp, 4
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
lw $t1, 4($sp)
sw $t1, -8($fp)
addu $sp, $sp, 4
.while.start.2:
lw $t0, -8($fp)
sw $t0, ($sp)
subu $sp, $sp, 4
lw $t0, -4($fp)
sw $t0, ($sp)
subu $sp, $sp, 4
lw $t0, 8($sp)
lw $t1, 4($sp)
lw $a0, 8($t0)
lw $a1, 8($t1)
addiu $sp, $sp, 8
slt $a1, $a0, $a1
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
lw $t0, -0($fp)
sw $t0, ($sp)
subu $sp, $sp, 4
li $v0, 9
li $a0, 12
syscall
la $t0, Int
sw $t0, ($v0)
li $t0, 1
sw $t0, 4($v0)
li $a0, 10
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
lw $t0, 4($sp)
sw $t0, -0($fp)
lw $t0, -8($fp)
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
lw $t0, 4($sp)
sw $t0, -8($fp)
lw $a0, 4($sp)
addu, $sp, $sp, 8
sw $a0, ($sp)
subu, $sp, $sp, 4
j .while.start.2
.while.end.2:
li $t0, 0
sw $t0, 4($sp)
lw $t0, -0($fp)
sw $t0, ($sp)
subu $sp, $sp, 4
lw $a0, 4($sp)
addu, $sp, $sp, 8
sw $a0, ($sp)
subu, $sp, $sp, 4
jr $ra
.A2I.i2a:
li $t0, 0 #.A2I.i2a
lw $t0, 16($fp)
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
lw $t0, 8($sp)
lw $t1, 4($sp)
lw $a0, 8($t0)
lw $a1, 8($t1)
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
lw $t4, 4($sp) # .if.start.30
lw $t5, 8($t4)
addu $sp, $sp, 4
beqz $t5, .if.start.30
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
j .if.end.30
.if.start.30:
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
lw $t0, 16($fp)
sw $t0, ($sp)
subu $sp, $sp, 4
lw $t0, 8($sp)
lw $t1, 4($sp)
lw $a0, 8($t0)
lw $a1, 8($t1)
addiu $sp, $sp, 8
slt $a1, $a0, $a1
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
lw $t4, 4($sp) # .if.start.29
lw $t5, 8($t4)
addu $sp, $sp, 4
beqz $t5, .if.start.29
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
addu $sp, $sp, 8
sw $t0, ($sp)
subu $sp, $sp, 4
j .if.end.29
.if.start.29:
lw $t0, 16($fp)
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
lw $t0, 4($sp)
lw $a0, 8($t0)
not $a1, $a0
addi $a1, $a1, 1
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
.if.end.29:
.if.end.30:
jr $ra
.A2I.i2a_aux:
li $t0, 0 #.A2I.i2a_aux
sw $t0, ($sp)
subu $sp, $sp, 4
lw $t0, 16($fp)
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
lw $t0, 8($sp)
lw $t1, 4($sp)
lw $a0, 8($t0)
lw $a1, 8($t1)
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
lw $t4, 4($sp) # .if.start.31
lw $t5, 8($t4)
addu $sp, $sp, 4
beqz $t5, .if.start.31
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
j .if.end.31
.if.start.31:
lw $t0, 16($fp)
sw $t0, ($sp)
subu $sp, $sp, 4
li $v0, 9
li $a0, 12
syscall
la $t0, Int
sw $t0, ($v0)
li $t0, 1
sw $t0, 4($v0)
li $a0, 10
sw $a0, 8($v0)
sw $v0, ($sp)
subu $sp, $sp, 4
lw $t0, 8($sp)
lw $t1, 4($sp)
lw $a0, 8($t0)
lw $a1, 8($t1)
addiu $sp, $sp, 8
la $t0, zero_error
sw $t0, ($sp)
subu $sp, $sp, 4
beqz $a1, .raise
addu $sp, $sp, 4
div $a0, $a1
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
lw $t1, 4($sp)
sw $t1, -0($fp)
addu $sp, $sp, 4
lw $t0, 16($fp)
sw $t0, ($sp)
subu $sp, $sp, 4
lw $t0, -0($fp)
sw $t0, ($sp)
subu $sp, $sp, 4
li $v0, 9
li $a0, 12
syscall
la $t0, Int
sw $t0, ($v0)
li $t0, 1
sw $t0, 4($v0)
li $a0, 10
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
addu $sp, $sp, 8
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
addu $sp, $sp, 8
sw $t0, ($sp)
subu $sp, $sp, 4
.if.end.31:
jr $ra
.A2I.A2I:
li $t0, 0 #.A2I.A2I
lw $a0, 12($fp)
sw $a0, 0($sp)
subu $sp, $sp, 4
lw $a0, 4($sp)
addu, $sp, $sp, 4
sw $a0, ($sp)
subu, $sp, $sp, 4
jr $ra
.Main.menu:
li $t0, 0 #.Main.menu
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
lw $a0, 4($sp)
addu, $sp, $sp, 108
sw $a0, ($sp)
subu, $sp, $sp, 4
jr $ra
.Main.prompt:
li $t0, 0 #.Main.prompt
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
lw $a0, 4($sp)
addu, $sp, $sp, 12
sw $a0, ($sp)
subu, $sp, $sp, 4
jr $ra
.Main.get_int:
li $t0, 0 #.Main.get_int
sw $t0, ($sp)
subu $sp, $sp, 4
sw $t0, ($sp)
subu $sp, $sp, 4
li $v0, 9
li $a0, 8
syscall
sw $v0, 0($sp) # new Object
subu $sp, $sp ,4
la $t0, A2I
sw $t0, ($v0)
li $t0, 0
sw $t0, 4($v0)
sw $ra, ($sp)
subu $sp, $sp, 4
sw $fp, ($sp)
subu $sp, $sp, 4
move $fp, $sp
jal .A2I.A2I
addu $sp, $sp, 4
move $sp, $fp
addu $sp, $sp, 4
lw $fp, ($sp)
addu $sp, $sp, 4
lw $ra, ($sp)
lw $t1, 4($sp)
sw $t1, -0($fp)
addu $sp, $sp, 4
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
addu $sp, $sp, 4
sw $t0, ($sp)
subu $sp, $sp, 4
lw $t1, 4($sp)
sw $t1, -4($fp)
addu $sp, $sp, 4
lw $t0, -4($fp)
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
addu $sp, $sp, 8
sw $t0, ($sp)
subu $sp, $sp, 4
lw $a0, 4($sp)
addu, $sp, $sp, 4
sw $a0, ($sp)
subu, $sp, $sp, 4
jr $ra
.Main.is_even:
li $t0, 0 #.Main.is_even
sw $t0, ($sp)
subu $sp, $sp, 4
lw $t0, 16($fp)
sw $t0, ($sp)
subu $sp, $sp, 4
lw $t1, 4($sp)
sw $t1, -0($fp)
addu $sp, $sp, 4
lw $t0, -0($fp)
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
lw $t0, 8($sp)
lw $t1, 4($sp)
lw $a0, 8($t0)
lw $a1, 8($t1)
addiu $sp, $sp, 8
slt $a1, $a0, $a1
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
lw $t4, 4($sp) # .if.start.34
lw $t5, 8($t4)
addu $sp, $sp, 4
beqz $t5, .if.start.34
lw $t0, -0($fp)
sw $t0, ($sp)
subu $sp, $sp, 4
lw $t0, 4($sp)
lw $a0, 8($t0)
not $a1, $a0
addi $a1, $a1, 1
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
j .if.end.34
.if.start.34:
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
lw $t0, -0($fp)
sw $t0, ($sp)
subu $sp, $sp, 4
lw $t0, 8($sp)
lw $t1, 4($sp)
lw $a0, 8($t0)
lw $a1, 8($t1)
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
lw $t4, 4($sp) # .if.start.33
lw $t5, 8($t4)
addu $sp, $sp, 4
beqz $t5, .if.start.33
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
j .if.end.33
.if.start.33:
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
lw $t0, -0($fp)
sw $t0, ($sp)
subu $sp, $sp, 4
lw $t0, 8($sp)
lw $t1, 4($sp)
lw $a0, 8($t0)
lw $a1, 8($t1)
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
lw $t4, 4($sp) # .if.start.32
lw $t5, 8($t4)
addu $sp, $sp, 4
beqz $t5, .if.start.32
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
j .if.end.32
.if.start.32:
lw $t0, -0($fp)
sw $t0, ($sp)
subu $sp, $sp, 4
li $v0, 9
li $a0, 12
syscall
la $t0, Int
sw $t0, ($v0)
li $t0, 1
sw $t0, 4($v0)
li $a0, 2
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
.if.end.32:
.if.end.33:
.if.end.34:
jr $ra
.Main.class_type:
li $t0, 0 #.Main.class_type
sw $t0, ($sp)
subu $sp, $sp, 4
sw $t0, ($sp)
subu $sp, $sp, 4
sw $t0, ($sp)
subu $sp, $sp, 4
sw $t0, ($sp)
subu $sp, $sp, 4
sw $t0, ($sp)
subu $sp, $sp, 4
sw $t0, ($sp)
subu $sp, $sp, 4
move $t0, $t0 # Case
lw $t0, 16($fp)
sw $t0, ($sp)
subu $sp, $sp, 4
la $t0, void_error
sw $t0, ($sp)
lw $t0, 4($sp)
subu $sp, $sp, 4
beqz $t0, .raise
addu $sp, $sp, 4
la $a0, E #action E
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
j case.end.1
action.1:
la $a0, D #action D
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
j case.end.1
action.2:
la $a0, C #action C
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
beqz $a0, action.3
sw $t0, -8($fp)
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
j case.end.1
action.3:
la $a0, B #action B
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
beqz $a0, action.4
sw $t0, -12($fp)
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
j case.end.1
action.4:
la $a0, A #action A
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
beqz $a0, action.5
sw $t0, -16($fp)
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
j case.end.1
action.5:
la $a0, Object #action Object
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
beqz $a0, action.6
sw $t0, -20($fp)
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
j case.end.1
action.6:
la $t0, case_error
sw $t0, ($sp)
subu $sp, $sp, 4
j .raise
case.end.1:
jr $ra
.Main.print:
li $t0, 0 #.Main.print
sw $t0, ($sp)
subu $sp, $sp, 4
li $v0, 9
li $a0, 8
syscall
sw $v0, 0($sp) # new Object
subu $sp, $sp ,4
la $t0, A2I
sw $t0, ($v0)
li $t0, 0
sw $t0, 4($v0)
sw $ra, ($sp)
subu $sp, $sp, 4
sw $fp, ($sp)
subu $sp, $sp, 4
move $fp, $sp
jal .A2I.A2I
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
lw $a0, 4($sp)
addu, $sp, $sp, 8
sw $a0, ($sp)
subu, $sp, $sp, 4
jr $ra
.Main.main:
li $t0, 0 #.Main.main
sw $t0, ($sp)
subu $sp, $sp, 4
sw $t0, ($sp)
subu $sp, $sp, 4
sw $t0, ($sp)
subu $sp, $sp, 4
sw $t0, ($sp)
subu $sp, $sp, 4
sw $t0, ($sp)
subu $sp, $sp, 4
sw $t0, ($sp)
subu $sp, $sp, 4
li $v0, 9
li $a0, 12
syscall
sw $v0, 0($sp) # new Object
subu $sp, $sp ,4
la $t0, A
sw $t0, ($v0)
li $t0, 1
sw $t0, 4($v0)
sw $ra, ($sp)
subu $sp, $sp, 4
sw $fp, ($sp)
subu $sp, $sp, 4
move $fp, $sp
jal .A.A
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
.while.start.3:
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
lw $t0, 4($sp)
lw $a0, 8($t0)
addu $sp, $sp, 4
beqz $a0, .while.end.3
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
lw $t4, 4($sp) # .if.start.35
lw $t5, 8($t4)
addu $sp, $sp, 4
beqz $t5, .if.start.35
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
j .if.end.35
.if.start.35:
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
.if.end.35:
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
la $t0, String
sw $t0, ($v0)
li $t0, 1
sw $t0, 4($v0)
la $a0, msg56
sw $a0, 8($v0)
sw $v0, ($sp)
subu $sp, $sp, 4
lw $t0, 8($sp)
lw $t1, 4($sp)
lw $a0, 8($t0)
lw $a1, 8($t1)
addiu $sp, $sp, 8
sw $ra, ($sp)
subu $sp, $sp, 4
sw $a0, ($sp)
subu $sp, $sp, 4
sw $a1, ($sp)
subu $sp, $sp, 4
jal str_eq
lw $t0, 4($sp)
addu $sp, $sp, 4
lw $ra, 4($sp)
addu $sp, $sp, 4
sw $t0, ($sp)
subu $sp, $sp, 4
lw $t4, 4($sp) # .if.start.46
lw $t5, 8($t4)
addu $sp, $sp, 4
beqz $t5, .if.start.46
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
li $v0, 9
li $a0, 12
syscall
sw $v0, 0($sp) # new Object
subu $sp, $sp ,4
la $t0, A
sw $t0, ($v0)
li $t0, 1
sw $t0, 4($v0)
sw $ra, ($sp)
subu $sp, $sp, 4
sw $fp, ($sp)
subu $sp, $sp, 4
move $fp, $sp
jal .A.A
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
addu $t0, $t0, 8
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
li $v0, 9
li $a0, 12
syscall
sw $v0, 0($sp) # new Object
subu $sp, $sp ,4
la $t0, B
sw $t0, ($v0)
li $t0, 1
sw $t0, 4($v0)
sw $ra, ($sp)
subu $sp, $sp, 4
sw $fp, ($sp)
subu $sp, $sp, 4
move $fp, $sp
jal .B.B
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
addu $sp, $sp, 12
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
lw $a0, 4($sp)
addu, $sp, $sp, 8
sw $a0, ($sp)
subu, $sp, $sp, 4
j .if.end.46
.if.start.46:
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
la $t0, String
sw $t0, ($v0)
li $t0, 1
sw $t0, 4($v0)
la $a0, msg57
sw $a0, 8($v0)
sw $v0, ($sp)
subu $sp, $sp, 4
lw $t0, 8($sp)
lw $t1, 4($sp)
lw $a0, 8($t0)
lw $a1, 8($t1)
addiu $sp, $sp, 8
sw $ra, ($sp)
subu $sp, $sp, 4
sw $a0, ($sp)
subu $sp, $sp, 4
sw $a1, ($sp)
subu $sp, $sp, 4
jal str_eq
lw $t0, 4($sp)
addu $sp, $sp, 4
lw $ra, 4($sp)
addu $sp, $sp, 4
sw $t0, ($sp)
subu $sp, $sp, 4
lw $t4, 4($sp) # .if.start.45
lw $t5, 8($t4)
addu $sp, $sp, 4
beqz $t5, .if.start.45
move $t0, $t0 # Case
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
la $t0, void_error
sw $t0, ($sp)
lw $t0, 4($sp)
subu $sp, $sp, 4
beqz $t0, .raise
addu $sp, $sp, 4
la $a0, C #action C
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
beqz $a0, action.7
sw $t0, -0($fp)
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
j case.end.2
action.7:
la $a0, A #action A
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
beqz $a0, action.8
sw $t0, -4($fp)
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
j case.end.2
action.8:
la $a0, Object #action Object
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
beqz $a0, action.9
sw $t0, -8($fp)
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
addu, $sp, $sp, 12
sw $a0, ($sp)
subu, $sp, $sp, 4
j case.end.2
action.9:
la $t0, case_error
sw $t0, ($sp)
subu $sp, $sp, 4
j .raise
case.end.2:
j .if.end.45
.if.start.45:
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
la $t0, String
sw $t0, ($v0)
li $t0, 1
sw $t0, 4($v0)
la $a0, msg59
sw $a0, 8($v0)
sw $v0, ($sp)
subu $sp, $sp, 4
lw $t0, 8($sp)
lw $t1, 4($sp)
lw $a0, 8($t0)
lw $a1, 8($t1)
addiu $sp, $sp, 8
sw $ra, ($sp)
subu $sp, $sp, 4
sw $a0, ($sp)
subu $sp, $sp, 4
sw $a1, ($sp)
subu $sp, $sp, 4
jal str_eq
lw $t0, 4($sp)
addu $sp, $sp, 4
lw $ra, 4($sp)
addu $sp, $sp, 4
sw $t0, ($sp)
subu $sp, $sp, 4
lw $t4, 4($sp) # .if.start.44
lw $t5, 8($t4)
addu $sp, $sp, 4
beqz $t5, .if.start.44
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
li $v0, 9
li $a0, 12
syscall
sw $v0, 0($sp) # new Object
subu $sp, $sp ,4
la $t0, A
sw $t0, ($v0)
li $t0, 1
sw $t0, 4($v0)
sw $ra, ($sp)
subu $sp, $sp, 4
sw $fp, ($sp)
subu $sp, $sp, 4
move $fp, $sp
jal .A.A
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
addu $t0, $t0, 8
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
li $v0, 9
li $a0, 12
syscall
sw $v0, 0($sp) # new Object
subu $sp, $sp ,4
la $t0, D
sw $t0, ($v0)
li $t0, 1
sw $t0, 4($v0)
sw $ra, ($sp)
subu $sp, $sp, 4
sw $fp, ($sp)
subu $sp, $sp, 4
move $fp, $sp
jal .D.D
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
lw $a0, 4($sp)
addu, $sp, $sp, 8
sw $a0, ($sp)
subu, $sp, $sp, 4
j .if.end.44
.if.start.44:
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
la $t0, String
sw $t0, ($v0)
li $t0, 1
sw $t0, 4($v0)
la $a0, msg60
sw $a0, 8($v0)
sw $v0, ($sp)
subu $sp, $sp, 4
lw $t0, 8($sp)
lw $t1, 4($sp)
lw $a0, 8($t0)
lw $a1, 8($t1)
addiu $sp, $sp, 8
sw $ra, ($sp)
subu $sp, $sp, 4
sw $a0, ($sp)
subu $sp, $sp, 4
sw $a1, ($sp)
subu $sp, $sp, 4
jal str_eq
lw $t0, 4($sp)
addu $sp, $sp, 4
lw $ra, 4($sp)
addu $sp, $sp, 4
sw $t0, ($sp)
subu $sp, $sp, 4
lw $t4, 4($sp) # .if.start.43
lw $t5, 8($t4)
addu $sp, $sp, 4
beqz $t5, .if.start.43
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
li $v0, 9
li $a0, 12
syscall
sw $v0, 0($sp) # new Object
subu $sp, $sp ,4
la $t0, C
sw $t0, ($v0)
li $t0, 1
sw $t0, 4($v0)
sw $ra, ($sp)
subu $sp, $sp, 4
sw $fp, ($sp)
subu $sp, $sp, 4
move $fp, $sp
jal .C.C
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
sw $ra, ($sp)
subu $sp, $sp, 4
sw $fp, ($sp)
subu $sp, $sp, 4
move $fp, $sp
jal .A.method5
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
lw $t1, 4($sp)
sw $t1, ($t0)
j .if.end.43
.if.start.43:
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
la $t0, String
sw $t0, ($v0)
li $t0, 1
sw $t0, 4($v0)
la $a0, msg61
sw $a0, 8($v0)
sw $v0, ($sp)
subu $sp, $sp, 4
lw $t0, 8($sp)
lw $t1, 4($sp)
lw $a0, 8($t0)
lw $a1, 8($t1)
addiu $sp, $sp, 8
sw $ra, ($sp)
subu $sp, $sp, 4
sw $a0, ($sp)
subu $sp, $sp, 4
sw $a1, ($sp)
subu $sp, $sp, 4
jal str_eq
lw $t0, 4($sp)
addu $sp, $sp, 4
lw $ra, 4($sp)
addu $sp, $sp, 4
sw $t0, ($sp)
subu $sp, $sp, 4
lw $t4, 4($sp) # .if.start.42
lw $t5, 8($t4)
addu $sp, $sp, 4
beqz $t5, .if.start.42
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
li $v0, 9
li $a0, 12
syscall
sw $v0, 0($sp) # new Object
subu $sp, $sp ,4
la $t0, C
sw $t0, ($v0)
li $t0, 1
sw $t0, 4($v0)
sw $ra, ($sp)
subu $sp, $sp, 4
sw $fp, ($sp)
subu $sp, $sp, 4
move $fp, $sp
jal .C.C
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
sw $ra, ($sp)
subu $sp, $sp, 4
sw $fp, ($sp)
subu $sp, $sp, 4
move $fp, $sp
jal .B.method5
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
lw $t1, 4($sp)
sw $t1, ($t0)
j .if.end.42
.if.start.42:
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
la $t0, String
sw $t0, ($v0)
li $t0, 1
sw $t0, 4($v0)
la $a0, msg62
sw $a0, 8($v0)
sw $v0, ($sp)
subu $sp, $sp, 4
lw $t0, 8($sp)
lw $t1, 4($sp)
lw $a0, 8($t0)
lw $a1, 8($t1)
addiu $sp, $sp, 8
sw $ra, ($sp)
subu $sp, $sp, 4
sw $a0, ($sp)
subu $sp, $sp, 4
sw $a1, ($sp)
subu $sp, $sp, 4
jal str_eq
lw $t0, 4($sp)
addu $sp, $sp, 4
lw $ra, 4($sp)
addu $sp, $sp, 4
sw $t0, ($sp)
subu $sp, $sp, 4
lw $t4, 4($sp) # .if.start.41
lw $t5, 8($t4)
addu $sp, $sp, 4
beqz $t5, .if.start.41
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
li $v0, 9
li $a0, 12
syscall
sw $v0, 0($sp) # new Object
subu $sp, $sp ,4
la $t0, C
sw $t0, ($v0)
li $t0, 1
sw $t0, 4($v0)
sw $ra, ($sp)
subu $sp, $sp, 4
sw $fp, ($sp)
subu $sp, $sp, 4
move $fp, $sp
jal .C.C
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
sw $ra, ($sp)
subu $sp, $sp, 4
sw $fp, ($sp)
subu $sp, $sp, 4
move $fp, $sp
jal .C.method5
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
lw $t1, 4($sp)
sw $t1, ($t0)
j .if.end.41
.if.start.41:
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
la $t0, String
sw $t0, ($v0)
li $t0, 1
sw $t0, 4($v0)
la $a0, msg63
sw $a0, 8($v0)
sw $v0, ($sp)
subu $sp, $sp, 4
lw $t0, 8($sp)
lw $t1, 4($sp)
lw $a0, 8($t0)
lw $a1, 8($t1)
addiu $sp, $sp, 8
sw $ra, ($sp)
subu $sp, $sp, 4
sw $a0, ($sp)
subu $sp, $sp, 4
sw $a1, ($sp)
subu $sp, $sp, 4
jal str_eq
lw $t0, 4($sp)
addu $sp, $sp, 4
lw $ra, 4($sp)
addu $sp, $sp, 4
sw $t0, ($sp)
subu $sp, $sp, 4
lw $t4, 4($sp) # .if.start.40
lw $t5, 8($t4)
addu $sp, $sp, 4
beqz $t5, .if.start.40
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
li $v0, 9
li $a0, 12
syscall
sw $v0, 0($sp) # new Object
subu $sp, $sp ,4
la $t0, D
sw $t0, ($v0)
li $t0, 1
sw $t0, 4($v0)
sw $ra, ($sp)
subu $sp, $sp, 4
sw $fp, ($sp)
subu $sp, $sp, 4
move $fp, $sp
jal .D.D
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
lw $t4, 4($sp) # .if.start.36
lw $t5, 8($t4)
addu $sp, $sp, 4
beqz $t5, .if.start.36
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
lw $a0, 4($sp)
addu, $sp, $sp, 12
sw $a0, ($sp)
subu, $sp, $sp, 4
j .if.end.36
.if.start.36:
li $v0, 9
li $a0, 12
syscall
la $t0, String
sw $t0, ($v0)
li $t0, 1
sw $t0, 4($v0)
la $a0, msg66
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
la $a0, msg67
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
.if.end.36:
j .if.end.40
.if.start.40:
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
la $t0, String
sw $t0, ($v0)
li $t0, 1
sw $t0, 4($v0)
la $a0, msg68
sw $a0, 8($v0)
sw $v0, ($sp)
subu $sp, $sp, 4
lw $t0, 8($sp)
lw $t1, 4($sp)
lw $a0, 8($t0)
lw $a1, 8($t1)
addiu $sp, $sp, 8
sw $ra, ($sp)
subu $sp, $sp, 4
sw $a0, ($sp)
subu $sp, $sp, 4
sw $a1, ($sp)
subu $sp, $sp, 4
jal str_eq
lw $t0, 4($sp)
addu $sp, $sp, 4
lw $ra, 4($sp)
addu $sp, $sp, 4
sw $t0, ($sp)
subu $sp, $sp, 4
lw $t4, 4($sp) # .if.start.39
lw $t5, 8($t4)
addu $sp, $sp, 4
beqz $t5, .if.start.39
li $t1, 0
sw $t1, -12($fp)
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
li $v0, 9
li $a0, 12
syscall
sw $v0, 0($sp) # new Object
subu $sp, $sp ,4
la $t0, E
sw $t0, ($v0)
li $t0, 1
sw $t0, 4($v0)
sw $ra, ($sp)
subu $sp, $sp, 4
sw $fp, ($sp)
subu $sp, $sp, 4
move $fp, $sp
jal .E.E
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
lw $t0, 4($sp)
sw $t0, -12($fp)
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
li $v0, 9
li $a0, 12
syscall
la $t0, Int
sw $t0, ($v0)
li $t0, 1
sw $t0, 4($v0)
li $a0, 8
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
lw $t1, 4($sp)
sw $t1, -16($fp)
addu $sp, $sp, 4
li $v0, 9
li $a0, 12
syscall
la $t0, String
sw $t0, ($v0)
li $t0, 1
sw $t0, 4($v0)
la $a0, msg69
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
la $a0, msg70
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
lw $t0, -12($fp)
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
la $a0, msg71
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
la $t0, A2I
sw $t0, ($v0)
li $t0, 0
sw $t0, 4($v0)
sw $ra, ($sp)
subu $sp, $sp, 4
sw $fp, ($sp)
subu $sp, $sp, 4
move $fp, $sp
jal .A2I.A2I
addu $sp, $sp, 4
move $sp, $fp
addu $sp, $sp, 4
lw $fp, ($sp)
addu $sp, $sp, 4
lw $ra, ($sp)
lw $t1, 4($sp)
sw $t1, -20($fp)
addu $sp, $sp, 4
lw $t0, -16($fp)
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
lw $t0, -20($fp)
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
la $a0, msg72
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
addu, $sp, $sp, 8
sw $a0, ($sp)
subu, $sp, $sp, 4
lw $a0, 4($sp)
addu, $sp, $sp, 24
sw $a0, ($sp)
subu, $sp, $sp, 4
lw $t0, -12($fp)
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
lw $a0, 4($sp)
addu, $sp, $sp, 12
sw $a0, ($sp)
subu, $sp, $sp, 4
j .if.end.39
.if.start.39:
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
la $t0, String
sw $t0, ($v0)
li $t0, 1
sw $t0, 4($v0)
la $a0, msg73
sw $a0, 8($v0)
sw $v0, ($sp)
subu $sp, $sp, 4
lw $t0, 8($sp)
lw $t1, 4($sp)
lw $a0, 8($t0)
lw $a1, 8($t1)
addiu $sp, $sp, 8
sw $ra, ($sp)
subu $sp, $sp, 4
sw $a0, ($sp)
subu $sp, $sp, 4
sw $a1, ($sp)
subu $sp, $sp, 4
jal str_eq
lw $t0, 4($sp)
addu $sp, $sp, 4
lw $ra, 4($sp)
addu $sp, $sp, 4
sw $t0, ($sp)
subu $sp, $sp, 4
lw $t4, 4($sp) # .if.start.38
lw $t5, 8($t4)
addu $sp, $sp, 4
beqz $t5, .if.start.38
li $v0, 9
li $a0, 12
syscall
sw $v0, 0($sp) # new Object
subu $sp, $sp ,4
la $t0, A
sw $t0, ($v0)
li $t0, 1
sw $t0, 4($v0)
sw $ra, ($sp)
subu $sp, $sp, 4
sw $fp, ($sp)
subu $sp, $sp, 4
move $fp, $sp
jal .A.A
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
j .if.end.38
.if.start.38:
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
la $t0, String
sw $t0, ($v0)
li $t0, 1
sw $t0, 4($v0)
la $a0, msg74
sw $a0, 8($v0)
sw $v0, ($sp)
subu $sp, $sp, 4
lw $t0, 8($sp)
lw $t1, 4($sp)
lw $a0, 8($t0)
lw $a1, 8($t1)
addiu $sp, $sp, 8
sw $ra, ($sp)
subu $sp, $sp, 4
sw $a0, ($sp)
subu $sp, $sp, 4
sw $a1, ($sp)
subu $sp, $sp, 4
jal str_eq
lw $t0, 4($sp)
addu $sp, $sp, 4
lw $ra, 4($sp)
addu $sp, $sp, 4
sw $t0, ($sp)
subu $sp, $sp, 4
lw $t4, 4($sp) # .if.start.37
lw $t5, 8($t4)
addu $sp, $sp, 4
beqz $t5, .if.start.37
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
j .if.end.37
.if.start.37:
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
li $v0, 9
li $a0, 12
syscall
sw $v0, 0($sp) # new Object
subu $sp, $sp ,4
la $t0, A
sw $t0, ($v0)
li $t0, 1
sw $t0, 4($v0)
sw $ra, ($sp)
subu $sp, $sp, 4
sw $fp, ($sp)
subu $sp, $sp, 4
move $fp, $sp
jal .A.A
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
lw $t1, 4($sp)
sw $t1, ($t0)
.if.end.37:
.if.end.38:
.if.end.39:
.if.end.40:
.if.end.41:
.if.end.42:
.if.end.43:
.if.end.44:
.if.end.45:
.if.end.46:
lw $a0, 4($sp)
addu, $sp, $sp, 24
sw $a0, ($sp)
subu, $sp, $sp, 4
j .while.start.3
.while.end.3:
li $t0, 0
sw $t0, 4($sp)
lw $a0, 4($sp)
addu, $sp, $sp, 8
sw $a0, ($sp)
subu, $sp, $sp, 4
jr $ra
.Main.Main:
li $t0, 0 #.Main.Main
li $v0, 9
li $a0, 12
syscall
la $t0, String
sw $t0, ($v0)
li $t0, 1
sw $t0, 4($v0)
la $a0, msg75
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
addu, $sp, $sp, 12
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
msg0: .asciiz "0"
msg1: .asciiz "1"
msg2: .asciiz "2"
msg3: .asciiz "3"
msg4: .asciiz "4"
msg5: .asciiz "5"
msg6: .asciiz "6"
msg7: .asciiz "7"
msg8: .asciiz "8"
msg9: .asciiz "9"
msg10: .asciiz "0"
msg11: .asciiz "1"
msg12: .asciiz "2"
msg13: .asciiz "3"
msg14: .asciiz "4"
msg15: .asciiz "5"
msg16: .asciiz "6"
msg17: .asciiz "7"
msg18: .asciiz "8"
msg19: .asciiz "9"
msg20: .asciiz ""
msg21: .asciiz "-"
msg22: .asciiz "+"
msg23: .asciiz "0"
msg24: .asciiz "-"
msg25: .asciiz ""
msg26: .asciiz "
	To add a number to "
msg27: .asciiz "...enter a:
"
msg28: .asciiz "	To negate "
msg29: .asciiz "...enter b:
"
msg30: .asciiz "	To find the difference between "
msg31: .asciiz "and another number...enter c:
"
msg32: .asciiz "	To find the factorial of "
msg33: .asciiz "...enter d:
"
msg34: .asciiz "	To square "
msg35: .asciiz "...enter e:
"
msg36: .asciiz "	To cube "
msg37: .asciiz "...enter f:
"
msg38: .asciiz "	To find out if "
msg39: .asciiz "is a multiple of 3...enter g:
"
msg40: .asciiz "	To divide "
msg41: .asciiz "by 8...enter h:
"
msg42: .asciiz "	To get a new number...enter j:
"
msg43: .asciiz "	To quit...enter q:

"
msg44: .asciiz "
"
msg45: .asciiz "Please enter a number...  "
msg46: .asciiz "Class type is now E
"
msg47: .asciiz "Class type is now D
"
msg48: .asciiz "Class type is now C
"
msg49: .asciiz "Class type is now B
"
msg50: .asciiz "Class type is now A
"
msg51: .asciiz "Oooops
"
msg52: .asciiz " "
msg53: .asciiz "number "
msg54: .asciiz "is even!
"
msg55: .asciiz "is odd!
"
msg56: .asciiz "a"
msg57: .asciiz "b"
msg58: .asciiz "Oooops
"
msg59: .asciiz "c"
msg60: .asciiz "d"
msg61: .asciiz "e"
msg62: .asciiz "f"
msg63: .asciiz "g"
msg64: .asciiz "number "
msg65: .asciiz "is divisible by 3.
"
msg66: .asciiz "number "
msg67: .asciiz "is not divisible by 3.
"
msg68: .asciiz "h"
msg69: .asciiz "number "
msg70: .asciiz "is equal to "
msg71: .asciiz "times 8 with a remainder of "
msg72: .asciiz "
"
msg73: .asciiz "j"
msg74: .asciiz "q"
msg75: .asciiz ""
buffer: .space 1024
type_str0: .asciiz "Object"
type_str1: .asciiz "Int"
type_str2: .asciiz "Bool"
type_str3: .asciiz "String"
type_str4: .asciiz "IO"
type_str5: .asciiz "A"
type_str6: .asciiz "B"
type_str7: .asciiz "C"
type_str8: .asciiz "D"
type_str9: .asciiz "E"
type_str10: .asciiz "A2I"
type_str11: .asciiz "Main"
Object: .word 0, 23, type_str0, .Object.abort, .Object.type_name, .Object.copy
Int: .word 1, 2, type_str1, .Object.abort, .Object.type_name, .Object.copy
Bool: .word 3, 4, type_str2, .Object.abort, .Object.type_name, .Object.copy
String: .word 5, 6, type_str3, .Object.abort, .Object.type_name, .Object.copy, .String.length, .String.concat, .String.substr
IO: .word 7, 10, type_str4, .Object.abort, .Object.type_name, .Object.copy, .IO.out_string, .IO.out_int, .IO.in_string, .IO.in_int
A: .word 11, 20, type_str5, .Object.abort, .Object.type_name, .Object.copy, .A.value, .A.set_var, .A.method1, .A.method2, .A.method3, .A.method4, .A.method5
B: .word 12, 19, type_str6, .Object.abort, .Object.type_name, .Object.copy, .A.value, .A.set_var, .A.method1, .A.method2, .A.method3, .A.method4, .B.method5
C: .word 13, 14, type_str7, .Object.abort, .Object.type_name, .Object.copy, .A.value, .A.set_var, .A.method1, .A.method2, .A.method3, .A.method4, .C.method5, .C.method6
D: .word 15, 18, type_str8, .Object.abort, .Object.type_name, .Object.copy, .A.value, .A.set_var, .A.method1, .A.method2, .A.method3, .A.method4, .B.method5, .D.method7
E: .word 16, 17, type_str9, .Object.abort, .Object.type_name, .Object.copy, .A.value, .A.set_var, .A.method1, .A.method2, .A.method3, .A.method4, .B.method5, .D.method7, .E.method6
A2I: .word 21, 22, type_str10, .Object.abort, .Object.type_name, .Object.copy, .A2I.c2i, .A2I.i2c, .A2I.a2i, .A2I.a2i_aux, .A2I.i2a, .A2I.i2a_aux
Main: .word 8, 9, type_str11, .Object.abort, .Object.type_name, .Object.copy, .IO.out_string, .IO.out_int, .IO.in_string, .IO.in_int, .Main.menu, .Main.prompt, .Main.get_int, .Main.is_even, .Main.class_type, .Main.print, .Main.main