%{
	/* C Declarations and Definitions */
	#include "ass5_17CS10057_translator.h"
	extern int yylex(void);
	void yyerror(const char *s);
%}

%union {
		int intval;
		char charval;
    IdStr Idl;
    float floatval;
    string *strval;
    DeclStr decl;
    ArgListStr argsl;
    int instr;
    Expression expon;
    List *nextlist;		//for N -> epsilon
}

%token TYPEDEF EXTERN STATIC AUTO REGISTER INLINE RESTRICT
%token CHAR SHORT INT LONG SIGNED UNSIGNED FLOAT DOUBLE CONST VOLATILE VOID
%token _BOOL _COMPLEX _IMAGINARY
%token STRUCT UNION ENUM
%token BREAK CASE CONTINUE DEFAULT DO IF ELSE FOR GOTO WHILE SWITCH SIZEOF
%token RETURN

%token DOTS SHIFT_REQ SHIFT_LEQ PLUS_EQ MINUS_EQ STAR_EQ
%token DIV_EQ MOD_EQ BIN_AND_EQ BIN_XOR_EQ BIN_OR_EQ SHIFT_R SHIFT_L
%token INC DEC ACC AMP OR LTE GTE EQ NEQ
%token PUNCTUATOR SINGLE_COMMENT MULTI_COMMENT
%token SQ_BRACKET_OP SQ_BRACKET_CL RO_BRACKET_OP RO_BRACKET_CL CUR_BRACKET_OP CUR_BRACKET_CL
%token DOT MUL ADD SUB NEG EXCLAIMATION DIV MODULO BIT_SHIFT_L BIT_SHIFT_R QUESTION AND COLON SEMICOLON ASSIGN COMMA HASH
%token BITOR BITXOR


%token <Idl> IDENTIFIER
%token <intval> INTEGER_CONSTANT
%token <strval> STRING_LITERAL
%token <floatval> FLOATING_CONSTANT
%token <strval> ENUMERATION_CONSTANT
%token <charval> CHARACTER_CONSTANT

%type <expon> primary_expression postfix_expression unary_expression cast_expression multiplicative_expression additive_expression shift_expression relational_expression equality_expression AND_expression exclusive_OR_expression inclusive_OR_expression logical_AND_expression logical_OR_expression conditional_expression assignment_expression_opt assignment_expression constant_expression expression expression_statement expression_opt declarator direct_declarator initializer IDENTIFIER_opt declaration init_declarator_list init_declarator_list_opt init_declarator

%type <nextlist> block_item_list block_item statement labeled_statement compound_statement selection_statement iteration_statement jump_statement

%type <argsl> argument_expression_list argument_expression_list_opt

%type <decl> type_specifier declaration_specifiers specifier_qualifier_list Typeame pointer pointer_opt

%type <instr>       M
%type <nextlist>    N
%type <charval>     unary_operator

%start translation_unit


%left '+' '-'
%left '*' '/' '%'
%nonassoc UNARY

%%
M: %empty {
    			$$ = nextInstr;
					}
					;

N: %empty {
    			$$ = makelist(nextInstr);
    			quads.emit(OP_GOTO, -1);
					}
					;

primary_expression
	: IDENTIFIER {
			            //Check whether its a function
			            SymRec * check_func = glbSt->search(*$1.name);
			            if(check_func == NULL)
			            {
			                $$.loc  =  currSt->lookup(*$1.name);
			                if($$.loc->recType != NULL && $$.loc->recType->basetp == Tarray)
			                {
			                    //array
			                    $$.arr = $$.loc;
			                    $$.loc = currSt->gentemp(new Type(Tint));
			                    $$.loc->initVal.int_val = 0;
			                    $$.loc->isInitialized = true;
			                    quads.emit(OP_ASSIGN,0,$$.loc->name);
			                    $$.type = $$.arr->recType;
			                }
			                else
			                {
			                    // not an array
			                    $$.type = $$.loc->recType;
			                    $$.arr = NULL;
			                    $$.isPointer = false;
			                }
			            }
			            else
			            {
			                // function
			                $$.loc = check_func;
			                $$.type = check_func->recType;
			                $$.arr = NULL;
			                $$.isPointer = false;
			            }
			        }
	| INTEGER_CONSTANT {
                    // Declare and initialize the temp val as int
                    $$.loc  = currSt->gentemp(new Type(Tint));
                    $$.type = $$.loc->recType;
                    $$.loc->initVal.int_val = $1;
                    $$.loc->isInitialized = true;
                    $$.arr = NULL;
                    quads.emit(OP_ASSIGN, $1, $$.loc->name);
                }
	| FLOATING_CONSTANT {
                        // Declare and initialize the temp val as float
                        $$.loc  = currSt->gentemp(new Type(Tfloat));
                        $$.type = $$.loc->recType;
                        $$.loc->initVal.float_val = $1;
                        $$.loc->isInitialized = true;
                        $$.arr = NULL;
                        quads.emit(OP_ASSIGN, $1, $$.loc->name);
                      }
	| CHARACTER_CONSTANT {
                            // Declare and initialize the temp val as char
                            $$.loc  = currSt->gentemp(new Type(Tchar));
                            $$.type = $$.loc->recType;
                            $$.loc->initVal.char_val = $1;
                            $$.loc->isInitialized = true;
                            $$.arr = NULL;
                            quads.emit(OP_ASSIGN, $1, $$.loc->name);
                        }
	| STRING_LITERAL {}
	| RO_BRACKET_OP expression RO_BRACKET_CL { $$ = $2; }
	// {printf("primary_expression\n");}
	;

