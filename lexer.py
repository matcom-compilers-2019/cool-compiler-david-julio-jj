# Lexical Analisys

import ply.lex as lex
from ply.lex import TOKEN


class CoolLexer(object):

    def __init__(self):
        self.lexer = None  # ply lexer instance
        self.tokens = self.tokens_collection + list(self.reserved.values())  # ply tokens collection
        self.reserved = self.keywords_collections  # ply reserved keywords
        self.last_token = None  # last token

    @property
    def tokens_collection(self):
        """
        Cool Syntax Tokens
        :return: tuple
        """
        return (
            # Identifiers
            "ID", "TYPE",
            # Literals
            "LPAREN", "RPAREN", "LBRACE", "RBRACE", "COLON", "COMA", "DOT", "SEMICOLON", "AROBA",
            # Operations
            "PLUS", "MINUS", "DIVIDE", "MULTIPLY", "NOT", "LT", "EQ", "LTEQ", "ASSIGN", "INT_COMP",
            # Basic Types
            "STRING", "BOOLEAN", "INTEGER",
            # Special Operators
            "ARROW"
        )

    @property
    def keywords_collections(self):
        """
        Cool Keywords
        :return:  dict
        """

        return {
            "class": "CLASS",
            "else": "ELSE",
            "if": "IF",
            "fi": "FI",
            "in": "IN",
            "inherits": "inherits",
            "isvoid": "ISVOID",
            "let": "LET",
            "loop": "LOOP",
            "pool": "POOL",
            "then": "THEN",
            "while": "WHILE",
            "case": "CASE",
            "esac": "ESAC",
            "new": "NEW",
            "of": "OF",
            "not": "NOT"
        }

    @property
    def buildIn_types(self):
        """
        Build in types in Cool
        :return: dict
        """
        return {
            "Bool": "BOOL_TYPE",
            "Int": "INT_TYPE",
            "String": "STRING_TYPE",
            "IO": "IO_TYPE",
            "Main": "MAIN_TYPE",
            "Object": "OBJECT_TYPE",
            "SELF_TYPE": "SELF_TYPE"
        }

    ####################################################################################################################
    #---------------------- Lexical Analisis, Regular Expresion and Rule Declarations ----------------------------------
    ####################################################################################################################

    t_LPAREN = r'\('
    t_RPAREN = r'\)'
    t_LBRACE = r'\{'
    t_RBRACE = r'\}'
    t_COLON = r'\:'
    t_COMA = r'\,'
    t_DOT = r'\.'
    t_SEMICOLON = r'\;'
    t_AROBA = r'\@'
    t_PLUS = r'\+'
    t_MINUS = r'\-'
    t_DIVIDE = r'\/'
    t_MULTIPLY = r'\*'
    t_LT = r'\<'
    t_EQ = r'\='
    t_LTEQ = r'\<\='
    t_ASSIGN = r'\<\-'
    t_INT_COMP = r'\~'
    t_ARROW = r'\=\>'



