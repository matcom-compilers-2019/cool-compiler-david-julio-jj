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
    def __init__(self, name, parent, feature):
        super(Class, self).__init__()
        self.name = name
        self.parent = parent
        self.feature = feature

    def prettier(self):
        return "{}\n name: {}\n parent: {}\n(features: {})".format(self.classname, self.name, self.parent, self.feature)

class Inherits(AST):
    def __init__(self, tipo):
        super(Inherits, self).__init__()
        self.tipo = tipo

    def prettier(self):
        return "{}(type: {})".format(self.classname, self.tipo)
    
class Feature(AST):
    def __init__(self, parameters_list, ):
        super(Feature, self).__init__()