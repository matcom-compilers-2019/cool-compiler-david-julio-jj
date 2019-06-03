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

<feature>               ::= ID ( <parameters_list> ) : TYPE { <expression> }
                        |   <feature_parameter>
			 			
<params_list>			::= <parameters_list>, <parameter>
			 			| 	<parameter>
			 			| 	<empty>
			 			
<parameter>	 			::= ID : TYPE

<feature_parameter> 	::= ID : TYPE <- <expr>
			 			|   ID : TYPE
			 			
<expr> 		 			::= ID <- <expr>
             			|   <expr>.ID( <arguments_list> )
             			|   <expr>@TYPE.ID( <arguments_list> )
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

<arguments_list>        ::= <arguments_list_opt>, <expression>
                        |   <expression>
                        |   <empty>
                        
<case> 		 			::= case <expr> of <case_actions> esac

<case_actions> 			::= <case_actions>; ID : TYPE => <expr> 
			   			|   ID : TYPE => <expr>;
			   			
<let> 		 			::= let <nested_let_params> in <expr>

<nested_let_params>		::= <nested_let_params>, <feature_parameter>
						| 	<feature_parameter>

<while>		 			::= while <expr> loop <expr> pool

<if>		 			::= if <expr> then <expr> else <expr> fi

<block_expr> 			::= { <block_list> }

<block_list> 			::= <block_list> <expr> ;
             			|   <expr> ;
             			
<empty>      			::=

<comment>	 			::=
```

