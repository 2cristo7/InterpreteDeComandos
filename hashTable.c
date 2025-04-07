#include "hashTable.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

static HashTable* hashTable = NULL;

void initializeHashTable(int size) {
    hashTable = (HashTable*)malloc(sizeof(HashTable));
    hashTable->size = size;
    hashTable->count = 0;
    hashTable->table = (Slot**)malloc(sizeof(Slot*) * size);

    // Inicializar las entradas de la tabla
    for (int i = 0; i < size; i++) {
        hashTable->table[i] = NULL;
    }
}

// Función de hash
int hash(const char* token) {
    unsigned long hashValue = 0;
    int c;

    while ((c = *token++)) {
        hashValue = (hashValue * 31) + c;  // Función de hash básica
    }

    return hashValue % hashTable->size;
}

// Buscar un token en la tabla hash
Slot search(const char* token) {
    int index = hash(token);
    Slot* s = hashTable->table[index];
    Slot result;

    result.id = -10;       // Token no encontrado
    result.token = NULL;
    result.value = 0.0;

    while (s) {
        if (strcmp(s->token, token) == 0) {
            result.id = s->id;
            result.token = strdup(s->token);  // OK
            result.value = s->value;          // ✅ añadimos esto
            break;
        }
        s = s->next;
    }

    return result;
}


// Insertar un token en la tabla hash
void insert(const char* token, int id, double value) {
    // Si la tabla está demasiado llena, la redimensionamos
    if (hashTable->count >= hashTable->size * 0.7) {  // Umbral del 70%
        resizeHashTable(hashTable);
    }

    int index = hash(token);

    // Buscar si el token ya existe
    if (search(token).id != -10) {
        return;  // El token ya está en la tabla
    }

    // Si no existe, crear un nuevo slot y agregarlo
    Slot* newSlot = (Slot*)malloc(sizeof(Slot));
    newSlot->token = strdup(token);

    if (newSlot->token == NULL) {
        printf("Error al asignar memoria para el token.\n");
        free(newSlot);
        return;
    }

    newSlot->id = id;  // Asignar el ID
    newSlot->value = value;
    newSlot->next = hashTable->table[index];  // Insertar al principio de la lista
    hashTable->table[index] = newSlot;

    hashTable->count++;  // Incrementar el contador de elementos
}

int update(const char* token, double newValue) {
    int index = hash(token);
    Slot* s = hashTable->table[index];
    while (s) {
        if (strcmp(s->token, token) == 0) {
            s->value = newValue;
            return 1;
        }
        s = s->next;
    }
    return 0;
}

// Función para redimensionar la tabla hash
void resizeHashTable() {
    int newSize = hashTable->size * 2;  // Doblamos el tamaño de la tabla
    Slot** newTable = (Slot**)malloc(sizeof(Slot*) * newSize);

    // Inicializar la nueva tabla
    for (int i = 0; i < newSize; i++) {
        newTable[i] = NULL;
    }

    // Reinsertar los elementos en la nueva tabla
    for (int i = 0; i < hashTable->size; i++) {
        Slot* slot = hashTable->table[i];
        while (slot != NULL) {
            int newIndex = hash(slot->token) % newSize;  // Recalcular el hash con el nuevo tamaño
            Slot* newSlot = (Slot*)malloc(sizeof(Slot));
            newSlot->token = strdup(slot->token);
            newSlot->id = slot->id;
            newSlot->next = newTable[newIndex];
            newTable[newIndex] = newSlot;
            slot = slot->next;
        }
    }

    // Liberar la memoria de la tabla vieja
    free(hashTable->table);
    hashTable->table = newTable;
    hashTable->size = newSize;
}


// Imprimir toda la tabla hash
void printTS() {
    if (hashTable == NULL) {
        printf("La tabla de símbolos no está inicializada.\n");
        return;
    }

    if (hashTable->size == 0) {
        printf("\n----- Workspace vacío -----\n");
    }
    else {
        printf("\n----- Variables definidas -----\n");
        for (int i = 0; i < hashTable->size; i++) {
            Slot* slot = hashTable->table[i];
            while (slot != NULL) {
                if (slot->id == T_ID) {
                    printf("%s = %f\n", slot->token, slot->value);
                }
                slot = slot->next;
            }
        }
        printf("-------------------------------\n");
    }

}

void clearType(int id) {
    if (hashTable == NULL) return;

    for (int i = 0; i < hashTable->size; i++) {
        Slot* current = hashTable->table[i];
        Slot* prev = NULL;

        while (current != NULL) {
            if (current->id == id) {
                // Eliminar este nodo
                Slot* toDelete = current;
                if (prev == NULL) {
                    hashTable->table[i] = current->next;
                    current = hashTable->table[i];
                } else {
                    prev->next = current->next;
                    current = current->next;
                }

                free(toDelete->token);
                free(toDelete);
                hashTable->count--;
            } else {
                prev = current;
                current = current->next;
            }
        }
    }
}

// Liberar la memoria de la tabla hash
void freeHashTable() {
    if (hashTable == NULL) {
        return;
    }

    // Liberar cada "Slot" en la tabla
    for (int i = 0; i < hashTable->size; i++) {
        Slot* slot = hashTable->table[i];

        while (slot != NULL) {
            Slot* temp = slot;  // Guardar el nodo actual
            slot = slot->next;  // Mover al siguiente nodo
            free(temp->token);  // Liberar el token (cadena)
            free(temp);         // Liberar el nodo Slot
        }
    }

    // Liberar la tabla en sí
    free(hashTable->table);
    free(hashTable);  // Liberar la estructura de la tabla hash
    hashTable = NULL; // Asegurar que el puntero se ponga a NULL después de liberarlo
}