%{
#include "parser.h"
#include <string.h>
#include <stdlib.h>
%}

DIGITO      [0-9]
LETRA       [a-zA-Z_]
ID          {LETRA}({LETRA}|{DIGITO})*
INT         {DIGITO}+
FLOAT       {DIGITO}*\.{DIGITO}+
CIENTIFIC   {DIGITO}*(\.{DIGITO}*)?([eE][+-]?{DIGITO}+)
HEXA        0[xX][0-9a-fA-F]+

%%

"Q"             return QUIT_CALL;
"WORKSPACE()"   return WORKSPACE_CALL;
"CLEAR()"       return CLEAR_CALL;

{CIENTIFIC}     { yylval.num = atof(yytext); return NUMBER; }
{FLOAT}         { yylval.num = atof(yytext); return NUMBER; }
{INT}           { yylval.num = atof(yytext); return NUMBER; }
{HEXA}          { yylval.num = (double)strtol(yytext, NULL, 16); return NUMBER; }

{ID}            { yylval.str = strdup(yytext); return ID; }


"+"             return PLUS;
"-"             return MINUS;
"*"             return TIMES;
"/"             return DIVIDE;
"("             return '(';
")"             return ')';

"="             return '=';

[ \t]+          ;
\n              return EOL;

.               { printf("Carácter no válido: %s\n", yytext); }

%%

int yywrap() { return 1; }
