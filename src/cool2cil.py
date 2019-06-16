import src.ast as ast
import src.cil_nodes as node
import src.visitor as visitor

class cool2cil:

    def __init__(self):
        self.string = []
        self.data = []
        self.code = []

    @visitor.on('node')
    def visit(self, node):
        pass

    @visitor.when(ast.ProgramNode)
    def visit(self, node):
        self.visit(node.class_list)