postfix_expression
	: primary_expression {	$$ = $1; }
	| postfix_expression SQ_BRACKET_OP expression SQ_BRACKET_CL {
        //Explanation of Array handling

        $$.loc = currSt->gentemp(new Type(Tint));

        SymRec* temporary = currSt->gentemp(new Type(Tint));

        char temp[10];

        sprintf(temp,"%d",$1.type->next->getSize());

        quads.emit(OP_MULT,$3.loc->name,temp,temporary->name);
        quads.emit(OP_ADD,$1.loc->name,temporary->name,$$.loc->name);

        // new size will be calculated and the temporary variable storing the size will be passed on as $$.loc

        //$$.arr is base pointer
        $$.arr = $1.arr;

        //$$.type is basetp(arr)
        $$.type = $1.type->next;

        //$$.arr->recType type of the arr and is used for size calculations
	 }
	| postfix_expression RO_BRACKET_OP RO_BRACKET_CL {}
	| postfix_expression RO_BRACKET_OP argument_expression_list_opt RO_BRACKET_CL {
        //Explanation of Function Handling
        $$.loc = currSt->gentemp(CopyType($1.type));
        //temporary is created
        char str[10];
        if($3.arguments == NULL)
        {
            //No function Parameters
            sprintf(str,"0");
            quads.emit(OP_CALL,$1.loc->name,str,$$.loc->name);
        }
        else
        {
            for(int i=0;i<$3.arguments->size();i++)
            {
                // To print the parameters
                quads.emit(OP_PARAM,(*$3.arguments)[i]->loc->name);

            }
            sprintf(str,"%ld",$3.arguments->size());
            quads.emit(OP_CALL,$1.loc->name,str,$$.loc->name);
        }

        $$.arr = NULL;
        $$.type = $$.loc->recType;
    }
	| postfix_expression DOT IDENTIFIER {}
	| postfix_expression ACC IDENTIFIER {}
	| postfix_expression INC {
        $$.loc = currSt->gentemp(CopyType($1.type));
        if($1.arr != NULL)
        {
            // Post increment of an array element
            SymRec * temp_elem = currSt->gentemp(CopyType($1.type));
            quads.emit(OP_RINDEX,$1.arr->name,$1.loc->name,$$.loc->name);
            quads.emit(OP_RINDEX,$1.arr->name,$1.loc->name,temp_elem->name);
            quads.emit(OP_ADD,temp_elem->name,"1",temp_elem->name);
            quads.emit(OP_LINDEX,$1.loc->name,temp_elem->name,$1.arr->name);
            $$.arr = NULL;
        }
        else
        {
            //post increment of an simple element
            quads.emit(OP_ASSIGN,$1.loc->name,$$.loc->name);
            quads.emit(OP_ADD,$1.loc->name,"1",$1.loc->name);
        }
        $$.type = $$.loc->recType;
    }
	| postfix_expression DEC {
		$$.loc = currSt->gentemp(CopyType($1.type));
        if($1.arr != NULL)
        {
            // Post decrement of an array element
            SymRec * temp_elem = currSt->gentemp(CopyType($1.type));
            quads.emit(OP_RINDEX,$1.arr->name,$1.loc->name,$$.loc->name);
            quads.emit(OP_RINDEX,$1.arr->name,$1.loc->name,temp_elem->name);
            quads.emit(OP_SUB,temp_elem->name,"1",temp_elem->name);
            quads.emit(OP_LINDEX,$1.loc->name,temp_elem->name,$1.arr->name);
            $$.arr = NULL;
        }
        else
        {
            //post decrement of an simple element
            quads.emit(OP_ASSIGN,$1.loc->name,$$.loc->name);
            quads.emit(OP_SUB,$1.loc->name,"1",$1.loc->name);
        }
        $$.type = $$.loc->recType;
	}
	| RO_BRACKET_OP Typeame RO_BRACKET_CL CUR_BRACKET_OP initializer_list CUR_BRACKET_CL	{}
	|  RO_BRACKET_OP Typeame RO_BRACKET_CL CUR_BRACKET_OP initializer_list COMMA CUR_BRACKET_CL	{}
	// {printf("postfix_expression\n");}
	;

argument_expression_list_opt
    : argument_expression_list { $$ = $1; }
    /* | %empty { $$.arguments = NULL; } */
		;

argument_expression_list
	: assignment_expression {
	    $$.arguments = new vector<Expression*>;
	    Expression * tex = new Expression($1);
	    $$.arguments->push_back(tex);
	}
	| argument_expression_list COMMA assignment_expression {
        Expression * tex = new Expression($3);
        $$.arguments->push_back(tex);
    };
	// {printf("argument_expression_list\n");}
	;

