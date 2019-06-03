# Parser

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
# ------------------------------------------------------------------------------------------------------

import ply.yacc as yacc
import src.ast as AST
from src.lexer import make_lexer



class CoolParser(object):

    def __init__(self, build_parser=True, debug=False, write_tables=True,
                 optimize=True, outputdir="", yacctab="yacctab", debuglog=None, errorlog=None):

        # Initialize self.parser and self.tokens to None
        self.tokens = None
        self.lexer = None
        self.parser = None
        self.error_list = []

        # Save Flags - PRIVATE PROPERTIES
        self._debug = debug
        self._write_tables = write_tables
        self._optimize = optimize
        self._outputdir = outputdir
        self._yacctab = yacctab
        self._debuglog = debuglog
        self._errorlog = errorlog

        # Build parser if build_parser flag is set to True
        if build_parser is True:
            self.build(debug=debug, write_tables=write_tables, optimize=optimize, outputdir=outputdir,
                       yacctab=yacctab, debuglog=debuglog, errorlog=errorlog)

    # ################################ PRECEDENCE RULES ################################

    # precedence rules
    precedence = (
        ('right', 'ASSIGN'),
        ('right', 'NOT'),
        ('nonassoc', 'LTEQ', 'LT', 'EQ'),
        ('left', 'PLUS', 'MINUS'),
        ('left', 'MULTIPLY', 'DIVIDE'),
        ('right', 'ISVOID'),
        ('right', 'INT_COMP'),
        ('left', 'AT'),
        ('left', 'DOT')
    )

    def p_program(self, p):
        """
        <program>   ::= <classes>
        """
        p[0] = AST.Program(classes=p[1])

    def p_classes(self, p):
        """
        <classes>   ::= <classes> <class> SEMICOLON
                    |   <class> SEMICOLON
        """
        if len(p) == 3:
            p[0] = (p[1],)
        else:
            p[0] = p[1] + (p[2],)

    def p_class(self, p):
        """
        <inherits> ::= <empty>
        <class>     ::= class TYPE LBRACE <features_list_opt> RBRACE SEMICOLON
        """
        p[0] = AST.Class(name=p[2], parent='Object', features=p[4])

    def p_class_inherits(self, p):
        """
        <inherits> ::= inherit TYPE
        <class>     ::= class TYPE <inheritance> LBRACE <features_list_opt> RBRACE SEMICOLON
        """
        p[0] = AST.Class(name=p[2], parent=p[3], features=p[5])

    def p_features_list_opt(self, p):
        """
        <features_list_opt>     ::= <features_list>
                                |   <empty>
        """
        p[0] = tuple() if p.slice[1].type == "empty" else p[1]

    def p_feature_list(self, p):
        """
        <features_list>  ::= features_list feature SEMICOLON
                         |  feature SEMICOLON
        """
        if len(p) == 3:
            p[0] = (p[1],)
        else:
            p[0] = p[1] + (p[2],)

    def p_feature_method(self, p):
        """
        <feature>       ::= ID LPAREN parameters_list RPAREN COLON TYPE LBRACE expression RBRACE
                        |   feature_parameter
        """
        p[0] = AST.ClassMethod(name=p[1], formal_params=p[3], return_type=p[6], body=p[8])

    def p_feature_method_no_formals(self, p):
        """
        <feature> : ID LPAREN RPAREN COLON TYPE LBRACE expression RBRACE
        <parameters_list> ::= <empty>
        """
        p[0] = AST.ClassMethod(name=p[1], formal_params=tuple(), return_type=p[5], body=p[7])

    def p_feature_attr_initialized(self, p):
        """
        <feature_parameter> : ID COLON TYPE ASSIGN expression
        """
        p[0] = AST.ClassAttribute(name=p[1], attr_type=p[3], init_expr=p[5])

    def p_feature_attr(self, p):
        """
        feature : ID COLON TYPE
        """
        p[0] = AST.ClassAttribute(name=p[1], attr_type=p[3], init_expr=None)

    def p_formal_list_many(self, p):
        """
        <formal_params_list>    ::= formal_params_list COMMA formal_param
                                |   formal_param
        """
        if len(p) == 2:
            p[0] = (p[1],)
        else:
            p[0] = p[1] + (p[3],)

    def p_formal(self, p):
        """
        <formal_param>  ::= ID COLON TYPE
        """
        p[0] = AST.FormalParameter(name=p[1], param_type=p[3])

    def p_expression_object_identifier(self, p):
        """
        <expr> ::= ID
        """
        p[0] = AST.Object(name=p[1])

    def p_expression_integer_constant(self, p):
        """
        <expr> ::= INTEGER
        """
        p[0] = AST.Integer(content=p[1])

    def p_expression_boolean_constant(self, p):
        """
        <expr> ::= BOOLEAN
        """
        p[0] = AST.Boolean(content=p[1])

    def p_expression_string_constant(self, p):
        """
        <expr> ::= STRING
        """
        p[0] = AST.String(content=p[1])

    def p_expression_self(self, p):
        """
        <expr>  ::= SELF
        """
        p[0] = AST.Self()

    def p_expression_block(self, p):
        """
        <expr> ::= LBRACE block_list RBRACE
        """
        p[0] = AST.Block(expr_list=p[2])

    def p_block_list(self, p):
        """
        <block_list>    ::= block_list expression SEMICOLON
                        | expression SEMICOLON
        """
        if len(p) == 3:
            p[0] = (p[1],)
        else:
            p[0] = p[1] + (p[2],)

    def p_expression_assignment(self, p):
        """
        <expr> ::= ID ASSIGN expression
        """
        p[0] = AST.Assignment(AST.Object(name=p[1]), expr=p[3])

    # ######################### METHODS DISPATCH ######################################

    def p_expression_dispatch(self, p):
        """
        <expr>    ::= expression DOT ID LPAREN arguments_list_opt RPAREN
        """
        p[0] = AST.DynamicDispatch(instance=p[1], method=p[3], arguments=p[5])

    def p_arguments_list_opt(self, p):
        """
        <arguments_list_opt>    ::= arguments_list
                                | empty
        """
        p[0] = tuple() if p.slice[1].type == "empty" else p[1]

    def p_arguments_list(self, p):
        """
        <arguments_list>    ::= arguments_list COMMA expression
                            | expression
        """
        if len(p) == 2:
            p[0] = (p[1],)
        else:
            p[0] = p[1] + (p[3],)

    def p_expression_static_dispatch(self, p):
        """
        <expr>    ::= expression AT TYPE DOT ID LPAREN arguments_list_opt RPAREN
        """
        p[0] = AST.StaticDispatch(instance=p[1], dispatch_type=p[3], method=p[5], arguments=p[7])

    def p_expression_self_dispatch(self, p):
        """
        <expr>    ::= ID LPAREN arguments_list_opt RPAREN
        """
        p[0] = AST.DynamicDispatch(instance=AST.Self(), method=p[1], arguments=p[3])

    # ######################### PARENTHESIZED, MATH & COMPARISONS #####################

    def p_expression_math_operations(self, p):
        """
        <expr>      ::= expression PLUS expression
                    |   expression MINUS expression
                    |   expression MULTIPLY expression
                    |   expression DIVIDE expression
        """
        if p[2] == '+':
            p[0] = AST.Addition(first=p[1], second=p[3])
        elif p[2] == '-':
            p[0] = AST.Subtraction(first=p[1], second=p[3])
        elif p[2] == '*':
            p[0] = AST.Multiplication(first=p[1], second=p[3])
        elif p[2] == '/':
            p[0] = AST.Division(first=p[1], second=p[3])

    def p_expression_math_comparisons(self, p):
        """
        <expr>      ::= expression LT expression
                    |   expression LTEQ expression
                    |   expression EQ expression
        """
        if p[2] == '<':
            p[0] = AST.LessThan(first=p[1], second=p[3])
        elif p[2] == '<=':
            p[0] = AST.LessThanOrEqual(first=p[1], second=p[3])
        elif p[2] == '=':
            p[0] = AST.Equal(first=p[1], second=p[3])

    def p_expression_with_parenthesis(self, p):
        """
        <expr> : LPAREN expression RPAREN
        """
        p[0] = p[2]

    # ######################### CONTROL FLOW EXPRESSIONS ##############################

    def p_expression_if_conditional(self, p):
        """
        <expr> : IF expression THEN expression ELSE expression FI
        """
        p[0] = AST.If(predicate=p[2], then_body=p[4], else_body=p[6])

    def p_expression_while_loop(self, p):
        """
        <expr> : WHILE expression LOOP expression POOL
        """
        p[0] = AST.WhileLoop(predicate=p[2], body=p[4])

    # ######################### LET EXPRESSIONS ########################################

    def p_expression_let(self, p):
        """
         <expr> : let_expression
        """
        p[0] = p[1]

    def p_expression_let_simple(self, p):
        """
        <let_expression>    ::= LET ID COLON TYPE IN expression
                            | nested_lets COMMA LET ID COLON TYPE
        """
        p[0] = AST.Let(instance=p[2], return_type=p[4], init_expr=None, body=p[6])

    def p_expression_let_initialized(self, p):
        """
        <let_expression>    ::= LET ID COLON TYPE ASSIGN expression IN expression
                            | nested_lets COMMA LET ID COLON TYPE ASSIGN expression
        """
        p[0] = AST.Let(instance=p[2], return_type=p[4], init_expr=p[6], body=p[8])

    def p_inner_lets_simple(self, p):
        """
        <nested_lets>       ::= ID COLON TYPE IN expression
                            | nested_lets COMMA ID COLON TYPE
        """
        p[0] = AST.Let(instance=p[1], return_type=p[3], init_expr=None, body=p[5])

    def p_inner_lets_initialized(self, p):
        """
        <nested_lets>       ::= ID COLON TYPE ASSIGN expression IN expression
                            | nested_lets COMMA ID COLON TYPE ASSIGN expression
        """
        p[0] = AST.Let(instance=p[1], return_type=p[3], init_expr=p[5], body=p[7])

    # ######################### CASE EXPRESSION ########################################

    def p_expression_case(self, p):
        """
        <expr>  ::= CASE expression OF actions_list ESAC
        """
        p[0] = AST.Case(expr=p[2], actions=p[4])

    def p_actions_list(self, p):
        """
        <actions_list>  ::= actions_list action
                        | action
        """
        if len(p) == 2:
            p[0] = (p[1],)
        else:
            p[0] = p[1] + (p[2],)

    def p_action_expr(self, p):
        """
        <action>    ::= ID COLON TYPE ARROW expression SEMICOLON
        """
        p[0] = (p[1], p[3], p[5])

    # ######################### UNARY OPERATIONS #######################################

    def p_expression_new(self, p):
        """
        <expr>  ::= NEW TYPE
        """
        p[0] = AST.NewObject(p[2])

    def p_expression_isvoid(self, p):
        """
        <expr>  ::= ISVOID expression
        """
        p[0] = AST.IsVoid(p[2])

    def p_expression_integer_complement(self, p):
        """
        <expr>  ::= INT_COMP expression
        """
        p[0] = AST.IntegerComplement(p[2])

    def p_expression_boolean_complement(self, p):
        """
        <expr>  ::= NOT expression
        """
        p[0] = AST.BooleanComplement(p[2])

    # ######################### THE EMPTY PRODUCTION ###################################

    def p_empty(self, p):
        """
        <empty> :
        """
        p[0] = None

    # ######################### p ERROR HANDLER ####################################

    def p_error(self, p):
        """
        Error rule for Syntax Errors handling and reporting.
        """
        if p is None:
            print("Error! Unexpected end of input!")
        else:
            error = "Syntax error! Line: {}, position: {}, character: {}, type: {}".format(
                p.lineno, p.lexpos, p.value, p.type)
            self.error_list.append(error)
            self.parser.errok()

    # ################### END OF FORMAL GRAMMAR RULES SPECIFICATION ####################

    def build(self, **kwargs):
        """
        Builds the Parser Instance
        :param kwargs:
        :return:
        """
        # Parse the parameters
        if kwargs is None or len(kwargs) == 0:
            debug, write_tables, optimize, outputdir, yacctab, debuglog, errorlog = \
                self._debug, self._write_tables, self._optimize, self._outputdir, self._yacctab, self._debuglog, \
                self._errorlog
        else:
            debug = kwargs.get("debug", self._debug)
            write_tables = kwargs.get("write_tables", self._write_tables)
            optimize = kwargs.get("optimize", self._optimize)
            outputdir = kwargs.get("outputdir", self._outputdir)
            yacctab = kwargs.get("yacctab", self._yacctab)
            debuglog = kwargs.get("debuglog", self._debuglog)
            errorlog = kwargs.get("errorlog", self._errorlog)

        # Build CoolLexer
        self.lexer = make_lexer(debug=debug, optimize=optimize, outputdir=outputdir, debuglog=debuglog,
                                errorlog=errorlog)

        # Expose tokens collections to this instance scope
        self.tokens = self.lexer.tokens

        # Build yacc parser
        self.parser = yacc.yacc(module=self, write_tables=write_tables, debug=debug, optimize=optimize,
                                outputdir=outputdir, tabmodule=yacctab, debuglog=debuglog, errorlog=errorlog)

    def parse(self, program_source_code: str) -> AST.Program:
        """
        Parses a COOL program source code passed as a string.
        :param program_source_code: string.
        :return: Parser output.
        """
        if self.parser is None:
            raise ValueError("Parser was not build, try building it first with the build() method.")

        return self.parser.parse(program_source_code)

def make_parser(**kwargs) -> CoolParser:
    """
    Utility function.
    :return: PyCoolParser object.
    """
    a_parser = CoolParser(**kwargs)
    a_parser.build()
    return a_parser


if __name__ == '__main__':
    import sys

    parser = make_parser()

    if len(sys.argv) > 1:
        if not str(sys.argv[1]).endswith(".cl"):
            print("Cool program source code files must end with .cl extension.")
            print("Usage: ./parser.py program.cl")
            exit()

        input_file = sys.argv[1]
        with open(input_file, encoding="utf-8") as file:
            cool_program_code = file.read()

        parse_result = parser.parse(cool_program_code)
        print(parse_result)
    else:
        print("PyCOOLC Parser: Interactive Mode.\r\n")
        while True:
            try:
                s = input('COOL >>> ')
            except EOFError:
                break
            if not s:
                continue
            result = parser.parse(s)
            if result is not None:
                print(result)
