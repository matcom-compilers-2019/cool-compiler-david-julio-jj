# Semantic Analizer

# Authors:  Joel David Hernandez Cruz
#           Juan Jose Roque Cires
#           Julio Cesar Rodriguez Sanchez

# ------------------------------------------------------------------------------------------------------
#   Reference ply (Python Lex-Yacc) Documentation
#
#   Reference links
#   https://www.dabeaz.com/ply/ply.html#ply_nn13
#   http://www.dalkescientific.com/writings/NBN/parsing_with_ply.html
#   https://www.dabeaz.com/ply/PLYTalk.pdf
#
# ------------------------------------------------------------------------------------------------------

import src.visitor as visitor
import src.cil_nodes as node

# Registers
"""
Registers $v0 and $v1 are used to return values from functions.

Registers $a0 – $a3 are used to pass the first four arguments 
to routines (remaining arguments are passed on the stack).

Registers $t0 – $t9 are caller-saved registers that are used to
hold temporary quantities that need not be preserved across calls

Registers $s0 – $s7 (16–23) are callee-saved registers that hold long-lived
values that should be preserved across calls. They are preserve across calls

Register $gp is a global pointer that points to the middle of a 64K block
of memory in the static data segment. Preserve across calls

Register $fp is the frame pointer. Register $fp is saved by every procedure 
that allocates a new stack frame.Preserve across calls

Register $sp (29) is the stack pointer, which points to the last location on
the stack(Points to Free Memory). Preserve across calls

Register $ra only needs to be saved if the callee itself makes a call.
"""

"""
Code Example for Factorial
main (){
    printf ("The factorial of 10 is %d\n", fact (10));
}
int fact (int n){
    if (n < 1)
        return (1);
    else
        return (n * fact (n - 1));
}

    .text
    .globl main
main:
    subu    $sp, $sp, 32    # Stack frame is 32 bytes long
    sw      $ra, 20($sp)    # Save return address
    sw      $fp, 16($sp)    # Save old frame pointer
    addiu   $fp, $sp, 28    # Set up frame pointer

    li      $a0, 10         # Put argument (10) in $a0
    jal     fact            # Call factorial function

    la      $a0,$LC         # Put format string in $a0
    move    $a1,$v0         # Move fact result to $a1
    jal     printf          # Call the print function
    
    lw      $ra,20($sp)     # Restore return address
    lw      $fp,16($sp)     # Restore frame pointer
    addiu   $sp,$sp,32      # Pop stack frame
    jr      $ra             # Return to caller

    .rdata
$LC:
    .ascii  “The factorial of 10 is %d\n\000”
    
    .text
fact:
    subu    $sp, $sp, 32    # Stack frame is 32 bytes long
    sw      $ra, 20($sp)    # Save return address
    sw      $fp, 16($sp)    # Save frame pointer
    addiu   $fp, $sp, 28    # Set up frame pointer
    sw      $a0, 0($fp)     # Save argument (n)
    
    lw      $v0,0($fp)      # Load n
    bgtz    $v0,$L2         # Branch if n > 0
    li      $v0,1           # Return 1
    jr      $L1             # Jump to code to return

$L2:
    lw      $v1,0($fp)      # Load n
    subu    $v0,$v1,1       # Compute n - 1
    move    $a0,$v0         # Move value to $a0

    jal     fact            # Call factorial function
    
    lw      $v1,0($fp)      # Load n
    mul     $v0,$v0,$v1     # Compute fact(n-1) * n

$L1:                        # Result is in $v0
    lw      $ra, 20($sp)    # Restore $ra
    lw      $fp, 16($sp)    # Restore $fp
    addiu   $sp, $sp, 32    # Pop stack
    jr      $ra             # Return to caller
    

.inerithed:
    move [fp + 12], eax
    move [fp + 16], ebx
    move [eax], eax
    move [eax], ecx
    move [eax + 4], edx
    move [ebx], eax
    move [ebx + 4], ebx
    ge ecx, eax, eax
    le ebx, edx, ebx
    and eax, ebx, eax
    push eax
"""


