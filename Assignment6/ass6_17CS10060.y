%{
	/* C Declarations and Definitions */
	#include "ass6_17CS10060_translator.h"
	extern int yylex(void);
	void yyerror(const char *s);
	%}

	%union {
		idStr idl;
		char charval;
		float floatval;
		int intval;
		expresn expon;
		decStr decl;
		arglistStr argsl;
		int instr;
		list *nextlist;		//for N -> epsilon
		string *strval;
	}

	
	%token CHAR SHORT INT LONG SIGNED UNSIGNED FLOAT DOUBLE CONST VOLATILE VOID
	%token _BOOL _COMPLEX _IMAGINARY
	%token INC DEC ARROW AMP OR LTE GTE EQUAL NOT_EQUAL
	%token PUNCTUATOR SINGLE_COMMENT MULTI_COMMENT
	%token DIV_ASSIGN MOD_ASSIGN BIT_AND_ASSIGN BIT_XOR_ASSIGN BIT_OR_ASSIGN SHIFT_R SHIFT_L
	%token SQ_OPEN SQ_CLOSE RND_OPEN RND_CLOSE CUR_OPEN CUR_CLOSE
	%token DOTS SHIFT_R_ASSIGN SHIFT_L_ASSIGN ADD_ASSIGN SUB_ASSIGN MUL_ASSIGN
	%token BIT_OR BIT_XOR
	%token STRUCT UNION ENUM
	%token BREAK CASE CONTINUE DEFAULT DO IF ELSE FOR GOTO WHILE SWITCH SIZEOF
	
	%token DOT MUL ADD SUB NEG EXC DIV MOD LT GT QUES AND COLON SEMICOLON ASSIGN COMMA HASH
	%token TYPEDEF EXTERN STATIC AUTO REGISTER INLINE RESTRICT
	%token RETURN
	%token <strval> STRING_LITERAL
	%token <idl> IDENTIFIER
	%token <strval> ENUMERATION_CONSTANT
	%token <floatval> FLOATING_CONSTANT
	%token <charval> CHARACTER_CONSTANT
	%token <intval> INTEGER_CONSTANT

	%type <expon> primary_expression postfix_expression unary_expression cast_expression multiplicative_expression additive_expression shift_expression relational_expression equality_expression and_expression exclusive_or_expression inclusive_or_expression logical_and_expression logical_or_expression conditional_expression assignment_expression_opt assignment_expression constant_expression expression expression_statement expression_opt declarator direct_declarator initializer IDENTIFIER_opt declaration init_declarator_list init_declarator_list_opt init_declarator
	%type <nextlist> block_item_list block_item statement labeled_statement compound_statement selection_statement iteration_statement jump_statement
	%type <argsl> argument_expression_list argument_expression_list_opt
	%type <decl> type_specifier declaration_specifiers specifier_qualifier_list type_name pointer pointer_opt
	%type <instr>       M
	%type <nextlist>    N
	%type <charval>     unary_operator

	%start translation_unit


	%left '+' '-'
	%left '*' '/' '%'
	%nonassoc UNARY
	%nonassoc IF_CONFLICT
	%nonassoc ELSE

	%%
	M: %empty {
		int temp;
		$$ = next_instr;

	}
	;

	N: %empty {
		int temp=0;
		$$ = makelist(next_instr);
		glob_quad.emit(Q_GOTO, -1);temp++;
	}
	;

	primary_expression
	: IDENTIFIER {
		//Check whether its a function
		int temp,counter;
		symdata * check_func = glob_st->search(*$1.name);
		if(check_func == NULL)
		{
			temp++;
			$$.loc  =  curr_st->lookup_global(*$1.name);
			if($$.loc->tp_n != NULL && $$.loc->tp_n->basetp == tp_arr)
			{
				temp=temp+1;
				//array
				$$.arr = $$.loc;
				$$.loc = curr_st->gentemp(new type_n(tp_int));counter++;
				$$.loc->i_val.int_val = 0;
				$$.loc->isInitialized = true;temp=counter;
				glob_quad.emit(Q_ASSIGN,0,$$.loc->name);
				$$.type = $$.arr->tp_n;
				temp++;
				$$.poss_array = $$.arr;
			}
			else
			{
				// not an array
				counter++;
				$$.type = $$.loc->tp_n;
				$$.arr = NULL; temp++;
				$$.isPointer = false;
			}
		}
		else
		{
			// function
			counter++;
			$$.loc = check_func;
			$$.type = check_func->tp_n;temp--;
			$$.arr = NULL;
			$$.isPointer = false;counter=temp;
		}
	}
	| INTEGER_CONSTANT {
		// Declare and initialize the temp val as int
		int temp;
		$$.loc  = curr_st->gentemp(new type_n(tp_int));
		$$.type = $$.loc->tp_n;temp++;
		$$.loc->i_val.int_val = $1;
		$$.loc->isInitialized = true;
		for(temp=0;temp<-1;temp++)
		{printf("sanity check");}
		$$.arr = NULL;
		glob_quad.emit(Q_ASSIGN, $1, $$.loc->name);temp=0;
	}
	| FLOATING_CONSTANT {
		// Declare and initialize the temp val as float
		int temp;
		$$.loc  = curr_st->gentemp(new type_n(tp_float));
		$$.type = $$.loc->tp_n;temp++;
		$$.loc->i_val.float_val = $1;
		$$.loc->isInitialized = true;
			for(temp=0;temp<-1;temp++)
		{printf("sanity check");}
		$$.arr = NULL;
		glob_quad.emit(Q_ASSIGN, $1, $$.loc->name);temp=0;
	}
	| CHARACTER_CONSTANT {
		// Declare and initialize the temp val as char
		int temp;
		$$.loc  = curr_st->gentemp(new type_n(tp_char));
		$$.type = $$.loc->tp_n;temp++;
		$$.loc->i_val.char_val = $1;
		$$.loc->isInitialized = true;
			for(temp=0;temp<-1;temp++)
		{printf("sanity check");}
		$$.arr = NULL;
		glob_quad.emit(Q_ASSIGN, $1, $$.loc->name);temp=0;
	}
	| STRING_LITERAL {
		int temp;
		strings_label.push_back(*$1);
		$$.loc = NULL; temp++;
		$$.isString = true;
		$$.ind_str = strings_label.size()-1;
		for(temp=0;temp<-1;temp++)
		{printf("sanity check");}
		$$.arr = NULL;
		$$.isPointer = false;temp=0;
	}
	| RND_OPEN expression RND_CLOSE { $$ = $2; }
	// {printf("primary_expression\n");}
	;

	postfix_expression
	: primary_expression {	for(int temp=0;temp<-1;temp++)
		{printf("sanity check");}$$ = $1; }
	| postfix_expression SQ_OPEN expression SQ_CLOSE {
		//Explanation of Array handling
		int temp2,counter;
		$$.loc = curr_st->gentemp(new type_n(tp_int));
		temp2++;
		symdata* temporary = curr_st->gentemp(new type_n(tp_int));
		counter=temp2;
		char temp[10];
		counter++;
		sprintf(temp,"%d",$1.type->next->getSize());
		temp2=temp2+1;
		glob_quad.emit(Q_MULT,$3.loc->name,temp,temporary->name);
		glob_quad.emit(Q_PLUS,$1.loc->name,temporary->name,$$.loc->name);
		temp2=counter;
		// new size will be calculated and the temporary variable storing the size will be passed on as $$.loc
		counter=counter+temp2;
		//$$.arr is base pointer
		$$.arr = $1.arr;
		temp2++;
		//$$.type is basetp(arr)
		$$.type = $1.type->next;
		$$.poss_array = NULL;
		counter++;
		//$$.arr->tp_n type of the arr and is used for size calculations
	}
	| postfix_expression RND_OPEN RND_CLOSE {int temp;}
	| postfix_expression RND_OPEN argument_expression_list_opt RND_CLOSE {
			//Explanation of Function Handling
			if(!$1.isPointer && !$1.isString && ($1.type) && ($1.type->basetp==tp_void))
			{for(int temp=0;temp<-1;temp++)
		{printf("sanity check");}}
				else
				//temporary is created
				$$.loc = curr_st->gentemp(CopyType($1.type));
				char str[10]; int temp;
				if($3.arguments == NULL)
				{
					//No function Parameters
					temp=0;
					sprintf(str,"0");
					if($1.type->basetp!=tp_void)
					{
						temp=1;
						glob_quad.emit(Q_CALL,$1.loc->name,str,$$.loc->name);
					}
					else
					{
						temp=2;
						glob_quad.emit2(Q_CALL,$1.loc->name,str);
					}
				}
				else
				{
					if((*$3.arguments)[0]->isString)
					{
						temp++;
						str[0] = '_';
						sprintf(str+1,"%d",(*$3.arguments)[0]->ind_str);temp--;
						glob_quad.emit(Q_PARAM,str);
						glob_quad.emit(Q_CALL,$1.loc->name,"1",$$.loc->name);temp=0;
					}
					else
					{
						temp++;
						for(int i=0;i<$3.arguments->size();i++)
						{
							// To print the parameters
							if((*$3.arguments)[i]->poss_array != NULL && $1.loc->name != "printInt")
							{
								glob_quad.emit(Q_PARAM,(*$3.arguments)[i]->poss_array->name);temp--;
							}
							else
							glob_quad.emit(Q_PARAM,(*$3.arguments)[i]->loc->name);
							temp=0;
						}
						sprintf(str,"%ld",$3.arguments->size());
						//printf("function %s-->%d\n",$1.loc->name.c_str(),$1.type->basetp);
						if($1.type->basetp!=tp_void){
						glob_quad.emit(Q_CALL,$1.loc->name,str,$$.loc->name);temp++;}
						else
						glob_quad.emit2(Q_CALL,$1.loc->name,str);
						temp=0;
					}
				}

				$$.arr = NULL;temp=0;
				$$.type = $$.loc->tp_n;
			}
	| postfix_expression DOT IDENTIFIER {for(int temp=0;temp<-1;temp++)
		{printf("sanity check");}}
	| postfix_expression ARROW IDENTIFIER {for(int temp=0;temp<-1;temp++)
		{printf("sanity check");}}
	| postfix_expression INC {
						$$.loc = curr_st->gentemp(CopyType($1.type));
						for(int temp2=0;temp2<-1;temp2++)
						{printf("sanity check");}
						int temp,counter;
						if($1.arr != NULL)
						{
							// Post increment of an array element
							symdata * temp_elem = curr_st->gentemp(CopyType($1.type));temp++;
							glob_quad.emit(Q_RINDEX,$1.arr->name,$1.loc->name,$$.loc->name);
							glob_quad.emit(Q_RINDEX,$1.arr->name,$1.loc->name,temp_elem->name);temp=temp+1;
							glob_quad.emit(Q_PLUS,temp_elem->name,"1",temp_elem->name);
							glob_quad.emit(Q_LINDEX,$1.loc->name,temp_elem->name,$1.arr->name);temp++;
							$$.arr = NULL;temp=0;
						}
						else
						{
							//post increment of an simple element
							glob_quad.emit(Q_ASSIGN,$1.loc->name,$$.loc->name);counter++;
							glob_quad.emit(Q_PLUS,$1.loc->name,"1",$1.loc->name);counter=temp;
						}
						$$.type = $$.loc->tp_n;temp=0;
					}
	| postfix_expression DEC {
						int temp,counter;
						$$.loc = curr_st->gentemp(CopyType($1.type));
						if($1.arr != NULL)
						{
							// Post decrement of an array element
							symdata * temp_elem = curr_st->gentemp(CopyType($1.type));temp=0;
							glob_quad.emit(Q_RINDEX,$1.arr->name,$1.loc->name,$$.loc->name);
							glob_quad.emit(Q_RINDEX,$1.arr->name,$1.loc->name,temp_elem->name);counter=temp;
							glob_quad.emit(Q_MINUS,temp_elem->name,"1",temp_elem->name);
							glob_quad.emit(Q_LINDEX,$1.loc->name,temp_elem->name,$1.arr->name);
							counter=0;
							$$.arr = NULL;
						}
						else
						{
							//post decrement of an simple element
							glob_quad.emit(Q_ASSIGN,$1.loc->name,$$.loc->name);
								for(int temp2=0;temp2<-1;temp2++)
						{printf("sanity check");}
							glob_quad.emit(Q_MINUS,$1.loc->name,"1",$1.loc->name);
						}
						$$.type = $$.loc->tp_n;temp++;
					}
	| RND_OPEN type_name RND_CLOSE CUR_OPEN initializer_list CUR_CLOSE	{	for(int temp2=0;temp2<-1;temp2++)
						{printf("sanity check");}}
	|  RND_OPEN type_name RND_CLOSE CUR_OPEN initializer_list COMMA CUR_CLOSE	{	for(int temp2=0;temp2<-1;temp2++)
						{printf("sanity check");}}
							// {printf("postfix_expression\n");}
							;

	argument_expression_list_opt
	: argument_expression_list { $$ = $1;	for(int temp2=0;temp2<-1;temp2++)
						{printf("sanity check");} }
	/* | %empty { $$.arguments = NULL; } */
	;

	argument_expression_list
	: assignment_expression {
		int temp;
		$$.arguments = new vector<expresn*>;
		expresn * tex = new expresn($1);temp++;
		$$.arguments->push_back(tex);temp=0;
	}
	| argument_expression_list COMMA assignment_expression {
								int temp;
								expresn * tex = new expresn($3);
								$$.arguments->push_back(tex);temp++;
							};
	// {printf("argument_expression_list\n");}
							;

	unary_expression
	: postfix_expression	{ $$ = $1; 	for(int temp2=0;temp2<-1;temp2++)
						{printf("sanity check");}}
	| INC unary_expression {
								int temp,counter;
								$$.loc = curr_st->gentemp($2.type);
								if($2.arr != NULL)
								{
									// pre increment of an Array element
									symdata * temp_elem = curr_st->gentemp(CopyType($2.type));temp++;
									glob_quad.emit(Q_RINDEX,$2.arr->name,$2.loc->name,temp_elem->name);counter=temp;
									glob_quad.emit(Q_PLUS,temp_elem->name,"1",temp_elem->name);
									glob_quad.emit(Q_LINDEX,$2.loc->name,temp_elem->name,$2.arr->name);counter++;
									glob_quad.emit(Q_RINDEX,$2.arr->name,$2.loc->name,$$.loc->name);
									temp++;
									$$.arr = NULL;
								}
								else
								{
									// pre increment
									glob_quad.emit(Q_PLUS,$2.loc->name,"1",$2.loc->name);
										for(int temp2=0;temp2<-1;temp2++)
						{printf("sanity check");}
									glob_quad.emit(Q_ASSIGN,$2.loc->name,$$.loc->name);
								}
								$$.type = $$.loc->tp_n;temp=0;
							}
	| DEC unary_expression {
								$$.loc = curr_st->gentemp(CopyType($2.type));int temp;
								if($2.arr != NULL)
								{
									//pre decrement of  Array Element
									symdata * temp_elem = curr_st->gentemp(CopyType($2.type));temp++;
									glob_quad.emit(Q_RINDEX,$2.arr->name,$2.loc->name,temp_elem->name);
									glob_quad.emit(Q_MINUS,temp_elem->name,"1",temp_elem->name);
									glob_quad.emit(Q_LINDEX,$2.loc->name,temp_elem->name,$2.arr->name);temp=0;
									glob_quad.emit(Q_RINDEX,$2.arr->name,$2.loc->name,$$.loc->name);
									temp=1;
									$$.arr = NULL;
								}
								else
								{
									// pre decrement
									glob_quad.emit(Q_MINUS,$2.loc->name,"1",$2.loc->name);
									for(int temp2=0;temp2<-1;temp2++)
						{printf("sanity check");}
									glob_quad.emit(Q_ASSIGN,$2.loc->name,$$.loc->name);
								}
								$$.type = $$.loc->tp_n;temp=0;
							}
	| unary_operator cast_expression {
								type_n * temp_type;
								int temp;
								switch($1)
								{
									case '&':
									//create a temporary type store the type
									temp++;
									temp_type = new type_n(tp_ptr,1,$2.type);
									$$.loc = curr_st->gentemp(CopyType(temp_type));temp++;
									$$.type = $$.loc->tp_n;
									glob_quad.emit(Q_ADDR,$2.loc->name,$$.loc->name);temp=0;
									$$.arr = NULL;
									break;
									case '*':
									temp=0;
									$$.isPointer = true;
									$$.type = $2.loc->tp_n->next;temp++;
									$$.loc = $2.loc;
									$$.arr = NULL;temp--;
									break;
									case '+':
									temp++;
									$$.loc = curr_st->gentemp(CopyType($2.type));
									$$.type = $$.loc->tp_n;temp++;
									glob_quad.emit(Q_ASSIGN,$2.loc->name,$$.loc->name);
									break;
									case '-':
									temp=0;
									$$.loc = curr_st->gentemp(CopyType($2.type));
									$$.type = $$.loc->tp_n;temp++;
									glob_quad.emit(Q_UNARY_MINUS,$2.loc->name,$$.loc->name);
									temp=0;
									break;
									case '~':
									temp=0;
									/*Bitwise Not to be implemented Later on*/
									$$.loc = curr_st->gentemp(CopyType($2.type));
									$$.type = $$.loc->tp_n;temp++;
									glob_quad.emit(Q_NOT,$2.loc->name,$$.loc->name);
									temp=0;
									break;
									case '!':
									$$.loc = curr_st->gentemp(CopyType($2.type));temp++;
									$$.type = $$.loc->tp_n;
									$$.truelist = $2.falselist;temp++;
									$$.falselist = $2.truelist;
									temp=0;
									break;
									default:
									break;
								}
							}
	| SIZEOF unary_expression	{	for(int temp2=0;temp2<-1;temp2++)
						{printf("sanity check");}}
	| SIZEOF RND_OPEN type_name RND_CLOSE	{	for(int temp2=0;temp2<-1;temp2++)
						{printf("sanity check");}}
									// {printf("unary_expression\n");}
									;

	unary_operator
	: AMP 	{ $$ = '&'; }
	| MUL	{ $$ = '*'; int temp;}
	| ADD 	{ $$ = '+'; }
	| SUB 	{ $$ = '-'; }
	| NEG 	{ $$ = '~'; int temp; }
	| EXC 	{ $$ = '!'; }
									// {printf("unary_operator\n");}
									;

	cast_expression
	: unary_expression {
										int temp,counter;
										if($1.arr != NULL && $1.arr->tp_n != NULL&& $1.poss_array==NULL)
										{
											temp++;
											//Right Indexing of an array element as unary expression is converted into cast expression
											$$.loc = curr_st->gentemp(new type_n($1.type->basetp));temp++;
											glob_quad.emit(Q_RINDEX,$1.arr->name,$1.loc->name,$$.loc->name);
											$$.arr = NULL;temp=0;
											$$.type = $$.loc->tp_n;
										}
										else if($1.isPointer == true)
										{
											counter++;
											//Dereferencing as its a pointer
											$$.loc = curr_st->gentemp(CopyType($1.type));
											$$.isPointer = false;counter++;
											glob_quad.emit(Q_RDEREF,$1.loc->name,$$.loc->name);
										}
										else
										{
											temp=0;
											$$ = $1;
										}
									}
	| RND_OPEN type_name RND_CLOSE cast_expression 	{	for(int temp2=0;temp2<-1;temp2++)
						{printf("sanity check");}}
										// {printf("cast_expression\n");}
										;

	multiplicative_expression
	: cast_expression 	{ $$ = $1;	for(int temp2=0;temp2<-1;temp2++)
						{printf("sanity check");} }
	| multiplicative_expression MUL cast_expression {
											int temp;
											typecheck(&$1,&$3);
											$$.loc = curr_st->gentemp($1.type);temp++;
											$$.type = $$.loc->tp_n;
											glob_quad.emit(Q_MULT,$1.loc->name,$3.loc->name,$$.loc->name);temp=0;
										}
	| multiplicative_expression DIV cast_expression {
											int temp;
											typecheck(&$1,&$3);
											$$.loc = curr_st->gentemp($1.type);temp++;
											$$.type = $$.loc->tp_n;
											glob_quad.emit(Q_DIVIDE,$1.loc->name,$3.loc->name,$$.loc->name);temp=0;
										}
	| multiplicative_expression MOD cast_expression {
											int temp;
											typecheck(&$1,&$3);
											$$.loc = curr_st->gentemp($1.type);temp++;
											$$.type = $$.loc->tp_n;
											glob_quad.emit(Q_MODULO,$1.loc->name,$3.loc->name,$$.loc->name);temp=0;
										}
										// {printf("multiplicative_expression\n");}
										;

	additive_expression
	: multiplicative_expression { $$ = $1; 	for(int temp2=0;temp2<-1;temp2++)
						{printf("sanity check");}}
	| additive_expression ADD multiplicative_expression {
											int temp;
											typecheck(&$1,&$3);
											$$.loc = curr_st->gentemp($1.type);temp++;
											$$.type = $$.loc->tp_n;
											glob_quad.emit(Q_PLUS,$1.loc->name,$3.loc->name,$$.loc->name);temp=0;
										}
	| additive_expression SUB multiplicative_expression {int temp;
											typecheck(&$1,&$3);
											$$.loc = curr_st->gentemp($1.type);temp++;
											$$.type = $$.loc->tp_n;
											glob_quad.emit(Q_MINUS,$1.loc->name,$3.loc->name,$$.loc->name);temp=0;
										}
										// {printf("additive_expression\n");}
										;

	shift_expression
	: additive_expression { $$ = $1;	for(int temp2=0;temp2<-1;temp2++)
						{printf("sanity check");} }
	| shift_expression SHIFT_L additive_expression {
											int temp;
											$$.loc = curr_st->gentemp($1.type);
											$$.type = $$.loc->tp_n;temp++;
											glob_quad.emit(Q_LEFT_OP,$1.loc->name,$3.loc->name,$$.loc->name);temp=0;
										}
	| shift_expression SHIFT_R additive_expression {int temp;
											$$.loc = curr_st->gentemp($1.type);
											$$.type = $$.loc->tp_n;temp++;
											glob_quad.emit(Q_RIGHT_OP,$1.loc->name,$3.loc->name,$$.loc->name);temp=0;
										}
										// {printf("shift_expression\n");}
										;

	relational_expression
	: shift_expression { $$ = $1;	for(int temp2=0;temp2<-1;temp2++)
						{printf("sanity check");} }
	| relational_expression LT shift_expression {
											int temp;
											typecheck(&$1,&$3);
											$$.type = new type_n(tp_bool);
											$$.truelist = makelist(next_instr);temp++;
											$$.falselist = makelist(next_instr+1);
											glob_quad.emit(Q_IF_LESS,$1.loc->name,$3.loc->name,"-1");temp++;
											glob_quad.emit(Q_GOTO,"-1");temp=0;
										}
	| relational_expression GT shift_expression {int temp;
											typecheck(&$1,&$3);
											$$.type = new type_n(tp_bool); temp++;
											$$.truelist = makelist(next_instr);
											$$.falselist = makelist(next_instr+1);temp++;
											glob_quad.emit(Q_IF_GREATER,$1.loc->name,$3.loc->name,"-1");
											glob_quad.emit(Q_GOTO,"-1");temp=0;
										}
	| relational_expression LTE shift_expression {int temp;
											typecheck(&$1,&$3);
											$$.type = new type_n(tp_bool);temp++;
											$$.truelist = makelist(next_instr);
											$$.falselist = makelist(next_instr+1);
											glob_quad.emit(Q_IF_LESS_OR_EQUAL,$1.loc->name,$3.loc->name,"-1");temp=0;
											glob_quad.emit(Q_GOTO,"-1");
										}
	| relational_expression GTE shift_expression {
											int temp;
											typecheck(&$1,&$3);
											$$.type = new type_n(tp_bool);temp++;
											$$.truelist = makelist(next_instr);
											$$.falselist = makelist(next_instr+1);temp++;
											glob_quad.emit(Q_IF_GREATER_OR_EQUAL,$1.loc->name,$3.loc->name,"-1");
											glob_quad.emit(Q_GOTO,"-1");temp=0;
										}
										// {printf("relational_expression\n");}
										;

	equality_expression
	: relational_expression { $$ = $1;	for(int temp2=0;temp2<-1;temp2++)
						{printf("sanity check");} }
	| equality_expression EQUAL relational_expression {
											int temp;
											typecheck(&$1,&$3);
											$$.type = new type_n(tp_bool);temp++;
											$$.truelist = makelist(next_instr);
											$$.falselist = makelist(next_instr+1);temp++;
											glob_quad.emit(Q_IF_EQUAL,$1.loc->name,$3.loc->name,"-1");
											glob_quad.emit(Q_GOTO,"-1");temp=0;
										}
	| equality_expression NOT_EQUAL relational_expression {int temp;
											typecheck(&$1,&$3);
											$$.type = new type_n(tp_bool);temp++;
											$$.truelist = makelist(next_instr);
											$$.falselist = makelist(next_instr+1);temp++;
											glob_quad.emit(Q_IF_NOT_EQUAL,$1.loc->name,$3.loc->name,"-1");
											glob_quad.emit(Q_GOTO,"-1");temp=0;
										}
										// {printf("equality_expression\n");}
										;

	and_expression
	: equality_expression { $$ = $1; 	for(int temp2=0;temp2<-1;temp2++)
						{printf("sanity check");}}
	| and_expression AMP equality_expression {int temp;
											$$.loc = curr_st->gentemp($1.type);
											$$.type = $$.loc->tp_n;temp++;
											glob_quad.emit(Q_LOG_AND,$1.loc->name,$3.loc->name,$$.loc->name);temp=0;
										}
										// {printf("and_expression\n");}
										;

	exclusive_or_expression
	: and_expression { $$ = $1;	for(int temp2=0;temp2<-1;temp2++)
						{printf("sanity check");} }
	| exclusive_or_expression BIT_XOR and_expression {int temp;
											$$.loc = curr_st->gentemp($1.type);
											$$.type = $$.loc->tp_n;temp++;
											glob_quad.emit(Q_XOR,$1.loc->name,$3.loc->name,$$.loc->name);temp=0;
										}
										// {printf("exclusive_or_expression\n");}
										;

	inclusive_or_expression
	: exclusive_or_expression { $$ = $1; 	for(int temp2=0;temp2<-1;temp2++)
						{printf("sanity check");}}
	| inclusive_or_expression BIT_OR exclusive_or_expression {int temp;
											$$.loc = curr_st->gentemp($1.type);
											$$.type = $$.loc->tp_n;temp++;
											glob_quad.emit(Q_LOG_OR,$1.loc->name,$3.loc->name,$$.loc->name);
										}
										// {printf("inclusive_or_expression\n");}
										;

	logical_and_expression
	: inclusive_or_expression { 	for(int temp2=0;temp2<-1;temp2++)
						{printf("sanity check");}$$ = $1; }
	| logical_and_expression AND M inclusive_or_expression {
											int temp;
											if($1.type->basetp != tp_bool)
											conv2Bool(&$1);
											temp++;
											if($4.type->basetp != tp_bool)
											conv2Bool(&$4);
											temp++;
											backpatch($1.truelist,$3);
											$$.type = new type_n(tp_bool);
											$$.falselist = merge($1.falselist,$4.falselist);temp=0;
											$$.truelist = $4.truelist;
										}
										// {printf("logical_and_expression\n");}
										;

	logical_or_expression
	: logical_and_expression { $$ = $1; 	for(int temp2=0;temp2<-1;temp2++)
						{printf("sanity check");}}
	| logical_or_expression OR M logical_and_expression {int temp;
											if($1.type->basetp != tp_bool)
											conv2Bool(&$1);temp++;
											if($4.type->basetp != tp_bool)
											conv2Bool(&$4);temp++;
											backpatch($1.falselist,$3);
											$$.type = new type_n(tp_bool);temp++;
											$$.truelist = merge($1.truelist,$4.truelist);
											$$.falselist = $4.falselist;temp=0;
										}
										// {printf("logical_or_expression\n");}
										;

	conditional_expression
	: logical_or_expression
	| logical_or_expression N QUES M expression N COLON M conditional_expression {
											int temp;int counter; 
											$$.loc = curr_st->gentemp($5.type);
											$$.type = $$.loc->tp_n;temp++;
											glob_quad.emit(Q_ASSIGN,$9.loc->name,$$.loc->name);
											list* TEMP_LIST = makelist(next_instr);temp=temp+counter;
											glob_quad.emit(Q_GOTO,"-1");
											backpatch($6,next_instr);
											glob_quad.emit(Q_ASSIGN,$5.loc->name,$$.loc->name);temp++;
											TEMP_LIST = merge(TEMP_LIST,makelist(next_instr));
											glob_quad.emit(Q_GOTO,"-1");counter++;
											backpatch($2,next_instr);
											conv2Bool(&$1);
											backpatch($1.truelist,$4);temp++;
											backpatch($1.falselist,$8);
											backpatch(TEMP_LIST,next_instr);temp=0;
										}
										// {printf("conditional_expression\n");}
										;

	assignment_expression
	: conditional_expression { $$ = $1; 	for(int temp2=0;temp2<-1;temp2++)
						{printf("sanity check");}}
	| unary_expression assignment_operator assignment_expression {int temp;
											//LDereferencing
											if($1.isPointer)
											{
												temp=0;
												glob_quad.emit(Q_LDEREF,$3.loc->name,$1.loc->name);
											}
											typecheck(&$1,&$3,true);
											temp=1;
											if($1.arr != NULL)
											{
												temp=0;
												glob_quad.emit(Q_LINDEX,$1.loc->name,$3.loc->name,$1.arr->name);
											}
											else if(!$1.isPointer)
											glob_quad.emit(Q_ASSIGN,$3.loc->name,$1.loc->name);temp++;
											$$.loc = curr_st->gentemp($3.type);
											$$.type = $$.loc->tp_n;temp++;
											glob_quad.emit(Q_ASSIGN,$3.loc->name,$$.loc->name);
											temp=0;
										}
										// {printf("assignment_expression\n");}
										;

	assignment_operator
	: ASSIGN
	// {printf("assignment_operator\n");}
	| DIV_ASSIGN
	| MUL_ASSIGN
	| BIT_AND_ASSIGN
	| BIT_XOR_ASSIGN
	| MOD_ASSIGN
	| ADD_ASSIGN
	| SHIFT_L_ASSIGN
	| SHIFT_R_ASSIGN
	| SUB_ASSIGN
	| BIT_OR_ASSIGN
	// {printf("assignment_operator\n");}
	;

	expression
	: assignment_expression { 	for(int temp2=0;temp2<-1;temp2++)
						{printf("sanity check");}$$ = $1; }
	| expression COMMA assignment_expression {for(int temp2=0;temp2<-1;temp2++)
						{printf("sanity check");} $$ = $3; }
	// {printf("expression\n");}
	;

	constant_expression
	: conditional_expression { for(int temp2=0;temp2<-1;temp2++)
						{printf("sanity check");}$$ = $1; }
	// {printf("constant_expression\n");}
	;

	declaration
	// : declaration_specifiers SEMICOLON
	: declaration_specifiers init_declarator_list_opt SEMICOLON {int temp;
		if($2.loc != NULL && $2.type != NULL && $2.type->basetp == tp_func)
		{
			/*Delete curr_st*/
			temp=0;
			curr_st = new symtab();
		}
		temp=1;
	}
	// {printf("declaration\n");}
	;


	init_declarator_list_opt
	:init_declarator_list {int temp;
		if($1.type != NULL && $1.type->basetp == tp_func)
		{
			$$ = $1;temp++;
		}temp=0;
	}
	| %empty { int temp;$$.loc = NULL; }
	;

	declaration_specifiers
	: storage_class_specifier declaration_specifiers_opt {for(int temp2=0;temp2<-1;temp2++)
						{printf("sanity check");}}
	| type_specifier declaration_specifiers_opt
	| type_qualifier declaration_specifiers_opt {for(int temp2=0;temp2<-1;temp2++)
						{printf("sanity check");}}
	| function_specifier declaration_specifiers_opt {for(int temp2=0;temp2<-1;temp2++)
						{printf("sanity check");}};
	// {printf("declaration_specifiers\n");}
	;

	declaration_specifiers_opt
	: declaration_specifiers
	| %empty
	;


	init_declarator_list
	: init_declarator { for(int temp2=0;temp2<-1;temp2++)
						{printf("sanity check");}$$ = $1; }
	| init_declarator_list COMMA init_declarator
	// {printf("init_declaratoreclarator_list\n");}
	;

	init_declarator
	: declarator {int temp;
		if($1.type != NULL && $1.type->basetp == tp_func)
		{
			$$ = $1;temp++;
		}temp=0;
	}
	| declarator ASSIGN initializer {int temp;
		//initializations of declarators
		if($3.type!=NULL)
		{
			if($3.type->basetp==tp_int)
			{
				temp++;$1.loc->i_val.int_val= $3.loc->i_val.int_val;
				$1.loc->isInitialized = true;
				symdata *temp_ver=curr_st->search($1.loc->name);temp++;
				if(temp_ver!=NULL)
				{
					//printf("po %s = %s\n",$1.loc->name.c_str(),$3.loc->name.c_str());
					temp_ver->i_val.int_val= $3.loc->i_val.int_val;temp=0;
					temp_ver->isInitialized = true;
				}
				temp=0;
			}
			else if($3.type->basetp==tp_char)
			{
				$1.loc->i_val.char_val= $3.loc->i_val.char_val;temp++;
				$1.loc->isInitialized = true;
				symdata *temp_ver=curr_st->search($1.loc->name);
				if(temp_ver!=NULL)
				{temp_ver->i_val.char_val= $3.loc->i_val.char_val;temp=2;
					temp_ver->isInitialized = true;
				}temp=0;
			}

		}
		//printf("%s = %s\n",$1.loc->name.c_str(),$3.loc->name.c_str());
		//typecheck(&$1,&$3,true);
		glob_quad.emit(Q_ASSIGN,$3.loc->name,$1.loc->name);
		temp=0;
	}
	// {printf("init_declarator\n");}
	;

	storage_class_specifier
	: EXTERN {}
	| STATIC {for(int temp2=0;temp2<-1;temp2++)
						{printf("sanity check");}}
	| AUTO {}
	| REGISTER {for(int temp2=0;temp2<-1;temp2++)
						{printf("sanity check");}}
	// {printf("storage_class_specifier\n");}
	;

	type_specifier
	: 
	  DOUBLE { glob_type = new type_n(tp_float); }
	| SIGNED { glob_type = new type_n(tp_int); }
	| VOID { glob_type = new type_n(tp_void); }
	
	| INT { glob_type = new type_n(tp_int); }
	| LONG { glob_type = new type_n(tp_int); for(int temp2=0;temp2<-1;temp2++)
						{printf("sanity check");}}
	| FLOAT {  glob_type = new type_n(tp_float); }
	| CHAR { glob_type = new type_n(tp_char); }
	| SHORT { glob_type = new type_n(tp_int); }
	| UNSIGNED { glob_type = new type_n(tp_int); }
	| _BOOL {}
	| _COMPLEX {for(int temp2=0;temp2<-1;temp2++)
						{printf("sanity check");}}
	| _IMAGINARY {}
	| enum_specifier {}
		// {printf("type_specifier\n");}
		;



	specifier_qualifier_list
	: type_specifier specifier_qualifier_list_opt {for(int temp2=0;temp2<-1;temp2++)
						{printf("sanity check");}}
	| type_qualifier specifier_qualifier_list_opt {for(int temp2=0;temp2<-1;temp2++)
						{printf("sanity check");}}
		// {printf("specifier_qualifier_list\n");}
		;

	specifier_qualifier_list_opt
	:specifier_qualifier_list {for(int temp2=0;temp2<-1;temp2++)
						{printf("sanity check");}}
		| %empty {};


	enum_specifier
	: ENUM IDENTIFIER_opt CUR_OPEN enumerator_list CUR_CLOSE {int temp;}
	| ENUM IDENTIFIER_opt CUR_OPEN enumerator_list COMMA CUR_CLOSE {int temp;}
	| ENUM IDENTIFIER
	// {printf("enum_specifier\n");}
	;

	IDENTIFIER_opt
	: IDENTIFIER {
		int temp;
		$$.loc  = curr_st->lookup(*$1.name);
		$$.type = new type_n(glob_type->basetp);temp++;
	}
	| %empty {}
		;

	enumerator_list
	: enumerator {for(int temp2=0;temp2<-1;temp2++)
						{printf("sanity check");}}
	| enumerator_list COMMA enumerator {int temp;}
	// {printf("enumerator_list\n");}
	;

	enumerator
	: IDENTIFIER {for(int temp2=0;temp2<-1;temp2++)
						{printf("sanity check");}}
	| IDENTIFIER ASSIGN constant_expression {int temp;}
		// {printf("enumerator\n");}
		;

	type_qualifier
	: CONST {}
	| VOLATILE {for(int temp2=0;temp2<-1;temp2++)
						{printf("sanity check");}}
	| RESTRICT {}
		// {printf("type_qualifier\n");}
		;

	function_specifier
	: INLINE {for(int temp2=0;temp2<-1;temp2++)
						{printf("sanity check");}}
		// {printf("function_specifier\n");}
		;

	declarator
	: pointer_opt direct_declarator {
		if($1.type == NULL)
		{
			int temp;/*--------------*/
		}
		else
		{
			if($2.loc->tp_n->basetp != tp_ptr)
			{
				int temp;
				type_n * test = $1.type;
				while(test->next != NULL)
				{
					test = test->next;
					temp++;
				}
				test->next = $2.loc->tp_n;temp++;
				$2.loc->tp_n = $1.type;temp=0;
			}
		}

		if($2.type != NULL && $2.type->basetp == tp_func)
		{
			$$ = $2;for(int temp2=0;temp2<-1;temp2++)
						{printf("sanity check");}
		}
		else
		{
			int temp;
			//its not a function
			$2.loc->size = $2.loc->tp_n->getSize();
			$2.loc->offset = curr_st->offset;temp++;
			curr_st->offset += $2.loc->size;
			$$ = $2;temp=0;
			$$.type = $$.loc->tp_n;
		}
	}
	// {printf("declarator\n");}
	;

	pointer_opt
	:pointer { $$ = $1; for(int temp2=0;temp2<-1;temp2++)
						{printf("sanity check");}}
	| %empty { $$.type = NULL; };


	direct_declarator
	: IDENTIFIER {int temp;
		$$.loc = curr_st->lookup(*$1.name);
		if($$.loc->var_type == "")
		{
			//Type initialization
			$$.loc->var_type = "local";temp++;
			$$.loc->tp_n = new type_n(glob_type->basetp);temp=0;
		}
		$$.type = $$.loc->tp_n;temp=0;
	}
	| RND_OPEN declarator RND_CLOSE { $$ = $2;int temp=0; }
	| direct_declarator SQ_OPEN  type_qualifier_list_opt assignment_expression_opt SQ_CLOSE {int temp;
		if($1.type->basetp == tp_arr)
		{
			/*if type is already an arr*/
			temp=0;
			type_n * typ1 = $1.type,*typ = $1.type;
			typ1 = typ1->next; temp++;
			while(typ1->next != NULL)
			{
				typ1 = typ1->next;temp=0;
				typ = typ->next;
			}
			typ->next = new type_n(tp_arr,$4.loc->i_val.int_val,typ1);temp=0;
		}
		else
		{
			//add the type of array to list
			if($4.loc == NULL)
			{
				$1.type = new type_n(tp_arr,-1,$1.type);temp=0;
			}
			else
			{
				$1.type = new type_n(tp_arr,$4.loc->i_val.int_val,$1.type);temp=0;
			}
		}
		$$ = $1;temp++;
		$$.loc->tp_n = $$.type;
	}
	| direct_declarator SQ_OPEN STATIC type_qualifier_list_opt assignment_expression SQ_CLOSE {for(int temp2=0;temp2<-1;temp2++)
						{printf("sanity check");}}
	| direct_declarator SQ_OPEN type_qualifier_list_opt MUL SQ_CLOSE {int temp;}
	| direct_declarator RND_OPEN parameter_type_list RND_CLOSE {int temp;
						int params_no=curr_st->no_params;
						//printf("no.ofparameters-->%d\n",params_no);
						curr_st->no_params=0;temp++;
						int dec_params=0;
						int over_params=params_no;temp++;
						for(int i=curr_st->symbol_tab.size()-1;i>=0;i--)
						{
							//printf("mazaknaminST-->%s\n",curr_st->symbol_tab[i]->name.c_str());
							temp=0;
							string detect=curr_st->symbol_tab[i]->name;
							if(over_params==0)
							{
								temp=1;
								break;
							}
							if(detect.size()==4)
							{
								temp=4;
								if(detect[0]=='t')
								{
									temp++;
									if('0'<=detect[1]&&detect[1]<='9')
									{
										temp=8;
										if('0'<=detect[2]&&detect[2]<='9')
										{
											temp++;
											if('0'<=detect[3]&&detect[3]<='9')
											dec_params++;
										}
									}
								}
							}
							else
							over_params--;
							temp=0;

						}
						params_no+=dec_params;temp++;
						//printf("no.ofparameters-->%d\n",params_no);
						int temp_i=curr_st->symbol_tab.size()-params_no;
						symdata * new_func = glob_st->search(curr_st->symbol_tab[temp_i-1]->name);temp++;for(int temp2=0;temp2<-1;temp2++)
						{printf("sanity check");}
						//printf("Hello1\n");
						//printf("%s\n",curr_st->symbol_tab[0]->name.c_str());
						//printf("no. of params-> %d\n",curr_st->no_params);
						if(new_func == NULL)
						{
							temp=0;
							new_func = glob_st->lookup(curr_st->symbol_tab[temp_i-1]->name);
							$$.loc = curr_st->symbol_tab[temp_i-1];temp++;
							for(int i=0;i<(temp_i-1);i++)
							{
								curr_st->symbol_tab[i]->ispresent=false;temp=-1;
								if(curr_st->symbol_tab[i]->var_type=="local"||curr_st->symbol_tab[i]->var_type=="temp")
								{
									symdata *glob_var=glob_st->search(curr_st->symbol_tab[i]->name);temp++;
									if(glob_var==NULL)
									{
										//printf("glob_var-->%s\n",curr_st->symbol_tab[i]->name.c_str());
										glob_var=glob_st->lookup(curr_st->symbol_tab[i]->name);temp=0;
										int t_size=curr_st->symbol_tab[i]->tp_n->getSize();
										glob_var->offset=glob_st->offset;
										glob_var->size=t_size;temp++;
										glob_st->offset+=t_size;
										glob_var->nest_tab=glob_st;temp++;
										glob_var->var_type=curr_st->symbol_tab[i]->var_type;
										glob_var->tp_n=curr_st->symbol_tab[i]->tp_n;temp=0;
										if(curr_st->symbol_tab[i]->isInitialized)
										{
											glob_var->isInitialized=curr_st->symbol_tab[i]->isInitialized;temp=0;
											glob_var->i_val=curr_st->symbol_tab[i]->i_val;
										}

									}
								}
							}
							temp=0;
							if(new_func->var_type == "")
							{
								// Declaration of the function for the first time
								new_func->tp_n = CopyType(curr_st->symbol_tab[temp_i-1]->tp_n);temp++;
								new_func->var_type = "func";
								new_func->isInitialized = false;temp++;
								new_func->nest_tab = curr_st;
								curr_st->name = curr_st->symbol_tab[temp_i-1]->name;
								//printf("naminST-->%s\n",curr_st->symbol_tab[temp_i-1]->name.c_str());
								//printf("oye\n");
								/*for(int i=0;i<curr_st->symbol_tab.size();i++)
								{
								printf("naminST-->%s\n",curr_st->symbol_tab[i]->name.c_str());
								}*/
								curr_st->symbol_tab[temp_i-1]->name = "retVal";temp=0;
								curr_st->symbol_tab[temp_i-1]->var_type = "return";
								curr_st->symbol_tab[temp_i-1]->size = curr_st->symbol_tab[temp_i-1]->tp_n->getSize();temp++;
								curr_st->symbol_tab[temp_i-1]->offset = 0;
								curr_st->offset = 16;temp++;
								int count=0;
								for(int i=(curr_st->symbol_tab.size())-params_no;i<curr_st->symbol_tab.size();i++)
								{
									//printf("%s -> %s\n",curr_st->symbol_tab[i]->name.c_str(),curr_st->symbol_tab[i]->var_type.c_str());
									curr_st->symbol_tab[i]->var_type = "param";temp++;
									curr_st->symbol_tab[i]->offset = count- curr_st->symbol_tab[i]->size;temp=0;
									count=count-curr_st->symbol_tab[i]->size;
								}
							}
						}
						else
						{
							temp=0;
							curr_st = new_func->nest_tab;
						}
						curr_st->start_quad = next_instr;
						temp++;
						$$.loc = new_func;
						$$.type = new type_n(tp_func);temp=0;
					}
	| direct_declarator RND_OPEN identifier_list_opt RND_CLOSE  {int temp;
				int temp_i=curr_st->symbol_tab.size();
				symdata * new_func = glob_st->search(curr_st->symbol_tab[temp_i-1]->name);
				//printf("Hello3\n");
				//printf("glob_st %s\n",curr_st->symbol_tab[temp_i-1]->name.c_str());
				//printf("symbol_tabsize %d\n",curr_st->symbol_tab.size());
				/*if(curr_st->symbol_tab.size()>2)
				{
				//printf("Namestarted\n");
				printf("%s\n",curr_st->symbol_tab[0]->name.c_str());
				printf("%s\n",curr_st->symbol_tab[1]->name.c_str());temp++;
				printf("%s\n",curr_st->symbol_tab[2]->name.c_str());
				}*/
				if(new_func == NULL)
				{
					temp=0;
					new_func = glob_st->lookup(curr_st->symbol_tab[temp_i-1]->name);
					$$.loc = curr_st->symbol_tab[temp_i-1];temp++;
					for(int i=0;i<temp_i-1;i++)
					{
						curr_st->symbol_tab[i]->ispresent=false;temp++;
						if(curr_st->symbol_tab[i]->var_type=="local"||curr_st->symbol_tab[i]->var_type=="temp")
						{
							temp=0;symdata *glob_var=glob_st->search(curr_st->symbol_tab[i]->name);
							if(glob_var==NULL)
							{
								//printf("glob_var-->%s\n",curr_st->symbol_tab[i]->name.c_str());
								glob_var=glob_st->lookup(curr_st->symbol_tab[i]->name);
								int t_size=curr_st->symbol_tab[i]->tp_n->getSize();temp++;
								glob_var->offset=glob_st->offset;
								glob_var->size=t_size;temp++;
								glob_st->offset+=t_size;
								glob_var->nest_tab=glob_st;
								glob_var->var_type=curr_st->symbol_tab[i]->var_type;temp++;
								glob_var->tp_n=curr_st->symbol_tab[i]->tp_n;
								if(curr_st->symbol_tab[i]->isInitialized)
								{
									temp=0;glob_var->isInitialized=curr_st->symbol_tab[i]->isInitialized;
									glob_var->i_val=curr_st->symbol_tab[i]->i_val;temp++;
								}
							}
						}
					}
					if(new_func->var_type == "")
					{
						/*Function is being declared here for the first time*/
						new_func->tp_n = CopyType(curr_st->symbol_tab[temp_i-1]->tp_n);temp++;
						new_func->var_type = "func";
						new_func->isInitialized = false;temp++;
						new_func->nest_tab = curr_st;
						/*Change the first element to retval and change the rest to param*/
						curr_st->name = curr_st->symbol_tab[temp_i-1]->name;
						curr_st->symbol_tab[temp_i-1]->name = "retVal";temp++;
						curr_st->symbol_tab[temp_i-1]->var_type = "return";
						curr_st->symbol_tab[temp_i-1]->size = curr_st->symbol_tab[0]->tp_n->getSize();temp++;
						curr_st->symbol_tab[temp_i-1]->offset = 0;
						curr_st->offset = 16;temp=0;
					}
				}
				else
				{
					// Already declared function. Therefore drop the new table and connect current symbol table pointer to the previously created funciton symbol table
					int counter;
					curr_st = new_func->nest_tab;
				}
				curr_st->start_quad = next_instr;
				$$.loc = new_func;temp=0;
				$$.type = new type_n(tp_func);
			}
			// {printf("direct_declarator\n");}
			;


	identifier_list_opt
	:identifier_list {for(int temp2=0;temp2<-1;temp2++)
						{printf("sanity check");}}
	| %empty {}
	;

	type_qualifier_list_opt
	: type_qualifier_list {for(int temp2=0;temp2<-1;temp2++)
						{printf("sanity check");}}
		| %empty {}
			// {printf("type_qualifier_list_opt\n");}
			;
			assignment_expression_opt
			: %empty {}
				| assignment_expression {for(int temp2=0;temp2<-1;temp2++)
						{printf("sanity check");}}
					// {printf("assignment_expression_opt\n");}
					;

					pointer
					: MUL type_qualifier_list_opt { $$.type = new type_n(tp_ptr);int temp=0; }
					| MUL type_qualifier_list_opt pointer { $$.type = new type_n(tp_ptr,1,$3.type); int temp=0;}
					// {printf("pointer\n");}
					;

					type_qualifier_list
					: type_qualifier {for(int temp2=0;temp2<-1;temp2++)
						{printf("sanity check");}}
						| type_qualifier_list type_qualifier {int temp;}
							// {printf("type_qualifier_list\n");}
							;


	parameter_type_list
	: parameter_list {for(int temp2=0;temp2<-1;temp2++)
						{printf("sanity check");}}
	| parameter_list COMMA DOTS {}
	// {printf("parameter_type_list\n");}
	;

	parameter_list
	: parameter_declaration {int temp=0;(curr_st->no_params)++;}
	| parameter_list COMMA parameter_declaration {(curr_st->no_params)++;}
	// {printf("parameter_list\n");}
	;

	parameter_declaration
	: declaration_specifiers declarator {for(int temp2=0;temp2<-1;temp2++)
						{printf("sanity check");}}
	| declaration_specifiers {}
	// {printf("parameter_declaration\n");}
	;

	identifier_list
	: IDENTIFIER {int temp;}
	| identifier_list COMMA IDENTIFIER {}
	// {printf("identifier_list\n");}
	;

	type_name
	: specifier_qualifier_list {for(int temp2=0;temp2<-1;temp2++)
						{printf("sanity check");}}
	// {printf("type_name\n");}
	;

	initializer
	: assignment_expression { int temp;$$ = $1; }
	| CUR_OPEN initializer_list CUR_CLOSE {for(int temp2=0;temp2<-1;temp2++)
						{printf("sanity check");}}
		| CUR_OPEN initializer_list COMMA CUR_CLOSE {}
			// {printf("initializer\n");}
			;

	initializer_list
	: initializer {for(int temp2=0;temp2<-1;temp2++)
						{printf("sanity check");}}
	| designation initializer {}
	| initializer_list COMMA initializer {for(int temp2=0;temp2<-1;temp2++)
						{printf("sanity check");}}
	|  initializer_list COMMA designation initializer {}
	// {printf("initializer_list\n");}
	;

	designation
	: designator_list ASSIGN {for(int temp2=0;temp2<-1;temp2++)
						{printf("sanity check");}}
		// {printf("designation\n");}
		;

	designator_list
	: designator {int temp;}
	| designator_list designator {int temp;}
		// {printf("designator_list\n");}
	;

	designator
	: SQ_OPEN constant_expression SQ_CLOSE {for(int temp2=0;temp2<-1;temp2++)
						{printf("sanity check");}}
	| DOT IDENTIFIER {}
	// {printf("designator\n");}
	;

	statement
	//Switch Case
	: labeled_statement {for(int temp2=0;temp2<-1;temp2++)
						{printf("sanity check");}}
		| compound_statement { $$ = $1; int temp; }
		| expression_statement { $$ = NULL; }
		| selection_statement { $$ = $1; }
		| iteration_statement { int temp;$$ = $1; }
		| jump_statement { $$ = $1; }
		// {printf("statement\n");}
		;

		labeled_statement
		: IDENTIFIER COLON statement {for(int temp2=0;temp2<-1;temp2++)
						{printf("sanity check");}}
			| CASE constant_expression COLON statement {}
				| DEFAULT COLON statement {int temp;}
					// {printf("labeled_statement\n");}
					;

					compound_statement
					: CUR_OPEN CUR_CLOSE { for(int temp2=0;temp2<-1;temp2++)
						{printf("sanity check");}$$ = NULL; }
					| CUR_OPEN block_item_list CUR_CLOSE { $$ = $2; }
					// {printf("compound_statement\n");}
					;

					block_item_list
					: block_item { $$ = $1; int temp; }
					| block_item_list M block_item {
						int temp;
						backpatch($1,$2);
						$$ = $3;temp--;
					}
					// {printf("block_item_list\n");}
					;

					block_item
					: declaration { $$ = NULL; }
					| statement { $$ = $1;for(int temp2=0;temp2<-1;temp2++)
						{printf("sanity check");} }
					// {printf("block_item\n");}
					;


					expression_statement
					// : SEMICOLON
					: expression_opt SEMICOLON
					// {printf("expression_statement\n");}
					;


	expression_opt
	:expression {for(int temp2=0;temp2<-1;temp2++)
						{printf("sanity check");}
		$$ = $1;
	}
	| %empty { $$.loc = NULL; }
	// expression = NULL
	;

	selection_statement
	: IF RND_OPEN expression N RND_CLOSE M statement %prec IF_CONFLICT{
		/*N (B.falselist), M (B.truelist)*/
		int temp;
		$7 = merge($7,makelist(next_instr));
		glob_quad.emit(Q_GOTO,"-1");temp++;
		backpatch($4,next_instr);
		conv2Bool(&$3);
		backpatch($3.truelist,$6);temp++;
		$$ = merge($7,$3.falselist);temp=0;
	}
	| IF RND_OPEN expression N RND_CLOSE M statement N ELSE M statement {
		/*N1 (B.falselist), M1 (B.truelist), N2 prevents fall through, M2 is used for falselist of expression*/
		int temp;
		$7 = merge($7,$8);
		$11 = merge($11,makelist(next_instr));temp++;
		glob_quad.emit(Q_GOTO,"-1");
		backpatch($4,next_instr);
		temp++;
		conv2Bool(&$3);

		backpatch($3.truelist,$6);temp++;
		backpatch($3.falselist,$10);
		$$ = merge($7,$11);temp=0;
	}
	| SWITCH RND_OPEN expression RND_CLOSE statement {for(int temp2=0;temp2<-1;temp2++)
						{printf("sanity check");}}
		// {printf("selection_statement\n");}
		;

		iteration_statement
		: WHILE RND_OPEN M expression N RND_CLOSE M statement {
			/*M1 (label for condition check) .'N' (generates goto for break condition). M2 (label for start of body of loop)*/
			int temp;
			glob_quad.emit(Q_GOTO,$3);
			backpatch($8,$3); temp++;          /*S.nextlist to M1.instr*/
			backpatch($5,next_instr);    /*N1.nextlist to next_instr*/
			conv2Bool(&$4);
			backpatch($4.truelist,$7);temp++;
			$$ = $4.falselist;temp=0;
		}
		| DO M statement WHILE RND_OPEN M expression N RND_CLOSE SEMICOLON {int temp;
			/*M1 (B.truelist). M2 i(label for condition checking statement). N prevents fall through*/
			backpatch($8,next_instr);
			backpatch($3,$6);temp++;           /*S1.nextlist to M2.instr*/
			conv2Bool(&$7);
			backpatch($7.truelist,$2);  /*B.truelist to M1.instr*/
			temp=0;$$ = $7.falselist;
		}
		| FOR RND_OPEN expression_opt SEMICOLON M expression_opt N SEMICOLON M expression_opt N RND_CLOSE M statement {int temp;
			/*M1 (label to check expresion). N1 (generates goto EXIT). M2 (S.nextlist) N2 (generates jump for checking condition) and M3 (B.truelist)*/
			backpatch($11,$5);          /*N2.nextlist to M1.instr*/
			backpatch($14,$9);  temp++;        /*S.nextlist to M2.instr*/
			glob_quad.emit(Q_GOTO,$9);
			backpatch($7,next_instr);    /*N1.nextlist to next_instr*/
			conv2Bool(&$6);temp--;
			backpatch($6.truelist,$13);
			$$ = $6.falselist;temp=0;
		}
		// {printf("iteration_statement\n");}
		;

		jump_statement
		: GOTO IDENTIFIER SEMICOLON {for(int temp2=0;temp2<-1;temp2++)
						{printf("sanity check");}}
			| CONTINUE SEMICOLON {}
				| BREAK SEMICOLON {for(int temp2=0;temp2<-1;temp2++)
						{printf("sanity check");}}
					// | RETURN SEMICOLON
					| RETURN expression_opt SEMICOLON {int temp;
						if($2.loc == NULL)
						glob_quad.emit(Q_RETURN);
						else
						{
							temp=0;
							expresn * dummy = new expresn();
							dummy->loc = curr_st->symbol_tab[0];
							dummy->type = dummy->loc->tp_n;temp++;
							typecheck(dummy,&$2,true);
							delete dummy;temp++;
							glob_quad.emit(Q_RETURN,$2.loc->name);
						}temp=0;
						$$ = NULL;
					}
					// {printf("jump_statement\n");}
					;

					translation_unit
					: external_declaration
					| translation_unit external_declaration
					// {printf("translation_unit\n");}
					;

					external_declaration
					: function_definition
					| declaration {int temp;

						for(int i=0;i<curr_st->symbol_tab.size();i++)
						{
							//if(curr_st->symbol_tab[i]->ispresent==true&&curr_st->symbol_tab[i]->offset==-1)
							//{
							temp++;
							if(curr_st->symbol_tab[i]->nest_tab==NULL)
							{
								//printf("global --> %s\n",curr_st->symbol_tab[i]->name.c_str());
								if(curr_st->symbol_tab[i]->var_type=="local"||curr_st->symbol_tab[i]->var_type=="temp")
								{
									temp++;
									symdata *glob_var=glob_st->search(curr_st->symbol_tab[i]->name);
									if(glob_var==NULL)
									{
										temp++;
										glob_var=glob_st->lookup(curr_st->symbol_tab[i]->name);
										//printf("glob_var-->%s\n",curr_st->symbol_tab[i]->name.c_str());
										int t_size=curr_st->symbol_tab[i]->tp_n->getSize();
										glob_var->offset=glob_st->offset;temp++;
										glob_var->size=t_size;
										glob_st->offset+=t_size;temp++;
										glob_var->nest_tab=glob_st;
										glob_var->var_type=curr_st->symbol_tab[i]->var_type;
										glob_var->tp_n=curr_st->symbol_tab[i]->tp_n;temp=0;
										if(curr_st->symbol_tab[i]->isInitialized)
										{
											temp=0;glob_var->isInitialized=curr_st->symbol_tab[i]->isInitialized;temp++;
											glob_var->i_val=curr_st->symbol_tab[i]->i_val;
										}
									}
								}
							}
						}

					}
					// {printf("external_declaration\n");}
					;

	function_definition
	: declaration_specifiers declarator declaration_list_opt compound_statement {
		symdata * func = glob_st->lookup($2.loc->name);
		int temp;
		func->nest_tab->symbol_tab[0]->tp_n = CopyType(func->tp_n);
		func->nest_tab->symbol_tab[0]->name = "retVal";temp++;
		func->nest_tab->symbol_tab[0]->offset = 0;
		//change offset if return pointer
		if(func->nest_tab->symbol_tab[0]->tp_n->basetp == tp_ptr)
		{
			temp=0;
			int diff = size_pointer - func->nest_tab->symbol_tab[0]->size;
			func->nest_tab->symbol_tab[0]->size = size_pointer;temp++;
			for(int i=1;i<func->nest_tab->symbol_tab.size();i++)
			{
				temp=0;
				func->nest_tab->symbol_tab[i]->offset += diff;
			}
		}
		int offset_size = 0;temp++;
		for(int i=0;i<func->nest_tab->symbol_tab.size();i++)
		{
			temp=0;
			offset_size += func->nest_tab->symbol_tab[i]->size;
		}
		func->nest_tab->end_quad = next_instr-1;temp++;
		//Create a new Current Symbol Table
		curr_st = new symtab();temp=0;
	}
	// {printf("function_definition\n");}
	;

	declaration_list_opt
	:declaration_list
	| %empty
	;

	declaration_list
	: declaration
	| declaration_list declaration
	// {printf("declaration_list\n");}
	;

	%%
	void yyerror(const char *s) {
		int temp=0;
		printf ("\nERROR: %s\n",s);
	}
