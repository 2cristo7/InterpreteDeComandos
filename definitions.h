#ifndef PRIMERAITERACION_DEFINITIONS_H
#define PRIMERAITERACION_DEFINITIONS_H

// Definir la estructura Slot que se compartirá entre varios archivos
typedef struct Slot {
    char *token;
    int id;
    double value;
    struct Slot *next;
} Slot;

#define T_ID 350
#define T_CONSTANT 351

///////////////////// OTHERS
#define T_ERROR -100
#define T_EOF -1
#define T_CR 1


#endif //PRIMERAITERACION_DEFINITIONS_H