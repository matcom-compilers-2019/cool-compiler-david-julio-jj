# Lexical Analisys

import ply.lex as lex
from ply.lex import TOKEN

class CoolLexer(object):
    
    def __init__(self):
        self.lexer = None
        self.tokens = {}
        self.reserved = {}
        self.last_token = None