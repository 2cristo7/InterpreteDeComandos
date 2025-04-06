%{
#include <stdio.h>
#include <stdlib.h>

void yyerror(const char *s);
int yylex(void);

int quit_flag = 0;

void set_quit_flag(int value) { quit_flag = value; }
int get_quit_flag(void) { return quit_flag; }

%}

%union {
    double num;
}

%token EOL

%token <num> NUMBER
%token PLUS MINUS TIMES DIVIDE

%token QUIT_CALL

%type <num> expr

%%

input:
    /* vacío */
  | input line
  ;

line:
    expr EOL            { printf("%.2f\n", $1); }
  | QUIT_CALL EOL       { set_quit_flag(1); }
  | EOL                 { /* línea vacía */ }
  | error EOL           { yyerror("Entrada no válida"); yyerrok; }
  ;


expr:
    expr PLUS expr      { $$ = $1 + $3; }
  | expr MINUS expr     { $$ = $1 - $3; }
  | expr TIMES expr     { $$ = $1 * $3; }
  | expr DIVIDE expr    {
                          if ($3 == 0) {
                              yyerror("División por cero");
                              $$ = 0;
                          } else {
                              $$ = $1 / $3;
                          }
                        }
  | '(' expr ')'        { $$ = $2; }
  | NUMBER              { $$ = $1; }
  ;

%%

void yyerror(const char *s) {
    fprintf(stderr, "Error: %s\n", s);
}
