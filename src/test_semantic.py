import src.type as type

def test_Object():
    assert type.BasicType.Object.name == "Object"
    assert type.BasicType.Object.parent == None
    assert len(type.BasicType.Object.methods) == 3

def test_Int():
    assert type.BasicType.Int.name == "Int"
    assert type.BasicType.Int.parent == type.BasicType.Object
    assert len(type.BasicType.Int.methods) == 0

def test_Void():
    assert type.BasicType.Void.name == "Void"
    assert type.BasicType.Void.parent == type.BasicType.Object
    assert len(type.BasicType.Void.methods) == 0

def test_Bool():
    assert type.BasicType.Bool.name == "Bool"
    assert type.BasicType.Bool.parent == type.BasicType.Object
    assert len(type.BasicType.Bool.methods) == 0

def test_String():
    assert type.BasicType.String.name == "String"
    assert type.BasicType.String.parent == type.BasicType.Object
    assert len(type.BasicType.String.methods) == 3

def test_IO():
    assert type.BasicType.IO.name == "IO"
    assert type.BasicType.IO.parent == type.BasicType.Object
    assert len(type.BasicType.IO.methods) == 4

def test_heranchy():
    assert type.BasicType.String < type.BasicType.Object

def test_getBasicTypes():
    assert len(type.BasicType.basicTypes) == 6

def test_getparams():
    assert type.BasicType.String.get_method('concat') != None
    assert type.BasicType.String.get_method_args('concat') == [type.BasicType.String]