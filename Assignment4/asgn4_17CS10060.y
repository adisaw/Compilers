%{
#include <string.h>
#include <stdio.h>
extern int yylex();
void yyerror(char *s);
%}

%union
{
	int intval;	
	float floatval;
  	char *charval;
}

%token IDENTIFIER <charval>STRING_LITERAL <intval>INTEGER_CONSTANT
%token <floatval>FLOATING_CONSTANT <charval>CHARACTER_CONSTANT
%token ACC INC DEC LTE GTE STAR_EQ DIV_EQ MOD_EQ  
%token SIZEOF SHIFT_L SHIFT_R AND EQ NEQ OR
%token PLUS_EQ MINUS_EQ SHIFT_LEQ SHIFT_REQ
%token BIN_AND_EQ BIN_XOR_EQ BIN_OR_EQ
%token EXTERN STATIC AUTO REGISTER 
%token VOID CHAR SHORT INT LONG FLOAT 
%token DOUBLE SIGNED UNSIGNED _BOOL _COMPLEX _IMAGINARY
%token ENUM CONST VOLATILE RESTRICT INLINE DOTS
%token CASE DEFAULT IF SWITCH ELSE
%token DO WHILE FOR GOTO CONTINUE RETURN BREAK
%token RO_BRACKET_OP RO_BRACKET_CL SQ_BRACKET_OP SQ_BRACKET_CL
%token CUR_BRACKET_OP CUR_BRACKET_CL DOT COMMA 
%token AMP MUL ADD SUB NEG EXCLAIMATION DIV MODULO
%token BIT_SHIFT_L BIT_SHIFT_R BITXOR BITOR QUESTION COLON
%token ASSIGN SEMICOLON HASH
%token STRUCT TYPEDEF UNION 

%start translation_unit

%%
primary_expression: IDENTIFIER
					| constant
					| STRING_LITERAL
					| RO_BRACKET_OP expression RO_BRACKET_CL
					{fprintf(stderr,"***RULE : primary_expression \n***");}
					;

constant:  INTEGER_CONSTANT
		|  FLOATING_CONSTANT
		|  CHARACTER_CONSTANT
		;

postfix_expression: primary_expression
					| postfix_expression SQ_BRACKET_OP expression SQ_BRACKET_CL
					| postfix_expression RO_BRACKET_OP argument_expression_list_opt RO_BRACKET_CL
					| postfix_expression DOT IDENTIFIER
					| postfix_expression ACC IDENTIFIER
					| postfix_expression INC
					| postfix_expression DEC
					| RO_BRACKET_OP type_name RO_BRACKET_CL CUR_BRACKET_OP initializer_list CUR_BRACKET_CL
					| RO_BRACKET_OP type_name RO_BRACKET_CL CUR_BRACKET_OP initializer_list COMMA CUR_BRACKET_CL
					{fprintf(stderr,"RULE : postfix_expression \n");}
					;

argument_expression_list_opt: argument_expression_list
						| %empty
						{fprintf(stderr,"RULE : argument_expression_list_opt \n");}
						;

argument_expression_list: assignment_expression
						| argument_expression_list COMMA assignment_expression
						{fprintf(stderr,"RULE : argument_expression_list \n");}
						;

unary_expression: postfix_expression
				| INC unary_expression
				| DEC unary_expression
				| unary_operator cast_expression
				| SIZEOF unary_expression
				| SIZEOF RO_BRACKET_OP type_name RO_BRACKET_CL
				{fprintf(stderr,"RULE : unary_expression \n");}
				;

unary_operator: AMP
				| MUL
				| ADD
				| SUB
				| NEG
				| EXCLAIMATION
				{fprintf(stderr,"RULE : unary_operator \n");}
				;

cast_expression: unary_expression
				| RO_BRACKET_OP type_name RO_BRACKET_CL cast_expression
				{fprintf(stderr,"RULE : cast_expression \n");}
				;

multiplicative_expression: cast_expression
						| multiplicative_expression MUL cast_expression
						| multiplicative_expression DIV cast_expression
						| multiplicative_expression MODULO cast_expression 
						{fprintf(stderr,"RULE : multiplicative_expression \n");}
						;

