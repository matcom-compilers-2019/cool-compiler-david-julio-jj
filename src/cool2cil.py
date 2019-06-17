import src.ast as ast
import src.cil_nodes as cil_node
import src.visitor as visitor
import src.scope as Scope
from src.scope import Scope
from src.type import ctype


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
        value = self.name_keys[var]
        self.name_keys[var] += 1
        self.name_keys[var] = 1

    def reset(self):
        self.name_keys = {}


class Cool2cil:

    def calc_static(self):
        r = 0
        for i in self.data:
            r += len(i)
        return r

    def sort_type(self, type_list: dict):
        type_list = list(type_list.values())
        type_map = {}
        bit_mask = [False] * len(type_list)
        for i in range(len(type_list)):
            ctype = type_list[i]
            type_map[ctype.name] = i

        bit_mask[type_map['Object']] = True
        sorted = {}
        self_type = type_list[type_map['SELF_TYPE']]
        sorted[self_type.name] = self_type
        object_type = type_list[type_map['Object']]
        sorted[object_type.name] = object_type
        for i in range(len(type_list)):
            ctype = type_list[i]
            if ctype.name == 'Object' or ctype.name == 'SELF_TYPE':
                continue
            if not bit_mask[i]:
                self.sort_type_(ctype, type_list, type_map, bit_mask, sorted)
        return sorted

    def sort_type_(self, ctype, type_list, type_map, mask, sort_list):
        mask[type_map[ctype.name]] = True
        parent = ctype.parent
        iparent = type_map[parent.name]
        if not mask[iparent]:
            self.sort_type_(parent, type_list, type_map, mask, sort_list)
        sort_list[ctype.name] = ctype

    def get_node_by_type(self, t, classes):
        for i in classes:
            if t == i.name:
                return i

    def delete(self, method_name, tp):
        t = []
        for i in range(len(tp.methods)):
            if method_name != (list(tp.methods[i].keys())[0]).split('.')[1]:
                t.append(tp.methods[i])
        tp.methods = t

    def __init__(self):
        self.constructors = {}
        self.data = []
        self.dtpe = []
        self.code = []
        self.vtable = vTable()
        self.name_generator = Unique_name_generator()

    @visitor.on('node')
    def visit(self, node, scope):
        pass

    @visitor.when(ast.Program)
    def visit(self, node: ast.Program, _):
        scope_root = Scope(None, None)
        for classDef in node.classes:
            new_type = ctype(classDef.name)
            scope_root.createType(new_type)
        for classDef in node.classes:
            a = scope_root.getType(classDef.name)
            a.parent = scope_root.getType(classDef.parent)
        new_types = self.sort_type(scope_root.get_types())
        node.classes = list(map(lambda x: self.get_node_by_type(x, node.classes), list(new_types.keys())[6:]))
        scope_root.set_types(new_types)
        t = scope_root.get_types()
        for i in list(new_types.keys())[1:6]:
            if i != 'Int' and i != 'Bool':
                new_types[i].fix_methods()
        for j in node.classes:
            scope = Scope(j.name, scope_root)
            methods = filter(lambda x: type(x) is ast.ClassMethod, j.features)
            methods = list(methods)
            attribs = filter(lambda x: type(x) is ast.ClassAttribute, j.features)
            attribs = list(attribs)
            p_type = scope.getType(j.parent)
            scope.getType(j.name).add_attrib(*tuple(p_type.attributes))
            scope.getType(j.name).add_method(*tuple(p_type.methods))
            for i in attribs:
                scope.getType(j.name).add_attrib({i.name: scope.getType(i.attr_type)})
            for i in methods:
                self.delete(i.name, scope.getType(j.name))
                scope.getType(j.name).add_method({f'{j.name}.{i.name}': {
                    'formal_params': {
                        t.name: scope.getType(t.param_type) for t in i.formal_params
                    },
                    'return_type': scope.getType(i.return_type),
                    'body': i.body
                }})
        for i in list(t.keys())[1:]:
            if i != 'Int' and i != 'Bool':
                self.constructors[i] = []
                meths = []
                for m in t[i].methods:
                    meths.append(list(m.keys())[0])
                attrs = []
                for a in t[i].attributes:
                    attrs.append(list(a.keys())[0])
                self.dtpe.append(cil_node.DotType(t[i].name, attrs, meths))

    @visitor.when(ast.Class)
    def visit(self, node: ast.Class, scope: CILScope):
        attr = filter(lambda x: type(x) is ast.ClassAttribute, node.features)
        attr = list(attr)
        for method in attr:
            self.constructors[node.name].append(self.visit(method, Scope(node.name))[1])
        methods = filter(lambda x: type(x) is ast.ClassMethod, node.features)
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
        real_name = scope.get_real_name(node.instance.name)
        expr = self.visit(node.expr, scope)
        if real_name == '':
            assignment_node = cil_node.CILSetAttr(node.instance.name)
        else :
            assignment_node = cil_node.CILAssignment(real_name)
        return expr[0], expr[1] + assignment_node

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

    @visitor.when(ast.ClassAttribute)
    def visit(self, node: ast.ClassAttribute, scope):
        if node.init_expr:
            tmp = self.visit(node.init_expr, scope)
            return tmp[0], [cil_node.CILAttribute(node.attr_type, node.name, tmp[1])]
        return [], []

    @visitor.when(ast.NewObject)
    def visit(self, node: ast.NewObject, scope):
        c = self.constructors[node.static_type.name]
        t = [cil_node.CILAlocate(node.static_type)]
        for i in c:
            t += i.exp_code
            t.append(cil_node.CILInitAttr(i.attr_name))

    @visitor.when(ast.Integer)
    def visit(self, node: ast.Integer, scope):
        return [], [cil_node.CILInteger(node.content)]

    @visitor.when(ast.Boolean)
    def visit(self, node: ast.Boolean, scope):
        return [], [cil_node.CILBoolean(node.content)]

    @visitor.when(ast.String)
    def visit(self, node: ast.String, scope):
        self.data.append(node.content)
        return [], [cil_node.CILString(self.calc_static())]

    @visitor.when(ast.Addition)
    def visit(self, node: ast.Addition, scope):
        return [], [cil_node.CILArithm(self.visit(node.first, scope), self.visit(node.second, scope), '+')]

    @visitor.when(ast.Subtraction)
    def visit(self, node: ast.Subtraction, scope):
        return [], [cil_node.CILArithm(self.visit(node.first, scope), self.visit(node.second, scope), '-')]

    @visitor.when(ast.Multiplication)
    def visit(self, node: ast.Multiplication, scope):
        return [], [cil_node.CILArithm(self.visit(node.first, scope), self.visit(node.second, scope), '*')]

    @visitor.when(ast.Division)
    def visit(self, node: ast.Division, scope):
        return [], [cil_node.CILArithm(self.visit(node.first, scope), self.visit(node.second, scope), '/')]

    @visitor.when(ast.Equal)
    def visit(self, node: ast.Equal, scope):
        return [], [cil_node.CILBoolOp(self.visit(node.first, scope), self.visit(node.second, scope), '=')]

    @visitor.when(ast.LessThan)
    def visit(self, node: ast.LessThan, scope):
        return [], [cil_node.CILBoolOp(self.visit(node.first, scope), self.visit(node.second, scope), '<')]

    @visitor.when(ast.LessThanOrEqual)
    def visit(self, node: ast.LessThanOrEqual, scope):
        return [], [cil_node.CILBoolOp(self.visit(node.first, scope), self.visit(node.second, scope), '<=')]

    @visitor.when(ast.IntegerComplement)
    def visit(self, node: ast.IntegerComplement, scope):
        return [], [cil_node.CILNArith(self.visit(node.integer_expr, scope))]

    @visitor.when(ast.BooleanComplement)
    def visit(self, node: ast.BooleanComplement, scope):
        return [], [cil_node.CILNBool(self.visit(node.boolean_expr, scope))]


