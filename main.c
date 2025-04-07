#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "symbolTable.h"

extern int yyparse(void);
extern void set_quit_flag(int value);
extern int get_quit_flag(void);
extern void yy_scan_string(const char *str);
extern void yylex_destroy(void); // Limpia buffers de Flex

#define MAX_LINE 1024

int main() {

    initializeSymbolTable();

    char line[MAX_LINE];

    printf("Bienvenido al intérprete matemático interactivo.\n");
    printf("Escriba HELP() para ayuda, QUIT() para salir.\n");

    while (!get_quit_flag()) {
        printf("> ");
        fflush(stdout);

        if (!fgets(line, MAX_LINE, stdin)) {
            break;
        }

        // Saltar líneas vacías
        if (strlen(line) <= 1) continue;

        yy_scan_string(line);  // Análisis de esta línea
        yyparse();
        yylex_destroy();       // Limpia memoria de Flex para próximas líneas
    }

    printf("¡Hasta pronto!\n");

    freeTable();
    return 0;
}
