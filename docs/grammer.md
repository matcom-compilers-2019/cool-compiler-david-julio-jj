## Grammer

**Notacion BNF**:

- No Terminales se representan entre <>.
- Se emplea el simbolo ::= para las producciones.
- Un elemento es opcional si se encierra entre [].
- Un elemento que se repite cero o mas veces se encierra entre ()*
- El simbolo | se emplea para agrupar reglas.

**Gramatica**:

```Coo
<program> 	 ::= <classes>
<classes> 	 ::= <classes><class>; 
			 | <class>;
<class> 	 ::= class TYPE [<inherits>] { <feature> };
<inhertits>  ::= inherits TYPE
			 | <empty>
<feature> 	 ::= ID[<parameters>[(, <parameters>)*]] : TYPE { <expr> }
			 | ID : TYPE [ <- <expr> ];
<parameters> ::= ID : TYPE
<expr> 		 ::= ID <- <expr>
             |  <expr>.ID( <expr>(, <expr>)*)
             |  [self].ID( <expr>(, <expr>)*)
             |  <expr>@TYPE.ID( <expr>(, <expr>)*)
             |  if <expr> then <expr> else <expr> fi
             |  while <expr> loop <expr> pool
             |  { <expr>; (<expr>;)* }
             |  <let>
             |  <case>
             |  new TYPE
             |  isvoid <expr>
             |  <expr> <op> <expr>
             |  <comment>
             |  TRUE
             |  FALSE
             |  ~ <expr>
             |  ID
             |  STRING
             |	INTEGER
             |  not <expr>
<case> 		 :: = case <expr> of ID : TYPE => <expr>; [(ID : TYPE => <expr>;)*] esac
<let> 		 ::= let ID : TYPE [ <- expr ] (, ID : TYPE [ <- expre ])* in <expr>
<op> 		 ::= +
             | -
             | /
             | *
             | <
             | <=
             | =
<empty>      ::=
```

