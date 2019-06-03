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
# ------------------------------------------------------------------------------------------------------

import ply.lex as lex
from ply.lex import TOKEN


class CoolLexer(object):

    def __init__(self, build_lexer=True, debug=False, lextab="lextab", optimize=True, outputdir="", debuglog=None, errorlog=None):
        self.lexer = None       # ply lexer instance
        self.tokens = ()        # ply tokens collection
        self.reserved = {}      # ply reserved keywords
        self.last_token = None  # last token

        # State Variables
        self.string_backslash = False
        self.string_recorded = ""
        self.comment_count = 0

        # kwargs
        self._lextab = lextab
        self._debug = debug
        self._optimize = optimize
        self._debuglog = debuglog
        self._outputdir = outputdir
        self._errorlog = errorlog

        # Build lexer if build_lexer flag is set to True
        if build_lexer is True:
            self.build(debug=debug, lextab=lextab, optimize=optimize, outputdir=outputdir, debuglog=debuglog,
                       errorlog=errorlog)

    @property
    def tokens_collection(self):
        # Docstring
        """
        Cool Syntax Tokens
        :return: Tuple
        """
        return (
            # Identifiers
            "ID", "TYPE",
            # Primitive Types
            "INTEGER", "STRING", "BOOLEAN",
            # Literals
            "LPAREN", "RPAREN", "LBRACE", "RBRACE", "COLON", "COMMA", "DOT", "SEMICOLON", "AT",
            # Operators
            "PLUS", "MINUS", "MULTIPLY", "DIVIDE", "EQ", "LT", "LTEQ", "ASSIGN", "INT_COMP", "NOT",
            # Special Operators
            "ARROW"
        )

    @property
    def keywords_collections(self):
        """
        Cool Keywords
        :return:  dict : pair keyword: Caps keyword
        """

        return {
            "class": "CLASS",
            "case": "CASE",
            "else": "ELSE",
            "esac": "ESAC",
            "fi": "FI",
            "if": "IF",
            "in": "IN",
            "inherits": "INHERITS",
            "isvoid": "ISVOID",
            "not": "NOT",
            "new": "NEW",
            "let": "LET",
            "loop": "LOOP",
            "of": "OF",
            "pool": "POOL",
            "self": "SELF",
            "then": "THEN",
            "while": "WHILE",
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
            "IO": "IO_TYPE",
            "Main": "MAIN_TYPE",
            "Object": "OBJECT_TYPE",
            "String": "STRING_TYPE",
            "SELF_TYPE": "SELF_TYPE"
        }

    # -----------------------------------------------------------------------------------------------------
    # --------------------- Lexical Analisis, Regular Expresion and Rule Declarations ---------------------
    # -----------------------------------------------------------------------------------------------------

    # Regular Expresion Rules for Simple Tokens

    # Ignore rule for single line comments
    t_ignore_SINGLE_LINE_COMMENT = r"\-\-[^\n]*"
    # A string containing ignored characters (spaces and tabs)
    t_ignore = ' \t\r\f'

    t_LPAREN = r'\('        # (
    t_RPAREN = r'\)'        # )
    t_LBRACE = r'\{'        # {
    t_RBRACE = r'\}'        # }
    t_COLON = r'\:'         # :
    t_COMA = r'\,'          # ,
    t_SEMICOLON = r'\;'     # ;
    t_AT = r'\@'            # @
    t_PLUS = r'\+'          # +
    t_MINUS = r'\-'         # -
    t_DIVIDE = r'\/'        # /
    t_MULTIPLY = r'\*'      # *
    t_NOT = r'\not'         # not
    t_LTEQ = r'\<\='        # <=
    t_ASSIGN = r'\<\-'      # <-
    t_ARROW = r'\=\>'       # =>
    t_LT = r'\<'            # <
    t_EQ = r'\='            # =
    t_INT_COMP = r'\~'      # ~
    t_DOT = r'\.'           # .

    # t_ignore_COMMENTD = r'-.-'
    # t_ignore_COMMENT = r'*...*'

    # -----------------------------------------------------------------------------------------------------
    # TOKEN decorator to define more complex regular expresion rules for tokens
    # -----------------------------------------------------------------------------------------------------

    # Expesions
    #  
    # INTEGER, BOOLEAN, ID, TYPE,
    @TOKEN(r"\d+")
    def t_INTEGER(self, t):
        try:
            t.value = int(t.value)
        except ValueError:
            print("Integer value too large %d", t.value)
            t.value = 0
        return t

    @TOKEN(r"(true|false)")
    def t_BOOLEAN(self, t):
        if t.value == "true":
            t.value = True
        else:
            t.value = False

        return t

    @TOKEN(r"[a-z_][a-zA-Z_0-9]*")
    def t_ID(self, t):
        t.value = self.keywords_collections.get(t.value, 'ID')

        return t

    @TOKEN(r"[A-Z][a-zA-Z_0-9]*")
    def t_TYPE(self, t):
        t.type = self.keywords_collections.get(t.value, 'TYPE')

        return t

    # Define a rule so we can track line numbers
    @TOKEN(r"\n+")
    def t_newline(self, t):
        t.lexer.lineno += len(t.value)

    # -----------------------------------------------------------------------------------------------------
    #   Defining conditional rules for strings and comments
    #   Using exclusive directive since we only want at this time to execture string realted functionallity
    # -----------------------------------------------------------------------------------------------------

    @property
    def states(self):
        return (
            ("STRING", "exclusive"),
            ("COMMENT", "exclusive")
        )

    # STRING ignored characters
    t_STRING_ignore = ''

    ##### Rules for String State #####
    # Match the first \" double coutes
    def t_start_string(self, t):
        r'\"'
        t.lexer.begin('STRING')  # Start the String State
        t.lexer.string_backslash = False  # Determine if is a blackslash double cuote
        t.lexer.string_recorded = ""  # To keep track of recorded string

    # Handels string end event
    def t_STRING_end(self, t):
        if not t.lexer.string_backslash:
            t.lexer.begin("INITIAL")
            t.value = t.lexer.string_recorded
            t.type = "STRING"
            return t
        else:
            t.lexer.string_recorded += '"'
            t.lexer.string_backslashed = False

    # Handels new line event
    def t_STRING_newline(self, t):
        r'\n'
        t.lexer.lineno += 1
        if not t.lexer.string_backslash:
            print("String newline not escaped")
            t.lexer.skip(1)
        else:
            t.lexer.string_backslashed = False

    # Handels record event
    def t_STRING_anything(self, t):
        r'[^\n]'
        if not t.lexer.string_backslash:
            if t.value != '\\':
                t.lexer.string_recorded += t.value
            else:
                t.lexer.string_backslash = True
        else:
            if t.value == 'b':
                t.lexer.string_recorded += '\b'
            elif t.value == 't':
                t.lexer.string_recorded += '\t'
            elif t.value == 'n':
                t.lexer.string_recorded += '\n'
            elif t.value == 'f':
                t.lexer.string_recorded += '\f'
            elif t.value == '\\':
                t.lexer.string_recorded += '\\'
            else:
                t.lexer.string_recorded += t.value
            t.lexer.string_backslash = False

    # STRING error handler
    def t_STRING_error(self, t):
        print("Illegal character! Line: {0}, character: {1}".format(t.lineno, t.value[0]))
        t.lexer.skip(1)

    ##### END of String State #####

    ##### Rules for Comment State #####

    def t_start_comment(self, t):
        r'\(\*'
        t.lexer.begin("COMMENT")
        t.lexer.comment_count = 0

    def t_COMMENT_startanother(self, t):
        r'\(\*'
        t.lexer.comment_count += 1

    def t_COMMENT_end(self, t):
        r'\*\)'
        if t.lexer.comment_count == 0:
            t.lexer.begin("INITIAL")
        else:
            t.lexer.comment_count -= 1

    # COMMENT ignored characters
    t_COMMENT_ignore = ''

    # Error handeling rule
    def t_error(self, t):
        print("Not Permited Character '%s'" % t.value[0])
        t.lexer.skip(1)
        
    # COMMENT error handler
    def t_COMMENT_error(self, token):
        token.lexer.skip(1)

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
        # Parse the parameters
        if kwargs is None or len(kwargs) == 0:
            debug, lextab, optimize, outputdir, debuglog, errorlog = \
                self._debug, self._lextab, self._optimize, self._outputdir, self._debuglog, self._errorlog
        else:
            debug = kwargs.get("debug", self._debug)
            lextab = kwargs.get("lextab", self._lextab)
            optimize = kwargs.get("optimize", self._optimize)
            outputdir = kwargs.get("outputdir", self._outputdir)
            debuglog = kwargs.get("debuglog", self._debuglog)
            errorlog = kwargs.get("errorlog", self._errorlog)

        self.reserved = self.keywords_collections.keys()  # ply reserved keywords
        self.tokens = self.tokens_collection + tuple(self.keywords_collections.values())  # ply tokens collection

        self.lexer = lex.lex(module=self, lextab=lextab, debug=debug, optimize=optimize, outputdir=outputdir, 
                                debuglog=debuglog, errorlog=errorlog)

    def input(self, cool_program_source_code: str):
        """
        Run lexical analysis on a given COOL program source code string.
        :param cool_program_source_code: COOL program source code as a string.
        :return: None.
        """
        if self.lexer is None:
            raise Exception("Lexer was not built. Try calling the build() method first, and then tokenize().")

        self.lexer.input(cool_program_source_code)

    def token(self):
        """
        Advanced the lexers tokens tape one place and returns the current token.
        :side-effects: Modifies self.last_token.
        :return: Token.
        """
        if self.lexer is None:
            raise Exception("Lexer was not built. Try building the lexer with the build() method.")

        self.last_token = self.lexer.token()
        return self.last_token

    def clone_ply_lexer(self):
        """
        Clones the internal PLY's lex-generated lexer instance. Returns a new copy.
        :return: PLY's lex-generated lexer clone.
        """
        a_clone = self.lexer.clone()
        return a_clone

    @staticmethod
    def test(program_source_code: str):
        """
        Given a cool program source code string try to run lexical analysis on it and return all tokens as an iterator.
        :param program_source_code: String.
        :return: Iterator.
        """
        temp_lexer = CoolLexer()
        temp_lexer.input(program_source_code)
        iter_token_stream = iter([some_token for some_token in temp_lexer])
        del temp_lexer
        return iter_token_stream

    # ################### ITERATOR PROTOCOL ############################################

    def __iter__(self):
        return self

    def __next__(self):
        t = self.token()
        if t is None:
            raise StopIteration
        return t

    def next(self):
        return self.__next__()

def make_lexer(**kwargs) -> CoolLexer:
    """
    Utility function.
    :return: CoolLexer object.
    """
    a_lexer = CoolLexer(**kwargs)
    a_lexer.build()
    return a_lexer


if __name__ == "__main__":
    import sys

    if len(sys.argv) != 2:
        print("Usage: ./lexer.py program.cl")
        exit()
    elif not str(sys.argv[1]).endswith(".cl"):
        print("Cool program source code files must end with .cl extension.")
        print("Usage: ./lexer.py program.cl")
        exit()

    input_file = sys.argv[1]
    with open(input_file, encoding="utf-8") as file:
        cool_program_code = file.read()

    lexer = make_lexer()
    lexer.input(cool_program_code)
    for token in lexer:
        print(token)