unary_expression
	: postfix_expression	{ $$ = $1; }
	| INC unary_expression {
        $$.loc = currSt->gentemp($2.type);
        if($2.arr != NULL)
        {
            // pre increment of an Array element
            SymRec * temp_elem = currSt->gentemp(CopyType($2.type));
            quads.emit(OP_RINDEX,$2.arr->name,$2.loc->name,temp_elem->name);
            quads.emit(OP_ADD,temp_elem->name,"1",temp_elem->name);
            quads.emit(OP_LINDEX,$2.loc->name,temp_elem->name,$2.arr->name);
            quads.emit(OP_RINDEX,$2.arr->name,$2.loc->name,$$.loc->name);
            $$.arr = NULL;
        }
        else
        {
            // pre increment
            quads.emit(OP_ADD,$2.loc->name,"1",$2.loc->name);
            quads.emit(OP_ASSIGN,$2.loc->name,$$.loc->name);
        }
        $$.type = $$.loc->recType;
    }
	| DEC unary_expression {
        $$.loc = currSt->gentemp(CopyType($2.type));
        if($2.arr != NULL)
        {
            //pre decrement of  Array Element
            SymRec * temp_elem = currSt->gentemp(CopyType($2.type));
            quads.emit(OP_RINDEX,$2.arr->name,$2.loc->name,temp_elem->name);
            quads.emit(OP_SUB,temp_elem->name,"1",temp_elem->name);
            quads.emit(OP_LINDEX,$2.loc->name,temp_elem->name,$2.arr->name);
            quads.emit(OP_RINDEX,$2.arr->name,$2.loc->name,$$.loc->name);
            $$.arr = NULL;
        }
        else
        {
            // pre decrement
            quads.emit(OP_SUB,$2.loc->name,"1",$2.loc->name);
            quads.emit(OP_ASSIGN,$2.loc->name,$$.loc->name);
        }
        $$.type = $$.loc->recType;
    }
	| unary_operator cast_expression {
        Type * temp_type;
        switch($1)
        {
            case '&':
                //create a temporary type store the type
                temp_type = new Type(Tptr,1,$2.type);
                $$.loc = currSt->gentemp(CopyType(temp_type));
                $$.type = $$.loc->recType;
                quads.emit(OP_ADDREF,$2.loc->name,$$.loc->name);
                $$.arr = NULL;
                break;
            case '*':
                $$.isPointer = true;
                $$.type = $2.loc->recType->next;
                $$.loc = $2.loc;
                $$.arr = NULL;
                break;
            case '+':
                $$.loc = currSt->gentemp(CopyType($2.type));
                $$.type = $$.loc->recType;
                quads.emit(OP_ASSIGN,$2.loc->name,$$.loc->name);
                break;
            case '-':
                $$.loc = currSt->gentemp(CopyType($2.type));
                $$.type = $$.loc->recType;
                quads.emit(OP_UMINUS,$2.loc->name,$$.loc->name);
                break;
            case '~':
                /*Bitwise Not to be implemented Later on*/
                $$.loc = currSt->gentemp(CopyType($2.type));
                $$.type = $$.loc->recType;
                quads.emit(OP_NOT,$2.loc->name,$$.loc->name);
                break;
            case '!':
                $$.loc = currSt->gentemp(CopyType($2.type));
                $$.type = $$.loc->recType;
                $$.truelist = $2.falselist;
                $$.falselist = $2.truelist;
                break;
            default:
                break;
        }
    }
	| SIZEOF unary_expression	{}
	| SIZEOF RO_BRACKET_OP Typeame RO_BRACKET_CL	{}
	// {printf("unary_expression\n");}
	;

unary_operator
	: AMP 	{ $$ = '&'; }
	| MUL	{ $$ = '*'; }
	| ADD 	{ $$ = '+'; }
	| SUB 	{ $$ = '-'; }
	| NEG 	{ $$ = '~'; }
	| EXCLAIMATION 	{ $$ = '!'; }
	// {printf("unary_operator\n");}
	;

cast_expression
	: unary_expression {
	    if($1.arr != NULL && $1.arr->recType != NULL)
	    {
	        //Right Indexing of an array element as unary expression is converted into cast expression
	        $$.loc = currSt->gentemp(new Type($1.type->basetp));
	        quads.emit(OP_RINDEX,$1.arr->name,$1.loc->name,$$.loc->name);
	        $$.arr = NULL;
	        $$.type = $$.loc->recType;
	    }
	    else if($1.isPointer == true)
	    {
	        //Dereferencing as its a pointer
	        $$.loc = currSt->gentemp(CopyType($1.type));
	        $$.isPointer = false;
	        quads.emit(OP_RDEREF,$1.loc->name,$$.loc->name);
	    }
	    else
	        $$ = $1;
	}
	| RO_BRACKET_OP Typeame RO_BRACKET_CL cast_expression 	{}
	// {printf("cast_expression\n");}
	;

