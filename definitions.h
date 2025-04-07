#ifndef PRIMERAITERACION_DEFINITIONS_H
#define PRIMERAITERACION_DEFINITIONS_H

// Definir la estructura Slot que se compartirá entre varios archivos
typedef struct Slot {
    char *token;
    int id;
    double value;
    struct Slot *next;
} Slot;

///////////////////// ALSO IN TS
#define T_ID 350
#define T_DATATYPE 351

///////////////////// NOT IN TS
#define T_OPERATOR 352
#define T_DELIMITER 353
#define T_COMMENT 354
#define T_STRING 355
#define T_COLON 356
#define T_INCREMENT 357
#define T_DECREMENT 358
// Numbers
#define T_INT 360
#define T_FLOAT 361
#define T_HEXA 362
#define T_CIENTIFIC 363
#define T_COMPLEX 634

///////////////////// OTHERS
#define T_ERROR -100
#define T_EOF -1
#define T_CR 1


#endif //PRIMERAITERACION_DEFINITIONS_H