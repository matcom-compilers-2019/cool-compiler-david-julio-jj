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
j .Object.abort
.Bazz.printh:
li $t0, 0 #.Bazz.printh
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
.Bazz.doh:
li $t0, 0 #.Bazz.doh
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
lw $t1, 4($sp)
sw $t1, -0($fp)
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
lw $t0, -0($fp)
sw $t0, ($sp)
subu $sp, $sp, 4
lw $a0, 4($sp)
addu, $sp, $sp, 8
sw $a0, ($sp)
subu, $sp, $sp, 4
jr $ra
.Bazz.Bazz:
li $t0, 0 #.Bazz.Bazz
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
la $t0, Int
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
addu $t0, $t0, 0
lw $t1, 4($sp)
sw $t1, ($t0)
move $t0, $t0 # Case
lw $a0, 12($fp)
sw $a0, 0($sp)
subu $sp, $sp, 4
la $t0, void_error
sw $t0, ($sp)
lw $t0, 4($sp)
subu $sp, $sp, 4
beqz $t0, .raise
addu $sp, $sp, 4
la $a0, Bar #action Bar
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
lw $t0, -0($fp)
sw $t0, ($sp)
subu $sp, $sp, 4
j case.end.1
action.1:
la $a0, Razz #action Razz
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
li $a0, 44
syscall
sw $v0, 0($sp) # new Object
subu $sp, $sp ,4
la $t0, Bar
sw $t0, ($v0)
li $t0, 9
sw $t0, 4($v0)
sw $ra, ($sp)
subu $sp, $sp, 4
sw $fp, ($sp)
subu $sp, $sp, 4
move $fp, $sp
jal .Bar.Bar
addu $sp, $sp, 4
move $sp, $fp
addu $sp, $sp, 4
lw $fp, ($sp)
addu $sp, $sp, 4
lw $ra, ($sp)
j case.end.1
action.2:
la $a0, Foo #action Foo
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
li $a0, 36
syscall
sw $v0, 0($sp) # new Object
subu $sp, $sp ,4
la $t0, Razz
sw $t0, ($v0)
li $t0, 7
sw $t0, 4($v0)
sw $ra, ($sp)
subu $sp, $sp, 4
sw $fp, ($sp)
subu $sp, $sp, 4
move $fp, $sp
jal .Razz.Razz
addu $sp, $sp, 4
move $sp, $fp
addu $sp, $sp, 4
lw $fp, ($sp)
addu $sp, $sp, 4
lw $ra, ($sp)
j case.end.1
action.3:
la $a0, Bazz #action Bazz
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
li $a0, 28
syscall
sw $v0, 0($sp) # new Object
subu $sp, $sp ,4
la $t0, Foo
sw $t0, ($v0)
li $t0, 5
sw $t0, 4($v0)
sw $ra, ($sp)
subu $sp, $sp, 4
sw $fp, ($sp)
subu $sp, $sp, 4
move $fp, $sp
jal .Foo.Foo
addu $sp, $sp, 4
move $sp, $fp
addu $sp, $sp, 4
lw $fp, ($sp)
addu $sp, $sp, 4
lw $ra, ($sp)
j case.end.1
action.4:
la $t0, case_error
sw $t0, ($sp)
subu $sp, $sp, 4
j .raise
case.end.1:
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
addu $t0, $t0, 8
lw $t1, 4($sp)
sw $t1, ($t0)
lw $a0, 12($fp)
sw $a0, 0($sp)
subu $sp, $sp, 4
lw $a0, 4($sp)
addu, $sp, $sp, 16
sw $a0, ($sp)
subu, $sp, $sp, 4
jr $ra
.Foo.doh:
li $t0, 0 #.Foo.doh
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
lw $t1, 4($sp)
sw $t1, -0($fp)
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
lw $t0, -0($fp)
sw $t0, ($sp)
subu $sp, $sp, 4
lw $a0, 4($sp)
addu, $sp, $sp, 8
sw $a0, ($sp)
subu, $sp, $sp, 4
jr $ra
.Foo.Foo:
li $t0, 0 #.Foo.Foo
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
move $t0, $t0 # Case
lw $a0, 12($fp)
sw $a0, 0($sp)
subu $sp, $sp, 4
la $t0, void_error
sw $t0, ($sp)
lw $t0, 4($sp)
subu $sp, $sp, 4
beqz $t0, .raise
addu $sp, $sp, 4
la $a0, Bar #action Bar
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
sw $t0, -0($fp)
lw $t0, -0($fp)
sw $t0, ($sp)
subu $sp, $sp, 4
j case.end.2
action.5:
la $a0, Razz #action Razz
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
sw $t0, -4($fp)
li $v0, 9
li $a0, 44
syscall
sw $v0, 0($sp) # new Object
subu $sp, $sp ,4
la $t0, Bar
sw $t0, ($v0)
li $t0, 9
sw $t0, 4($v0)
sw $ra, ($sp)
subu $sp, $sp, 4
sw $fp, ($sp)
subu $sp, $sp, 4
move $fp, $sp
jal .Bar.Bar
addu $sp, $sp, 4
move $sp, $fp
addu $sp, $sp, 4
lw $fp, ($sp)
addu $sp, $sp, 4
lw $ra, ($sp)
j case.end.2
action.6:
la $a0, Foo #action Foo
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
sw $t0, -8($fp)
li $v0, 9
li $a0, 36
syscall
sw $v0, 0($sp) # new Object
subu $sp, $sp ,4
la $t0, Razz
sw $t0, ($v0)
li $t0, 7
sw $t0, 4($v0)
sw $ra, ($sp)
subu $sp, $sp, 4
sw $fp, ($sp)
subu $sp, $sp, 4
move $fp, $sp
jal .Razz.Razz
addu $sp, $sp, 4
move $sp, $fp
addu $sp, $sp, 4
lw $fp, ($sp)
addu $sp, $sp, 4
lw $ra, ($sp)
j case.end.2
action.7:
la $a0, Bazz #action Bazz
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
sw $t0, -12($fp)
li $v0, 9
li $a0, 28
syscall
sw $v0, 0($sp) # new Object
subu $sp, $sp ,4
la $t0, Foo
sw $t0, ($v0)
li $t0, 5
sw $t0, 4($v0)
sw $ra, ($sp)
subu $sp, $sp, 4
sw $fp, ($sp)
subu $sp, $sp, 4
move $fp, $sp
jal .Foo.Foo
addu $sp, $sp, 4
move $sp, $fp
addu $sp, $sp, 4
lw $fp, ($sp)
addu $sp, $sp, 4
lw $ra, ($sp)
j case.end.2
action.8:
la $t0, case_error
sw $t0, ($sp)
subu $sp, $sp, 4
j .raise
case.end.2:
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
addu $t0, $t0, 8
lw $t1, 4($sp)
sw $t1, ($t0)
move $t0, $t0 # Case
lw $a0, 12($fp)
sw $a0, 0($sp)
subu $sp, $sp, 4
la $t0, void_error
sw $t0, ($sp)
lw $t0, 4($sp)
subu $sp, $sp, 4
beqz $t0, .raise
addu $sp, $sp, 4
la $a0, Bar #action Bar
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
sw $t0, -16($fp)
lw $t0, -16($fp)
sw $t0, ($sp)
subu $sp, $sp, 4
j case.end.3
action.9:
la $a0, Razz #action Razz
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
beqz $a0, action.10
sw $t0, -20($fp)
li $v0, 9
li $a0, 44
syscall
sw $v0, 0($sp) # new Object
subu $sp, $sp ,4
la $t0, Bar
sw $t0, ($v0)
li $t0, 9
sw $t0, 4($v0)
sw $ra, ($sp)
subu $sp, $sp, 4
sw $fp, ($sp)
subu $sp, $sp, 4
move $fp, $sp
jal .Bar.Bar
addu $sp, $sp, 4
move $sp, $fp
addu $sp, $sp, 4
lw $fp, ($sp)
addu $sp, $sp, 4
lw $ra, ($sp)
j case.end.3
action.10:
la $a0, Foo #action Foo
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
beqz $a0, action.11
sw $t0, -24($fp)
li $v0, 9
li $a0, 36
syscall
sw $v0, 0($sp) # new Object
subu $sp, $sp ,4
la $t0, Razz
sw $t0, ($v0)
li $t0, 7
sw $t0, 4($v0)
sw $ra, ($sp)
subu $sp, $sp, 4
sw $fp, ($sp)
subu $sp, $sp, 4
move $fp, $sp
jal .Razz.Razz
addu $sp, $sp, 4
move $sp, $fp
addu $sp, $sp, 4
lw $fp, ($sp)
addu $sp, $sp, 4
lw $ra, ($sp)
j case.end.3
action.11:
la $t0, case_error
sw $t0, ($sp)
subu $sp, $sp, 4
j .raise
case.end.3:
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
addu $sp, $sp, 4
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
addu $t0, $t0, 16
lw $t1, 4($sp)
sw $t1, ($t0)
lw $a0, 12($fp)
sw $a0, 0($sp)
subu $sp, $sp, 4
lw $a0, 4($sp)
addu, $sp, $sp, 24
sw $a0, ($sp)
subu, $sp, $sp, 4
jr $ra
.Razz.Razz:
li $t0, 0 #.Razz.Razz
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
addu $t0, $t0, 0
lw $t1, 4($sp)
sw $t1, ($t0)
move $t0, $t0 # Case
lw $a0, 12($fp)
sw $a0, 0($sp)
subu $sp, $sp, 4
la $t0, void_error
sw $t0, ($sp)
lw $t0, 4($sp)
subu $sp, $sp, 4
beqz $t0, .raise
addu $sp, $sp, 4
la $a0, Bar #action Bar
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
beqz $a0, action.12
sw $t0, -0($fp)
lw $t0, -0($fp)
sw $t0, ($sp)
subu $sp, $sp, 4
j case.end.4
action.12:
la $a0, Razz #action Razz
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
beqz $a0, action.13
sw $t0, -4($fp)
li $v0, 9
li $a0, 44
syscall
sw $v0, 0($sp) # new Object
subu $sp, $sp ,4
la $t0, Bar
sw $t0, ($v0)
li $t0, 9
sw $t0, 4($v0)
sw $ra, ($sp)
subu $sp, $sp, 4
sw $fp, ($sp)
subu $sp, $sp, 4
move $fp, $sp
jal .Bar.Bar
addu $sp, $sp, 4
move $sp, $fp
addu $sp, $sp, 4
lw $fp, ($sp)
addu $sp, $sp, 4
lw $ra, ($sp)
j case.end.4
action.13:
la $a0, Foo #action Foo
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
beqz $a0, action.14
sw $t0, -8($fp)
li $v0, 9
li $a0, 36
syscall
sw $v0, 0($sp) # new Object
subu $sp, $sp ,4
la $t0, Razz
sw $t0, ($v0)
li $t0, 7
sw $t0, 4($v0)
sw $ra, ($sp)
subu $sp, $sp, 4
sw $fp, ($sp)
subu $sp, $sp, 4
move $fp, $sp
jal .Razz.Razz
addu $sp, $sp, 4
move $sp, $fp
addu $sp, $sp, 4
lw $fp, ($sp)
addu $sp, $sp, 4
lw $ra, ($sp)
j case.end.4
action.14:
la $a0, Bazz #action Bazz
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
beqz $a0, action.15
sw $t0, -12($fp)
li $v0, 9
li $a0, 28
syscall
sw $v0, 0($sp) # new Object
subu $sp, $sp ,4
la $t0, Foo
sw $t0, ($v0)
li $t0, 5
sw $t0, 4($v0)
sw $ra, ($sp)
subu $sp, $sp, 4
sw $fp, ($sp)
subu $sp, $sp, 4
move $fp, $sp
jal .Foo.Foo
addu $sp, $sp, 4
move $sp, $fp
addu $sp, $sp, 4
lw $fp, ($sp)
addu $sp, $sp, 4
lw $ra, ($sp)
j case.end.4
action.15:
la $t0, case_error
sw $t0, ($sp)
subu $sp, $sp, 4
j .raise
case.end.4:
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
addu $t0, $t0, 8
lw $t1, 4($sp)
sw $t1, ($t0)
move $t0, $t0 # Case
lw $a0, 12($fp)
sw $a0, 0($sp)
subu $sp, $sp, 4
la $t0, void_error
sw $t0, ($sp)
lw $t0, 4($sp)
subu $sp, $sp, 4
beqz $t0, .raise
addu $sp, $sp, 4
la $a0, Bar #action Bar
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
beqz $a0, action.16
sw $t0, -16($fp)
lw $t0, -16($fp)
sw $t0, ($sp)
subu $sp, $sp, 4
j case.end.5
action.16:
la $a0, Razz #action Razz
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
beqz $a0, action.17
sw $t0, -20($fp)
li $v0, 9
li $a0, 44
syscall
sw $v0, 0($sp) # new Object
subu $sp, $sp ,4
la $t0, Bar
sw $t0, ($v0)
li $t0, 9
sw $t0, 4($v0)
sw $ra, ($sp)
subu $sp, $sp, 4
sw $fp, ($sp)
subu $sp, $sp, 4
move $fp, $sp
jal .Bar.Bar
addu $sp, $sp, 4
move $sp, $fp
addu $sp, $sp, 4
lw $fp, ($sp)
addu $sp, $sp, 4
lw $ra, ($sp)
j case.end.5
action.17:
la $a0, Foo #action Foo
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
beqz $a0, action.18
sw $t0, -24($fp)
li $v0, 9
li $a0, 36
syscall
sw $v0, 0($sp) # new Object
subu $sp, $sp ,4
la $t0, Razz
sw $t0, ($v0)
li $t0, 7
sw $t0, 4($v0)
sw $ra, ($sp)
subu $sp, $sp, 4
sw $fp, ($sp)
subu $sp, $sp, 4
move $fp, $sp
jal .Razz.Razz
addu $sp, $sp, 4
move $sp, $fp
addu $sp, $sp, 4
lw $fp, ($sp)
addu $sp, $sp, 4
lw $ra, ($sp)
j case.end.5
action.18:
la $t0, case_error
sw $t0, ($sp)
subu $sp, $sp, 4
j .raise
case.end.5:
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
addu $sp, $sp, 4
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
addu $t0, $t0, 16
lw $t1, 4($sp)
sw $t1, ($t0)
move $t0, $t0 # Case
lw $a0, 12($fp)
sw $a0, 0($sp)
subu $sp, $sp, 4
la $t0, void_error
sw $t0, ($sp)
lw $t0, 4($sp)
subu $sp, $sp, 4
beqz $t0, .raise
addu $sp, $sp, 4
la $a0, Bar #action Bar
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
beqz $a0, action.19
sw $t0, -28($fp)
lw $t0, -28($fp)
sw $t0, ($sp)
subu $sp, $sp, 4
j case.end.6
action.19:
la $a0, Razz #action Razz
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
beqz $a0, action.20
sw $t0, -32($fp)
li $v0, 9
li $a0, 44
syscall
sw $v0, 0($sp) # new Object
subu $sp, $sp ,4
la $t0, Bar
sw $t0, ($v0)
li $t0, 9
sw $t0, 4($v0)
sw $ra, ($sp)
subu $sp, $sp, 4
sw $fp, ($sp)
subu $sp, $sp, 4
move $fp, $sp
jal .Bar.Bar
addu $sp, $sp, 4
move $sp, $fp
addu $sp, $sp, 4
lw $fp, ($sp)
addu $sp, $sp, 4
lw $ra, ($sp)
j case.end.6
action.20:
la $t0, case_error
sw $t0, ($sp)
subu $sp, $sp, 4
j .raise
case.end.6:
lw $t0, 12($fp)
la $t1, void_error
sw $t1, ($sp)
subu $sp, $sp, 4
beqz $t0, .raise
addu $sp, $sp, 4
addu $t0, $t0, 8
addu $t0, $t0, 20
lw $t1, 4($sp)
sw $t1, ($t0)
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
jal .Bazz.doh
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
addu $sp, $sp, 4
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
lw $t0, 12($fp)
la $t1, void_error
sw $t1, ($sp)
subu $sp, $sp, 4
beqz $t0, .raise
addu $sp, $sp, 4
addu $t0, $t0, 8
addu $t0, $t0, 20
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
addu $t0, $t0, 24
lw $t1, 4($sp)
sw $t1, ($t0)
lw $a0, 12($fp)
sw $a0, 0($sp)
subu $sp, $sp, 4
lw $a0, 4($sp)
addu, $sp, $sp, 32
sw $a0, ($sp)
subu, $sp, $sp, 4
jr $ra
.Bar.Bar:
li $t0, 0 #.Bar.Bar
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
addu $t0, $t0, 0
lw $t1, 4($sp)
sw $t1, ($t0)
move $t0, $t0 # Case
lw $a0, 12($fp)
sw $a0, 0($sp)
subu $sp, $sp, 4
la $t0, void_error
sw $t0, ($sp)
lw $t0, 4($sp)
subu $sp, $sp, 4
beqz $t0, .raise
addu $sp, $sp, 4
la $a0, Bar #action Bar
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
beqz $a0, action.21
sw $t0, -0($fp)
lw $t0, -0($fp)
sw $t0, ($sp)
subu $sp, $sp, 4
j case.end.7
action.21:
la $a0, Razz #action Razz
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
beqz $a0, action.22
sw $t0, -4($fp)
li $v0, 9
li $a0, 44
syscall
sw $v0, 0($sp) # new Object
subu $sp, $sp ,4
la $t0, Bar
sw $t0, ($v0)
li $t0, 9
sw $t0, 4($v0)
sw $ra, ($sp)
subu $sp, $sp, 4
sw $fp, ($sp)
subu $sp, $sp, 4
move $fp, $sp
jal .Bar.Bar
addu $sp, $sp, 4
move $sp, $fp
addu $sp, $sp, 4
lw $fp, ($sp)
addu $sp, $sp, 4
lw $ra, ($sp)
j case.end.7
action.22:
la $a0, Foo #action Foo
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
beqz $a0, action.23
sw $t0, -8($fp)
li $v0, 9
li $a0, 36
syscall
sw $v0, 0($sp) # new Object
subu $sp, $sp ,4
la $t0, Razz
sw $t0, ($v0)
li $t0, 7
sw $t0, 4($v0)
sw $ra, ($sp)
subu $sp, $sp, 4
sw $fp, ($sp)
subu $sp, $sp, 4
move $fp, $sp
jal .Razz.Razz
addu $sp, $sp, 4
move $sp, $fp
addu $sp, $sp, 4
lw $fp, ($sp)
addu $sp, $sp, 4
lw $ra, ($sp)
j case.end.7
action.23:
la $a0, Bazz #action Bazz
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
beqz $a0, action.24
sw $t0, -12($fp)
li $v0, 9
li $a0, 28
syscall
sw $v0, 0($sp) # new Object
subu $sp, $sp ,4
la $t0, Foo
sw $t0, ($v0)
li $t0, 5
sw $t0, 4($v0)
sw $ra, ($sp)
subu $sp, $sp, 4
sw $fp, ($sp)
subu $sp, $sp, 4
move $fp, $sp
jal .Foo.Foo
addu $sp, $sp, 4
move $sp, $fp
addu $sp, $sp, 4
lw $fp, ($sp)
addu $sp, $sp, 4
lw $ra, ($sp)
j case.end.7
action.24:
la $t0, case_error
sw $t0, ($sp)
subu $sp, $sp, 4
j .raise
case.end.7:
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
addu $t0, $t0, 8
lw $t1, 4($sp)
sw $t1, ($t0)
move $t0, $t0 # Case
lw $a0, 12($fp)
sw $a0, 0($sp)
subu $sp, $sp, 4
la $t0, void_error
sw $t0, ($sp)
lw $t0, 4($sp)
subu $sp, $sp, 4
beqz $t0, .raise
addu $sp, $sp, 4
la $a0, Bar #action Bar
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
beqz $a0, action.25
sw $t0, -16($fp)
lw $t0, -16($fp)
sw $t0, ($sp)
subu $sp, $sp, 4
j case.end.8
action.25:
la $a0, Razz #action Razz
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
beqz $a0, action.26
sw $t0, -20($fp)
li $v0, 9
li $a0, 44
syscall
sw $v0, 0($sp) # new Object
subu $sp, $sp ,4
la $t0, Bar
sw $t0, ($v0)
li $t0, 9
sw $t0, 4($v0)
sw $ra, ($sp)
subu $sp, $sp, 4
sw $fp, ($sp)
subu $sp, $sp, 4
move $fp, $sp
jal .Bar.Bar
addu $sp, $sp, 4
move $sp, $fp
addu $sp, $sp, 4
lw $fp, ($sp)
addu $sp, $sp, 4
lw $ra, ($sp)
j case.end.8
action.26:
la $a0, Foo #action Foo
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
beqz $a0, action.27
sw $t0, -24($fp)
li $v0, 9
li $a0, 36
syscall
sw $v0, 0($sp) # new Object
subu $sp, $sp ,4
la $t0, Razz
sw $t0, ($v0)
li $t0, 7
sw $t0, 4($v0)
sw $ra, ($sp)
subu $sp, $sp, 4
sw $fp, ($sp)
subu $sp, $sp, 4
move $fp, $sp
jal .Razz.Razz
addu $sp, $sp, 4
move $sp, $fp
addu $sp, $sp, 4
lw $fp, ($sp)
addu $sp, $sp, 4
lw $ra, ($sp)
j case.end.8
action.27:
la $t0, case_error
sw $t0, ($sp)
subu $sp, $sp, 4
j .raise
case.end.8:
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
addu $sp, $sp, 4
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
addu $t0, $t0, 16
lw $t1, 4($sp)
sw $t1, ($t0)
move $t0, $t0 # Case
lw $a0, 12($fp)
sw $a0, 0($sp)
subu $sp, $sp, 4
la $t0, void_error
sw $t0, ($sp)
lw $t0, 4($sp)
subu $sp, $sp, 4
beqz $t0, .raise
addu $sp, $sp, 4
la $a0, Bar #action Bar
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
beqz $a0, action.28
sw $t0, -28($fp)
lw $t0, -28($fp)
sw $t0, ($sp)
subu $sp, $sp, 4
j case.end.9
action.28:
la $a0, Razz #action Razz
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
beqz $a0, action.29
sw $t0, -32($fp)
li $v0, 9
li $a0, 44
syscall
sw $v0, 0($sp) # new Object
subu $sp, $sp ,4
la $t0, Bar
sw $t0, ($v0)
li $t0, 9
sw $t0, 4($v0)
sw $ra, ($sp)
subu $sp, $sp, 4
sw $fp, ($sp)
subu $sp, $sp, 4
move $fp, $sp
jal .Bar.Bar
addu $sp, $sp, 4
move $sp, $fp
addu $sp, $sp, 4
lw $fp, ($sp)
addu $sp, $sp, 4
lw $ra, ($sp)
j case.end.9
action.29:
la $t0, case_error
sw $t0, ($sp)
subu $sp, $sp, 4
j .raise
case.end.9:
lw $t0, 12($fp)
la $t1, void_error
sw $t1, ($sp)
subu $sp, $sp, 4
beqz $t0, .raise
addu $sp, $sp, 4
addu $t0, $t0, 8
addu $t0, $t0, 20
lw $t1, 4($sp)
sw $t1, ($t0)
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
jal .Bazz.doh
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
addu $sp, $sp, 4
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
lw $t0, 12($fp)
la $t1, void_error
sw $t1, ($sp)
subu $sp, $sp, 4
beqz $t0, .raise
addu $sp, $sp, 4
addu $t0, $t0, 8
addu $t0, $t0, 20
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
addu $t0, $t0, 24
lw $t1, 4($sp)
sw $t1, ($t0)
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
lw $t0, 12($fp)
la $t1, void_error
sw $t1, ($sp)
subu $sp, $sp, 4
beqz $t0, .raise
addu $sp, $sp, 4
addu $t0, $t0, 8
addu $t0, $t0, 28
lw $t1, 4($sp)
sw $t1, ($t0)
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
addu $t0, $t0, 32
lw $t1, 4($sp)
sw $t1, ($t0)
lw $a0, 12($fp)
sw $a0, 0($sp)
subu $sp, $sp, 4
lw $a0, 4($sp)
addu, $sp, $sp, 40
sw $a0, ($sp)
subu, $sp, $sp, 4
jr $ra
.Main.main:
li $t0, 0 #.Main.main
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
jr $ra
.Main.Main:
li $t0, 0 #.Main.Main
li $v0, 9
li $a0, 20
syscall
sw $v0, 0($sp) # new Object
subu $sp, $sp ,4
la $t0, Bazz
sw $t0, ($v0)
li $t0, 3
sw $t0, 4($v0)
sw $ra, ($sp)
subu $sp, $sp, 4
sw $fp, ($sp)
subu $sp, $sp, 4
move $fp, $sp
jal .Bazz.Bazz
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
addu $t0, $t0, 0
lw $t1, 4($sp)
sw $t1, ($t0)
li $v0, 9
li $a0, 28
syscall
sw $v0, 0($sp) # new Object
subu $sp, $sp ,4
la $t0, Foo
sw $t0, ($v0)
li $t0, 5
sw $t0, 4($v0)
sw $ra, ($sp)
subu $sp, $sp, 4
sw $fp, ($sp)
subu $sp, $sp, 4
move $fp, $sp
jal .Foo.Foo
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
li $v0, 9
li $a0, 36
syscall
sw $v0, 0($sp) # new Object
subu $sp, $sp ,4
la $t0, Razz
sw $t0, ($v0)
li $t0, 7
sw $t0, 4($v0)
sw $ra, ($sp)
subu $sp, $sp, 4
sw $fp, ($sp)
subu $sp, $sp, 4
move $fp, $sp
jal .Razz.Razz
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
addu $t0, $t0, 8
lw $t1, 4($sp)
sw $t1, ($t0)
li $v0, 9
li $a0, 44
syscall
sw $v0, 0($sp) # new Object
subu $sp, $sp ,4
la $t0, Bar
sw $t0, ($v0)
li $t0, 9
sw $t0, 4($v0)
sw $ra, ($sp)
subu $sp, $sp, 4
sw $fp, ($sp)
subu $sp, $sp, 4
move $fp, $sp
jal .Bar.Bar
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
# Start .data segment (data!)
.data
zero_error: .asciiz "Divition by zero exception"
index_error: .asciiz "Invalid index exception"
void_error: .asciiz "Objects must be inizializated before use exception"
case_error: .asciiz "Case expression no match exception"
void_str: .asciiz ""
msg0: .asciiz "do nothing"
buffer: .space 1024
type_str0: .asciiz "Object"
type_str1: .asciiz "Int"
type_str2: .asciiz "Bool"
type_str3: .asciiz "String"
type_str4: .asciiz "IO"
type_str5: .asciiz "Bazz"
type_str6: .asciiz "Foo"
type_str7: .asciiz "Razz"
type_str8: .asciiz "Bar"
type_str9: .asciiz "Main"
Object: .word 0, 19, type_str0, .Object.abort, .Object.type_name, .Object.copy
Int: .word 1, 2, type_str1, .Object.abort, .Object.type_name, .Object.copy
Bool: .word 3, 4, type_str2, .Object.abort, .Object.type_name, .Object.copy
String: .word 5, 6, type_str3, .Object.abort, .Object.type_name, .Object.copy, .String.length, .String.concat, .String.substr
IO: .word 7, 16, type_str4, .Object.abort, .Object.type_name, .Object.copy, .IO.out_string, .IO.out_int, .IO.in_string, .IO.in_int
Bazz: .word 8, 15, type_str5, .Object.abort, .Object.type_name, .Object.copy, .IO.out_string, .IO.out_int, .IO.in_string, .IO.in_int, .Bazz.printh, .Bazz.doh
Foo: .word 9, 14, type_str6, .Object.abort, .Object.type_name, .Object.copy, .IO.out_string, .IO.out_int, .IO.in_string, .IO.in_int, .Bazz.printh, .Foo.doh
Razz: .word 10, 13, type_str7, .Object.abort, .Object.type_name, .Object.copy, .IO.out_string, .IO.out_int, .IO.in_string, .IO.in_int, .Bazz.printh, .Foo.doh
Bar: .word 11, 12, type_str8, .Object.abort, .Object.type_name, .Object.copy, .IO.out_string, .IO.out_int, .IO.in_string, .IO.in_int, .Bazz.printh, .Foo.doh
Main: .word 17, 18, type_str9, .Object.abort, .Object.type_name, .Object.copy, .Main.main