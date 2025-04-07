//
// Created by usuario on 9/03/25.
//

#ifndef PRIMERAITERACION_HASHTABLE_H
#define PRIMERAITERACION_HASHTABLE_H

#include "definitions.h"

// Estructura de la tabla hash
typedef struct HashTable {
    Slot** table;
    int size;
    int count;  // Número de elementos en la tabla
} HashTable;

// Funciones de la tabla hash
void initializeHashTable(int size);
void resizeHashTable();
int hash(const char* token);
Slot search(const char* token);
void insert(const char* token, int id, double value);
int update(const char* token, double newValue);
void printTS();
void freeHashTable();

void clearType(int id);

void setVariable(const char* name, double value);
int getVariable(const char* name, double* out);

#endif //PRIMERAITERACION_HASHTABLE_H
