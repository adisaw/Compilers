%{
	#include <stdio.h>
	#include <string.h>
	#include "y.tab.h"
	#include<math.h>
	extern void yyerror(const char*);
%}



/*KEYWORDS*/
AUTO 		"auto"
BREAK 		"break"
CASE 		"case"
CHAR 		"char"
CONST 		"const"
CONTINUE 	"continue"
DEFAULT 	"default"
DO 			"do"
DOUBLE 		"double"
ELSE 		"else"
ENUM 		"enum"
EXTERN 		"extern"
FLOAT 		"float"
FOR 		"for"
GOTO 		"goto"
IF 			"if"
INLINE 		"inline"
INT 		"int"
LONG 		"long"
REGISTER 	"register"
RESTRICT 	"restrict"
RETURN 		"return"
SHORT 		"short"
SIGNED 		"signed"
SIZEOF 		"sizeof"
STATIC 		"static"
STRUCT 		"struct"
SWITCH 		"switch"
TYPEDEF 	"typedef"
UNION 		"union"
UNSIGNED	"unsigned"
VOID 		"void"
VOLATILE 	"volatile"
WHILE 		"while"
_BOOL 		"_Bool"
_COMPLEX 	"_Complex"
_IMAGINARY 	"_Imaginary"

/* IDENTIFIERS */
DIGIT  [0-9]
IDENTIFIER_NONDIGIT  [a-zA-Z_]
IDENTIFIER      {IDENTIFIER_NONDIGIT}({IDENTIFIER_NONDIGIT}|{DIGIT})*


/*CONSTANTS*/
CONSTANT   {INTEGER_CONSTANT}|{FLOATING_CONSTANT}|{ENUMERATION_CONSTANT}|{CHARACTER_CONSTANT}
NONZERO_DIGIT  [1-9]
NONZERO_INTEGER_CONSTANT  {NONZERO_DIGIT}({NONZERO_DIGIT}|{DIGIT})*
INTEGER_CONSTANT {NONZERO_INTEGER_CONSTANT}|"0"
SIGN  "+"|"-"
DIGIT_SEQUENCE  [0-9]+
EXPONENT_PART   ("e"{SIGN}?{DIGIT_SEQUENCE})|("E"{SIGN}?{DIGIT_SEQUENCE})
FRACTIONAL_CONSTANT  ({DIGIT_SEQUENCE}?"."{DIGIT_SEQUENCE})|({DIGIT_SEQUENCE}".")
FLOATING_CONSTANT    ({FRACTIONAL_CONSTANT}{EXPONENT_PART}?)|({DIGIT_SEQUENCE}{EXPONENT_PART})
ENUMERATION_CONSTANT  {IDENTIFIER}
ESCAPE_SEQUENCE  "\'"|"\""|"\?"|"\\"|"\a"|"\b"|"\f"|"\n"|"\r"|"\t"|"\v"
C_CHAR   {ESCAPE_SEQUENCE}|[^("\'"|"\\"|"\n")]
C_CHAR_SEQUENCE   {C_CHAR}+
CHARACTER_CONSTANT  '{C_CHAR_SEQUENCE}'

/*STRING LITERALS*/
S_CHAR  {ESCAPE_SEQUENCE}|[^("\""|"\\"|"\n")]
S_CHAR_SEQUENCE    {S_CHAR}+
STRING_LITERAL    \"{S_CHAR_SEQUENCE}?\"

/*PUNCTUATOR */

PUNCTUATORONE     "["|"]"|"("|")"|"{"|"}"|"."|"->"
PUNCTUATORTWO   "++"|"--"|"&"|"*"|"+"|"-"|"~"|"!"
PUNCTUATORTHREE  "/"|"%"|"<<"|">>"|"<"|">"|"<="|">="|"=="|"!="|"^"|"|"|"&&"|"||"
PUNCTUATORFOUR  "?"|":"|";"|"..."|","|"#" 
PUNCTUATORFIVE "="|"*="|"/="|"%="|"+="|"-="|"<<="|">>="|"&="|"^="|"|="
PUNCTUATOR     {PUNCTUATORONE}|{PUNCTUATORTWO}|{PUNCTUATORTHREE}|{PUNCTUATORFOUR}|{PUNCTUATORFIVE}


/* COMMENTS */
COMMENT  {SINGLE_LINE_COMMENT}|{MULTI_LINE_COMMENT}
MULTI_LINE_COMMENT   "/*"([^*]|\*+[^*/])*\*+"/"
SINGLE_LINE_COMMENT   "//"[^("\n")]*



/* WHITESPACE */
WS [ \t\n]

