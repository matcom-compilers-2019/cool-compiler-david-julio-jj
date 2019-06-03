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
        <feature>       ::= ID LPAREN <parameters_list> RPAREN COLON TYPE LBRACE <expression> RBRACE
                        |   <feature_parameter>
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
        <expression> ::= ID
        """
        p[0] = AST.Object(name=p[1])

    def p_expression_integer_constant(self, p):
        """
        <expression> ::= INTEGER
        """
        p[0] = AST.Integer(content=p[1])

    def p_expression_boolean_constant(self, p):
        """
        <expression> ::= BOOLEAN
        """
        p[0] = AST.Boolean(content=p[1])

    def p_expression_string_constant(self, p):
        """
        <expression> ::= STRING
        """
        p[0] = AST.String(content=p[1])

    def p_expression_self(self, p):
        """
        <expression>  ::= SELF
        """
        p[0] = AST.Self()

    def p_expression_block(self, p):
        """
        <expression> ::= LBRACE block_list RBRACE
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
        <expression> ::= ID ASSIGN expression
        """
        p[0] = AST.Assignment(AST.Object(name=p[1]), expr=p[3])

    