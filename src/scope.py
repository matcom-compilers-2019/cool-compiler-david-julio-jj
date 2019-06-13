import src.type as tp

class ScopeError(BaseException):
    def __init__(self, e):
        self.e = e
    
    def __str__(self):
        return self.e

ctypes = {i.name: i for i in tp.BasicType.basicTypes}

class Scope:
    def __init__(self, classname, parentScope=None):
        self.parentScope = parentScope
        self.classname = classname
        global ctypes
        self.var = {}
        self.att = {}

    def defineAttrib(self, att: str, ct: tp.ctype):
        if att in self.att:
            raise ScopeError(f'{att} attribute already defined.')
        self.att[att] = ct
        
    def getType(self, typeName: str):
        global ctypes
        if not typeName in ctypes:
            raise ScopeError(f'Type {typeName} not defined.')
        return ctypes[typeName]

    def getTypeFor(self, symbol: str):
        if symbol == 'Self':
            return self.getType(self.classname)
        c = self
        while c.classname:
            if symbol in c.var:
                t = c.var[symbol]
                return t
            if symbol in c.att:
                return c.att[symbol]
            c = c.parentScope

        raise ScopeError(f'Symbol {symbol} not defined in the Scope.')
         
    def createType(self, ct: tp.ctype):
        global ctypes
        if ct.name in ctypes:
            raise ScopeError(f'{ct.name} is already defined.')
        ctypes[ct.name] = ct
    
    def defineSymbol(self, symbol: str, ct: tp.ctype, override=False):
        c = self
        while c:
            if not override and symbol in c.var:
                raise ScopeError(f'Symbol {symbol} already defined in the Scope.')        
            c = c.parentScope
        self.var[symbol] = ct
    
    def join(self, fst: tp.ctype, snd: tp.ctype):
        c = fst
        while c:
            if snd < c:
                return c
            c = c.parent
