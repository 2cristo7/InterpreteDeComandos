%{
#include "parser.h"
#include <string.h>
%}

%%

[0-9]+(\.[0-9]+)?([eE][-+]?[0-9]+)?  { yylval.num = atof(yytext); return NUMBER; }

"+"     return PLUS;
"-"     return MINUS;
"*"     return TIMES;
"/"     return DIVIDE;

"QUIT()"    return QUIT_CALL;

[ \t]+  ; // Ignorar espacios
\n      return EOL;

.       { printf("Carácter no válido: %s\n", yytext); }

%%

int yywrap() { return 1; }
