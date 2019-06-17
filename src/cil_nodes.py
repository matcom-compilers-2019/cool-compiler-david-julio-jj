class CiLNode:
    pass


class DotType(CiLNode):
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