multiplicative_expression
	: cast_expression 	{ $$ = $1; }
	| multiplicative_expression MUL cast_expression {
        typeCheck(&$1,&$3);
        $$.loc = currSt->gentemp($1.type);
        $$.type = $$.loc->recType;
        quads.emit(OP_MULT,$1.loc->name,$3.loc->name,$$.loc->name);
	}
	| multiplicative_expression DIV cast_expression {
        typeCheck(&$1,&$3);
        $$.loc = currSt->gentemp($1.type);
        $$.type = $$.loc->recType;
        quads.emit(OP_DIV,$1.loc->name,$3.loc->name,$$.loc->name);
    }
	| multiplicative_expression MODULO cast_expression {
        typeCheck(&$1,&$3);
        $$.loc = currSt->gentemp($1.type);
        $$.type = $$.loc->recType;
        quads.emit(OP_MOD,$1.loc->name,$3.loc->name,$$.loc->name);
    }
	// {printf("multiplicative_expression\n");}
	;

additive_expression
	: multiplicative_expression { $$ = $1; }
	| additive_expression ADD multiplicative_expression {
        typeCheck(&$1,&$3);
        $$.loc = currSt->gentemp($1.type);
        $$.type = $$.loc->recType;
        quads.emit(OP_ADD,$1.loc->name,$3.loc->name,$$.loc->name);
	}
	| additive_expression SUB multiplicative_expression {
        typeCheck(&$1,&$3);
        $$.loc = currSt->gentemp($1.type);
        $$.type = $$.loc->recType;
        quads.emit(OP_SUB,$1.loc->name,$3.loc->name,$$.loc->name);
    }
	// {printf("additive_expression\n");}
	;

shift_expression
	: additive_expression { $$ = $1; }
	| shift_expression SHIFT_L additive_expression {
        $$.loc = currSt->gentemp($1.type);
        $$.type = $$.loc->recType;
        quads.emit(OP_LST,$1.loc->name,$3.loc->name,$$.loc->name);
    }
	| shift_expression SHIFT_R additive_expression {
        $$.loc = currSt->gentemp($1.type);
        $$.type = $$.loc->recType;
        quads.emit(OP_RST,$1.loc->name,$3.loc->name,$$.loc->name);
    }
	// {printf("shift_expression\n");}
	;

relational_expression
	: shift_expression { $$ = $1; }
    | relational_expression BIT_SHIFT_L shift_expression {
        typeCheck(&$1,&$3);
        $$.type = new Type(Tbool);
        $$.truelist = makelist(nextInstr);
        $$.falselist = makelist(nextInstr+1);
        quads.emit(OP_IF_LTH,$1.loc->name,$3.loc->name,"-1");
        quads.emit(OP_GOTO,"-1");
    }
	| relational_expression BIT_SHIFT_R shift_expression {
        typeCheck(&$1,&$3);
        $$.type = new Type(Tbool);
        $$.truelist = makelist(nextInstr);
        $$.falselist = makelist(nextInstr+1);
        quads.emit(OP_IF_GTH,$1.loc->name,$3.loc->name,"-1");
        quads.emit(OP_GOTO,"-1");
    }
	| relational_expression LTE shift_expression {
        typeCheck(&$1,&$3);
        $$.type = new Type(Tbool);
        $$.truelist = makelist(nextInstr);
        $$.falselist = makelist(nextInstr+1);
        quads.emit(OP_IF_LEQ,$1.loc->name,$3.loc->name,"-1");
        quads.emit(OP_GOTO,"-1");
    }
	| relational_expression GTE shift_expression {
        typeCheck(&$1,&$3);
        $$.type = new Type(Tbool);
        $$.truelist = makelist(nextInstr);
        $$.falselist = makelist(nextInstr+1);
        quads.emit(OP_IF_GEQ,$1.loc->name,$3.loc->name,"-1");
        quads.emit(OP_GOTO,"-1");
    }
	// {printf("relational_expression\n");}
	;

equality_expression
	: relational_expression { $$ = $1; }
	| equality_expression EQ relational_expression {
        typeCheck(&$1,&$3);
        $$.type = new Type(Tbool);
        $$.truelist = makelist(nextInstr);
        $$.falselist = makelist(nextInstr+1);
        quads.emit(OP_IF_EQ,$1.loc->name,$3.loc->name,"-1");
        quads.emit(OP_GOTO,"-1");
 	}
	| equality_expression NEQ relational_expression {
        typeCheck(&$1,&$3);
        $$.type = new Type(Tbool);
        $$.truelist = makelist(nextInstr);
        $$.falselist = makelist(nextInstr+1);
        quads.emit(OP_IF_NEQ,$1.loc->name,$3.loc->name,"-1");
        quads.emit(OP_GOTO,"-1");
 	}
	// {printf("equality_expression\n");}
	;

AND_expression
	: equality_expression { $$ = $1; }
	| AND_expression AMP equality_expression {
        $$.loc = currSt->gentemp($1.type);
        $$.type = $$.loc->recType;
        quads.emit(OP_LOGIC_AND,$1.loc->name,$3.loc->name,$$.loc->name);
    }
	// {printf("AND_expression\n");}
	;

