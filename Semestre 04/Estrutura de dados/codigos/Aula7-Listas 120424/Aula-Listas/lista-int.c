#include <stdio.h>
#include <stdlib.h>
#include <string.h>

typedef struct NodeInt {
    int dado;
    struct NodeInt* proximo;
} NodeInt;

void adicionaValor(NodeInt **lista, int valor) {
    NodeInt* novo =  (NodeInt*) malloc(sizeof(NodeInt));
    novo->proximo = NULL;
    novo->dado = valor;

    if (*lista == NULL) {
        *lista = novo;
        return;
    }

    NodeInt* ultimo = *lista;
    while (ultimo->proximo != NULL) {
        ultimo = ultimo->proximo;
    }
    ultimo->proximo = novo;
}

void mostraLista(NodeInt* lista) {
    if (lista == NULL) {
        printf("LISTA VAZIA\n");
        return;
    }

    while (lista != NULL) {
        printf("%d\n", lista->dado);
        lista = lista->proximo;
    }
}

int main() {
    NodeInt* listaValores = NULL;

    // listaValores = (NodeInt*) malloc(sizeof(NodeInt));
    // listaValores->dado = 10;
    // listaValores->proximo = (NodeInt*) malloc(sizeof(NodeInt));
    // listaValores->proximo->dado = 20;
    // listaValores->proximo->proximo = (NodeInt*) malloc(sizeof(NodeInt));
    // listaValores->proximo->proximo->dado = 30;

    mostraLista(listaValores);

    printf("\n\nAdicionando mais 3 valores\n\n");
    
    adicionaValor(&listaValores, 10);
    adicionaValor(&listaValores, 20);
    adicionaValor(&listaValores, 30);

    // NodeInt* atual;
    // atual = listaValores;
    // printf("%d\n", atual->dado);
    // atual = atual->proximo;
    // printf("%d\n", atual->dado);    
    // atual = atual->proximo;
    // printf("%d\n", atual->dado);

    mostraLista(listaValores);    
    
    printf("\n\nAdicionando mais 2 valores\n\n");
    
    adicionaValor(&listaValores, 40);
    adicionaValor(&listaValores, 50);

    mostraLista(listaValores);    

    // adicionaValor(listaValores, 10);
    // adicionaValor(listaValores, 20);
    // adicionaValor(listaValores, 30);

    // mostraLista(listaValores);
}