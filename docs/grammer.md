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
			 |   <class>;
<class> 	 ::= class TYPE [<inherits>] { <feature> };
<inhertits>  ::= inherits TYPE
			 |   <empty>
<feature> 	 ::= ID[<parameters_list>] : TYPE { <expr> }
			 |   <feature_parameter>;
<params_list>::= <parameters_list>, <parameter>
			 | 	 <parameter>
<parameter>	 ::= ID : TYPE
<feature_parameter> ::= ID : TYPE <- <expr>
			 | 			ID : TYPE
<expr> 		 ::= ID <- <expr>
             |   <expr>.ID( <expr>(, <expr>)*)
             |   [self].ID( <expr>(, <expr>)*)
             |   <expr>@TYPE.ID( <expr>(, <expr>)*)
             |   <if>
             |   <while>
             |   { <expr>; ( <expr>; )* }
             |   <let>
             |   <case>
             |   new TYPE
             |   isvoid <expr>
             |   <expr> <op> <expr>
             |   <comment>
             |   TRUE
             |   FALSE
             |   ~ <expr>
             |	 ( <expr> )
             |   ID
             |   STRING
             |	 INTEGER
             |   not <expr>
<case> 		 ::= case <expr> of ID : TYPE => <expr>; [(ID : TYPE => <expr>;)*] esac
<let> 		 ::= let ID : TYPE [ <- expr ] (, ID : TYPE [ <- expre ])* in <expr>
<while>		 ::= while <expr> loop <expr> pool
<if>		 ::= if <expr> then <expr> else <expr> fi
<op> 		 ::= +
             | 	 -
             |   /
             |   *
             |   <
             |   <=
             |   =
<empty>      ::=
<comment>	 ::=
```

