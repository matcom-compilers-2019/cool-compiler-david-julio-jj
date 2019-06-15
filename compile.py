import src.parser as parser
import src.semantic_analizaer as check_semantic
from sys import argv

if __name__ == '__main__':
    inp = ''
    with open(argv[1], 'r') as fd:
        temp = fd.read()
        while temp:
            inp += temp
            temp = fd.read()
    parser_object = parser.make_parser()
    ast = parser_object.parse(inp)
    semantic_object = check_semantic.CheckSemantic()
    semantic_object.visit(ast, None)
    # print(ast)

