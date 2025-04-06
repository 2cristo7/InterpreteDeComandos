%{
#include "parser.h"
#include <string.h>
%}


DIGITO      [0-9]
INT         -?{DIGITO}+
FLOAT       -?{DIGITO}*\.{DIGITO}+
HEXA        0[xX][0-9a-fA-F]+
CIENTIFIC   -?{DIGITO}*(\.{DIGITO}*)?([eE][\+\-]?{DIGITO}+)
COMPLEX     -?{DIGITO}*(\.{DIGITO}*)?([eE][\+\-]?{DIGITO}+)?i

%%

{CIENTIFIC}    { yylval.num = atof(yytext); return NUMBER; }
{FLOAT}        { yylval.num = atof(yytext); return NUMBER; }
{INT}          { yylval.num = atof(yytext); return NUMBER; }
{HEXA}         { yylval.num = (double)strtol(yytext, NULL, 16); return NUMBER; }



"+"     return PLUS;
"-"     return MINUS;
"*"     return TIMES;
"/"     return DIVIDE;
"("     return '(';
")"     return ')';


QUIT[ \t]*\(\)     return QUIT_CALL;


[ \t]+  ; // Ignorar espacios
\n      return EOL;

.       { printf("Carácter no válido: %s\n", yytext); }


%%

int yywrap() { return 1; }
