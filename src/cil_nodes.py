import src.ast as ast


class CILNode:
    pass


class DotData(CILNode):
    def __init__(self):
        self.strings = []


class DotType(CILNode):
    def __init__(self, cType, attributes, methods):
        self.cType = cType
        self.attributes = attributes
        self.methods = methods

    def __str__(self):
        r = f'type {self.cType} {"{"}\n'
        for i in self.attributes:
            r += f'\tattribute {i}\n'
        for i in self.methods:
            r += f'\tmethod {i.split(".")[1]} : {i}\n'
        return r


class DotCode(CILNode):
    def __init__(self):
        self.methods = []


class CILLabel(CILNode):
    def __init__(self, label: str):
        self.label = label


class CILJump(CILNode):
    def __init__(self, label: str):
        self.label = label


class CILPush(CILNode):
    def __init__(self):
        pass


class CILPop(CILNode):
    def __init__(self):
        pass


class CILProgram(CILNode):
    def __init__(self):
        pass


class CILType(CILNode):
    def __init__(self):
        pass


class CILReadS(CILNode):
    def ___init__(self, offset: int, register: str):
        self.offset = offset
        self.register = register


class CILMethod(CILNode):
    def __init__(self, name: str, classname: str, params, locals, body):
        self.name = f'.{classname}.{name}'
        self.params = params
        self.locals = locals
        self.body = body


class CILExpression(CILNode):
    pass


class CILAssignment(CILExpression):
    def __init__(self, dest: str, expr: CILExpression):
        self.dest = dest
        self.expr = expr


class CILGetAttr(CILExpression):
    def __init__(self, attr_name: str, expr: CILExpression):
        self.attr_name = attr_name
        self.expr = expr


class CILDynamicDispatch(CILExpression):
    def __init__(self, cargs: int, method_name: str):
        self.cargs = cargs
        self.method = method_name


class CILStaticDispatch(CILExpression):
    def __init__(self, cargs: int, classname: str, method_name: str):
        self.cargs = cargs
        self.method = f'.{classname}.{method_name}'


class StackToRegister(CILExpression):
    def __init__(self, register_name):
        self.register = register_name


class RegisterToStack(CILExpression):
    def __init__(self, register_name):
        self.register = register_name
