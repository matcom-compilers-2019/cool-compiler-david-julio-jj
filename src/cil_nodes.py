class CILNode:
    pass


class DotType(CILNode):
    def __init__(self, cType, attributes, methods, t_in, t_out):
        self.cType = cType
        self.attributes = attributes
        self.methods = methods
        self.t_in = t_in
        self.t_out = t_out

    def __str__(self):
        r = f'type {self.cType} {"{"}\n'
        r += f'\tin {self.t_in}\n\tout{self.t_out}\n'
        for i in self.attributes:
            r += f'\tattribute {i}\n'
        for i in self.methods:
            r += f'\tmethod {i.split(".")[1]} : {i}\n'
        return r


class CILProgram(CILNode):
    def __init__(self):
        pass


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


class CILSetAttr(CILExpression):
    def __init__(self, offset):
        self.offset = offset


class CILAlocate(CILExpression):
    def __init__(self, ctype: str):
        self.ctype = ctype


class CILInitAttr(CILExpression):
    def __init__(self, offset: str):
        self.offset = offset


class CILDynamicDispatch(CILExpression):
    def __init__(self, c_args: int, method_name: int):
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
    def __init__(self, attributes, ctype, size):
        self.attributes = attributes
        self.ctype = ctype
        self.size = size


class CILAttribute(CILExpression):
    def __init__(self, offset: str, exp_code: list):
        self.offset = offset
        self.exp_code = exp_code


class CILFormal(CILExpression):
    def __init__(self, dest: str, has_init_expr=True):
        self.has_init_expr = has_init_expr
        self.dest = dest


class CILIf(CILExpression): # Listo
    def __init__(self, predicate, then_body, else_body, key):
        self.predicate = predicate
        self.else_body = else_body
        self.then_body = then_body
        self.if_tag = f'.if.start.{key}'
        self.end_tag = f'.if.end.{key}'


class CILWhile(CILExpression):  # Listo
    def __init__(self, predicate, body, key):
        self.predicate = predicate
        self.body = body
        self.while_tag = f'.while.start.{key}'
        self.end_tag = f'.if.end.{key}'


class CILGetAttr(CILExpression):
    def __init__(self, offset):
        self.offset = offset


class CILGetLocal(CILExpression):
    def __init__(self, local_name):
        self.name = local_name


class CILInteger(CILExpression):  # Listo
    def __init__(self, value):
        self.value = value


class CILBoolean(CILExpression):
    def __init__(self, value):
        self.value = value


class CILString(CILExpression):
    def __init__(self, pos):
        self.pos = pos


class CILArithm(CILExpression):
    def __init__(self, fst, snd, op):
        self.fst = fst
        self.snd = snd
        self.op = op


class CILBoolOp(CILExpression):
    def __init__(self, fst, snd, op):
        self.fst = fst
        self.snd = snd
        self.op = op


class CILNArith(CILExpression):
    def __init__(self, fst):
        self.fst = fst


class CILNBool(CILExpression):
    def __init__(self, fst):
        self.fst = fst


class CILBlock(CILExpression):
    def __init__(self, size):
        self.size = size


class CILDecInt(CILExpression):
    def __init__(self):
        pass


class CILIsVoid(CILExpression):
    def __init__(self, exp):
        self.exp = exp


class CILCase(CILExpression):
    def __init__(self, instance, actions):
        self.instance = instance
        self.actions = actions


class CILAction(CILExpression):
    def __init__(self, ctype, body):
        self.ctype = ctype
        self.body = body


class CILSelf(CILExpression):
    def __init__(self):
        pass


class CILCopy(CILExpression):
    def __init__(self):
        pass