exclusive_OR_expression
	: AND_expression { $$ = $1; }
	| exclusive_OR_expression BITXOR AND_expression {
        $$.loc = currSt->gentemp($1.type);
        $$.type = $$.loc->recType;
        quads.emit(OP_XOR,$1.loc->name,$3.loc->name,$$.loc->name);
    }
	// {printf("exclusive_OR_expression\n");}
	;

inclusive_OR_expression
	: exclusive_OR_expression { $$ = $1; }
	| inclusive_OR_expression BITOR exclusive_OR_expression {
        $$.loc = currSt->gentemp($1.type);
        $$.type = $$.loc->recType;
        quads.emit(OP_LOGIC_OR,$1.loc->name,$3.loc->name,$$.loc->name);
    }
	// {printf("inclusive_OR_expression\n");}
	;

logical_AND_expression
	: inclusive_OR_expression { $$ = $1; }
	| logical_AND_expression AND M inclusive_OR_expression {
	    if($1.type->basetp != Tbool)
	        conv2bool(&$1);
	    if($4.type->basetp != Tbool)
	        conv2bool(&$4);
	    backpatch($1.truelist,$3);
	    $$.type = new Type(Tbool);
	    $$.falselist = merge($1.falselist,$4.falselist);
	    $$.truelist = $4.truelist;
	}
	// {printf("logical_AND_expression\n");}
	;

logical_OR_expression
	: logical_AND_expression { $$ = $1; }
	| logical_OR_expression OR M logical_AND_expression {
        if($1.type->basetp != Tbool)
            conv2bool(&$1);
        if($4.type->basetp != Tbool)
            conv2bool(&$4);
        backpatch($1.falselist,$3);
        $$.type = new Type(Tbool);
        $$.truelist = merge($1.truelist,$4.truelist);
        $$.falselist = $4.falselist;
    }
	// {printf("logical_OR_expression\n");}
	;

conditional_expression
	: logical_OR_expression
	| logical_OR_expression N QUESTION M expression N COLON M conditional_expression {
        $$.loc = currSt->gentemp($5.type);
        $$.type = $$.loc->recType;
        quads.emit(OP_ASSIGN,$9.loc->name,$$.loc->name);
        List* TEMP_LIST = makelist(nextInstr);
        quads.emit(OP_GOTO,"-1");
        backpatch($6,nextInstr);
        quads.emit(OP_ASSIGN,$5.loc->name,$$.loc->name);
        TEMP_LIST = merge(TEMP_LIST,makelist(nextInstr));
        quads.emit(OP_GOTO,"-1");
        backpatch($2,nextInstr);
        conv2bool(&$1);
        backpatch($1.truelist,$4);
        backpatch($1.falselist,$8);
        backpatch(TEMP_LIST,nextInstr);
    }
	// {printf("conditional_expression\n");}
	;

assignment_expression
	: conditional_expression { $$ = $1; }
	| unary_expression assignment_operator assignment_expression {
        //LDereferencing
        if($1.isPointer)
        {
            quads.emit(OP_LDEREF,$3.loc->name,$1.loc->name);
        }
        typeCheck(&$1,&$3,true);
        if($1.arr != NULL)
        {
            quads.emit(OP_LINDEX,$1.loc->name,$3.loc->name,$1.arr->name);
        }
        else if(!$1.isPointer)
            quads.emit(OP_ASSIGN,$3.loc->name,$1.loc->name);
        $$.loc = currSt->gentemp($3.type);
        $$.type = $$.loc->recType;
        quads.emit(OP_ASSIGN,$3.loc->name,$$.loc->name);
    }
	// {printf("assignment_expression\n");}
	;

assignment_operator
	: ASSIGN
	// {printf("assignment_operator\n");}
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
	// {printf("assignment_operator\n");}
	;

expression
	: assignment_expression { $$ = $1; }
	| expression COMMA assignment_expression { $$ = $3; }
	// {printf("expression\n");}
	;

constant_expression
	: conditional_expression { $$ = $1; }
	// {printf("constant_expression\n");}
	;

declaration
	// : declaration_specifiers SEMICOLON
	: declaration_specifiers init_declarator_list_opt SEMICOLON {
        if($2.loc != NULL && $2.type != NULL && $2.type->basetp == Tfunc)
        {
            /*Delete currSt*/
            currSt = new SymTab();
        }
    }
	// {printf("declaration\n");}
	;


init_declarator_list_opt
	:init_declarator_list {
        if($1.type != NULL && $1.type->basetp == Tfunc)
        {
            $$ = $1;
        }
     }
     | %empty { $$.loc = NULL; }
     ;

declaration_specifiers
	: storage_class_specifier {}
	| storage_class_specifier declaration_specifiers {}
	| type_specifier {}
	| type_specifier declaration_specifiers {}
	| type_qualifier {}
	| type_qualifier declaration_specifiers {}
	| function_specifier {}
	| function_specifier declaration_specifiers {}
	// {printf("declaration_specifiers\n");}
	;

init_declarator_list
	: init_declarator { $$ = $1; }
	| init_declarator_list COMMA init_declarator
	// {printf("init_declaratoreclarator_list\n");}
	;

