# lextab.py. This file automatically created by PLY (version 3.9). Don't edit!
_tabversion   = '3.8'
_lextokens    = set(('LT', 'POOL', 'ELSE', 'COLON', 'ISVOID', 'RPAREN', 'LOOP', 'THEN', 'ASSIGN', 'MINUS', 'CLASS', 'ID', 'DIVIDE', 'LTEQ', 'INHERITS', 'LPAREN', 'EQ', 'PLUS', 'SEMICOLON', 'CASE', 'STRING', 'FI', 'IF', 'LET', 'MULTIPLY', 'TYPE', 'NEW', 'ESAC', 'OF', 'SELF', 'INTEGER', 'BOOLEAN', 'IN', 'WHILE', 'RBRACE', 'ARROW', 'AT', 'INT_COMP', 'NOT', 'DOT', 'COMMA', 'LBRACE'))
_lexreflags   = 0
_lexliterals  = ''
_lexstateinfo = {'INITIAL': 'inclusive', 'STRING': 'exclusive', 'COMMENT': 'exclusive'}
_lexstatere   = {'INITIAL': [('(?P<t_BOOLEAN>(true|false))|(?P<t_INTEGER>\\d+)|(?P<t_TYPE>[A-Z][a-zA-Z_0-9]*)|(?P<t_ID>[a-z_][a-zA-Z_0-9]*)|(?P<t_newline>\\n+)|(?P<t_start_string>\\")|(?P<t_start_comment>\\(\\*)|(?P<t_ignore_SINGLE_LINE_COMMENT>\\-\\-[^\\n]*)|(?P<t_ARROW>\\=\\>)|(?P<t_ASSIGN>\\<\\-)|(?P<t_LTEQ>\\<\\=)|(?P<t_NOT>not)|(?P<t_AT>\\@)|(?P<t_COLON>\\:)|(?P<t_COMMA>\\,)|(?P<t_DIVIDE>\\/)|(?P<t_DOT>\\.)|(?P<t_EQ>\\=)|(?P<t_LBRACE>\\{)|(?P<t_LPAREN>\\()|(?P<t_LT>\\<)|(?P<t_MINUS>\\-)|(?P<t_MULTIPLY>\\*)|(?P<t_PLUS>\\+)|(?P<t_RBRACE>\\})|(?P<t_RPAREN>\\))|(?P<t_SEMICOLON>\\;)|(?P<t_INT_COMP>~)', [None, ('t_BOOLEAN', 'BOOLEAN'), None, ('t_INTEGER', 'INTEGER'), ('t_TYPE', 'TYPE'), ('t_ID', 'ID'), ('t_newline', 'newline'), ('t_start_string', 'start_string'), ('t_start_comment', 'start_comment'), (None, None), (None, 'ARROW'), (None, 'ASSIGN'), (None, 'LTEQ'), (None, 'NOT'), (None, 'AT'), (None, 'COLON'), (None, 'COMMA'), (None, 'DIVIDE'), (None, 'DOT'), (None, 'EQ'), (None, 'LBRACE'), (None, 'LPAREN'), (None, 'LT'), (None, 'MINUS'), (None, 'MULTIPLY'), (None, 'PLUS'), (None, 'RBRACE'), (None, 'RPAREN'), (None, 'SEMICOLON'), (None, 'INT_COMP')])], 'STRING': [('(?P<t_STRING_newline>\\n)|(?P<t_STRING_end>\\")|(?P<t_STRING_anything>[^\\n])', [None, ('t_STRING_newline', 'newline'), ('t_STRING_end', 'end'), ('t_STRING_anything', 'anything')])], 'COMMENT': [('(?P<t_COMMENT_startanother>\\(\\*)|(?P<t_COMMENT_end>\\*\\))', [None, ('t_COMMENT_startanother', 'startanother'), ('t_COMMENT_end', 'end')])]}
_lexstateignore = {'COMMENT': '', 'STRING': '', 'INITIAL': ' \t\r\x0c'}
_lexstateerrorf = {'COMMENT': 't_COMMENT_error', 'STRING': 't_STRING_error', 'INITIAL': 't_error'}
_lexstateeoff = {}