additive_expression: multiplicative_expression
					| additive_expression ADD multiplicative_expression
					| additive_expression SUB multiplicative_expression
					{fprintf(stderr,"RULE : additive_expression \n");}
					;

shift_expression: additive_expression 
				| shift_expression SHIFT_L additive_expression
				| shift_expression SHIFT_R additive_expression
				{fprintf(stderr,"RULE : shift_expression \n");}
				;

relational_expression: shift_expression
					| relational_expression BIT_SHIFT_L shift_expression
					| relational_expression BIT_SHIFT_R shift_expression
					| relational_expression LTE shift_expression
					| relational_expression GTE shift_expression
					{fprintf(stderr,"RULE : relational_expression \n");}
					;

equality_expression : relational_expression
					| equality_expression EQ relational_expression
					| equality_expression NEQ relational_expression
					{fprintf(stderr,"RULE : equality_expression \n");}
					;

AND_expression : equality_expression
				| AND_expression AMP equality_expression
				{fprintf(stderr,"RULE : AND_expression \n");}
				;

exclusive_OR_expression : AND_expression
						| exclusive_OR_expression BITXOR AND_expression
						{fprintf(stderr,"exclusive_OR_expression \n");}
						;

inclusive_OR_expression : exclusive_OR_expression
						| inclusive_OR_expression BITOR exclusive_OR_expression
						{fprintf(stderr,"RULE : inclusive_OR_expression \n");}
						;

logical_AND_expression : inclusive_OR_expression
						| logical_AND_expression AND inclusive_OR_expression
						{fprintf(stderr,"RULE : logical_AND_expression \n");}
						;

logical_OR_expression :logical_AND_expression
						| logical_OR_expression OR logical_AND_expression
						{fprintf(stderr,"RULE : logical_OR_expression \n");}
						;

conditional_expression: logical_OR_expression
						| logical_OR_expression QUESTION expression COLON conditional_expression
						{fprintf(stderr,"RULE : conditional_expression \n");}
						;

assignment_expression : conditional_expression
						| unary_expression assignment_operator assignment_expression
						{fprintf(stderr,"RULE : assignment_expression \n");}
						;

assignment_operator: ASSIGN
					| STAR_EQ
					| DIV_EQ
					| MOD_EQ
					| PLUS_EQ
					| MINUS_EQ
					| SHIFT_LEQ
					| SHIFT_REQ
					| BIN_AND_EQ
					| BIN_XOR_EQ
					| BIN_OR_EQ
					{fprintf(stderr,"RULE : assignment_operator \n");}
					;

expression: assignment_expression
			| expression COMMA assignment_expression
			{fprintf(stderr,"RULE : expression \n");}
			;

constant_expression: conditional_expression
					{fprintf(stderr,"RULE : constant_expression \n");}
					;

declaration: declaration_specifiers  init_declarator_list_opt SEMICOLON
			{fprintf(stderr,"RULE : declaration \n");}
			;

init_declarator_list_opt: init_declarator_list
						| %empty
						{fprintf(stderr,"RULE : init_declarator_list_opt \n");}
						;

declaration_specifiers: storage_class_specifier declaration_specifiers_opt
					  | type_specifier declaration_specifiers_opt
					  | type_qualifier declaration_specifiers_opt
					  | function_specifier declaration_specifiers_opt
					  {fprintf(stderr,"RULE : declaration_specifiers \n");}
					  ;

declaration_specifiers_opt: declaration_specifiers
						   | %empty
						   {fprintf(stderr,"RULE : declaration_specifiers_opt \n");} 
						   ;

init_declarator_list : init_declarator
					 | init_declarator_list COMMA init_declarator
					 {fprintf(stderr,"RULE : init_declarator_list \n");}
					 ;

init_declarator: declarator
				| declarator ASSIGN initializer
				{fprintf(stderr,"RULE : init_declarator \n");}
				;

storage_class_specifier: EXTERN
						| STATIC
						| AUTO
						| REGISTER
						{fprintf(stderr,"RULE : storage_class_specifier \n");}
						;

