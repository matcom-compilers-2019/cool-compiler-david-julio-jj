# from src.scope import Scope, ctypes
# from src.type import BasicType, ctype
# import pytest

# scopes = {}

# def setup_module(module):
#     global scopes
#     scopes['s1'] = Scope("S1")
#     scopes['s12'] = Scope("S12" ,scopes['s1'])



# def test_GetType():
#     global scopes
#     s = scopes['s1']
#     s12 = scopes['s12']
#     assert s.getType('Int') == BasicType.Int 
#     assert s12.getType('String') == BasicType.String

# def test_CreateType():
#     global scopes
#     s = scopes['s1']
#     s12 = scopes['s12']
#     s.createType(ctype('animal', BasicType.Object, []))
#     assert s.getType('animal') == ctypes['animal']

# def test_CreateSymbol():
#     global scopes
#     s = scopes['s1']
#     s12 = scopes['s12']
#     s.defineSymbol('x_1', ctypes['animal'])
#     assert s.getTypeFor('x_1') == s12.getTypeFor('x_1')