init_declarator
	: declarator {
        if($1.type != NULL && $1.type->basetp == Tfunc)
        {
            $$ = $1;
        }
    }
	| declarator ASSIGN initializer {
        //initializations of declarators
        typeCheck(&$1,&$3,true);
        quads.emit(OP_ASSIGN,$3.loc->name,$1.loc->name);
    }
	// {printf("init_declarator\n");}
	;

storage_class_specifier
	: EXTERN {}
	| STATIC {}
	| AUTO {}
	| REGISTER {}
	// {printf("storage_class_specifier\n");}
	;

type_specifier
	: VOID { glbType = new Type(Tvoid); }
	| CHAR { glbType = new Type(Tchar); }
	| SHORT { glbType = new Type(Tint); }
	| INT { glbType = new Type(Tint); }
	| LONG { glbType = new Type(Tint); }
	| FLOAT {  glbType = new Type(Tfloat); }
	| DOUBLE { glbType = new Type(Tfloat); }
	| SIGNED { glbType = new Type(Tint); }
	| UNSIGNED { glbType = new Type(Tint); }
	| _BOOL {}
	| _COMPLEX {}
	| _IMAGINARY {}
	| enum_specifier {}
	// {printf("type_specifier\n");}
	;



specifier_qualifier_list
	: type_specifier specifier_qualifier_list_opt {}
	| type_qualifier specifier_qualifier_list_opt {}
	// {printf("specifier_qualifier_list\n");}
	;

specifier_qualifier_list_opt
	:specifier_qualifier_list {}
	| %empty {};


enum_specifier
	: ENUM IDENTIFIER_opt CUR_BRACKET_OP enumerator_list CUR_BRACKET_CL {}
	| ENUM IDENTIFIER_opt CUR_BRACKET_OP enumerator_list COMMA CUR_BRACKET_CL {}
	| ENUM IDENTIFIER
	// {printf("enum_specifier\n");}
	;

IDENTIFIER_opt
	: IDENTIFIER {
        $$.loc  = currSt->lookup(*$1.name);
        $$.type = new Type(glbType->basetp);
	}
	| %empty {}
	;

enumerator_list
	: enumerator {}
	| enumerator_list COMMA enumerator {}
	// {printf("enumerator_list\n");}
	;

enumerator
	: IDENTIFIER {}
	| IDENTIFIER ASSIGN constant_expression {}
	// {printf("enumerator\n");}
	;

type_qualifier
	: CONST {}
	| VOLATILE {}
	| RESTRICT {}
	// {printf("type_qualifier\n");}
	;
function_specifier
	: INLINE {}
	// {printf("function_specifier\n");}
	;
declarator
	: pointer_opt direct_declarator {
        if($1.type == NULL)
        {
            /*--------------*/
        }
        else
        {
            if($2.loc->recType->basetp != Tptr)
            {
                Type * test = $1.type;
                while(test->next != NULL)
                {
                    test = test->next;
                }
                test->next = $2.loc->recType;
                $2.loc->recType = $1.type;
            }
        }

        if($2.type != NULL && $2.type->basetp == Tfunc)
        {
            $$ = $2;
        }
        else
        {
            //its not a function
            $2.loc->size = $2.loc->recType->getSize();
            $2.loc->offset = currSt->offset;
            currSt->offset += $2.loc->size;
            $$ = $2;
            $$.type = $$.loc->recType;
        }
    }
	// {printf("declarator\n");}
	;

pointer_opt
	:pointer { $$ = $1; }
	| %empty { $$.type = NULL; };