type_specifier: VOID 
				| CHAR
				| SHORT
				| INT
				| LONG 
				| FLOAT
				| DOUBLE 
				| SIGNED 
				| UNSIGNED 
				| _BOOL
				| _COMPLEX
				| _IMAGINARY
				| enum_specifier
				{fprintf(stderr,"RULE : type_specifier \n");}
				;

specifier_qualifier_list: type_specifier specifier_qualifier_list_opt
						| type_qualifier specifier_qualifier_list_opt
						{fprintf(stderr,"RULE : specifier_qualifier_list \n");}
						;

specifier_qualifier_list_opt: specifier_qualifier_list
							| %empty
							{fprintf(stderr,"RULE : specifier_qualifier_list_opt \n");}
							;

enum_specifier : ENUM  CUR_BRACKET_OP enumerator_list CUR_BRACKET_CL
				| 	ENUM IDENTIFIER CUR_BRACKET_OP enumerator_list CUR_BRACKET_CL
				|   ENUM CUR_BRACKET_OP enumerator_list COMMA CUR_BRACKET_CL
				|   ENUM  IDENTIFIER CUR_BRACKET_OP enumerator_list COMMA CUR_BRACKET_CL
				|   ENUM IDENTIFIER
				{fprintf(stderr,"RULE : enum_specifier \n");}
				;

enumerator_list: enumerator
				| enumerator_list COMMA enumerator
				{fprintf(stderr,"RULE : enumerator_list \n");}
				;

enumerator : IDENTIFIER
			| IDENTIFIER ASSIGN constant_expression
			{fprintf(stderr,"RULE : enumerator \n");}
			;

type_qualifier: CONST 
				| VOLATILE
				| RESTRICT
				{fprintf(stderr,"RULE : type_qualifier \n");}
				;

function_specifier: INLINE
				{fprintf(stderr,"RULE : function_specifier \n");}
				;

declarator: pointer direct_declarator
			| direct_declarator
			{fprintf(stderr,"RULE : declarator \n");}
			;

direct_declarator: IDENTIFIER
				| RO_BRACKET_OP declarator RO_BRACKET_CL
				|  direct_declarator SQ_BRACKET_OP type_qualifier_list_opt assignment_expression_opt SQ_BRACKET_CL
				|  direct_declarator SQ_BRACKET_OP STATIC type_qualifier_list_opt assignment_expression SQ_BRACKET_CL
				|  direct_declarator SQ_BRACKET_OP type_qualifier_list STATIC assignment_expression SQ_BRACKET_CL
				|  direct_declarator SQ_BRACKET_OP type_qualifier_list_opt MUL SQ_BRACKET_CL
				|  direct_declarator RO_BRACKET_OP parameter_type_list RO_BRACKET_CL
				|  direct_declarator  RO_BRACKET_OP identifier_list_opt RO_BRACKET_CL
				{fprintf(stderr,"RULE : direct_declarator \n");}
				;

type_qualifier_list_opt: type_qualifier_list
						| %empty
						{fprintf(stderr,"RULE : type_qualifier_list_opt \n");}
						;

assignment_expression_opt: assignment_expression 
						| %empty
						{fprintf(stderr,"RULE : assignment_expression_opt\n");}
						;

identifier_list_opt: identifier_list
					| %empty
					{fprintf(stderr,"RULE : identifier_list_opt \n");}
					;

pointer: MUL type_qualifier_list_opt
		| MUL type_qualifier_list_opt pointer
		{fprintf(stderr,"RULE : pointer \n");}
		;

type_qualifier_list: type_qualifier
				|  type_qualifier_list type_qualifier
				{fprintf(stderr,"RULE : type_qualifier_list \n");}
				;

parameter_type_list: parameter_list 
					| parameter_list COMMA DOTS
					{fprintf(stderr,"RULE : parameter_type_list \n");}
					;

parameter_list : parameter_declaration
				| parameter_list COMMA parameter_declaration
				{fprintf(stderr,"RULE : parameter_list \n");}
				;

parameter_declaration: declaration_specifiers declarator
					| declaration_specifiers
					{fprintf(stderr,"RULE : parameter_declaration \n");}
					;

identifier_list: IDENTIFIER
				| identifier_list COMMA IDENTIFIER
				{fprintf(stderr,"RULE : identifier_list \n");}

