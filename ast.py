# AST for parser

# ------------------------------------------------------------------------------------------------------
#   Reference ply (Python Lex-Yacc) Documentation
#
#   Reference links
#   https://www.dabeaz.com/ply/ply.html#ply_nn13
#   http://www.dalkescientific.com/writings/NBN/parsing_with_ply.html
#   https://www.dabeaz.com/ply/PLYTalk.pdf
#
#
#   By David M. Beazley
# ------------------------------------------------------------------------------------------------------

########################## Base Class For AST Nodes ##########################
class AST:
    def __init__(self):
        pass

    @property
    def classname(self):
        return str(self.__class__.__name__)

    def to_tuple(self):
        return tuple([
            ("class_name", self.classname)
        ])

    def prettier(self):
        return "{}".format(self.classname)

    def __repr__(self):
        return self.__str__()

    def __str__(self):
        return str(self.prettier())


########################## Grammar Definitions ##########################

class PROGRAM(AST):
    def __init__(self, classes):
        super(PROGRAM, self).__init__()
        self.classes = classes

    def to_tuple(self):
        return tuple([
            ("class_name", self.classname),
            ("classes", self.classes)
        ])

    def prettier(self):
        return "{}(classes{})".format(self.classname, self.classes)


#    Classes
#    Cool Reference Manual 2012 Pag: 4-6
class Class(AST):
    def __init__(self, name, parent, features):
        super(Class, self).__init__()
        self.name = name
        self.parent = parent
        self.features = features

    def to_tuple(self):
        return tuple([
            ("class_name", self.classname),
            ("name", self.name),
            ("parent", self.parent),
            ("features", self.features)
        ])

    def prettier(self):
        return "{}(name: {}, parent: {}, features: {})".format(self.classname, self.name, self.parent, self.features)


class ClassFeature(AST):
    def __init__(self):
        super(ClassFeature, self).__init__()


class Inherits(ClassFeature):
    def __init__(self, tipo):
        super(Inherits, self).__init__()
        self.tipo = tipo

    def to_tuple(self):
        return tuple([
            ("class name", self.classname),
            ("tipo", self.tipo)
        ])

    def prettier(self):
        return "{} type: {}".format(self.classname, self.tipo)


class ClassMethods(ClassFeature):
    def __init__(self, name, body, params_list, return_type):
        super(ClassMethods, self).__init__()
        self.name = name
        self.body = body
        self.params_list = params_list
        self.return_type = return_type

    def to_tuple(self):
        return tuple([
            ("class_name", self.classname),
            ("name", self.name),
            ("params_list", self.params_list),
            ("return_type", self.return_type),
            ("body", self.body)
        ])

    def prettier(self):
        return "{}(name: {}, body: {}, params_list: {}, return_type: {})".format(self.classname, self.name, self.body,
                                                                                 self.params_list, self.return_type)


class ClassAtributes(ClassFeature):
    def __init__(self, name, atribute, expr):
        super(ClassAtributes, self).__init__()
        self.name = name
        self.atribute = atribute
        self.expr = expr

    def to_tuple(self):
        return tuple([
            ("class_name", self.classname),
            ("name", self.name),
            ("atribute", self.atribute),
            ("expr", self.expr)
        ])

    def prettier(self):
        return "{}(name: {}, atribute: {}, expr: {})".format(self.classname, self.name, self.atribute, self.expr)


class Parameter(ClassFeature):
    def __init__(self, name, param_type):
        super(Parameter, self).__init__()
        self.name = name
        self.param_type = param_type

    def to_tuple(self):
        return tuple([
            ("class_name", self.classname),
            ("name", self.name),
            ("param_type", self.param_type)
        ])

    def to_readable(self):
        return "{}(name: '{}', param_type: {})".format(self.classname, self.name, self.param_type)


# Constants:
# Cool Reference Manual 2012: 7.1 Constants Pag: 9
class Constants(AST):
    def __init__(self):
        super(Constants, self).__init__()


class Integer(Constants):
    def __init__(self, value):
        super(Integer, self).__init__()
        self.value = value

    def to_tuple(self):
        return tuple([
            ("class_name", self.classname),
            ("value", self.value)
        ])

    def prettier(self):
        return "{}(value: {})".format(self.classname, self.value)


class String(Constants):
    def __init__(self, value):
        super(String, self).__init__()
        self.value = value

    def to_tuple(self):
        return tuple([
            ("class_name", self.classname),
            ("value", self.value)
        ])

    def prettier(self):
        return "{}(value: {})".format(self.classname, self.value)


class Boolean(Constants):
    def __init__(self, value):
        super(Boolean, self).__init__()
        self.value = value

    def to_tuple(self):
        return tuple([
            ("class_name", self.classname),
            ("value", self.value)
        ])

    def prettier(self):
        return "{}(value: {})".format(self.classname, self.value)


# Expressions
# isVoid,

class Expression(AST):
    def __init__(self):
        super(Expression, self).__init__()


class NewObject(Expression):
    def __init__(self, new_type):
        super(NewObject, self).__init__()
        self.type = new_type

    def to_tuple(self):
        return tuple([
            ("class_name", self.classname),
            ("type", self.type)
        ])

    def to_readable(self):
        return "{}(type: {})".format(self.classname, self.type)


class IsVoid(Expression):
    def __init__(self, expr):
        super(IsVoid, self).__init__()
        self.expr = expr

    def to_tuple(self):
        return tuple([
            ("class_name", self.classname),
            ("expr", self.expr)
        ])

    def to_readable(self):
        return "{}(expr: {})".format(self.classname, self.expr)


