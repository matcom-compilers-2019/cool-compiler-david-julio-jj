import src.ast as ast

SelfType = "SELF_TYPE"


class ctype:
    def __init__(self, name, parent=None, attributes=None, methods=None):
        """
        The Contructor for Cool Types
        Parameters:
            name (str): Type's name
            parent (ctype): Type's parent
            attributes (list): Type's Attributtes [{name: ctype}]
            methods (list): Type's methods [{
                name: {
                    'formal_params':{
                        param_name: ctype
                    },
                    'return_type': ctype,
                    'body': expr
                }
            }]
        """
        self.name = name
        self.parent = parent
        if attributes is None:
            attributes = []
        self.attributes = attributes
        if methods is None:
            methods = []
        self.methods = methods

    def add_attrib(self, *att):
        """
        Add attributes to Cool type
        Parameters:
            att (list): [{name: ctype}]
        """
        for i in att:
            self.attributes.append(i)

    def add_method(self, *methods):
        """
        Add methods to Cool type
        Parameters:
            methods (list): [{
                name: {
                    'formal_params':{
                        param_name: ctype
                    },
                    'return_type': ctype,
                    'body': expr
                }
            }]
        """
        for i in methods:
            self.methods.append(i)

    def delete(self, method_name):
        t = []
        for i in range(len(self.methods)):
            if method_name not in self.methods[i]:
                t.append(self.methods[i])
        self.methods = t

    def get_method(self, method_name: str):
        """
        get method from a type
        Parameters:
            method_name (str): name of method
        Returns:
            dict: {
                name: {
                    'formal_params':{
                        param_name: ctype
                    },
                    'return_type': ctype,
                    'body': expr
                }
            }
        """
        for i in self.methods:
            if method_name in i:
                return i
        return None if not self.parent else self.parent.get_method(method_name)

    def is_method(self, method_name: str):
        """verify method in a type
        
        Arguments:
            method_name {str} -- method's name
        
        Returns:
            bool -- if True the method exist
        """
        for i in self.methods:
            if method_name in i:
                return True
        return False if not self.parent else self.parent.is_method(method_name)

    def get_method_args(self, method_name: str):
        """get params from a method
        
        Arguments:
            method_name {str} -- method's name
        
        Returns:
            list -- return a list with the types of a method
        """
        m = self.get_method(method_name)
        p = m[method_name]['formal_params']
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
    Bool = ctype("Bool", Object, [], [])
    String = ctype("String", Object, [], [])
    SelfType = ctype("SELF_TYPE", None, [], [])
    IO = ctype("IO", Object, [], [
        {'out_string': {'formal_params': {'x_1': String}, 'return_type': SelfType, 'body': None}},
        {'out_int': {'formal_params': {'x_1': Int}, 'return_type': SelfType, 'body': None}},
        {'in_string': {'formal_params': {}, 'return_type': String, 'body': None}},
        {'in_int': {'formal_params': {}, 'return_type': Int, 'body': None}}
    ])
    Object.add_method(
        {'abort': {'formal_params': {}, 'return_type': Object, 'body': None}},
        {'type_name': {'formal_params': {}, 'return_type': String, 'body': None}},
        {'copy': {'formal_params': {}, 'retunr_type': SelfType, 'body': None}}
    )
    String.add_method(
        {'length': {'formal_params': {}, 'return_type': Int, 'body': None}},
        {'concat': {'formal_params': {'x_1': String}, 'return_type': String, 'body': None}},
        {'substr': {'formal_params': {'x_1': Int, 'x_2': Int}, 'return_type': String, 'body': None}}
    )
    basicTypes = [Object, Int, Bool, String, SelfType, IO]