direct_declarator
	: IDENTIFIER {
        $$.loc = currSt->lookup(*$1.name);
        if($$.loc->vType == "")
        {
            //Type initialization
            $$.loc->vType = "local";
            $$.loc->recType = new Type(glbType->basetp);
        }
        $$.type = $$.loc->recType;
    }
	| RO_BRACKET_OP declarator RO_BRACKET_CL { $$ = $2; }
	| direct_declarator SQ_BRACKET_OP  type_qualifier_list_opt assignment_expression_opt SQ_BRACKET_CL {
        if($1.type->basetp == Tarray)
        {
            /*if type is already an arr*/
            Type * typ1 = $1.type,*typ = $1.type;
            typ1 = typ1->next;
            while(typ1->next != NULL)
            {
                typ1 = typ1->next;
                typ = typ->next;
            }
            typ->next = new Type(Tarray,$4.loc->initVal.int_val,typ1);
        }
        else
        {
            //add the type of array to list
            if($4.loc == NULL)
                $1.type = new Type(Tarray,-1,$1.type);
            else
                $1.type = new Type(Tarray,$4.loc->initVal.int_val,$1.type);
        }
        $$ = $1;
        $$.loc->recType = $$.type;
    }
	| direct_declarator SQ_BRACKET_OP STATIC type_qualifier_list_opt assignment_expression SQ_BRACKET_CL {}
	| direct_declarator SQ_BRACKET_OP type_qualifier_list_opt MUL SQ_BRACKET_CL {}
	| direct_declarator RO_BRACKET_OP parameter_type_list RO_BRACKET_CL {
        SymRec * new_func = glbSt->search(currSt->records[0]->name);
        if(new_func == NULL)
        {
            new_func = glbSt->lookup(currSt->records[0]->name);
            $$.loc = currSt->records[0];
            if(new_func->vType == "")
            {
                // Function declaration
                new_func->recType = CopyType(currSt->records[0]->recType);
                new_func->vType = "func";
                new_func->isInitialized = false;
                new_func->nestedTab = currSt;
                currSt->name = currSt->records[0]->name;
                currSt->records[0]->vType = "return";
                currSt->records[0]->size = currSt->records[0]->recType->getSize();
                currSt->records[0]->offset = 0;
                currSt->offset = currSt->records[0]->size;
                for(int i=1;i<currSt->records.size();i++)
                {
                    currSt->records[i]->vType = "param";
                    currSt->records[i]->offset += currSt->records[0]->size;
                    currSt->offset += currSt->records[i]->size;
                }
            }
        }
        else
        {
            currSt = new_func->nestedTab;
        }
        $$.loc = new_func;
        $$.type = new Type(Tfunc);
    }
	| direct_declarator RO_BRACKET_OP identifier_list_opt RO_BRACKET_CL  {
        SymRec * new_func = glbSt->search(currSt->records[0]->name);
        if(new_func == NULL)
        {
            new_func = glbSt->lookup(currSt->records[0]->name);
            $$.loc = currSt->records[0];
            if(new_func->vType == "")
            {
               // Func declaration
                new_func->recType = CopyType(currSt->records[0]->recType);
                new_func->vType = "func";
                new_func->isInitialized = false;
                new_func->nestedTab = currSt;
                /*Change the first element to retval and change the rest to param*/
                currSt->name = currSt->records[0]->name;
                currSt->records[0]->vType = "return";
                currSt->records[0]->size = currSt->records[0]->recType->getSize();
                currSt->records[0]->offset = 0;
                currSt->offset = currSt->records[0]->size;
            }
        }
        else
        {
            // Function is already declared
            currSt = new_func->nestedTab;
        }
        $$.loc = new_func;
        $$.type = new Type(Tfunc);
}
	// {printf("direct_declarator\n");}
	;


identifier_list_opt
	:identifier_list {}
  | %empty {}
	;

type_qualifier_list_opt
	: type_qualifier_list {}
    | %empty {}
	// {printf("type_qualifier_list_opt\n");}
	;
assignment_expression_opt
	: %empty {}
	| assignment_expression {}
	// {printf("assignment_expression_opt\n");}
	;

pointer
	: MUL type_qualifier_list_opt { $$.type = new Type(Tptr); }
	| MUL type_qualifier_list_opt pointer { $$.type = new Type(Tptr,1,$3.type); }
	// {printf("pointer\n");}
	;

type_qualifier_list
	: type_qualifier {}
	| type_qualifier_list type_qualifier {}
	// {printf("type_qualifier_list\n");}
	;


parameter_type_list
	: parameter_list {}
	| parameter_list COMMA DOTS {}
	// {printf("parameter_type_list\n");}
	;

parameter_list
	: parameter_declaration {}
	| parameter_list COMMA parameter_declaration {}
	// {printf("parameter_list\n");}
	;

parameter_declaration
	: declaration_specifiers declarator {}
	| declaration_specifiers {}
	// {printf("parameter_declaration\n");}
	;

identifier_list
	: IDENTIFIER {}
	| identifier_list COMMA IDENTIFIER {}
	// {printf("identifier_list\n");}
	;

Typeame
	: specifier_qualifier_list {}
	// {printf("Typeame\n");}
	;

initializer
	: assignment_expression { $$ = $1; }
	| CUR_BRACKET_OP initializer_list CUR_BRACKET_CL {}
	| CUR_BRACKET_OP initializer_list COMMA CUR_BRACKET_CL {}
	// {printf("initializer\n");}
	;

initializer_list
	: initializer {}
	| designation initializer {}
	| initializer_list COMMA initializer {}
	|  initializer_list COMMA designation initializer {}
	// {printf("initializer_list\n");}
	;

designation
	: designator_list ASSIGN {}
	// {printf("designation\n");}
	;

designator_list
	: designator {}
	| designator_list designator {}
	// {printf("designator_list\n");}
	;

designator
	: SQ_BRACKET_OP constant_expression SQ_BRACKET_CL {}
	| DOT IDENTIFIER {}
	// {printf("designator\n");}
	;

statement
	//Switch Case
	: labeled_statement {}
	| compound_statement { $$ = $1; }
	| expression_statement { $$ = NULL; }
	| selection_statement { $$ = $1; }
	| iteration_statement { $$ = $1; }
	| jump_statement { $$ = $1; }
	// {printf("statement\n");}
	;

labeled_statement
	: IDENTIFIER COLON statement {}
	| CASE constant_expression COLON statement {}
	| DEFAULT COLON statement {}
	// {printf("labeled_statement\n");}
	;

compound_statement
	: CUR_BRACKET_OP CUR_BRACKET_CL { $$ = NULL; }
	| CUR_BRACKET_OP block_item_list CUR_BRACKET_CL { $$ = $2; }
	// {printf("compound_statement\n");}
	;

