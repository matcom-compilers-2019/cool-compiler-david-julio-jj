import src.ast as ast
import src.cil_nodes as cil_node
import src.visitor as visitor

class vTable:
    """
    {type:{f_name: int}}
    """
    pass

class cool2cil:

    def __init__(self):
        self.string = []
        self.data = []
        self.code = []
        self.vtable = vTable()

    @visitor.on('node')
    def visit(self, node):
        pass

    @visitor.when(ast.ProgramNode)
    def visit(self, node: ast.Program):
        self.code.append(cil_node.Jump('.Main.main'))
        self.visit(node.class_list)
        self.code.append(cil_node.Label('.end'))

    # @visitor.when(ast.Class)
    # def visit(self, node: ast.Class):

    @visitor.when(ast.Addition)
    def visit(self, node: ast.Addition):
        self.code.append(cil_node.Pop())
        self.visit(node.first)
        self.visit(node.second)


