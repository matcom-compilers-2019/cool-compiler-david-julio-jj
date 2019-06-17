import src.ast as ast
import src.cil_nodes as cil_node
import src.visitor as visitor
from src.scope import Scope
from src.type import ctype

class vTable:
    """
    {type:{f_name: int}}
    """
    pass

class Cool2cil:

    def sort_type(self, type_list: dict):
        type_list = list(type_list.values())
        type_map = {}
        bit_mask = [False] * len(type_list)
        for i in range(len(type_list)):
            ctype = type_list[i]
            type_map[ctype.name] = i

        bit_mask[type_map['Object']] = True
        sorted = {}
        self_type = type_list[type_map['SELF_TYPE']]
        sorted[self_type.name] = self_type
        object_type = type_list[type_map['Object']]
        sorted[object_type.name] = object_type
        for i in range(len(type_list)):
            ctype = type_list[i]
            if ctype.name == 'Object' or ctype.name == 'SELF_TYPE':
                continue
            if not bit_mask[i]:
                self.sort_type_(ctype, type_list, type_map, bit_mask, sorted)
        return sorted

    def sort_type_(self, ctype, type_list, type_map, mask, sort_list):
        mask[type_map[ctype.name]] = True
        parent = ctype.parent
        iparent = type_map[parent.name]
        if not mask[iparent]:
            self.sort_type_(parent, type_list, type_map, mask, sort_list)
        sort_list[ctype.name] = ctype

    def get_node_by_type(self, t, classes):
        for i in classes:
            if t == i.name:
                return i

    def delete(self, method_name, tp):
        t = []
        for i in range(len(tp.methods)):
            if method_name != (list(tp.methods[i].keys())[0]).split('.')[1]:
                t.append(tp.methods[i])
        tp.methods = t

    def __init__(self):
        self.dtpe = []
        self.data = []
        self.code = []
        self.vtable = vTable()

    @visitor.on('node')
    def visit(self, node):
        pass

    @visitor.when(ast.Program)
    def visit(self, node: ast.Program, _):
        scope_root = Scope(None, None)
        for classDef in node.classes:
            new_type = ctype(classDef.name)
            scope_root.createType(new_type)
        for classDef in node.classes:
            a = scope_root.getType(classDef.name)
            a.parent = scope_root.getType(classDef.parent)
        new_types = self.sort_type(scope_root.get_types())
        node.classes = list(map(lambda x: self.get_node_by_type(x, node.classes), list(new_types.keys())[6:]))
        scope_root.set_types(new_types)
        t = scope_root.get_types()
        for j in node.classes:
            scope = Scope(j.name, scope_root)
            methods = filter(lambda x: type(x) is ast.ClassMethod, j.features)
            methods = list(methods)
            attribs = filter(lambda x: type(x) is ast.ClassAttribute, j.features)
            attribs = list(attribs)
            p_type = scope.getType(j.parent)
            if p_type.name != 'Object' and p_type.name != 'IO':
                scope.getType(j.name).add_attrib(*tuple(p_type.attributes))
                scope.getType(j.name).add_method(*tuple(p_type.methods))
            for i in attribs:
                scope.getType(j.name).add_attrib({i.name: scope.getType(i.attr_type)})
            for i in methods:
                if j.name in list(scope_root.get_types().keys())[6:] and j.name != "Main":
                    self.delete(i.name, scope.getType(j.name))
                scope.getType(j.name).add_method({f'{j.name}.{i.name}': {
                    'formal_params': {
                        t.name: scope.getType(t.param_type) for t in i.formal_params
                    },
                    'return_type': scope.getType(i.return_type),
                    'body': i.body
                }})
        for i in list(t.keys())[6:]:
            meths = []
            for m in t[i].methods:
                meths.append(list(m.keys())[0])
            attrs = []
            for a in t[i].attributes:
                attrs.append(list(a.keys())[0])
            self.dtpe.append(cil_node.DotType(t[i].name, attrs, meths))

        for i in self.dtpe:
            print(str(i))

            pass
    # @visitor.when(ast.Class)
    # def visit(self, node: ast.Class):

    @visitor.when(ast.Addition)
    def visit(self, node: ast.Addition):
        self.add(cil_node.Pop())
        self.visit(node.first)
        self.visit(node.second)
        self.add(cil_node.ReadS(-4, ''))
        self


