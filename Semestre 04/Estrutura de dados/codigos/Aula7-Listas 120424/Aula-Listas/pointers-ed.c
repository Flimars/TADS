
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

typedef struct NodeInt {
    int dado;
    struct NodeInt* proximo;
} NodeInt;

void endereco(NodeInt* lista) {
    printf("Endereço: %p\n", lista);
}

/**
 * Aloca memória para um ponteiro de lista
 * Não funciona pois o ponteiro é passado por valor
 * Funciona para métodos que não precisam alocar memória dinamicamente
*/
void alocaErrado(NodeInt* lista) {
    lista = (NodeInt*) malloc(sizeof(NodeInt));
}

/**
 * Aloca memória para um ponteiro de lista
 * Precisa de ** para que o ponteiro seja passado por referência
*/
void alocaCorreto(NodeInt** lista) {
    *lista = (NodeInt*) malloc(sizeof(NodeInt));
}

int main() {
    NodeInt* listaValores = NULL;
    endereco(listaValores); // NULL

    alocaErrado(listaValores);
    endereco(listaValores); // NULL

    alocaCorreto(&listaValores);
    endereco(listaValores); // Endereço de memória alocado

}