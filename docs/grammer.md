## Grammer

**BNF Notation**:

**Gramatica**:

```Coo
<program> 	 			::= <classes>

<classes> 	 			::= <classes><class>; 
			 			|   <class>;
			 			
<class> 	 			::= class TYPE <inherits> { <features_list_opt> };

<inhertits>  			::= inherits sTYPE
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

