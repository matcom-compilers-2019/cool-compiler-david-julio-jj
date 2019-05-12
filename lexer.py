# Lexical Analisys

# Authors:  Joel David Hernandez Cruz
#           Juan Jose Roque Cires
#           Julio Cesar Rodriguez Sanchez

# ------------------------------------------------------------------------------------------------------
#   Reference ply (Python Lex-Yacc) Documentation
#
#   Reference links
#   https://www.dabeaz.com/ply/ply.html#ply_nn13
#   http://www.dalkescientific.com/writings/NBN/parsing_with_ply.html
#   https://www.dabeaz.com/ply/PLYTalk.pdf
#
#
#   By David M. Beazley
# ------------------------------------------------------------------------------------------------------

import ply.lex as lex
from ply.lex import TOKEN


class CoolLexer(object):

    def __init__(self, build_lexer=True, debug=False, optimize=True, debuglog=None, errorlog=None):
        self.lexer = None  # ply lexer instance
        self.tokens = self.tokens_collection + list(self.reserved.values())  # ply tokens collection
        self.reserved = self.keywords_collections  # ply reserved keywords
        self.last_token = None  # last token

        # State Variables
        self.string_backslash = False
        self.string_recorded = ""
        self.comment_count = 0

        # kwargs
        self._build_lexer = build_lexer
        self._debug = debug
        self._optimize = optimize
        self._debuglog = debuglog
        self._errorlog = errorlog

    @property
    def tokens_collection(self):
        # Docstring
        """
        Cool Syntax Tokens
        :return: list
        """
        return [
            # Identifiers
            "ID", "TYPE",
            # Literals
            "LPAREN", "RPAREN", "LBRACE", "RBRACE", "COLON", "COMA", "DOT", "SEMICOLON", "AROBA", "COMMENTD", "COMMENT",
            # Operations                                                                                  
            "PLUS", "MINUS", "DIVIDE", "MULTIPLY", "NOT", "LT", "EQ", "LTEQ", "ASSIGN", "INT_COMP",
            # Basic Types
            "STRING", "BOOLEAN", "INTEGER",
            # Special Operators
            "ARROW"
        ]

    @property
    def keywords_collections(self):
        """
        Cool Keywords
        :return:  dict : pair keyword: Caps keyword
        """

        return {
            "class": "CLASS",
            "else": "ELSE",
            "if": "IF",
            "fi": "FI",
            "in": "IN",
            "inherits": "INHERITS",
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
        :return: dict : pair keyword: Caps keyword
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

    # -----------------------------------------------------------------------------------------------------
    # --------------------- Lexical Analisis, Regular Expresion and Rule Declarations ---------------------
    # -----------------------------------------------------------------------------------------------------

    # Regular Expresion Rules for Simple Tokens

    # Ignore rule for single line comments
    t_ignore_SINGLE_LINE_COMMENT = r"\-\-[^\n]*"
    # A string containing ignored characters (spaces and tabs)
    t_ignore = ' \t'

    t_LPAREN = r'\('  # (
    t_RPAREN = r'\)'  # )
    t_LBRACE = r'\{'  # {
    t_RBRACE = r'\}'  # }
    t_COLON = r'\:'  # :
    t_COMA = r'\,'  # ,
    t_SEMICOLON = r'\;'  # ;
    t_AROBA = r'\@'  # @
    t_PLUS = r'\+'  # +
    t_MINUS = r'\-'  # -
    t_DIVIDE = r'\/'  # /
    t_MULTIPLY = r'\*'  # *
    t_NOT = r'\not'  # not
    t_LTEQ = r'\<\='  # <=
    t_ASSIGN = r'\<\-'  # <-
    t_ARROW = r'\=\>'  # =>
    t_LT = r'\<'  # <
    t_EQ = r'\='  # =
    t_INT_COMP = r'\~'  # ~
    t_DOT = r'\.'  # .

    # t_ignore_COMMENTD = r'-.-'
    # t_ignore_COMMENT = r'*...*'

    # -----------------------------------------------------------------------------------------------------
    # TOKEN decorator to define more complex regular expresion rules for tokens
    # -----------------------------------------------------------------------------------------------------

    # Expesions
    #  
    # INTEGER, BOOLEAN, ID, TYPE, 
    def t_INTEGER(self, t):
        r'\d+'
        try:
            t.value = int(t.value)
        except ValueError:
            print("Integer value too large %d", t.value)
            t.value = 0
        return t

    def t_BOOLEAN(self, t):
        r'(true|false)'
        if t.value == "true":
            t.value = True
        else:
            t.value = False

        return t

    def t_ID(self, t):
        r'[a-z_][a-zA-Z_0-9]*'
        t.value = self.keywords_collections.get(t.value, 'ID')

        return t

    def t_TYPE(self, t):
        r'[A-Z][a-zA-Z_0-9]*'
        t.type = self.keywords_collections.get(t.value, 'TYPE')

        return t

    # Define a rule so we can track line numbers
    def t_newline(self, t):
        # DocString for regex expresion
        r'\n+'
        t.lexer.lineno += len(t.value)

    # Error handeling rule
    def t_error(self, t):
        print("Not Permited Character '%s'" % t.value[0])
        t.lexer.skip(1)

    # -----------------------------------------------------------------------------------------------------
    #   Defining conditional rules for strings and comments
    #   Using exclusive directive since we only want at this time to execture string realted functionallity
    # -----------------------------------------------------------------------------------------------------

    states = (
        ('STRING', 'exclusive'),
        ('COMMENT', 'exclusive'),
    )

    # STRING ignored characters
    t_STRING_ignore = ''

    ##### Rules for String State #####
    # Match the first \" double coutes
    def t_start_string(self, t):
        r'\"'
        t.lexer.begin('STRING')  # Start the String State
        self.string_backslash = False  # Determine if is a blackslash double cuote
        self.string_recorded = ""  # To keep track of recorded string

    # Handels string end event
    def t_STRING_end(self, t):
        if not self.string_backslash:
            t.lexer.begin("INITIAL")
            t.value = self.string_recorded
            t.type = "STRING"
            return t
        else:
            self.string_recorded += '"'

    # Handels new line event
    def t_STRING_newline(self, t):
        r'\n'
        t.lexer.lineno += 1
        if not self.string_backslash:
            print("String newline not escaped")
            t.lexer.skip(1)
        else:
            t.lexer.string_backslashed = False

    # Handels record event
    def t_STRING_char(self, t):
        r'[^\n]'
        if not self.string_backslash:
            if t.value != '\\':
                self.string_recorded += t.value
            else:
                self.string_backslash = True
        else:
            if t.value == 'b':
                self.string_recorded += '\b'
            elif t.value == 't':
                self.string_recorded += '\t'
            elif t.value == 'n':
                self.string_recorded += '\n'
            elif t.value == 'f':
                self.string_recorded += '\f'
            elif t.value == '\\':
                self.string_recorded += '\\'
            else:
                self.string_recorded += t.value
            self.string_backslash = False

    ##### END of String State #####

    ##### Rules for Comment State #####

    # COMMENT ignored characters
    t_COMMENT_ignore = ''

    def t_start_comment(self, t):
        r'\(\*'
        t.lexer.begin("COMMENT")
        self.comment_count = 0

    def t_COMMENT_startanother(self, t):
        r'\(\*'
        self.comment_count += 1

    def t_COMMENT_end(self, t):
        r'\*\)'
        if self.comment_count == 0:
            t.lexer.begin("INITIAL")
        else:
            self.comment_count -= 1

    ##### END of Comment State #####

    # -----------------------------------------------------------------------------------------------------
    #   Build and Test for lexer.py
    # -----------------------------------------------------------------------------------------------------

    def build(self, **kwargs):
        """
        Builds the Lexer Instance
        :param kwargs:
        :return:
        """
        # Still Missing
        pass


if __name__ == "__main__":
    import sys