class Assignment(Expression):
    def __init__(self, instance, expr):
        super(Assignment, self).__init__()
        self.instance = instance
        self.expr = expr

    def to_tuple(self):
        return tuple([
            ("class_name", self.classname),
            ("instance", self.instance),
            ("expr", self.expr)
        ])

    def to_readable(self):
        return "{}(instance: {}, expr: {})".format(self.classname, self.instance, self.expr)

# <block_expr> in Grammar
class Block(Expression):
    def __init__(self, expr_list):
        super(Block, self).__init__()
        self.expr_list = expr_list

    def to_tuple(self):
        return tuple([
            ("class_name", self.classname),
            ("expr_list", self.expr_list)
        ])

    def to_readable(self):
        return "{}(expr_list: {})".format(self.classname, self.expr_list)


class DynamicDispatch(Expression):
    def __init__(self, instance, method, arguments):
        super(DynamicDispatch, self).__init__()
        self.instance = instance
        self.method = method
        self.arguments = arguments if arguments is not None else tuple()

    def to_tuple(self):
        return tuple([
            ("class_name", self.classname),
            ("instance", self.instance),
            ("method", self.method),
            ("arguments", self.arguments)
        ])

    def to_readable(self):
        return "{}(instance: {}, method: {}, arguments: {})".format(
            self.classname, self.instance, self.method, self.arguments)


class StaticDispatch(Expression):
    def __init__(self, instance, dispatch_type, method, arguments):
        super(StaticDispatch, self).__init__()
        self.instance = instance
        self.dispatch_type = dispatch_type
        self.method = method
        self.arguments = arguments if arguments is not None else tuple()

    def to_tuple(self):
        return tuple([
            ("class_name", self.classname),
            ("instance", self.instance),
            ("dispatch_type", self.dispatch_type),
            ("method", self.method),
            ("arguments", self.arguments)
        ])

    def to_readable(self):
        return "{}(instance: {}, dispatch_type: {}, method: {}, arguments: {})".format(
            self.classname, self.instance, self.dispatch_type, self.method, self.arguments)

# <let> in grammar
class Let(Expression):
    def __init__(self, instance, return_type, init_expr, body):
        super(Let, self).__init__()
        self.instance = instance
        self.return_type = return_type
        self.init_expr = init_expr
        self.body = body

    def to_tuple(self):
        return tuple([
            ("class_name", self.classname),
            ("instance", self.instance),
            ("return_type", self.return_type),
            ("init_expr", self.init_expr),
            ("body", self.body)
        ])

    def to_readable(self):
        return "{}(instance: {}, return_type: {}, init_expr: {}, body: {})".format(
            self.classname, self.instance, self.return_type, self.init_expr, self.body)

# <if> in Grammar
class If(Expression):
    def __init__(self, predicate, then_body, else_body):
        super(If, self).__init__()
        self.predicate = predicate
        self.then_body = then_body
        self.else_body = else_body

    def to_tuple(self):
        return tuple([
            ("class_name", self.classname),
            ("predicate", self.predicate),
            ("then_body", self.then_body),
            ("else_body", self.else_body)
        ])

    def to_readable(self):
        return "{}(predicate: {}, then_body: {}, else_body: {})".format(
            self.classname, self.predicate, self.then_body, self.else_body)

# <while> in Grammar
class WhileLoop(Expression):
    def __init__(self, predicate, body):
        super(WhileLoop, self).__init__()
        self.predicate = predicate
        self.body = body

    def to_tuple(self):
        return tuple([
            ("class_name", self.classname),
            ("predicate", self.predicate),
            ("body", self.body)
        ])

    def to_readable(self):
        return "{}(predicate: {}, body: {})".format(self.classname, self.predicate, self.body)

# <case> in Grammar
class Case(Expression):
    def __init__(self, expr, actions):
        super(Case, self).__init__()
        self.expr = expr
        self.actions = actions

    def to_tuple(self):
        return tuple([
            ("class_name", self.classname),
            ("expr", self.expr),
            ("actions", self.actions)
        ])

    def to_readable(self):
        return "{}(expr: {}, actions: {})".format(self.classname, self.expr, self.actions)

# <case_action> in Grammar
class Action(AST):
    def __init__(self, name, action_type, body):
        super(Action, self).__init__()
        self.name = name
        self.action_type = action_type
        self.body = body

    def to_tuple(self):
        return tuple([
            ("class_name", self.classname),
            ("name", self.name),
            ("action_type", self.action_type),
            ("body", self.body)
        ])

    def to_readable(self):
        return "{}(name: '}, action_type: {}, body: {})".format(self.classname, self.name, self.action_type, self.body)

# ############################## UNARY OPERATIONS ##################################
# ~, not

# To do

# ############################## BINARY OPERATIONS ##################################
# Add, Sub, Mult, Divi, LThan, Equal, LTEQ

# To do

class Object(AST):
    def __init__(self, name):
        super(Object, self).__init__()
        self.name = name

    def to_tuple(self):
        return tuple([
            ("class_name", self.classname),
            ("name", self.name)
        ])

    def to_readable(self):
        return "{}(name='{}')".format(self.classname, self.name)


class Self(Object):
    def __init__(self):
        super(Self, self).__init__("SELF")

    def to_tuple(self):
        return tuple([
            ("class_name", self.classname)
        ])

    def to_readable(self):
        return "{}".format(self.classname)