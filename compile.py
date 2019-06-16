import src.parser as parser
import src.semantic_analizaer as check_semantic
from sys import argv

if __name__ == '__main__':
    files = subprocess.Popen(['ls', 'examples/'], stdout=subprocess.PIPE).communicate()[0]
    files = files.decode()
    files = files.split('\n')
    files = list(filter(lambda x: len(x.split('.')) > 1 and x.split('.')[1] == 'cl', files))
    print(files)
    for i in files:
        print(i)
        inp = ''
        with open(f'examples/{i}', 'r') as fd:
            temp = fd.read()
            while temp:
                inp += temp
                temp = fd.read()
        parser_object = parser.make_parser()
        ast = parser_object.parse(inp)
        semantic_object = check_semantic.CheckSemantic()
        semantic_object.visit(ast, None, [])

