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

import src.ast as ast
from src.scope import Scope
from src.type import ctype


class CheckSemanticError(BaseException):
    def __init__(self, e):
        self.e = e

    def __str__(self):
        return self.e


class CheckSemantic:

    def check_ciclic_inheritance(self, type_list: dict):
        type_list = list(type_list.values())
        type_map = {}
        for i in range(len(type_list)):
            ctype = type_list[i]
            type_map[ctype.name] = i

        for i in range(len(type_list)):
            bit_mask = [False] * len(type_list)
            ctype = type_list[i]
            if not bit_mask[i] and not ctype.name == 'Object' and not ctype.name == 'SELF_TYPE':
                self.check_ciclic_inheritance_(ctype, type_map, bit_mask)
    
    def check_ciclic_inheritance_(self, ctype, type_map, mask):
        itype = type_map[ctype.name]
        if mask[itype]:
            raise CheckSemanticError(f'Circular inheritance at the type {ctype.name}')
        mask[itype] = True
        if ctype.parent.name == 'Object':
            return
        self.check_ciclic_inheritance_(ctype.parent, type_map, mask)

    @visitor.on('node')
    def visit(self, node, scope):
        pass

    @visitor.when(ast.Program)
    def visit(self, node: ast.Program, _):
        scope = Scope(None, None)
        for classDef in node.classes:
            new_type = ctype(classDef.name)
            scope.createType(new_type)
        for classDef in node.classes:
            a = scope.getType(classDef.name)
            a.parent = scope.getType(classDef.parent)
        self.check_ciclic_inheritance(scope.get_types())
        for i in node.classes:
            self.visit(i, Scope(i.name, scope))

    @visitor.when(ast.Class)
    def visit(self, node: ast.Class, scope: Scope):
        methods = filter(lambda x: type(x) is ast.ClassMethod, node.features)
        methods = list(methods)
        attribs = filter(lambda x: type(x) is ast.ClassAttribute, node.features)
        attribs = list(attribs)
        for i in attribs:
            scope.getType(node.name).add_attrib({i.name: scope.getType(i.attr_type)})
            scope.defineAttrib(i.name, scope.getType(i.attr_type))
        for i in methods:
            scope.getType(node.name).add_method({i.name: {
                'formal_params': {
                    t.name: scope.getType(t.param_type) for t in i.formal_params
                },
                'return_type': scope.getType(i.return_type),
                'body': i.body
            }})
        for i in node.features:
            self.visit(i, Scope(scope.classname, scope))

    @visitor.when(ast.ClassAttribute)
    def visit(self, node: ast.ClassAttribute, scope: Scope):
        node.static_type = scope.getType(node.attr_type)
        if node.init_expr:
            t_exp = self.visit(node.init_expr, scope)
            if node.attr_type != 'SELF_TYPE':
                if t_exp.name == 'SELF_TYPE':
                    raise CheckSemanticError(f'You can\t not assign a SELF_TYPE expression in a non SELF_TYPE'
                                             f'attribute')
                if not scope.getType(node.attr_type) < t_exp:
                    raise CheckSemanticError(f'{str(t_exp)} doesn\'t conform {str(scope.getType(node.attr_type))}')
            else:
                if t_exp.name == 'SELF_TYPE':
                    raise CheckSemanticError(f'Attribute {node.name} of type {node.attr_type} must to be instanced'
                                             f' by a SELF_type expression.')

    @visitor.when(ast.ClassMethod)
    def visit(self, node: ast.ClassMethod, scope: Scope):
        node.static_type = scope.getType(node.return_type)
        for i in node.formal_params:
            scope.defineSymbol(i.name, scope.getType(i.param_type))
        tb = self.visit(node.body, scope)
        if node.return_type == 'SELF_TYPE' or tb.name == 'SELF_TYPE':
            if tb.name == 'SELF_TYPE' and node.return_type == 'SELF_TYPE':
                return scope.classname
            else:
                raise CheckSemanticError(f'Method {node.name} returns SELF_TYPE and body doesn\'t')
        if not tb < scope.getType(node.return_type):
            raise CheckSemanticError(f'{tb} doesn\'t conform {node.return_type}')
        return scope.getType(node.return_type)

    @visitor.when(ast.Integer)
    def visit(self, node: ast.Integer, scope: Scope):
        node.static_type = scope.getType('Int')
        return scope.getType("Int")

    @visitor.when(ast.String)
    def visit(self, node: ast.String, scope: Scope):
        node.static_type = scope.getType('String')
        return scope.getType("String")

    @visitor.when(ast.Boolean)
    def visit(self, node: ast.Boolean, scope: Scope):
        node.static_type = scope.getType('Bool')
        return scope.getType("Bool")

    @visitor.when(ast.Object)
    def visit(self, node: ast.Object, scope: Scope):
        node.static_type = scope.getTypeFor(node.name)
        return scope.getTypeFor(node.name)

    @visitor.when(ast.Self)
    def visit(self, node: ast.Self, scope: Scope):
        node.static_type = scope.getType('SELF_TYPE')
        return scope.getType('SELF_TYPE')

    @visitor.when(ast.NewObject)
    def visit(self, node: ast.NewObject, scope: Scope):
        node.static_type = scope.getType(node.type)
        return scope.getType(node.type)

    @visitor.when(ast.IsVoid)
    def visit(self, node: ast.IsVoid, scope: Scope):
        node.static_type = scope.getType('Bool')
        self.visit(node.expr)
        return scope.getType("Bool")

    @visitor.when(ast.Assignment)
    def visit(self, node: ast.Assignment, scope: Scope):
        instance_type = scope.getTypeFor(node.instance.name)
        expr_type = self.visit(node.expr, scope)
        if expr_type.name == 'SELF_TYPE':
            r_type = scope.getType(scope.classname)
            if r_type < instance_type:
                return r_type
            raise CheckSemanticError(f'{r_type} doesn\'t conform {instance_type}')
        if not expr_type < instance_type:
            raise CheckSemanticError(f'{expr_type} doesn\'t conform {instance_type}')
        node.static_type = expr_type
        return expr_type
        
    @visitor.when(ast.Block)
    def visit(self, node: ast.Block, scope: Scope):
        t = None
        for item in node.expr_list:
            t = self.visit(item, scope)
        node.static_type = t
        return t

    @visitor.when(ast.DynamicDispatch)
    def visit(self, node: ast.DynamicDispatch, scope: Scope):
        instance_type = self.visit(node.instance, scope)
        inner_type = instance_type
        if inner_type.name == 'SELF_TYPE':
            inner_type = scope.getType(scope.classname)
            if not inner_type.is_method(node.method):
                raise CheckSemanticError(f'method {node.method} not defined')
        elif not instance_type.is_method(node.method):
            raise CheckSemanticError(f'method {node.method} not defined')
        args_type = inner_type.get_method_args(node.method)
        if len(args_type) != len(node.arguments):
            raise CheckSemanticError(f'{node.method} require {len(args_type)} arguments')
        for i in range(len(args_type)):
            t = self.visit(node.arguments[i], scope)
            if not t < args_type[i]:
                raise CheckSemanticError(f'{str(t)} doesn\'t conform {str(args_type[i])}')
        method = inner_type.get_method(node.method)
        r_type = method[node.method]['return_type']
        if r_type.name == 'SELF_TYPE':
            node.static_type = instance_type
            return instance_type
        node.static_type = instance_type
        return r_type

    @visitor.when(ast.StaticDispatch)
    def visit(self, node: ast.StaticDispatch, scope: Scope):
        instance_type = self.visit(node.instance, scope)
        class_type = scope.getType(node.dispatch_type)
        if not instance_type < class_type:
            raise CheckSemanticError(f'type {str(instance_type)} is not a {str(class_type)}')
        if not class_type.is_method(node.method):
            raise CheckSemanticError(f'method {node.method} not defined')
        args_type = class_type.get_method_args(node.method)
        if len(args_type) != len(node.arguments):
            raise CheckSemanticError(f'{node.method} require {len(args_type)} arguments')
        for i in range(len(args_type)):
            t = self.visit(node.arguments[i], scope)
            if not t < args_type[i]:
                raise CheckSemanticError(f'{str(t)} doesn\'t conform {str(args_type[i])}')
        method = class_type.get_method(node.method)
        r_type = method[node.method]['return_type']
        node.static_type = class_type        
        return class_type

    @visitor.when(ast.Let)
    def visit(self, node: ast.Let, scope: Scope):
        new_scope = Scope(scope.classname, scope)
        for decl in node.declarations:
            self.visit(decl, new_scope)
        b_type = self.visit(node.body, new_scope)
        node.static_type = b_type
        return b_type

    @visitor.when(ast.Formal)
    def visit(self, node: ast.Formal, scope: Scope):
        scope.defineSymbol(node.name, scope.getType(node.param_type), True)
        node.static_type = node.static_type
        t = self.visit(node.init_expr, scope)
        if not t:
            return
        if node.param_type == 'SELF_TYPE' and t.name == 'SELF_TYPE':
            return
        elif t.name == 'SELF_TYPE':
            if t < scope.getType(scope.classname):
                return
            else:
                raise CheckSemanticError(f'{node.name} doesn\'t conform {scope.classname}')
        elif node.param_type == 'SELF_TYPE':
            raise CheckSemanticError(f'Only can assign SELF_TYPE in a SELF_TYPE variable.')
        if not t < scope.getType(node.param_type):
            raise CheckSemanticError(f'{str(t)} doesn\'t conform {str(node.param_type)}')

    @visitor.when(ast.If)
    def visit(self, node: ast.If, scope: Scope):
        pred_type = self.visit(node.predicate, scope)
        if not pred_type.name == "Bool":
            raise CheckSemanticError(f'you can\'t match {pred_type.name} with Bool')
        if_type = self.visit(node.then_body, scope)
        else_type = self.visit(node.else_body, scope)
        if if_type.name == 'SELF_TYPE' and if_type.name == 'SELF_TYPE':
            node.static_type = if_type
            return if_type
        elif if_type.name == 'SELF_TYPE':
            return_type = scope.join(else_type, scope.getType(scope.classname))
            node.static_type = return_type
            return return_type
        elif else_type.name == 'SELF_TYPE':
            return_type = scope.join(if_type, scope.getType(scope.classname))
            node.static_type = return_type
            return return_type
        else:
            return_type = scope.join(if_type, else_type)
            node.static = return_type
            return return_type

    @visitor.when(ast.WhileLoop)
    def visit(self, node: ast.WhileLoop, scope: Scope):
        pred_type = self.visit(node.predicate, scope)
        if not pred_type.name == "Bool":
            raise CheckSemanticError(f'you can\'t match {pred_type.name} with Bool')
        self.visit(node.body, scope)
        object_type = scope.getType('Object')
        node.static_type = object_type
        return object_type

    @visitor.when(ast.Case)
    def visit(self, node: ast.Case, scope: Scope):
        self.visit(node.expr, scope)
        list_type = []
        for item in node.actions:
            list_type.append(self.visit(item, scope))
        return_type = list_type[0]
        for item in list_type[1:]:
            if return_type.name == 'SELF_TYPE' and item.name == 'SELF_TYPE':
                continue
            elif return_type.name == 'SELF_TYPE':
                return_type = scope.join(scope.getType(scope.classname), item)
            elif item.name == 'SELF_TYPE':
                return_type = scope.join(scope.getType(scope.classname), return_type)
            else:
                return_type = scope.join(return_type, item)
        node.static_type = return_type
        return return_type

    @visitor.when(ast.Action)
    def visit(self, node: ast.Action, scope: Scope):
        scope.getType(node.action_type)
        new_scope = Scope(scope.classname, scope)
        new_scope.defineSymbol(node.name, scope.getType(node.action_type))
        return_type = self.visit(node.body, new_scope)
        node.static_type = return_type
        return return_type

    @visitor.when(ast.IntegerComplement)
    def visit(self, node: ast.IntegerComplement, scope: Scope):
        exp_type = self.visit(node.integer_expr, scope)
        if not exp_type.name == "Int":
            raise CheckSemanticError(f'{exp_type.name} doest\' match with Int')
        int_type = scope.getType('Int')        
        return int_type

    @visitor.when(ast.BooleanComplement)
    def visit(self, node: ast.BooleanComplement, scope: Scope):
        exp_type = self.visit(node.boolean_expr, scope)
        if not exp_type.name == 'Bool':
            raise CheckSemanticError(f'{exp_type.name} doest\' match wiht Int')
        bool_type = scope.getType('Bool')
        return bool_type

    @visitor.when(ast.Addition)
    def visit(self, node: ast.Addition, scope: Scope):
        left_type = self.visit(node.first, scope)
        right_type = self.visit(node.second, scope)
        if not left_type.name == 'Int' or not right_type.name == 'Int':
            raise CheckSemanticError(f'expressions type must to be Int')
        int_type = scope.getType('Int')
        return int_type

    @visitor.when(ast.Subtraction)
    def visit(self, node: ast.Subtraction, scope: Scope):
        left_type = self.visit(node.first, scope)
        right_type = self.visit(node.second, scope)
        if not left_type.name == 'Int' or not right_type.name == 'Int':
            raise CheckSemanticError(f'expressions type must to be Int')
        int_type = scope.getType('Int')
        return int_type

    @visitor.when(ast.Multiplication)
    def visit(self, node: ast.Multiplication, scope: Scope):
        left_type = self.visit(node.first, scope)
        right_type = self.visit(node.second, scope)
        if not left_type.name == 'Int' or not right_type.name == 'Int':
            raise CheckSemanticError(f'expressions type must to be Int')
        int_type = scope.getType('Int')
        return int_type

    @visitor.when(ast.Division)
    def visit(self, node: ast.Division, scope: Scope):
        left_type = self.visit(node.first, scope)
        right_type = self.visit(node.second, scope)
        if not left_type.name == 'Int' or not right_type.name == 'Int':
            raise CheckSemanticError(f'expressions type must be Int')
        int_type = scope.getType('Int')
        return int_type
    
    @visitor.when(ast.Equal)
    def visit(self, node: ast.Equal, scope: Scope):
        left_type = self.visit(node.first, scope)
        right_type = self.visit(node.second, scope)
        if not left_type.name == right_type.name:
            raise CheckSemanticError(f'expressions type must be the same type')
        bool_type = scope.getType('Bool')
        return bool_type

    @visitor.when(ast.LessThan)
    def visit(self, node: ast.LessThan, scope: Scope):
        left_type = self.visit(node.first, scope)
        right_type = self.visit(node.second, scope)
        if not left_type.name == 'Int' or not right_type.name == 'Int':
            raise CheckSemanticError(f'expressions type must be Int')
        bool_type = scope.getType('Bool')
        return bool_type

    @visitor.when(ast.LessThanOrEqual)
    def visit(self, node: ast.LessThanOrEqual, scope: Scope):
        left_type = self.visit(node.first, scope)
        right_type = self.visit(node.second, scope)
        if not left_type.name == 'Int' or not right_type.name == 'Int':
            raise CheckSemanticError(f'expressions type must be Int')
        bool_type = scope.getType('Bool')
        return bool_type
