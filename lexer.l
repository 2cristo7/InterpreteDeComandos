%{
#include "parser.h"  // generado por Bison
#include <string.h>
%}

%%
echo                return TK_ECHO;
[ \t]+              ; // Ignorar espacios
\n                  return EOL;
[^ \t\n]+           { yylval.str = strdup(yytext); return TEXT; }
.                   return yytext[0];
%%

int yywrap() {
    return 1;
}
