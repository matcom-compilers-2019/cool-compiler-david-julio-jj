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
