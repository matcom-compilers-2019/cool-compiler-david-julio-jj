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


class CILBlock(CILNode):
    def __init__(self, label: str):
        pass


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
    def __init__(self, name: str, classname: str, params, local, body):
        self.name = f'.{classname}.{name}'
        self.params = params
        self.local = local
        self.body = body


class CILExpression(CILNode):
    pass


class CILAssignment(CILExpression):
    def __init__(self, dest: str):
        self.dest = dest


class CILGetAttr(CILExpression):
    def __init__(self, attr_name: str):
        self.attr_name = attr_name


class CILAlocate(CILExpression):
    def __init__(self, ctype: str):
        self.ctype = ctype


class CILInitAttr(CILExpression):
    def __init__(self, attr_name: str):
        self.attr_name = attr_name


class CILDynamicDispatch(CILExpression):
    def __init__(self, c_args: int, method_name: str):
        self.c_args = c_args
        self.method = method_name


class CILStaticDispatch(CILExpression):
    def __init__(self, c_args: int, classname: str, method_name: str):
        self.c_args = c_args
        self.method = f'.{classname}.{method_name}'


class CILLet(CILExpression):
    def __init__(self, c_args):
        self.c_args = c_args


class CILNew(CILExpression):
    def __init__(self, attributes, ctype):
        self.attributes = attributes
        self.ctype = ctype


class CILAttribute(CILExpression):
    def __init__(self, class_name: str, attr_name: str, exp_code: list):
        self.class_name = class_name
        self.attr_name = attr_name
        self.exp_code = exp_code


class CILFormal(CILExpression):
    def __init__(self, dest: str, default_int=False, default_bool=False):
        self.default_int = default_int
        self.default_bool = default_bool
        self.dest = dest


class CILIf(CILExpression):
    def __init__(self, predicate, then_body, else_body, key):
        self.predicate = predicate
        self.then_body = then_body
        self.else_body = else_body
        self.if_tag = f'.if.start.{key}'
        self.end_tag = f'.if.end.{key}'


class CILWhile(CILExpression):
    def __init__(self, predicate, body, key):
        self.predicate = predicate
        self.body = body
        self.while_tag = f'.while.start.{key}'
        self.end_tag = f'.if.end.{key}'


class CILObject(CILExpression):
    def __init__(self, name):
        self.name = name


class CILSetAttr(CILExpression):
    def __init__(self, attr_name):
        self.name = attr_name


class CILGetLocal(CILExpression):
    def __init__(self, local_name):
        self.name = local_name

# class StackToRegister(CILExpression):
#     def __init__(self, register_name):
#         self.register = register_name
#
#
# class RegisterToStack(CILExpression):
#     def __init__(self, register_name):
#         self.register = register_name

class CILInteger(CILExpression):
    def __init__(self, value):
        self.value = value


class CILBoolean(CILExpression):
    def __init__(self, value):
        self.value = value


class CILString(CILExpression):
    def __init__(self, pos):
        self.pos = pos


class CILArithm(CILExpression):  # listo
    def __init__(self, fst, snd, op):
        self.fst = fst
        self.snd = snd
        self.op = op


class CILBoolOp(CILExpression):  # listo
    def __init__(self, fst, snd, op):
        self.fst = fst
        self.snd = snd
        self.op = op


class CILNArith(CILExpression):  # listo
    def __init__(self, fst):
        self.fst = fst


class CILNBool(CILExpression):  # listo
    def __init__(self, fst):
        self.fst = fst
