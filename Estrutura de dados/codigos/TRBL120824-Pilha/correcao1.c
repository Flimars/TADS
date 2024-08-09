#include <stdio.h>

#define MAX 4

typedef struct {
    int tamanho;
    // Outros atributos do disco
} Disco;

typedef struct {
    Disco discos[MAX];
    int topo;
} Pilha;

// Função pilhaCheia
int pilhaCheia(Pilha *p) {
    return p->topo == MAX - 1;
}

// Função push
void push(Pilha *p, Disco disco) {
    if (!pilhaCheia(p)) {
        p->discos[++(p->topo)] = disco;
    } else {
        printf("Pilha cheia!\n");
    }
}

// Função pop
Disco pop(Pilha *p) {
    if (p->topo >= 0) {
        return p->discos[(p->topo)--];
    } else {
        Disco vazio = {0}; // Disco "vazio" para retornar em caso de pilha vazia
        printf("Pilha vazia!\n");
        return vazio;
    }
}

// Exibir pilhas
void exibirJogo(Pilha *p1, Pilha *p2, Pilha *p3, Pilha *p4, Pilha *temp1, Pilha *temp2) {
    for (int i = 0; i <= p1->topo; i++) {
        printf("%d ", p1->discos[i].tamanho); // Acesse o campo correto
    }
    printf("\n");
    // Repita para as outras pilhas...
}

int main() {
    // Implementação do jogo
    return 0;
}
