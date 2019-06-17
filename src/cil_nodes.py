class CiLNode:
    pass


class DotTypes(CiLNode):
    def __init__(self):
        self.types = []


class DotData(CiLNode):
    def __init__(self):
        self.strings = []


class DotCode(CiLNode):
    def __init__(self):
        self.methods = []


class Label(CiLNode):
    def __init__(self, label: str):
        self.label = label


class Jump(CiLNode):
    def __init__(self, label: str):
        self.label = label


class Push(CiLNode):
    def __init__(self):
        pass


class Pop(CiLNode):
    def __init__(self):
        pass


class CILProgram(CiLNode):
    def __init__(self):
        pass


class CILType(CiLNode):
    def __init__(self):
        pass
