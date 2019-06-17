import src.ast as ast
import src.cil_nodes as cil_node
import src.visitor as visitor
import src.scope as Scope

class vTable:
    """
    {type:{f_name: int}}
    """
    pass

BACKUP_REGISTER = 't0'


class CILScope:
    def __init__(self, classname, parentScope=None):
        self.classname = classname
        self.parentScope = parentScope
        self.vars = []

    def add_var(self, var):
        self.vars.append(var)

    def get_real_name(self, var_name: str):
        for name in self.var:
            if var_name in name:
                return name
        if self.parentScope:
            return self.parentScope.get_real_name(var_name)
        return '' 

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
    
    def reset(self):
        self.name_keys = {}

class cool2cil:

    def __init__(self):
        self.data = []
        self.types = []
        self.code = []
        self.vtable = vTable()
        self.name_generator = Unique_name_generator()

    @visitor.on('node')
    def visit(self, node, scope):
        pass

    @visitor.when(ast.ProgramNode)
    def visit(self, node: ast.Program, scope: CILScope):
        self.code.append(cil_node.CILJump('.Main.main'))
        self.visit(node.class_list)
        self.code.append(cil_node.CILLabel('.end'))

    @visitor.when(ast.Class)
    def visit(self, node: ast.Class, scope: CILScope):
        methods = filter(lambda x: type(x) is ast.ClassMethod, j.features)
        methods = list(methods)    
        for method in methods:
            self.visit(method, Scope(node.name))

    @visitor.when(ast.ClassMethod)
    def visit(self, node: ast.ClassMethod, scope: CILScope):
        self.name_generator.reset()
        params = ['self']
        for p in node.formal_params:
            redefinition = self.name_generator.generate(p) 
            params.append(redefinition)
            scope.add_var(redefinition)
        var, exprs = self.visit(node.body, scope)
        method = cil_node.CILMethod(node.name, scope.classname, params, var, exprs)
        self.code.append(method)

    @visitor.when(ast.Assignment)
    def visit(self, node: ast.Assignment, scope: CILScope):
        real_name = scope.get_real_name(node.instance)
        expr = self.visit(node.expr, scope) 
        if real_name == '':
            assignment_node = cil_node.CILGetAttr(node.instance, expr)
        else :
            assignment_node = cil_node.CILAssignment(real_name, expr)
        return ([expr[0]], [expr[1], assignment_node])

    @visitor.when(ast.Block)
    def visit(self, node: ast.Block, scope: CILScope):
        var = []
        codes = []
        for expr in node.expr_list:
            tmp = self.visit(expr, scope)
            var += tmp[0]
            codes += tmp[1] + cil_node.CILPop()
        return var, codes[:-1]

    @visitor.when(ast.DynamicDispatch)
    def visit(self, node: ast.DynamicDispatch, scope: CILScope):
        args = []
        var = []
        codes = []
        tmp = self.visit(node.instance, scope)
        for item in node.arguments:
            tmp = self.visit(item, scope)
            codes += tmp[1]
        codes.append(tmp[1])
        codes.append(cil_node.CILDynamicDispatch(len(node.arguments), node.method))
        return var, codes

    @visitor.when(ast.StaticDispatch)
    def visit(self, node: ast.StaticDispatch, scope: CILScope):
        args = []
        var = []
        codes = []
        tmp = self.visit(node.instance, scope)
        for item in node.arguments:
            tmp = self.visit(item, scope)
            codes += tmp[1]
        codes.append(tmp[1])
        codes.append(cil_node.CILStaticDispatch(len(node.arguments), scope.classname, node.method))
        return var, codes

    @visitor.when(ast.Addition)
    def visit(self, node: ast.Addition, node: CILScope):
        self.code.append(cil_node.CILPop())
        self.visit(node.first)
        self.visit(node.second)


