%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

void yyerror(const char *s);
int yylex(void);
%}

%union {
    char *str;
}

%token TK_ECHO
%token <str> TEXT
%token EOL
%type <str> text_list

%%

input:
    /* vacío */
    | input line
    ;

line:
    TK_ECHO text_list EOL    { printf("%s\n", $2); free($2); }
    | EOL                 { /* línea vacía */ }
    | error EOL           { yyerror("Comando no reconocido"); yyerrok; }
    ;

text_list:
    TEXT                  { $$ = strdup($1); }
    | text_list TEXT      {
                            $$ = malloc(strlen($1) + strlen($2) + 2);
                            sprintf($$, "%s %s", $1, $2);
                            free($1); free($2);
                          }
    ;

%%

void yyerror(const char *s) {
    fprintf(stderr, "Error: %s\n", s);
}
