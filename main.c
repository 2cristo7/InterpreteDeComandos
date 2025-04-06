#include <stdio.h>
#include <stdlib.h>
#include <string.h>

extern int yyparse(void);
extern void set_quit_flag(int value);
extern int get_quit_flag(void);
extern void yy_scan_string(const char *str);
extern void yy_delete_buffer(void *b);
extern void *yy_scan_buffer(char *, size_t);

#define MAX_LINE 1024

int main() {
    char line[MAX_LINE];

    printf("Bienvenido al intérprete matemático interactivo.\n");
    printf("Escriba HELP() para ayuda, QUIT() para salir.\n");

    while (!get_quit_flag()) {
        printf("> ");
        fflush(stdout);

        if (!fgets(line, MAX_LINE, stdin)) {
            break; // EOF o error
        }

        // Enviamos esta línea al analizador
        yy_scan_string(line);
        yyparse();
    }

    printf("¡Hasta pronto!\n");
    return 0;
}
