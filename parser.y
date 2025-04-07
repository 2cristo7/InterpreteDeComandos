%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <math.h>

#include "symbolTable.h"

void yyerror(const char *s);
int yylex(void);

int quit_flag = 0;

void set_quit_flag(int value) { quit_flag = value; }
int get_quit_flag(void) { return quit_flag; }
%}

%union {
    double num;
    char *str;
}


%token EOL

%token QUIT_CALL
%token WORKSPACE_CALL
%token CLEAR_CALL

%token <num> NUMBER
%token <str> ID

%token PLUS MINUS TIMES DIVIDE

%left PLUS MINUS
%left TIMES DIVIDE
%right UMINUS

%type <num> expr assignment

%%

input:
    /* vacío */
  | input line
  ;

line:
    assignment EOL       { printf("%.2f\n", $1); }
  | expr EOL             { printf("%.2f\n", $1); }
  | QUIT_CALL EOL        { set_quit_flag(1); }
  | WORKSPACE_CALL EOL   { printWorkspace(); }
  | CLEAR_CALL EOL       { clearVariables(); printf("Variables eliminadas.\n");}
  | EOL
  | error EOL            { yyerror("Entrada no válida"); yyerrok; }
  ;

assignment:
    ID '=' expr {
        setVariable($1, $3);
        $$ = $3;
        free($1);
    }
  ;

expr:
    expr PLUS expr       { $$ = $1 + $3; }
  | expr MINUS expr      { $$ = $1 - $3; }
  | expr TIMES expr      { $$ = $1 * $3; }
  | expr DIVIDE expr     {
                            if ($3 == 0) {
                                yyerror("División por cero");
                                $$ = 0;
                            } else {
                                $$ = $1 / $3;
                            }
                          }
  | MINUS expr %prec UMINUS { $$ = -$2; }
  | '(' expr ')'         { $$ = $2; }
  | NUMBER               { $$ = $1; }
  | ID                   {
                            double val;
                            if (getVariable($1, &val)) {
                                $$ = val;
                            } else {
                                yyerror("Variable no definida");
                                $$ = 0;
                            }
                            free($1);
                         }
;


%%

void yyerror(const char *s) {
    fprintf(stderr, "Error: %s\n", s);
}
