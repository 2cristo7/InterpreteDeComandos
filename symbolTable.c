#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <ctype.h>
#include <math.h>
#include "symbolTable.h"
#include "hashTable.h"

void initializeSymbolTable() {
    initializeHashTable(100);  // Ajusta el tamaño de la tabla hash según sea necesario

    // initilize constants
    insert("PI", T_CONSTANT, M_PI);
    insert("E", T_CONSTANT, M_E);
}

void printWorkspace() {
    printTS();
}

void clearVariables() {
    clearType(T_ID);
}

void freeTable() {
    freeHashTable();
}

void setVariable(const char* name, double value) {
    Slot slot = search(name);

    if (slot.id == -10) {
        insert(name, T_ID, value);
    }
    else if (slot.id == T_CONSTANT) {
        printf("Error: '%s' es una constante y no se puede modificar.\n", name);
    }else {
        update(name, value);
    }

    free(slot.token);  // Liberar strdup del search
}

int getVariable(const char* name, double* out) {
    Slot slot = search(name);

    if (slot.id == -10) {
        return 0;
    }

    *out = slot.value;
    free(slot.token);  // Liberar el strdup hecho en search
    return 1;
}
