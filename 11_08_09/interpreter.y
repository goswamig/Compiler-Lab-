%{	
	#include <stdio.h>
	#include <string.h>
	#include <math.h>
	#include "SymbTab.h"
	#include "globals.h"
	int yylex();
	void yyerror( char* );
	int flag = 0;	
%}

%union
{
	SymbolTable* tptr;
	int val;
}

%token <val>  NUM
%token <tptr> VAR
/*%type  <val>  expr*/

/*Type int*/
%token T_INT		

/*Type bool*/
%token T_BOOL

%token READ
%token WRITE
%token DECL
%token ENDDECL


%right '='
%left  '+' '-'
%left  '*' '/'
%left  NEG		/*	Unary minus	*/
%right '^'

%%

	input:
		|	decl_sec	{printf("Hello");}/* stmt_list	
		;
	stmt_list:
		|	statement stmt_list '\n'
		|	error '\n' 			{ yyerrok ; }
		;
	statement:	assign_stmt 
		|	read_stmt 
		|	write_stmt 
		|	';'
		;

	read_stmt:	READ '(' VAR ')' ';'	{	
							if( $3->type == INT_VAR )
								scanf("%d", & ($3->value.ivar));
							else if( $3->type == BOOL_VAR )
								scanf("%d", (int*) ($3->value.bvar));
							else
								yyerror("Variable undeclared");
						}
		;

	write_stmt:	WRITE '(' expr ')' ';'	{	printf("%d", $3);	}
		;

	assign_stmt:
		|	VAR '=' expr ';'	{ /*Perform type checking/ $1->value.ivar = $3; }
		;

	expr: 		NUM 			{ $$ = $1;		}
		|	VAR			{ $$ = $1->value.ivar; 	}
		|	expr '+' expr 		{ $$ = $1 + $3; 	}
		|	expr '-' expr	 	{ $$ = $1 - $3; 	}
		|	expr '*' expr 		{ $$ = $1 * $3; 	}
		|	expr '/' expr 		{ $$ = $1 / $3; 	}
		/*|	expr '^' expr		{ $$ = pow($1, $3);	}/
		|	'-' expr %prec NEG 	{ $$ = -$2 ; 		}
		|	'(' expr ')' 		{ $$ = $2; 		}
		;
*/
	decl_sec:	DECL decl_list ENDDECL 		{printf("Hello");}
		;
	decl_list:	decl
		|	decl decl_list
		;
	decl:		type idlist ';'
		;
	type:		T_INT			{ flag = 1; }
		|	T_BOOL			{ flag = 0; /* If anything else' unknown type' error */}
		;
	idlist:		id			
		|	id ',' idlist
		;
	id:		VAR			{ 
							if( flag ) 
								$1->type = INT_VAR;
							else
								$1->type = BOOL_VAR;
						}
						  
		;
	
%%

void yyerror(char* err)
{
	printf("%s at line number: %d\n", err, lineno);
}


int main()
{
	lineno = 0;	
	yyparse();
	return 0;
}