type_name: specifier_qualifier_list
			{fprintf(stderr,"RULE : type_name \n");}
			;

initializer : assignment_expression
			 | CUR_BRACKET_OP initializer_list CUR_BRACKET_CL
			 | CUR_BRACKET_OP initializer_list COMMA CUR_BRACKET_CL
			 {fprintf(stderr,"RULE : initializer \n");}
			 ;


initializer_list: designation_opt initializer
				| initializer_list COMMA designation_opt initializer
				{fprintf(stderr,"RULE : initializer_list \n");}
				;

designation_opt : designation
				| %empty
				{fprintf(stderr,"RULE : designation_opt \n");}
				;

designation: designator_list ASSIGN
			{fprintf(stderr,"RULE : designation \n");}
			;

designator_list : designator
				| designator_list designator
				{fprintf(stderr,"RULE : designator_list \n");}
				;

designator : SQ_BRACKET_OP constant_expression SQ_BRACKET_CL
			| DOT IDENTIFIER
			{fprintf(stderr,"RULE : designator \n");}
			;

statement: labeled_statement
		  | compound_statement
		  | expression_statement
		  | selection_statement
		  | iteration_statement
		  | jump_statement
		  {fprintf(stderr,"RULE : statement \n");}
		  ;

labeled_statement: IDENTIFIER COLON statement
				| CASE constant_expression COLON statement
				| DEFAULT COLON statement
				{fprintf(stderr,"RULE : labeled_statement \n");}
				;

compound_statement: CUR_BRACKET_OP block_item_list_opt CUR_BRACKET_CL
					{fprintf(stderr,"RULE : compound_statement \n");}
					;

block_item_list_opt : block_item_list
					| %empty
					{fprintf(stderr,"RULE : block_item_list_opt \n");}
					;

block_item_list: block_item
				| block_item_list block_item
				{fprintf(stderr,"RULE : block_item_list \n");}
				;

block_item: declaration
			| statement
			{fprintf(stderr,"RULE : block_item \n");}
			;

expression_statement: expression_opt SEMICOLON
					{fprintf(stderr,"RULE : expression_statement \n");}
					;

expression_opt: expression
				| %empty
				{fprintf(stderr,"RULE : expression_opt \n");}
				;

selection_statement: IF RO_BRACKET_OP expression RO_BRACKET_CL statement
					| IF RO_BRACKET_OP expression RO_BRACKET_CL statement ELSE statement
					| SWITCH RO_BRACKET_OP expression RO_BRACKET_CL statement
					{fprintf(stderr,"RULE : selection_statement \n");}
					;

iteration_statement: WHILE RO_BRACKET_OP expression RO_BRACKET_CL statement
					| DO statement WHILE RO_BRACKET_OP expression RO_BRACKET_CL SEMICOLON
					| FOR RO_BRACKET_OP expression_opt SEMICOLON expression_opt SEMICOLON expression_opt RO_BRACKET_CL statement
					| FOR RO_BRACKET_OP declaration expression_opt SEMICOLON expression_opt RO_BRACKET_CL statement
					{fprintf(stderr,"RULE : iteration_statement \n");}
					;

jump_statement: GOTO IDENTIFIER SEMICOLON
			  | CONTINUE SEMICOLON
			  | BREAK SEMICOLON
			  | RETURN expression_opt SEMICOLON
			  {fprintf(stderr,"RULE : jump_statement \n");}
			  ;

translation_unit: external_declaration
				| translation_unit external_declaration
				{fprintf(stderr,"RULE : translation_unit \n");}
				;

external_declaration: function_definition
					| declaration
					{fprintf(stderr,"RULE : external_declaration \n");}
					;

function_definition: declaration_specifiers declarator declaration_list_opt compound_statement
					{fprintf(stderr,"RULE : function_definition \n");}
					;

declaration_list_opt: declaration_list
					| %empty
					{fprintf(stderr,"RULE : declaration_list_opt \n");}
					;

declaration_list: declaration
				| declaration_list declaration
				{fprintf(stderr,"RULE : declaration_list \n");}
				;
%%
void yyerror(char *s)
{
	fprintf(stderr,"RULE : ERROR: %s \n",s);
}















				








