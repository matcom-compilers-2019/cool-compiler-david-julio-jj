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
    @visitor.on('AST')
    def visit(self, node, scope, errors):
        pass

    @visitor.when(ast.Program)
    def visit(self, node:ast.Program, scope:Scope, errors):
        for classDef in node.classes:
            methods = filter(lambda x: type(x) is ast.ClassMethod, classDef)
            methods = list(methods)
            attribs = filter(lambda x: type(x) is ast.ClassAttribute, classDef)
            attribs = list(attribs)
            newType = ctype(classDef.name, classDef.parent, attribs, methods)
            try:
                scope.createType(newType)
            except Exception as e:
                print(str(e))

        for i in node.classes:
            t = self.visit(i, Scope(i.name, scope), errors)
        
    @visitor.when(ast.Class)
    def visit(self, node:ast.Class, scope:Scope, errors):
        methods = filter(lambda x: type(x) is ast.ClassMethod, classDef)
        methods = list(methods)
        attribs = filter(lambda x: type(x) is ast.ClassAttribute, classDef)
        attribs = list(attribs)
        for i in attribs:
            ta = self.visit(i, scope, errors)
        for i in methods:
            tb = self.visit(i, Scope(scope.classname, scope), errors)
    
    @visitor.when(ast.ClassAttribute)
    def visit(self, node:ast.ClassAttribute, scope:Scope, errors):
        try:
            scope.defineAttrib(node.name, scope.getType(node.attr_type))
        except Exception as e:
            print(e)

    @visitor.when(ast.ClassMethod)
    def visit(self, node:ast.ClassMethod, scope:Scope, errors):
        for i in node.formal_params:
            try:
                scope.defineSymbol(i.name, scope.getType(i.param_type))
            except Exception as e:
                print(e)
        tb = self.visit(node.body, scope, error)
        if not tb < scope.getType(node.return_type):
            raise CheckSemanticError(f'{tb} doesn\'t conform {node.return_type}')
        return scope.getType(node.return_type)
    
    @visitor.when(ast.Integer)
    def visit(self, node:ast.Integer, scope:Scope, errors):
        return scope.getType("Int")

    @visitor.when(ast.String)
    def visit(self, node:ast.String, scope:Scope, errors):
        return scope.getType("String")

    @visitor.when(ast.Boolean)
    def visit(self, node:ast.Boolean, scope:Scope, errors):
        return scope.getType("Bool")

    @visitor.when(ast.Object)
    def visit(self, node:ast.Object, scope:Scope, errors):
        return scope.getTypeFor(node.name)

    @visitor.when(ast.Self)
    def visit(self, node:ast.Self, scope:Scope, errors):
        return scope.getType(scope.classname)

    @visitor.when(ast.NewObject)
    def visit(self, node:ast.NewObject, scope:Scope, errors):
        return scope.getType(node.type)

    @visitor.when(ast.IsVoid)
    def visit(self, node:ast.IsVoid, scope:Scope, errors):
        self.visit(node.expr)
        return scope.getType("Bool")

    @visitor.when(ast.Assignment)
    def visit(self, node:ast.Assignment, scope:Scope, errors):
        try:
            instanceType = scope.getTypeFor(node.instance.name)
            exprType = self.visit(node.expr, scope, errors)
            if not instanceType < exprType :
                raise CheckSemanticError(f'{tb} doesn\'t conform {node.return_type}')
            return exprType
        except:
            raise CheckSemanticError(f'Symbol {node.instance.name} not defined in the Scope.')    

    @visitor.when(ast.Block)
    def visit(self, node:ast.Block, scope:Scope, errors):
        for item in node.expr_list:
            self.visit(item, scope, errors)
        return self.visit(node.expr_list[-1], scope, errors)

    @visitor.when(ast.DynamicDispatch)
    def visit(self, node:ast.DynamicDispatch, scope:Scope, errors):
        instanceType = scope.getTypeFor(node.instance)
        if not instanceType.is_method(node.method):
           raise CheckSemanticError(f'method {node.method} not defined')
        argsType = instanceType.get_method_args(node.method)
        if len(argsType) != len(node.arguments):
            raise CheckSemanticError(f'{node.method} require {len(argsType)} arguments')
        for x, y in argsType, node.arguments:
            t = self.visit(y, scope, errors)
            if not t < x:
                raise CheckSemanticError(f'{str(t)} doesn\'t conform {str(x)}')
        method = instanceType.get_method(node.method)
        return  method.return_type

    @visitor.when(ast.StaticDispatch)
    def visit(self, node:ast.StaticDispatch, scope:Scope, errors):
        instanceType = scope.getTypeFor(node.instance)
        classType = scope.getType(node.dispatch_type)
        if not instanceType < :
            raise CheckSemanticError(f'type {instanceType} is not a {node.dispatch_type}')
        if not classType.is_method(node.method):
           raise CheckSemanticError(f'method {node.method} not defined')
        argsType = classType.get_method_args(node.method)
        if len(argsType) != len(node.arguments):
            raise CheckSemanticError(f'{node.method} require {len(argsType)} arguments')
        for x, y in argsType, node.arguments:
            t = self.visit(y, scope, errors)
            if not t < x:
                raise CheckSemanticError(f'{str(t)} doesn\'t conform {str(x)}')
        method = classType.get_method(node.method)
        return  method.return_type

    @visitor.when(ast.Let)
    def visit(self, node:ast.Let, scope:Scope, errors):
        newScope = Scope(scope.classname, scope)
        for decl in node.init_expr :
            try:
                self.visit(decl, newScope, errors)
            except Exception as e:
                print(e)
        return self.visit(node.body, newScope, errors)

    @visitor.when(ast.Formal)
    def visit(self, node:ast.Formal, scope:Scope, errors):
        scope.defineSymbol(node.name, scope.getType(node.param_type), True)
        t = self.visit(node.init_expr, scope)
    	if not t < node.param_type:
            raise CheckSemanticError(f'{str(t)} doesn\'t conform {str(node.param_type)}')            