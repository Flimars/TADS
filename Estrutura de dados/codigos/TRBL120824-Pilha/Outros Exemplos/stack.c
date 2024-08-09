#include <stdio.h>
#include <stdlib.h>

#define MAX 100 // Tamanho máximo da pilha

typedef struct {
    int topo;
    int elementos[MAX];
} Pilha;

// Função para inicializar a pilha
void inicializaPilha(Pilha *p) {
    p->topo = -1;
}

// Função para verificar se a pilha está vazia
int isEmpty(Pilha *p) {
    return p->topo == -1;
}

// Função para verificar se a pilha está cheia
int isFull(Pilha *p) {
    return p->topo == MAX - 1;
}

// Função para empilhar (push) um elemento
void push(Pilha *p, int valor) {
    if (isFull(p)) {
        printf("Erro: Pilha cheia!\n");
        return;
    }
    p->elementos[++(p->topo)] = valor;
}

// Função para desempilhar (pop) um elemento
int pop(Pilha *p) {
    if (isEmpty(p)) {
        printf("Erro: Pilha vazia!\n");
        return -1;
    }
    return p->elementos[(p->topo)--];
}

// Função para visualizar o elemento no topo da pilha
int peek(Pilha *p) {
    if (isEmpty(p)) {
        printf("Pilha vazia!\n");
        return -1;
    }
    return p->elementos[p->topo];
}

// Função principal para testar a pilha
int main() {
    Pilha p;
    inicializaPilha(&p);

    push(&p, 10);
    push(&p, 20);
    push(&p, 30);

    printf("Elemento no topo: %d\n", peek(&p));

    printf("Desempilhando: %d\n", pop(&p));
    printf("Desempilhando: %d\n", pop(&p));

    printf("Elemento no topo: %d\n", peek(&p));

    return 0;
}
