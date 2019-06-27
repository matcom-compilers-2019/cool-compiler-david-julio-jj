# Cool Compiler Project

## Integrantes
- [Joel David Hernández Cruz](https://github.com/JDavid17)
- [Juan José Roque Cires](https://github.com/jr638091)
- [Julio César Sánchez García](https://github.com/julioc1p)

## Content

Development Status.

| Compiler Stage     | Python Module                         | Status                                     |
|:-------------------|:--------------------------------------|:-------------------------------------------|
| Lexical Analysis   | [lexer.py](/src/lexer.py)                            | **complete**                |
| Parsing            | [parser.py](/src/parser.py)                          | **complete**                |
| Semantic Analysis  | [semantic_analizaer.py](/src/semantic_analizaer.py)  | **complete**                |
| Code Generation    | [mips_generator.py](/src/mips_genertor.py);          | **complete**                |


### Lexer & Parser
El proyecto esta desarrollado en python, para el desarrollo del lexer y el parser usamos la herramienta de parsing **ply**, que es una implementación de **Lex** y **Yac** originales de **C**, en python.

#### Grámatica
La Grámatica usada, tiene recursión extrema izquierda, los problemas de ambiguedad se resuelven luego en el parser, definiendo ciertas reglas de presedencia para los tokens. Ejemplo
```python
precedence = (
     ('left', 'PLUS', 'MINUS'),
     ('left', 'TIMES', 'DIVIDE'),
 )
 # Esta declaracion define que PLUS/MINUS tienen el mismo nivel de presedencia y son asociativos a la izquierda, al igual que TIMES/DIVIDE. Dentro de esta declaracion los tokens son ordenados de baja a alta presedencia, luego esta declaracion definiria que TIMES/DIVIDE tienen un mayor nivel de presedencia que PLUS/MINUS
```
```Coo
<program> 	 			::= <classes>

<classes> 	 			::= <classes><class>; 
			 			|   <class>;
			 			
<class> 	 			::= class TYPE <inherits> { <features_list_opt> }

<inhertits>  			::= inherits TYPE
			 			|   <empty>

<features_list_opt>     ::= <features_list>
                        |   <empty>

<features_list>         ::= <features_list> <feature> ;
                        |   <feature> ;

<feature>               ::= ID ( <formal_params_list_opt> ) : TYPE { <expression> }
                        |   <formal>
			 			
<formal_params_list_opt>::= <formal_params_list>
                        |   <empty>

<formal_params_list>    ::= <formal_params_list> , <formal_param>
                        |   <formal_param>

<formal_param>          ::= ID : TYPE
			 			
<expr> 		 			::= ID <- <expr>
             			|   <expr>.ID( <arguments_list_opt> )
             			|   <expr>@TYPE.ID( <arguments_list_opt> )
             			|   <if>
             			|   <while>
             			|   <block_expr>
             			|   <let>
             			|   <case>
             			|   new TYPE
             			|   isVoids <expr>
             			|   not <expr>
                        |   <expr> + <expr>
                        |   <expr> - <expr>
                        |   <expr> * <expr>
                        |   <expr> / <expr>
                        |   ~ <expr>
                        |   <expr> < <expr>
                        |   <expr> <= <expr>
                        |   <expr> = <expr>
             			|   <comment>
             			|	( <expr> )
                        |   SELF
             			|   ID
             			|   STRING
             			|   TRUE
             			|   FALSE
                        |	INTEGER

<arguments_list_opt>      ::= <arguments_list>
                          |   <empty>

<arguments_list>        ::= <arguments_list_opt>, <expression>
                        |   <expression>
                        
<case>                  ::= case <expression> of <case_actions> esac

<case_action>           ::= ID : TYPE => <expr>

<case_actions>          ::= <case_action>
                        |   <case_action> <case_actions>
			   			
<let_expression>        ::= let <formal_list> in <expression>

<formal_list>           ::= <formal_list>, <formal>
                        |   <formal>

<formal>                ::= ID : TYPE <- <expression>
                        |   ID : TYPE

<while>		 			::= while <expr> loop <expr> pool

<if>		 			::= if <expr> then <expr> else <expr> fi

<block_expr> 			::= { <block_list> }

<block_list> 			::= <block_list> <expr> ;
             			|   <expr> ;
             			
<empty>      			::=
```

#### Lexer
Para la implementación del lexer, definimos una lista de tokens, que define todos los posibles nombres que pueden tomar los tokens. Esta lista tambien es usada más adelante para identificar los terminales. Cada token esta especificado por una expresion regular compatible con el módulo **re** de Python. Ejemplo:
```python
tokens = (
   'NUMBER',
   'PLUS',
)
# El nombre que le sigue a t_ debe machear exactamente con el del token correspondiente
t_PLUS = 'r\+'

def t_NUMBER(t):
         r'\d+'
         t.value = int(t.value)    
         return t
```

#### Parser
Para la implementación del parser, hacemos uso de **ast.py**. Cada regla de la grámatica la definimos en Python, donde el docstring de la función contiene la especificación de la grámatica libre de contexto correspondiente. Ejemplo:
```python
# Ejemplo de uso
def p_class(self, parse):
        """
        class : CLASS TYPE LBRACE features_list_opt RBRACE
        """
        parse[0] = AST.Class(name=parse[2], parent="Object", features=parse[4])
```

### Ánalisis Semántico
Para entender nuestro análisis es importante analizar consideraciones que tuvimos, los métodos que devuelven como tipo SELF_TYPE en su body solo puden devolver SELF_TYPE. Invalidamos la herencia ciclica. Implementamos las reglas semánticas que aparecian en el manual de cool. Checkeamos los tipos en cada expresión, la herencia de Bool, Int y String no esta permitida.

### Generación de Código

#### Cool -> Cil
En el CIL resolvemos el renombramiento de variable y label, las tablas virtuales de los tipos y los constructores. Nos apoyamos en el Cil del libro de compilacion de Piad y definimos nuestro propia IL. A los tipos basicos [Int, Boolean, String] se les hace una copia del objeto al ser pasados como parametros.

#### Cil -> Mips
La generación de mips se divide en 3 partes fundamentales:
1. Crear el constructor de la clase Main.
2. **dotCode** donde se encuentran todo el código del programa
3. **dotData** donde se encuentran todas las definiciones de los strings 

Seguimos el siguiente convenio estudiado en **Programacion de Maquina**, cada llamado a funcion(**dispatch**) pusheamos en la pila el `$fp`y `$ra`, luego movemos el `$sp` a `$fp` para simular una pila vacia, y al regresar realizamos la operacion contraria. Dado este convenio para un metodo el `$fp` separa los argumentos y los locales, a la derecha e izquierda respectivamente. A los tipos basicos [Int, String, Boolean] se les hace boxing y unboxing.

## Ejecutando el proyecto

```bash
$ ./coolc.sh <input_file.cl>
```
