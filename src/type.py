import src.ast as ast

SelfType = "SELF_TYPE"


class ctype:
    def __init__(self, name, parent=None, attributes=[], methods=[]):
        self.name = name
        self.parent = parent
        self.attributes = attributes
        self.methods = methods

    def add_attrib(self, *att):
        for i in att:
            self.attributes.append(i)

    def add_method(self, *methods):
        for i in methods:
            self.methods.append(i)
    
    def get_method(self, method_name:str):
        for i in self.methods:
            if i.name == method_name:
                return i
        return None if not self.parent else self.parent.get_method(method_name) 

    def is_method(self, method_name:str):
        for i in self.methods:
            if i.name == method_name:
                return True
        return False if not self.parent else self.parent.is_method(method_name)         

    def get_method_args(self, method_name:str):
        m = self.get_method(method_name)
        p = m.formal_params
        return list(map(lambda x: p[x], p))

    def __eq__(self, other):
        return self.name == other.name

    def __str__(self):
        return self.name

    def __lt__(self, other):
        t = self
        while t:
            if t == other:
                return True
            t = t.parent
        return False


class BasicType:
    Object = ctype("Object", None, [], [])
    Int = ctype("Int", Object, [], [])
    Void = ctype("Void", Object, [], [])
    Bool = ctype("Bool", Object, [], [])
    String = ctype("String", Object, [], [])
    SelfType = ctype("SELF_TYPE", None, [], [])
    IO = ctype("IO", Object, [], [
        ast.ClassMethod('out_string',{'x_1': String}, SelfType, None), 
        ast.ClassMethod('out_int',{'x_1':Int}, SelfType, None),
        ast.ClassMethod('in_string',{}, String, None),
        ast.ClassMethod('in_int', {}, Int, None)
        ])
    Object.add_method(
        ast.ClassMethod('abort', {}, Object, None),
        ast.ClassMethod('type_name', {}, String, None),
        ast.ClassMethod('copy', {}, SelfType, None)
    )
    String.add_method(
        ast.ClassMethod('length', {}, Int, None),
        ast.ClassMethod('concat', {'x_1': String}, String, None),
        ast.ClassMethod('substr', {'x_1': Int, 'x_2': Int}, String, None)
    )
    basicTypes = [Object, Int, Void, Bool, String, SelfType]
