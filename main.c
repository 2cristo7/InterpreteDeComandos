#include <stdio.h>

int yyparse(void);

int main() {
    printf("Mini intérprete 'echo'. Escribe 'echo algo'\n");
    yyparse();
    return 0;
}
