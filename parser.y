%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <math.h>

#include "symbolTable.h"

extern FILE *yyin;

void yyerror(const char *s);
int yylex(void);

int quit_flag = 0;
int echo_enabled = 1;

void set_echo(int value) { echo_enabled = value; }
int get_echo() { return echo_enabled; }

void set_quit_flag(int value) { quit_flag = value; }
int get_quit_flag(void) { return quit_flag; }

void yyrestart(FILE *input_file);
%}

%union {
    double num;
    char *str;
}


%token EOL

%token QUIT_CALL
%token WORKSPACE_CALL
%token CLEAR_CALL
%token HELP_CALL
%token CLEAN_CALL

%token ECHO_ON ECHO_OFF
%token SEMICOLON

%token <str> LOAD_CALL

%token <str> ECHO_PRINT

%token <num> NUMBER
%token <str> ID

%token PLUS MINUS TIMES DIVIDE POWER

%left PLUS MINUS
%left TIMES DIVIDE
%right POWER
%right UMINUS

%type <num> expr
%type <num> assignment
%type <num> func_call
%type <num> line_end


%%

input:
    /* vacío */
  | input line
  ;

line:
    assignment line_end       { if (get_echo() && $2) printf("%.2f\n", $1); }
  | expr line_end             { if (get_echo() && $2) printf("%.2f\n", $1); }
  | QUIT_CALL line_end        { set_quit_flag(1); }
  | WORKSPACE_CALL line_end   { printWorkspace(); }
  | CLEAR_CALL line_end       { clearVariables(); printf("Variables eliminadas.\n");}
  | HELP_CALL line_end {
      printf("------ AYUDA ------\n");
      printf("Este es un intérprete de expresiones matemáticas.\n");
      printf("Comandos disponibles:\n");
      printf(" - QUIT()       : Salir del programa\n");
      printf(" - HELP()       : Mostrar esta ayuda\n");
      printf(" - CLEAR()      : Borrar todas las variables\n");
      printf(" - CLEAN()      : Limpiar la ventana de comandos\n");
      printf(" - WORKSPACE()  : Ver variables definidas\n");
      printf(" - ECHO ON/OFF()  : Activa o desactiva el ECHO\n");
      printf("\tPara descativarlo solo para 1 comando, terminarlo con un ';'\n");
      printf(" - LOAD(\"archivo.txt\") : Ejecutar comandos desde archivo\n");
      printf("También puedes usar:\n");
      printf(" - Variables: a = 3, a + 1\n");
      printf(" - Constantes: PI, E\n");
      printf(" - Operaciones básicas: +, -, *, /, ^\n");
      printf(" - Funciones: sin(), cos(), log(), min() y max()\n");
      printf("-------------------\n");
  }
  | CLEAN_CALL line_end {
      system("clear");  // En Linux/macOS
  }
  | ECHO_ON line_end  { set_echo(1); printf("ECHO activado.\n"); }
  | ECHO_OFF line_end { set_echo(0); printf("ECHO desactivado.\n"); }
  | LOAD_CALL line_end {
      char filename[1024];
      if (sscanf($1, "LOAD(\"%1023[^\"]\")", filename) != 1) {
          fprintf(stderr, "Error de formato en LOAD\n");
      } else {
          FILE *f = fopen(filename, "r");
          if (!f) {
              fprintf(stderr, "Error al abrir archivo: %s\n", filename);
          } else {
              printf("ARCHIVO ABIERTO\n");
              yyin = f;
              yyrestart(yyin);
          }
      }
      free($1);
  }
  | ECHO_PRINT line_end {
        // Imprimir el mensaje sin las comillas
        size_t len = strlen($1);
        if (len >= 2 && $1[0] == '"' && $1[len - 1] == '"') {
            $1[len - 1] = '\0'; // quitar última comilla
            printf("%s\n", $1 + 1); // quitar primera comilla
        } else {
            printf("%s\n", $1); // seguridad si falta comilla
        }
        free($1);
  }
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
  | expr POWER expr { $$ = pow($1, $3); }
  | MINUS expr %prec UMINUS { $$ = -$2; }
  | '(' expr ')'         { $$ = $2; }
  | NUMBER               { $$ = $1; }
  | func_call              { $$ = $1; }
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

func_call:
    ID '(' expr ')' {
        double result;

        if (strcmp($1, "sin") == 0) result = sin($3);
        else if (strcmp($1, "cos") == 0) result = cos($3);
        else if (strcmp($1, "tan") == 0) result = tan($3);
        else if (strcmp($1, "log") == 0) result = log($3);
        else if (strcmp($1, "exp") == 0) result = exp($3);
        else {
            yyerror("Función desconocida o número de argumentos incorrecto.");
            result = 0;
        }

        free($1);
        $$ = result;
    }

  | ID '(' expr ',' expr ')' {
        double result;

        if (strcmp($1, "min") == 0) result = fmin($3, $5);
        else if (strcmp($1, "max") == 0) result = fmax($3, $5);
        else {
            yyerror("Función desconocida o número de argumentos incorrecto.");
            result = 0;
        }

        free($1);
        $$ = result;
    }
;
line_end:
    EOL             { $$ = 1; }   // mostrar resultado
  | SEMICOLON       { $$ = 0; }   // no mostrar resultado
;



%%

void yyerror(const char *s) {
    fprintf(stderr, "Error: %s\n", s);
}
