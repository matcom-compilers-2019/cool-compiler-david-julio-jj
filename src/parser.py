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


def p_program(p):
    """
    <program> ::= <classes>
    """
    p[0] = AST.Program(classes=p[1])


def p_classes(p):
    """
    <classes> ::= <classes> <class> SEMICOLON
              |   <class> SEMICOLON
    """
    if len(p) == 3:
        p[0] = (p[1],)
    else:
        p[0] = p[1] + (p[2],)


def p_class(p):
    """
    <class> ::= class TYPE LBRACE <features_list_opt> RBRACE SEMICOLON

    <inherits> ::= <empty>
    """
    p[0] = AST.Class(name=p[2], parent='Object', features=p[4])


def p_class_inherits(p):
    """
    <class> ::= class TYPE <inheritance> LBRACE <features_list_opt> RBRACE SEMICOLON

    <inherits> ::= inherit TYPE
    """
    p[0] = AST.Class(name=p[2], parent=p[3], features=p[5])


def p_feature(p):
    """
    <feature> ::= ID LPAREN <parameters_list> RPAREN COLON TYPE LBRACE <expr> RBRACE
              |   <feature_parameter> SEMICOLON
              |   <empty>
    """
    pass