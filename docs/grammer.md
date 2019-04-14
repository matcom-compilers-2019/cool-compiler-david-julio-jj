## Grammer

**Notacion BNF**:

- No Terminales se representan entre <>.
- Se emplea el simbolo ::= para las producciones.
- Un elemento es opcional si se encierra entre [].
- Un elemento que se repite cero o mas veces se encierra entre {} --> nosotros usaremos ()* el () solo es el normal.
- El simbolo | se emplea para agrupar reglas.

**Gramatica**:

```Cool
S ::= (<class>)*
class ::= class TYPE [ inherits TYPE] { <feature> };
feature ::= ID[<parameters>[(, <parameters>)*]] : TYPE { <expr> }
        | ID : TYPE [ <- <expr> ];
parameters ::= ID : TYPE
expr ::= ID <- <expr>
     |  <expr>.ID( <expr>(, <expr>)*)
     |  [self].ID( <expr>(, <expr>)*)
     |  <expr>@TYPE.ID( <expr>(, <expr>)*)
     |  if <expr> then <expr> else <expr> fi
     |  while <expr> loop <expr> pool
     |  { <expr>; (<expr>;)* }
     |  let ID : TYPE [ <- expr ] (, ID : TYPE [ <- expre ])* in <expr>
     |  case <expr> of ID : TYPE => <expr>; [(ID : TYPE => <expr>;)*] esac
     |  new TYPE
     |  isvoid expr
     |  expr <op> expr
     |  <comment>
     |  true
     |  false
     |  ~expr
     |  ID
     |  not expr
op ::= +
     | -
     | /
     | *
     | <
     | <=
     | =
comment ::= --
     | **
```