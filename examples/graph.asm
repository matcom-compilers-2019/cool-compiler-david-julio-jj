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
li $a0, 20
syscall
sw $v0, 0($sp) # new Object
subu $sp, $sp ,4
la $t0, Main
sw $t0, ($v0)
li $t0, 3
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
j .Object.abort
.Graph.add_vertice:
li $t0, 0 #.Graph.add_vertice
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
lw $t1, 4($sp)
sw $t1, ($t0)
lw $a0, 4($sp)
addu, $sp, $sp, 8
sw $a0, ($sp)
subu, $sp, $sp, 4
jr $ra
.Graph.print_E:
li $t0, 0 #.Graph.print_E
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
jr $ra
.Graph.print_V:
li $t0, 0 #.Graph.print_V
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
jr $ra
.Graph.Graph:
li $t0, 0 #.Graph.Graph
li $v0, 9
li $a0, 12
syscall
sw $v0, 0($sp) # new Object
subu $sp, $sp ,4
la $t0, VList
sw $t0, ($v0)
li $t0, 1
sw $t0, 4($v0)
sw $ra, ($sp)
subu $sp, $sp, 4
sw $fp, ($sp)
subu $sp, $sp, 4
move $fp, $sp
jal .VList.VList
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
li $a0, 12
syscall
sw $v0, 0($sp) # new Object
subu $sp, $sp ,4
la $t0, EList
sw $t0, ($v0)
li $t0, 1
sw $t0, 4($v0)
sw $ra, ($sp)
subu $sp, $sp, 4
sw $fp, ($sp)
subu $sp, $sp, 4
move $fp, $sp
jal .EList.EList
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
.Vertice.outgoing:
li $t0, 0 #.Vertice.outgoing
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
.Vertice.number:
li $t0, 0 #.Vertice.number
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
.Vertice.init:
li $t0, 0 #.Vertice.init
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
.Vertice.add_out:
li $t0, 0 #.Vertice.add_out
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
lw $a0, 12($fp)
sw $a0, 0($sp)
subu $sp, $sp, 4
lw $a0, 4($sp)
addu, $sp, $sp, 8
sw $a0, ($sp)
subu, $sp, $sp, 4
jr $ra
.Vertice.print:
li $t0, 0 #.Vertice.print
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
lw $a0, 4($sp)
addu, $sp, $sp, 8
sw $a0, ($sp)
subu, $sp, $sp, 4
jr $ra
.Vertice.Vertice:
li $t0, 0 #.Vertice.Vertice
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
li $a0, 12
syscall
sw $v0, 0($sp) # new Object
subu $sp, $sp ,4
la $t0, EList
sw $t0, ($v0)
li $t0, 1
sw $t0, 4($v0)
sw $ra, ($sp)
subu $sp, $sp, 4
sw $fp, ($sp)
subu $sp, $sp, 4
move $fp, $sp
jal .EList.EList
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
.Edge.init:
li $t0, 0 #.Edge.init
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
.Edge.print:
li $t0, 0 #.Edge.print
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
lw $a0, 4($sp)
addu, $sp, $sp, 24
sw $a0, ($sp)
subu, $sp, $sp, 4
jr $ra
.Edge.Edge:
li $t0, 0 #.Edge.Edge
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
.EList.isNil:
li $t0, 0 #.EList.isNil
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
.EList.head:
li $t0, 0 #.EList.head
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
lw $a0, 4($sp)
addu, $sp, $sp, 8
sw $a0, ($sp)
subu, $sp, $sp, 4
jr $ra
.EList.tail:
li $t0, 0 #.EList.tail
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
addu, $sp, $sp, 8
sw $a0, ($sp)
subu, $sp, $sp, 4
jr $ra
.EList.cons:
li $t0, 0 #.EList.cons
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
la $t0, ECons
sw $t0, ($v0)
li $t0, 2
sw $t0, 4($v0)
sw $ra, ($sp)
subu $sp, $sp, 4
sw $fp, ($sp)
subu $sp, $sp, 4
move $fp, $sp
jal .ECons.ECons
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
addu $sp, $sp, 12
sw $t0, ($sp)
subu $sp, $sp, 4
jr $ra
.EList.append:
li $t0, 0 #.EList.append
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
.if.end.1:
jr $ra
.EList.print:
li $t0, 0 #.EList.print
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
jr $ra
.EList.EList:
li $t0, 0 #.EList.EList
lw $a0, 12($fp)
sw $a0, 0($sp)
subu $sp, $sp, 4
lw $a0, 4($sp)
addu, $sp, $sp, 4
sw $a0, ($sp)
subu, $sp, $sp, 4
jr $ra
.ECons.isNil:
li $t0, 0 #.ECons.isNil
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
.ECons.head:
li $t0, 0 #.ECons.head
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
.ECons.tail:
li $t0, 0 #.ECons.tail
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
.ECons.init:
li $t0, 0 #.ECons.init
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
.ECons.print:
li $t0, 0 #.ECons.print
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
lw $a0, 4($sp)
addu, $sp, $sp, 8
sw $a0, ($sp)
subu, $sp, $sp, 4
jr $ra
.ECons.ECons:
li $t0, 0 #.ECons.ECons
lw $a0, 12($fp)
sw $a0, 0($sp)
subu $sp, $sp, 4
lw $a0, 4($sp)
addu, $sp, $sp, 4
sw $a0, ($sp)
subu, $sp, $sp, 4
jr $ra
.VList.isNil:
li $t0, 0 #.VList.isNil
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
.VList.head:
li $t0, 0 #.VList.head
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
lw $a0, 4($sp)
addu, $sp, $sp, 8
sw $a0, ($sp)
subu, $sp, $sp, 4
jr $ra
.VList.tail:
li $t0, 0 #.VList.tail
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
addu, $sp, $sp, 8
sw $a0, ($sp)
subu, $sp, $sp, 4
jr $ra
.VList.cons:
li $t0, 0 #.VList.cons
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
la $t0, VCons
sw $t0, ($v0)
li $t0, 2
sw $t0, 4($v0)
sw $ra, ($sp)
subu $sp, $sp, 4
sw $fp, ($sp)
subu $sp, $sp, 4
move $fp, $sp
jal .VCons.VCons
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
.VList.print:
li $t0, 0 #.VList.print
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
jr $ra
.VList.VList:
li $t0, 0 #.VList.VList
lw $a0, 12($fp)
sw $a0, 0($sp)
subu $sp, $sp, 4
lw $a0, 4($sp)
addu, $sp, $sp, 4
sw $a0, ($sp)
subu, $sp, $sp, 4
jr $ra
.VCons.isNil:
li $t0, 0 #.VCons.isNil
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
.VCons.head:
li $t0, 0 #.VCons.head
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
.VCons.tail:
li $t0, 0 #.VCons.tail
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
.VCons.init:
li $t0, 0 #.VCons.init
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
.VCons.print:
li $t0, 0 #.VCons.print
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
lw $a0, 4($sp)
addu, $sp, $sp, 8
sw $a0, ($sp)
subu, $sp, $sp, 4
jr $ra
.VCons.VCons:
li $t0, 0 #.VCons.VCons
lw $a0, 12($fp)
sw $a0, 0($sp)
subu $sp, $sp, 4
lw $a0, 4($sp)
addu, $sp, $sp, 4
sw $a0, ($sp)
subu, $sp, $sp, 4
jr $ra
.Parse.read_input:
li $t0, 0 #.Parse.read_input
sw $t0, ($sp)
subu $sp, $sp, 4
sw $t0, ($sp)
subu $sp, $sp, 4
li $v0, 9
li $a0, 16
syscall
sw $v0, 0($sp) # new Object
subu $sp, $sp ,4
la $t0, Graph
sw $t0, ($v0)
li $t0, 2
sw $t0, 4($v0)
sw $ra, ($sp)
subu $sp, $sp, 4
sw $fp, ($sp)
subu $sp, $sp, 4
move $fp, $sp
jal .Graph.Graph
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
sw $t1, -4($fp)
addu $sp, $sp, 4
.while.start.1:
lw $t0, -4($fp)
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
addu $sp, $sp, 12
sw $t0, ($sp)
subu $sp, $sp, 4
lw $t0, 4($sp)
lw $a0, 8($t0)
addu $sp, $sp, 4
beqz $a0, .while.end.1
lw $t0, -4($fp)
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
lw $a0, 4($sp)
addu, $sp, $sp, 8
sw $a0, ($sp)
subu, $sp, $sp, 4
jr $ra
.Parse.parse_line:
li $t0, 0 #.Parse.parse_line
sw $t0, ($sp)
subu $sp, $sp, 4
sw $t0, ($sp)
subu $sp, $sp, 4
sw $t0, ($sp)
subu $sp, $sp, 4
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
li $a0, 16
syscall
sw $v0, 0($sp) # new Object
subu $sp, $sp ,4
la $t0, Vertice
sw $t0, ($v0)
li $t0, 2
sw $t0, 4($v0)
sw $ra, ($sp)
subu $sp, $sp, 4
sw $fp, ($sp)
subu $sp, $sp, 4
move $fp, $sp
jal .Vertice.Vertice
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
addu $sp, $sp, 8
sw $t0, ($sp)
subu $sp, $sp, 4
lw $t1, 4($sp)
sw $t1, -0($fp)
addu $sp, $sp, 4
.while.start.2:
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
beqz $a0, .while.end.2
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
li $a0, 20
syscall
sw $v0, 0($sp) # new Object
subu $sp, $sp ,4
la $t0, Edge
sw $t0, ($v0)
li $t0, 3
sw $t0, 4($v0)
sw $ra, ($sp)
subu $sp, $sp, 4
sw $fp, ($sp)
subu $sp, $sp, 4
move $fp, $sp
jal .Edge.Edge
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
addu $sp, $sp, 16
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
lw $a0, 4($sp)
addu, $sp, $sp, 4
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
.Parse.c2i:
li $t0, 0 #.Parse.c2i
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
li $a0, 0
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
li $a0, 1
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
li $a0, 2
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
la $a0, msg10
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
li $a0, 3
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
la $a0, msg11
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
li $a0, 4
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
la $a0, msg12
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
li $a0, 5
sw $a0, 8($v0)
sw $v0, ($sp)
subu $sp, $sp, 4
j .if.end.6
.if.start.6:
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
la $a0, msg13
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
lw $t4, 4($sp) # .if.start.5
lw $t5, 8($t4)
addu $sp, $sp, 4
beqz $t5, .if.start.5
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
j .if.end.5
.if.start.5:
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
la $a0, msg14
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
lw $t4, 4($sp) # .if.start.4
lw $t5, 8($t4)
addu $sp, $sp, 4
beqz $t5, .if.start.4
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
j .if.end.4
.if.start.4:
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
la $a0, msg15
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
lw $t4, 4($sp) # .if.start.3
lw $t5, 8($t4)
addu $sp, $sp, 4
beqz $t5, .if.start.3
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
j .if.end.3
.if.start.3:
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
la $a0, msg16
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
lw $t4, 4($sp) # .if.start.2
lw $t5, 8($t4)
addu $sp, $sp, 4
beqz $t5, .if.start.2
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
j .if.end.2
.if.start.2:
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
.if.end.2:
.if.end.3:
.if.end.4:
.if.end.5:
.if.end.6:
.if.end.7:
.if.end.8:
.if.end.9:
.if.end.10:
.if.end.11:
jr $ra
.Parse.a2i:
li $t0, 0 #.Parse.a2i
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
li $a0, 0
sw $a0, 8($v0)
sw $v0, ($sp)
subu $sp, $sp, 4
j .if.end.14
.if.start.14:
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
la $a0, msg17
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
j .if.end.13
.if.start.13:
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
la $a0, msg18
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
j .if.end.12
.if.start.12:
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
.if.end.12:
.if.end.13:
.if.end.14:
jr $ra
.Parse.a2i_aux:
li $t0, 0 #.Parse.a2i_aux
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
.while.start.3:
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
beqz $a0, .while.end.3
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
lw $t1, 4($sp)
sw $t1, -12($fp)
addu $sp, $sp, 4
lw $t0, -12($fp)
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
lw $t4, 4($sp) # .if.start.17
lw $t5, 8($t4)
addu $sp, $sp, 4
beqz $t5, .if.start.17
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
lw $t0, -8($fp)
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
lw $t0, -4($fp)
sw $t0, ($sp)
subu $sp, $sp, 4
lw $t0, 4($sp)
sw $t0, -8($fp)
lw $a0, 4($sp)
addu, $sp, $sp, 8
sw $a0, ($sp)
subu, $sp, $sp, 4
j .if.end.17
.if.start.17:
lw $t0, -12($fp)
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
lw $t4, 4($sp) # .if.start.16
lw $t5, 8($t4)
addu $sp, $sp, 4
beqz $t5, .if.start.16
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
lw $t0, -8($fp)
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
lw $t0, -4($fp)
sw $t0, ($sp)
subu $sp, $sp, 4
lw $t0, 4($sp)
sw $t0, -8($fp)
lw $a0, 4($sp)
addu, $sp, $sp, 8
sw $a0, ($sp)
subu, $sp, $sp, 4
j .if.end.16
.if.start.16:
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
lw $t4, 4($sp) # .if.start.15
lw $t5, 8($t4)
addu $sp, $sp, 4
beqz $t5, .if.start.15
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
j .if.end.15
.if.start.15:
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
.if.end.15:
lw $a0, 4($sp)
addu, $sp, $sp, 12
sw $a0, ($sp)
subu, $sp, $sp, 4
.if.end.16:
.if.end.17:
j .while.start.3
.while.end.3:
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
.Parse.Parse:
li $t0, 0 #.Parse.Parse
li $v0, 9
li $a0, 8
syscall
sw $v0, 0($sp) # new Object
subu $sp, $sp ,4
la $t0, BoolOp
sw $t0, ($v0)
li $t0, 0
sw $t0, 4($v0)
sw $ra, ($sp)
subu $sp, $sp, 4
sw $fp, ($sp)
subu $sp, $sp, 4
move $fp, $sp
jal .BoolOp.BoolOp
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
.Main.main:
li $t0, 0 #.Main.main
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
lw $a0, 4($sp)
addu, $sp, $sp, 8
sw $a0, ($sp)
subu, $sp, $sp, 4
jr $ra
.Main.Main:
li $t0, 0 #.Main.Main
li $v0, 9
li $a0, 8
syscall
sw $v0, 0($sp) # new Object
subu $sp, $sp ,4
la $t0, BoolOp
sw $t0, ($v0)
li $t0, 0
sw $t0, 4($v0)
sw $ra, ($sp)
subu $sp, $sp, 4
sw $fp, ($sp)
subu $sp, $sp, 4
move $fp, $sp
jal .BoolOp.BoolOp
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
.BoolOp.and:
li $t0, 0 #.BoolOp.and
lw $t0, 20($fp)
sw $t0, ($sp)
subu $sp, $sp, 4
lw $t4, 4($sp) # .if.start.18
lw $t5, 8($t4)
addu $sp, $sp, 4
beqz $t5, .if.start.18
lw $t0, 16($fp)
sw $t0, ($sp)
subu $sp, $sp, 4
j .if.end.18
.if.start.18:
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
.if.end.18:
jr $ra
.BoolOp.or:
li $t0, 0 #.BoolOp.or
lw $t0, 20($fp)
sw $t0, ($sp)
subu $sp, $sp, 4
lw $t4, 4($sp) # .if.start.19
lw $t5, 8($t4)
addu $sp, $sp, 4
beqz $t5, .if.start.19
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
j .if.end.19
.if.start.19:
lw $t0, 16($fp)
sw $t0, ($sp)
subu $sp, $sp, 4
.if.end.19:
jr $ra
.BoolOp.BoolOp:
li $t0, 0 #.BoolOp.BoolOp
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
msg0: .asciiz " ("
msg1: .asciiz ","
msg2: .asciiz ")"
msg3: .asciiz "
"
msg4: .asciiz "
"
msg5: .asciiz "
"
msg6: .asciiz ""
msg7: .asciiz "0"
msg8: .asciiz "1"
msg9: .asciiz "2"
msg10: .asciiz "3"
msg11: .asciiz "4"
msg12: .asciiz "5"
msg13: .asciiz "6"
msg14: .asciiz "7"
msg15: .asciiz "8"
msg16: .asciiz "9"
msg17: .asciiz "-"
msg18: .asciiz " "
msg19: .asciiz " "
msg20: .asciiz ","
msg21: .asciiz ""
msg22: .asciiz ""
msg23: .asciiz ""
msg24: .asciiz ""
buffer: .space 1024
type_str0: .asciiz "Object"
type_str1: .asciiz "Int"
type_str2: .asciiz "Bool"
type_str3: .asciiz "String"
type_str4: .asciiz "IO"
type_str5: .asciiz "Graph"
type_str6: .asciiz "Vertice"
type_str7: .asciiz "Edge"
type_str8: .asciiz "EList"
type_str9: .asciiz "ECons"
type_str10: .asciiz "VList"
type_str11: .asciiz "VCons"
type_str12: .asciiz "Parse"
type_str13: .asciiz "Main"
type_str14: .asciiz "BoolOp"
Object: .word 0, 29, type_str0, .Object.abort, .Object.type_name, .Object.copy
Int: .word 1, 2, type_str1, .Object.abort, .Object.type_name, .Object.copy
Bool: .word 3, 4, type_str2, .Object.abort, .Object.type_name, .Object.copy
String: .word 5, 6, type_str3, .Object.abort, .Object.type_name, .Object.copy, .String.length, .String.concat, .String.substr
IO: .word 7, 24, type_str4, .Object.abort, .Object.type_name, .Object.copy, .IO.out_string, .IO.out_int, .IO.in_string, .IO.in_int
Graph: .word 25, 26, type_str5, .Object.abort, .Object.type_name, .Object.copy, .Graph.add_vertice, .Graph.print_E, .Graph.print_V
Vertice: .word 8, 9, type_str6, .Object.abort, .Object.type_name, .Object.copy, .IO.out_string, .IO.out_int, .IO.in_string, .IO.in_int, .Vertice.outgoing, .Vertice.number, .Vertice.init, .Vertice.add_out, .Vertice.print
Edge: .word 10, 11, type_str7, .Object.abort, .Object.type_name, .Object.copy, .IO.out_string, .IO.out_int, .IO.in_string, .IO.in_int, .Edge.init, .Edge.print
EList: .word 12, 15, type_str8, .Object.abort, .Object.type_name, .Object.copy, .IO.out_string, .IO.out_int, .IO.in_string, .IO.in_int, .EList.isNil, .EList.head, .EList.tail, .EList.cons, .EList.append, .EList.print
ECons: .word 13, 14, type_str9, .Object.abort, .Object.type_name, .Object.copy, .IO.out_string, .IO.out_int, .IO.in_string, .IO.in_int, .ECons.isNil, .ECons.head, .ECons.tail, .EList.cons, .EList.append, .ECons.print, .ECons.init
VList: .word 16, 19, type_str10, .Object.abort, .Object.type_name, .Object.copy, .IO.out_string, .IO.out_int, .IO.in_string, .IO.in_int, .VList.isNil, .VList.head, .VList.tail, .VList.cons, .VList.print
VCons: .word 17, 18, type_str11, .Object.abort, .Object.type_name, .Object.copy, .IO.out_string, .IO.out_int, .IO.in_string, .IO.in_int, .VCons.isNil, .VCons.head, .VCons.tail, .VList.cons, .VCons.print, .VCons.init
Parse: .word 20, 23, type_str12, .Object.abort, .Object.type_name, .Object.copy, .IO.out_string, .IO.out_int, .IO.in_string, .IO.in_int, .Parse.read_input, .Parse.parse_line, .Parse.c2i, .Parse.a2i, .Parse.a2i_aux
Main: .word 21, 22, type_str13, .Object.abort, .Object.type_name, .Object.copy, .IO.out_string, .IO.out_int, .IO.in_string, .IO.in_int, .Parse.read_input, .Parse.parse_line, .Parse.c2i, .Parse.a2i, .Parse.a2i_aux, .Main.main
BoolOp: .word 27, 28, type_str14, .Object.abort, .Object.type_name, .Object.copy, .BoolOp.and, .BoolOp.or