class MIPS:
    def __init__(self, dotType, dotData, dotCode):
        self.dotType = dotType
        self.dotCode = dotCode
        self.dotData = dotData
        self.vars = []
        self.arguments = []
        self.mips_code = []

    def generate_mips(self):
        """
        Visits nodes in self.dot*
        """
        code = "    .text" \
               "    .glob main"

        exit_code = "li $v0, 10 " \
                    "syscall"
        pos = 0
        self.mips_code.append("# Start .data segment (data!)")
        self.mips_code.append(".data")
        for s_data in self.dotData:
            self.mips_code.append("msg{}:   .asscii     \"{}\"".format(pos, s_data))

    @visitor.on('node')
    def visit(self, node):
        pass

    @visitor.when(node.CILArithm)
    def visit(self, node: node.CILArithm):
        # Move values to $a0-$a1
        self.mips_code.append("lw $a0, {}($sp)".format(4 * node.fst))  # offset?
        self.mips_code.append("lw $a1, {}($sp)".format(4 * node.snd))

        if node.op == "+":
            self.mips_code.append("add $a0, $a0, $a1")
        elif node.op == "-":
            self.mips_code.append("sub $a0, $a0, $a1")
        elif node.op == "*":
            self.mips_code.append("mult $a0, $a1")
            self.mips_code.append("mlfo $a0")
        elif node.op == "/":
            self.mips_code.append("div $a0, $a1")
            self.mips_code.append("mlfo $a0")

        # Return value
        self.mips_code.append("sw $a0 0($sp)")

    @visitor.when(node.CILBoolOp)
    def visit(self, node: node.CILBoolOp):
        # Move values to $a0-$a1
        self.mips_code.append("lw $a0, {}($sp)".format(4 * node.fst))  # offset?
        self.mips_code.append("lw $a1, {}($sp)".format(4 * node.snd))

        if node.op == "=":
            self.mips_code.append("seq $a0, $a0, $a1")
        elif node.op == "<":
            self.mips_code.append("slt $a0, $a0, $a1")
        elif node.op == "<=":
            self.mips_code.append("sle $a0, $a0, $a1")
        elif node.op == ">":
            self.mips_code.append("sgt $a0, $a0, $a1")
        elif node.op == "=>":
            self.mips_code.append("sge $a0, $a0, $a1")

        # Return value
        self.mips_code.append("sw $a0 $sp")

    @visitor.when(node.CILNBool)
    def visit(self, node: node.CILNBool):
        self.mips_code.append("lw $a0, {}($sp)".format(4 * node.fst))

        self.mips_code.append("not $a0, $a0")

        # Return value
        self.mips_code.append("sw $a0 $sp")

    @visitor.when(node.CILNArith)
    def visit(self, node: node.CILNArith):
        self.mips_code.append("lw $a0, {}($sp)".format(4 * node.fst))

        self.mips_code.append("li $a1, 1")

        self.mips_code.append("sub $a0, $a1, $a0")

        # Return value
        self.mips_code.append("sw $a0 $sp")

    @visitor.when(node.CILJump)
    def visit(self, node: node.CILJump):
        self.mips_code.append("j {}".format(node.label))

    @visitor.when(node.CILLabel)
    def visit(self, node: node.CILLabel):
        self.mips_code.append("{}:".format(node.label))

    @visitor.when(node.CILIf)
    def visit(self, node: node.CILIf):
        self.visit(node.predicate)
        self.mips_code.append("move $t0, $a0")
        self.mips_code.append("li $t1, 1")
        self.mips_code.append("beq $t0, $t1, {}".format(node.if_tag))
        self.visit(node.else_body)
        self.mips_code.append("j {}".format(node.end_tag))
        self.mips_code.append("{}:".format(node.if_tag))
        self.visit(node.then_body)

    @visitor.when(node.CILWhile)
    def visit(self, node: node.CILWhile):
        self.mips_code.append("{}:".format(node.while_tag))
        self.visit(node.predicate)
        self.mips_code.append("move $t0, $a0")
        self.mips_code.append("li $t1, 1")
        self.mips_code.append("bne $t0, $t1, {}".format(node.end_tag))
        self.visit(node.body)
        self.mips_code.append("j {}".format(node.while_tag))
        self.mips_code.append("{}:".format(node.end_tag))

    @visitor.when(node.CILAlocate)
    def visit(self, node: node.CILAlocate):
        self.mips_code.append("li $v0, 9")
        self.mips_code.append("li $a0, {}".format(4 * (node.ctype + 4)))
        self.mips_code.append("syscall")
        # $v0 contains address of allocated memory
        self.mips_code.append("sw $v0, 0($sp)")

    @visitor.when(node.CILInitAttr)
    def visit(self, node: node.CILAttribute):
        self.mips_code.append("lw $t0, 4($sp)")
        self.mips_code.append("lw $t1, (12)($fp)")
        self.mips_code.append("addi $t1, $t1, 4")
        self.mips_code.append("sw $t0, $t1")
        self.mips_code.append("addu $sp, $sp, 4")

    @visitor.when(node.CILNew)
    def visit(self, node: node.CILNew):
        self.mips_code.append("subu $sp, $sp, 8")
        self.mips_code.append("sw $ra, 8($sp)")
        self.mips_code.append("sw $fp, 4($sp)")
        self.mips_code.append("la $fp, $sp")

        for attr in node.attributes:
            self.visit(attr)

    @visitor.when(node.CILInteger)
    def visit(self, node: node.CILInteger):
        self.mips_code.append("lw $a0, {}($sp)".format(4 * node.value))
        self.mips_code.append("sw $a0, {}($sp)".format(4 * node.value))

    @visitor.when(node.CILBoolean)
    def visit(self, node: node.CILBoolean):
        if node.value:
            self.mips_code.append("li $a0, 1")
        else:
            self.mips_code.append("li $a0, 0")
        self.mips_code.append("sw $a0, 4($sp)")

    @visitor.when(node.CILString)
    def visit(self, node: node.CILString):
        self.mips_code.append("la $t5, msg{}".format(node.pos))

    @visitor.when(node.CILDynamicDispatch)
    def visit(self, node: node.CILDynamicDispatch):
        self.mips_code.append("lw $t0, ($sp)")
        self.mips_code.append("la $t1, $t0")
        self.mips_code.append("la $t2, {}($t1)".format(4 * (node.c_args + 1)))

        self.mips_code.append("subu $sp, $sp, 12")
        self.mips_code.append("sw $ra, 12($sp)")
        self.mips_code.append("sw $fp, 8($sp)")
        self.mips_code.append("la $fp, $sp")

        self.mips_code.append("j ($t2)")

        self.mips_code.append("la $sp, $fp")
        self.mips_code.append("addu $sp, $sp, 12")
        self.mips_code.append("lw $ra, 12($sp)")
        self.mips_code.append("lw $fp, 8($sp)")

        self.mips_code.append("addu $sp, $sp, -{}".format(len(self.vars)))

    @visitor.when(node.CILStaticDispatch)
    def visit(self, node: node.CILStaticDispatch):
        self.mips_code.append("subu $sp, $sp, 12")
        self.mips_code.append("sw $ra, 12($sp)")
        self.mips_code.append("sw $fp, 8($sp)")
        self.mips_code.append("la $fp, $sp")

        self.mips_code.append("j {}".format(node.method))

        self.mips_code.append("la $sp, $fp")
        self.mips_code.append("addu $sp, $sp, 12")
        self.mips_code.append("lw $ra, 12($sp)")
        self.mips_code.append("lw $fp, 8($sp)")

        self.mips_code.append("addu $sp, $sp, -{}".format(len(self.vars)))

    @visitor.when(node.CILMethod)
    def visit(self, node: node.CILMethod):
        self.vars = node.local
        self.arguments = node.params

        self.mips_code.append("{}:".format(node.name))
        self.mips_code.append("addu $sp, $sp, {}".format(4 * len(node.local)))

        for code in node.body:
            self.visit(code)

