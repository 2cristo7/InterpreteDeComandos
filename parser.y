%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <math.h>

void yyerror(const char *s);
int yylex(void);

int quit_flag = 0;

void set_quit_flag(int value) { quit_flag = value; }
int get_quit_flag(void) { return quit_flag; }

// Estructura básica para variables (simplificada)
typedef struct variable {
    char *name;
    double value;
    struct variable *next;
} variable;

variable *var_table = NULL;

void set_variable(const char *name, double val) {
    variable *v = var_table;
    while (v) {
        if (strcmp(v->name, name) == 0) {
            v->value = val;
            return;
        }
        v = v->next;
    }
    v = malloc(sizeof(variable));
    v->name = strdup(name);
    v->value = val;
    v->next = var_table;
    var_table = v;
}

int get_variable(const char *name, double *out) {
    variable *v = var_table;
    while (v) {
        if (strcmp(v->name, name) == 0) {
            *out = v->value;
            return 1;
        }
        v = v->next;
    }
    return 0;
}
%}

%union {
    double num;
    char *str;
}

%token <num> NUMBER
%token <str> ID
%token PLUS MINUS TIMES DIVIDE EOL QUIT_CALL
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
  | EOL
  | error EOL            { yyerror("Entrada no válida"); yyerrok; }
  ;

assignment:
    ID '=' expr {
        set_variable($1, $3);
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
                            if (get_variable($1, &val)) {
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
