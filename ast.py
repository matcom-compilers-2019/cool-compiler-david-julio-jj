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

    def prettier(self):
        return "{}".format(self.classname)

    def __repr__(self):
        return self.__str__()

    def __str__(self):
        return str(self.prettier())

########################## Base Class For AST Nodes ##########################

class PROGRAM(AST):
    def __init__(self, classes):
        super(PROGRAM, self).__init__()
        self.classes = classes

    def prettier(self):
        return "{}(classes{})".format(self.classname, self.classes)

class Class(AST):
    def __init__(self, name, parent, features):
        super(Class, self).__init__()
        self.name = name
        self.parent = parent
        self.features = features

    def prettier(self):
        return "{}(name: {}, parent: {}, features: {})".format(self.classname, self.name, self.parent, self.features)

class ClassFeature(AST):
    def __init__(self):
        super(ClassFeature, self).__init__()

class Inherits(ClassFeature):
    def __init__(self, tipo):
        super(Inherits, self).__init__()
        self.tipo = tipo

    def prettier(self):
        return "{} type: {}".format(self.classname, self.tipo)
    
class ClassMethods(ClassFeature):
    def __init__(self, name, body, parameters_list, return_type):
        super(ClassMethods, self).__init__()
        self.name = name
        self.body = body
        self.parameter_list = parameters_list
        self.return_type = return_type

    def prettier(self):
        return "{}(name: {}, body: {}, parameter_list: {}, return_type: {})".format(self.classname, self.name, self.body, self.parameter_list, self.return_type)

class ClassAtributes(ClassFeature):
    def __init__(self, name, atribute, expr):
        super(ClassAtributes, self).__init__()
        self.name = name
        self.atribute = atribute
        self.expr = expr

    def prettier(self):
        return "{}(name: {}, atribute: {}, expr: {})".format()