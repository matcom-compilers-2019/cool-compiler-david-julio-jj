import src.ast as ast
import src.cil_nodes as cil_node
import src.visitor as visitor

class vTable:
    """
    {type:{f_name: int}}
    """
    pass

class Unique_name_generator:
    def __init__(self):
        self.name_keys = {}

    def generate(self, var: str):
        value = 1
        try:
            value = self.name_keys[var]
            self.name_keys[var] += 1
        except expression as identifier:
            self.name_keys[var] = 1
        return f'{var}@{str(value)}'

class cool2cil:

    def __init__(self):
        self.string = []
        self.data = []
        self.code = []
        self.vtable = vTable()
        self.name_generator = Unique_name_generator()

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


