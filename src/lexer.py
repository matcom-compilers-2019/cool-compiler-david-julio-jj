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
    """
    CoolLexer class.
    """
    def __init__(self,
                 build_lexer=True,
                 debug=False,
                 lextab="lextab",
                 optimize=True,
                 outputdir="",
                 debuglog=None,
                 errorlog=None):

        self.lexer = None               # ply lexer instance
        self.tokens = ()                # ply tokens collection
        self.reserved = {}              # ply reserved keywords map
        self.last_token = None          # last returned token

        # Save Flags - PRIVATE PROPERTIES
        self._debug = debug
        self._lextab = lextab
        self._optimize = optimize
        self._outputdir = outputdir
        self._debuglog = debuglog
        self._errorlog = errorlog

        # Build lexer if build_lexer flag is set to True
        if build_lexer is True:
            self.build(debug=debug, lextab=lextab, optimize=optimize, outputdir=outputdir, debuglog=debuglog,
                       errorlog=errorlog)

    # #################################  READONLY  #####################################

    @property
    def tokens_collection(self):
        """
        Collection of COOL Syntax Tokens.
        :return: Tuple.
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
    def basic_reserved(self):
        """
        Map of Basic-COOL reserved keywords.
        :return: dict.
        """
        return {
            "case": "CASE",
            "class": "CLASS",
            "else": "ELSE",
            "esac": "ESAC",
            "fi": "FI",
            "if": "IF",
            "in": "IN",
            "inherits": "INHERITS",
            "isvoid": "ISVOID",
            "let": "LET",
            "loop": "LOOP",
            "new": "NEW",
            "of": "OF",
            "pool": "POOL",
            "self": "SELF",
            "then": "THEN",
            "while": "WHILE"
        }

    @property
    def builtin_types(self):
        """
        A map of the built-in types.
        :return dict
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

    # ################################  PRIVATE  #######################################

    # ################# START OF LEXICAL ANALYSIS RULES DECLARATION ####################

    # Ignore rule for single line comments
    t_ignore_SINGLE_LINE_COMMENT = r"\-\-[^\n]*"

    ###
    # SIMPLE TOKENS
    t_LPAREN = r'\('        # (
    t_RPAREN = r'\)'        # )
    t_LBRACE = r'\{'        # {
    t_RBRACE = r'\}'        # }
    t_COLON = r'\:'         # :
    t_COMMA = r'\,'         # ,
    t_DOT = r'\.'           # .
    t_SEMICOLON = r'\;'     # ;
    t_AT = r'\@'            # @
    t_MULTIPLY = r'\*'      # *
    t_DIVIDE = r'\/'        # /
    t_PLUS = r'\+'          # +
    t_MINUS = r'\-'         # -
    t_INT_COMP = r'~'       # ~
    t_LT = r'\<'            # <
    t_EQ = r'\='            # =
    t_LTEQ = r'\<\='        # <=
    t_ASSIGN = r'\<\-'      # <-
    t_NOT = r'not'          # not
    t_ARROW = r'\=\>'       # =>

    @TOKEN(r"(true|false)")
    def t_BOOLEAN(self, t):
        t.value = True if t.value == "true" else False
        return t

    @TOKEN(r"\d+")
    def t_INTEGER(self, t):
        t.value = int(t.value)
        return t

    @TOKEN(r"[A-Z][a-zA-Z_0-9]*")
    def t_TYPE(self, t):
        t.type = self.basic_reserved.get(t.value, 'TYPE')
        return t

    @TOKEN(r"[a-z_][a-zA-Z_0-9]*")
    def t_ID(self, t):
        # Check for reserved words
        t.type = self.basic_reserved.get(t.value, 'ID')
        return t

    @TOKEN(r"\n+")
    def t_newline(self, t):
        t.lexer.lineno += len(t.value)

    # Ignore Whitespace Character Rule
    t_ignore = ' \t\r\f'

    # ################# LEXER STATES ######################################

    @property
    def states(self):
        return (
            ("STRING", "exclusive"),
            ("COMMENT", "exclusive")
        )

    ###
    # THE STRING STATE
    @TOKEN(r"\"")
    def t_start_string(self, t):
        t.lexer.begin("STRING")
        t.lexer.string_backslashed = False
        t.lexer.stringbuf = ""

    @TOKEN(r"\n")
    def t_STRING_newline(self, t):
        t.lexer.lineno += 1
        if not t.lexer.string_backslashed:
            print("String newline not escaped")
            t.lexer.skip(1)
        else:
            t.lexer.string_backslashed = False

    @TOKEN(r"\"")
    def t_STRING_end(self, t):
        if not t.lexer.string_backslashed:
            t.lexer.begin("INITIAL")
            t.value = t.lexer.stringbuf
            t.type = "STRING"
            return t
        else:
            t.lexer.stringbuf += '"'
            t.lexer.string_backslashed = False

    @TOKEN(r"[^\n]")
    def t_STRING_anything(self, t):
        if t.lexer.string_backslashed:
            if t.value == 'b':
                t.lexer.stringbuf += '\b'
            elif t.value == 't':
                t.lexer.stringbuf += '\t'
            elif t.value == 'n':
                t.lexer.stringbuf += '\n'
            elif t.value == 'f':
                t.lexer.stringbuf += '\f'
            elif t.value == '\\':
                t.lexer.stringbuf += '\\'
            else:
                t.lexer.stringbuf += t.value
            t.lexer.string_backslashed = False
        else:
            if t.value != '\\':
                t.lexer.stringbuf += t.value
            else:
                t.lexer.string_backslashed = True

    # STRING ignored characters
    t_STRING_ignore = ''

    # STRING error handler
    def t_STRING_error(self, t):
        print("Illegal character! Line: {0}, character: {1}".format(t.lineno, t.value[0]))
        t.lexer.skip(1)

    ###
    # THE COMMENT STATE
    @TOKEN(r"\(\*")
    def t_start_comment(self, t):
        t.lexer.begin("COMMENT")
        t.lexer.comment_count = 0

    @TOKEN(r"\(\*")
    def t_COMMENT_startanother(self, t):
        t.lexer.comment_count += 1

    @TOKEN(r"\*\)")
    def t_COMMENT_end(self, t):
        if t.lexer.comment_count == 0:
            t.lexer.begin("INITIAL")
        else:
            t.lexer.comment_count -= 1

    # COMMENT ignored characters
    t_COMMENT_ignore = ''

    # COMMENT error handler
    def t_COMMENT_error(self, t):
        t.lexer.skip(1)

    def t_error(self, t):
        """
        Error Handling and Reporting Rule.
        """
        print("Illegal character! Line: {0}, character: {1}".format(t.lineno, t.value[0]))
        t.lexer.skip(1)

    # ################# END OF LEXICAL ANALYSIS RULES DECLARATION ######################

    def build(self, **kwargs):
        """
        Builds the CoolLexer instance
        :param:
        :return: None
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

        self.reserved = self.basic_reserved.keys()
        self.tokens = self.tokens_collection + tuple(self.basic_reserved.values())

        # Build internal ply.lex instance
        self.lexer = lex.lex(module=self, lextab=lextab, debug=debug, optimize=optimize, outputdir=outputdir,
                             debuglog=debuglog, errorlog=errorlog)

    def input(self, cool_program_source_code: str):
        if self.lexer is None:
            raise Exception("Lexer was not built. Try calling the build() method first, and then tokenize().")

        self.lexer.input(cool_program_source_code)

    def token(self):
        if self.lexer is None:
            raise Exception("Lexer was not built. Try building the lexer with the build() method.")

        self.last_token = self.lexer.token()
        return self.last_token

    def clone_ply_lexer(self):
        a_clone = self.lexer.clone()
        return a_clone

    @staticmethod
    def test(program_source_code: str):
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


