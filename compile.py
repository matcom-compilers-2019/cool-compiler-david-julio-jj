import src.parser
from sys import argv

if __name__ == '__main__':
    inp = ''
    with open(argv[1], 'r') as fd:
        temp = fd.read()
        while temp:
            inp += temp
    print(inp)
