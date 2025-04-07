%{
#include "parser.h"
#include <string.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
%}
%option noinput nounput


DIGITO      [0-9]
LETRA       [a-zA-Z_]
ID          {LETRA}({LETRA}|{DIGITO})*
INT         {DIGITO}+
FLOAT       {DIGITO}*\.{DIGITO}+
CIENTIFIC   {DIGITO}*(\.{DIGITO}*)?([eE][+-]?{DIGITO}+)
HEXA        0[xX][0-9a-fA-F]+

%%

"QUIT()"        return QUIT_CALL;
"WORKSPACE()"   return WORKSPACE_CALL;
"CLEAR()"       return CLEAR_CALL;
"HELP()"        return HELP_CALL;
"CLEAN()"       return CLEAN_CALL;

ECHO[ \t]+ON     return ECHO_ON;
ECHO[ \t]+OFF    return ECHO_OFF;

{CIENTIFIC}     { yylval.num = atof(yytext); return NUMBER; }
{FLOAT}         { yylval.num = atof(yytext); return NUMBER; }
{INT}           { yylval.num = atof(yytext); return NUMBER; }
{HEXA}          { yylval.num = (double)strtol(yytext, NULL, 16); return NUMBER; }

{ID}            { yylval.str = strdup(yytext); return ID; }

LOAD\(\"[^"]+\"\)     {
    yylval.str = strdup(yytext);
    return LOAD_CALL;
}

echo[ \t]+\"[^\"]*\"    {
    yylval.str = strdup(yytext + 5);  // salta "echo "
    return ECHO_PRINT;
}



"+"             return PLUS;
"-"             return MINUS;
"*"             return TIMES;
"/"             return DIVIDE;
"^"             return POWER;
"("             return '(';
")"             return ')';

","             return ',';

"="             return '=';

";"             return SEMICOLON;


[ \t]+          ;
\n              return EOL;

.               { printf("Carácter no válido: %s\n", yytext); }

%%

int yywrap() { return 1; }
