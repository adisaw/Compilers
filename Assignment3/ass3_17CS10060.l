%{
	#include <stdio.h>
	#include <string.h>
%}

%{
#define AUTO     	15 
#define BREAK   	16
#define CASE     	17
#define CHAR        18
#define CONST 		19
#define CONTINUE  	20
#define DEFAULT 	21
#define DO 			22
#define DOUBLE 		23
#define ELSE 		24
#define ENUM 		25
#define EXTERN  	26
#define FLOAT 		27
#define FOR 		28
#define GOTO 		29
#define IF 			30
#define INLINE 		31
#define INT 		32
#define LONG 		33
#define REGISTER  	34
#define RESTRICT 	35
#define RETURN 		36
#define SHORT 		37
#define SIGNED 		38
#define SIZEOF  	39
#define STATIC 		40
#define STRUCT  	41
#define SWITCH 		42
#define TYPEDEF 	43
#define UNION 		44
#define UNSIGNED 	45
#define VOID 		46
#define VOLATILE 	47
#define WHILE 		48
#define _BOOL 	 	49
#define _COMPLEX 	50
#define _IMAGINARY 	51

#define DIGIT					52
#define IDENTIFIER_NONDIGIT 	53
#define IDENTIFIER 				54

#define NONZERO_DIGIT				55
#define NONZERO_INTEGER_CONSTANT	56
#define INTEGER_CONSTANT			57
#define CONSTANT					58
#define DIGIT_SEQUENCE				59
#define SIGN 						60
#define EXPONENT_PART				61
#define FRACTIONAL_CONSTANT			62
#define FLOATING_CONSTANT			63
#define ENUMERATION_CONSTANT		64
#define ESCAPE_SEQUENCE				65
#define C_CHAR 						66
#define C_CHAR_SEQUENCE				67
#define CHARACTER_CONSTANT 			68

#define S_CHAR  			69
#define S_CHAR_SEQUENCE		70
#define STRING_LITERAL 		71

#define SQ_BRACKET_OP	72
#define SQ_BRACKET_CL	73
#define RO_BRACKET_OP	74
#define RO_BRACKET_CL	75
#define CUR_BRACKET_OP	76
#define CUR_BRACKET_CL	77
#define DOT 			78
#define ACC				79
#define INC 			80
#define DEC 			81
#define AMP 			82
#define MUL 			83
#define ADD 			84
#define SUB 			85
#define NEG 			86
#define EXCLAIMATION 	87
#define DIV 			88
#define MODULO 			89
#define SHIFT_L 		90
#define SHIFT_R 		91
#define BIT_SHIFT_L 	92
#define BIT_SHIFT_R		93
#define LTE 			94
#define GTE 			95
#define EQ 				96
#define NEQ 			97
#define AND 			98
#define OR 				99
#define QUESTION    	100
#define COLON 			101
#define SEMICOLON 		102
#define DOTS 			103
#define ASSIGN			104
#define STAR_EQ 		105
#define DIV_EQ 			106
#define MOD_EQ 			107
#define PLUS_EQ			108
#define MINUS_EQ  		109
#define SHIFT_LEQ       110
#define SHIFT_REQ 		111
#define BIN_AND_EQ 		112
#define BIN_XOR_EQ		113
#define BIN_OR_EQ 		114
#define COMMA 			115
#define HASH 			116
#define SINGLE_LINE_COMMENT	117
#define MULTI_LINE_COMMENT   	118
#define BITOR   119
#define BITXOR  120
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
MULTI_LINE_COMMENT   "/*"([^*]|\*+[^*/])*\*+"/"
SINGLE_LINE_COMMENT   "//"[^("\n")]*
COMMENT  {SINGLE_LINE_COMMENT}|{MULTI_LINE_COMMENT}


/* WHITESPACE */
WS [ \t\n]

%%
{AUTO}   { return AUTO; }
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

{PUNCTUATOR} {
 	if(strcmp(yytext,"++") == 0) return INC;
	if(strcmp(yytext,"--") == 0) return DEC;
	if(strcmp(yytext,"&") == 0) return AMP;
	if(strcmp(yytext,"*") == 0) return MUL;
	if(strcmp(yytext,"+") == 0) return ADD;
	if(strcmp(yytext,"-") == 0) return SUB;
	if(strcmp(yytext,"~") == 0) return NEG;
	if(strcmp(yytext,"!") == 0) return EXCLAIMATION;


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
	if(strcmp(yytext,"&&") == 0) return AND;
	if(strcmp(yytext,"||") == 0) return OR;
	if(strcmp(yytext,"^")==0) return BITXOR;
	if(strcmp(yytext,"|")==0) return BITOR;}

{SINGLE_LINE_COMMENT} {return SINGLE_LINE_COMMENT;}
{MULTI_LINE_COMMENT}  {return MULTI_LINE_COMMENT;}

{WS} {/*  ignore whitespace*/}
%%






