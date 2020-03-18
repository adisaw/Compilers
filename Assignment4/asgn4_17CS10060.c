//Aditya Sawant 17CS10060
#include <stdio.h>
#include "y.tab.h"

int yydebug = 1;
extern char* yytext;
extern int yyparse();

int main() 
{
  int token;
  yyparse();
  return 0;
}