%%
{AUTO}   { return AUTO;}
{BREAK}  {return BREAK;}
{CASE}  {return CASE;}
{CHAR}  {return CHAR;}
{CONST} {return CONST;}
{CONTINUE} {return CONTINUE;}
{DEFAULT} {return DEFAULT;}
{DO} {return DO;}
{DOUBLE} {return DOUBLE;}
{ELSE} {return ELSE;}
{ENUM} {return ENUM;}
{EXTERN} {return EXTERN;}
{FLOAT} {return FLOAT;}
{FOR} {return FOR;}
{GOTO} {return GOTO;}
{IF} { return IF;}
{INLINE} {return INLINE;}
{INT} {return INT;}
{LONG} {return LONG;}
{REGISTER} {return REGISTER;}
{RESTRICT} {return RESTRICT;}
{RETURN} {return RETURN;}
{SHORT} {return SHORT;}
{SIGNED} {return SIGNED;}
{SIZEOF} {return SIZEOF;}
{STATIC} {return STATIC;}
{STRUCT} {return STRUCT;}
{SWITCH} {return SWITCH;}
{TYPEDEF} {return TYPEDEF;}
{UNION} {return UNION;}
{UNSIGNED} {return UNSIGNED;}
{VOID} {return VOID;}
{VOLATILE} {return VOLATILE;}
{WHILE} {return WHILE;}
{_BOOL} {return _BOOL;}
{_COMPLEX} {return _COMPLEX;}
{_IMAGINARY} {return _IMAGINARY;}

{IDENTIFIER} {return IDENTIFIER;}

{INTEGER_CONSTANT} {return INTEGER_CONSTANT;}
{FLOATING_CONSTANT} {return FLOATING_CONSTANT;}
{CHARACTER_CONSTANT} {return CHARACTER_CONSTANT;}
{STRING_LITERAL} {return STRING_LITERAL;}
{COMMENT} {/*ignore*/}
{PUNCTUATOR} {
 	if(strcmp(yytext,"++") == 0) return INC;
	if(strcmp(yytext,"--") == 0) return DEC;
	if(strcmp(yytext,"&") == 0) return AMP;
	if(strcmp(yytext,"*") == 0) return MUL;
	if(strcmp(yytext,"+") == 0) return ADD;
	if(strcmp(yytext,"-") == 0) return SUB;
	if(strcmp(yytext,"~") == 0) return NEG;
	if(strcmp(yytext,"!") == 0) return EXCLAIMATION;
	if(strcmp(yytext,"|") == 0) return BITOR;

	if(strcmp(yytext,"?") == 0) return QUESTION;
	if(strcmp(yytext,":") == 0) return COLON;
	if(strcmp(yytext,";") == 0) return SEMICOLON;
	if(strcmp(yytext,"...") == 0) return DOTS;
	if(strcmp(yytext,"=") == 0) return ASSIGN;
	if(strcmp(yytext,"*=") == 0) return STAR_EQ;
	if(strcmp(yytext,"/=") == 0) return DIV_EQ;
	if(strcmp(yytext,"%=") == 0) return MOD_EQ;
	if(strcmp(yytext,"+=") == 0) return PLUS_EQ;
	if(strcmp(yytext,"-=") == 0) return MINUS_EQ;
	if(strcmp(yytext,"<<=") == 0) return SHIFT_LEQ;
	if(strcmp(yytext,">>=") == 0) return SHIFT_REQ;
	if(strcmp(yytext,"&=") == 0) return BIN_AND_EQ;
	if(strcmp(yytext,"^=") == 0) return BIN_XOR_EQ;
	if(strcmp(yytext,"|=") == 0) return BIN_OR_EQ;
	
	if(strcmp(yytext,",") == 0) return COMMA;
	if(strcmp(yytext,"#") == 0) return HASH;

	if(strcmp(yytext,"[") == 0) return SQ_BRACKET_OP;
	if(strcmp(yytext,"]") == 0) return SQ_BRACKET_CL;
	if(strcmp(yytext,"(") == 0) return RO_BRACKET_OP;
	if(strcmp(yytext,")") == 0) return RO_BRACKET_CL;
	if(strcmp(yytext,"{") == 0) return CUR_BRACKET_OP;
	if(strcmp(yytext,"}") == 0) return CUR_BRACKET_CL;
	if(strcmp(yytext,".") == 0) return DOT;
	
	if(strcmp(yytext,"->") == 0) return ACC;


	if(strcmp(yytext,"/") == 0) return DIV;
	if(strcmp(yytext,"%") == 0) return MODULO;
	if(strcmp(yytext,"<<") == 0) return SHIFT_L;
	if(strcmp(yytext,">>") == 0) return SHIFT_R;
	if(strcmp(yytext,"<") == 0) return BIT_SHIFT_L;
	if(strcmp(yytext,">") == 0) return BIT_SHIFT_R;
	if(strcmp(yytext,"<=") == 0) return LTE;
	if(strcmp(yytext,">=") == 0) return GTE;
	if(strcmp(yytext,"==") == 0) return EQ;
	if(strcmp(yytext,"!=") == 0) return NEQ;
	if(strcmp(yytext,"^")==0)return BITXOR;
	if(strcmp(yytext,"&&") == 0) return AND;
	if(strcmp(yytext,"||") == 0) return OR;
}
{WS} {/*  ignore whitespace*/}

%%