block_item_list
	: block_item { $$ = $1; }
	| block_item_list M block_item {
        backpatch($1,$2);
        $$ = $3;
	}
	// {printf("block_item_list\n");}
	;

block_item
	: declaration { $$ = NULL; }
	| statement { $$ = $1; }
	// {printf("block_item\n");}
	;


expression_statement
	// : SEMICOLON
	: expression_opt SEMICOLON
	// {printf("expression_statement\n");}
	;


expression_opt
		:expression {
        				$$ = $1;
   							}
   	| %empty { $$.loc = NULL; }
		// expression = NULL
   	;

selection_statement
	: IF RO_BRACKET_OP expression N RO_BRACKET_CL M statement {
        /*N (B.falselist), M (B.truelist)*/
        $7 = merge($7,makelist(nextInstr));
        quads.emit(OP_GOTO,"-1");
        backpatch($4,nextInstr);
        conv2bool(&$3);
        backpatch($3.truelist,$6);
        $$ = merge($7,$3.falselist);
    }
	| IF RO_BRACKET_OP expression N RO_BRACKET_CL M statement N ELSE M statement {
        /*N1 (B.falselist), M1 (B.truelist), N2 prevents fall through, M2 is used for falselist of expression*/
        $7 = merge($7,$8);
        $11 = merge($11,makelist(nextInstr));
        quads.emit(OP_GOTO,"-1");
        backpatch($4,nextInstr);

        conv2bool(&$3);

        backpatch($3.truelist,$6);
        backpatch($3.falselist,$10);
        $$ = merge($7,$11);
    }
	| SWITCH RO_BRACKET_OP expression RO_BRACKET_CL statement {}
	// {printf("selection_statement\n");}
	;

iteration_statement
	: WHILE RO_BRACKET_OP M expression N RO_BRACKET_CL M statement {
        /*M1 (label for condition check) .'N' (generates goto for break condition). M2 (label for start of body of loop)*/
        quads.emit(OP_GOTO,$3);
        backpatch($8,$3);           /*S.nextlist to M1.instr*/
        backpatch($5,nextInstr);    /*N1.nextlist to nextInstr*/
        conv2bool(&$4);
        backpatch($4.truelist,$7);
        $$ = $4.falselist;
    }
	| DO M statement WHILE RO_BRACKET_OP M expression N RO_BRACKET_CL SEMICOLON {
        /*M1 (B.truelist). M2 i(label for condition checking statement). N prevents fall through*/
        backpatch($8,nextInstr);
        backpatch($3,$6);           /*S1.nextlist to M2.instr*/
        conv2bool(&$7);
        backpatch($7.truelist,$2);  /*B.truelist to M1.instr*/
        $$ = $7.falselist;
    }
    | FOR RO_BRACKET_OP expression_opt SEMICOLON M expression_opt N SEMICOLON M expression_opt N RO_BRACKET_CL M statement {
       /*M1 (label to check expresion). N1 (generates goto EXIT). M2 (S.nextlist) N2 (generates jump for checking condition) and M3 (B.truelist)*/
        backpatch($11,$5);          /*N2.nextlist to M1.instr*/
        backpatch($14,$9);          /*S.nextlist to M2.instr*/
        quads.emit(OP_GOTO,$9);
        backpatch($7,nextInstr);    /*N1.nextlist to nextInstr*/
        conv2bool(&$6);
        backpatch($6.truelist,$13);
        $$ = $6.falselist;
    }
	// {printf("iteration_statement\n");}
	;

jump_statement
	: GOTO IDENTIFIER SEMICOLON {}
	| CONTINUE SEMICOLON {}
	| BREAK SEMICOLON {}
	// | RETURN SEMICOLON
	| RETURN expression_opt SEMICOLON {
        if($2.loc == NULL)
            quads.emit(OP_RETURN);
        else
        {
            Expression * dummy = new Expression();
            dummy->loc = currSt->records[0];
            dummy->type = dummy->loc->recType;
            typeCheck(dummy,&$2,true);
            delete dummy;
            quads.emit(OP_RETURN,$2.loc->name);
        }
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
	| declaration
	// {printf("external_declaration\n");}
	;

function_definition
	: declaration_specifiers declarator declaration_list_opt compound_statement {
        SymRec * func = glbSt->lookup($2.loc->name);
        func->nestedTab->records[0]->recType = CopyType(func->recType);
        func->nestedTab->records[0]->name = "retVal";
        func->nestedTab->records[0]->offset = 0;
        //change offset if return pointer
        if(func->nestedTab->records[0]->recType->basetp == Tptr)
        {
            int diff = sizeOfPointer - func->nestedTab->records[0]->size;
            func->nestedTab->records[0]->size = sizeOfPointer;
            for(int i=1;i<func->nestedTab->records.size();i++)
            {
                func->nestedTab->records[i]->offset += diff;
            }
        }
        int offset_size = 0;
        for(int i=0;i<func->nestedTab->records.size();i++)
        {
            offset_size += func->nestedTab->records[i]->size;
        }
        //Create a new Current Symbol Table
        currSt = new SymTab();
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
	printf ("\nERROR: %s\n",s);
}
