#ifndef PRIMERAITERACION_SYMBOLTABLE_H
#define PRIMERAITERACION_SYMBOLTABLE_H

#include "definitions.h"

void initializeSymbolTable();
void printWorkspace();
void freeTable();

void clearVariables();

void setVariable(const char* name, double value);
int getVariable(const char* name, double* out);

#endif //PRIMERAITERACION_SYMBOLTABLE_H