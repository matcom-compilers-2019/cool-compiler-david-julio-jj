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

# Registers
"""
Registers $v0 and $v1 are used to return values from functions.
"""
V0 = '$v0'

"""
Registers $a0 – $a3 are used to pass the first four arguments 
to routines (remaining arguments are passed on the stack).
"""
A0 = '$a0'

"""
Registers $t0 – $t9 are caller-saved registers that are used to
hold temporary quantities that need not be preserved across calls
"""
T0 = '$t0'

"""
Registers $s0 – $s7 (16–23) are callee-saved registers that hold long-lived
values that should be preserved across calls. They are preserve across calls
"""
S0 = '%s0'

"""
Register $gp is a global pointer that points to the middle of a 64K block
of memory in the static data segment. Preserve across calls
"""
GP = '$gp'

"""
Register $fp is the frame pointer. Register $fp is saved by every procedure 
that allocates a new stack frame.Preserve across calls
"""
FP = '$fp'

"""
Register $sp (29) is the stack pointer, which points to the last location on
the stack(Points to Free Memory). Preserve across calls
"""
SP = '$sp'

"""
Register $ra only needs to be saved if the callee itself makes a call.
"""
RA = '$ra'


class MIPS:
    def __init__(self, dotType, dotData, dotCode):
        self.dotType = dotType
        self.dotCode = dotCode
        self.dotData = dotData
        self.mips_code = ""

    def generate_mips(self):
        """
        Visits nodes in self.dot*
        """

    @visitor.on('node')
    def visit(self, node, scope):
        pass
