#include <stdio.h>
#include <stdlib.h>
#include <time.h>

#define MAX_DISCOS 4
#define NUM_CORES 4

//Structs
typedef struct {
    int cor;
} Disco;

typedef struct {
    Disco discos[MAX_DISCOS];
    int topo;
} Pilha;

typedef struct {
    Disco disco;
    int ocupado;
} Temporario;

// Funções para manipular a pilha
void inicializarPilha(Pilha *p) {
    p->topo = -1;
}

int pilhaVazia(Pilha *p) {
    return p->topo == -1;
}

int pilhaCheia(Pilha *p) {
    return p->topo == MAX - 1;
}

int push(Pilha *p, int disco) {
    if (pilhaCheia(p)) {
        return 0;
    }
    p->discos[++(p->topo)] = disco;
    return 1;
}

int pop(Pilha *p) {
    if (pilhaVazia(p)) {
        return -1;
    }
    return p->discos[(p->topo)--];
}

// Inicialização do Jogo
void inicializarJogo(Pilha *p1, Pilha *p2, Pilha *p3, Pilha *p4) {
    int cores[12] = {1, 2, 3, 4, 1, 2, 3, 4, 1, 2, 3, 4};
    srand(time(NULL));

    for (int i = 11; i > 0; i--) {
        int j = rand() % (i + 1);
        int temp = cores[i];
        cores[i] = cores[j];
        cores[j] = temp;
    }

    for (int i = 0; i < 12; i++) {
        if (i < 4) push(p1, cores[i]);
        else if (i < 8) push(p2, cores[i]);
        else if (i < 10) push(p3, cores[i]);
        else push(p4, cores[i]);
    }
}

//Exibindo o Estado do Jogo
void exibirJogo(Pilha *p1, Pilha *p2, Pilha *p3, Pilha *p4, Pilha *temp1, Pilha *temp2) {
    printf("P1: ");
    for (int i = 0; i <= p1->topo; i++) {
        printf("%d ", p1->discos[i]);
    }
    printf("\n");

    printf("P2: ");
    for (int i = 0; i <= p2->topo; i++) {
        printf("%d ", p2->discos[i]);
    }
    printf("\n");

    printf("P3: ");
    for (int i = 0; i <= p3->topo; i++) {
        printf("%d ", p3->discos[i]);
    }
    printf("\n");

    printf("P4: ");
    for (int i = 0; i <= p4->topo; i++) {
        printf("%d ", p4->discos[i]);
    }
    printf("\n");

    printf("Temp1: ");
    if (!pilhaVazia(temp1)) {
        printf("%d", temp1->discos[temp1->topo]);
    }
    printf("\n");

    printf("Temp2: ");
    if (!pilhaVazia(temp2)) {
        printf("%d", temp2->discos[temp2->topo]);
    }
    printf("\n");
}

// Movimentação dos Discos
void moverDisco(Pilha *origem, Pilha *destino) {
    int disco = pop(origem);
    if (disco != -1) {
        if (!push(destino, disco)) {
            printf("Erro: Não foi possível mover o disco para a pilha destino.\n");
        }
    } else {
        printf("Erro: A pilha origem está vazia.\n");
    }
}

// Implementação do Jogo
int main() {
    Pilha p1, p2, p3, p4, temp1, temp2;
    inicializarPilha(&p1);
    inicializarPilha(&p2);
    inicializarPilha(&p3);
    inicializarPilha(&p4);
    inicializarPilha(&temp1);
    inicializarPilha(&temp2);

    inicializarJogo(&p1, &p2, &p3, &p4);

    int opcao;
    while (1) {
        exibirJogo(&p1, &p2, &p3, &p4, &temp1, &temp2);

        printf("Escolha uma ação:\n");
        printf("1. Mover disco de P1 para P2\n");
        printf("2. Mover disco de P1 para Temp1\n");
        printf("0. Sair\n");
        scanf("%d", &opcao);

        switch (opcao) {
            case 1:
                moverDisco(&p1, &p2);
                break;
            case 2:
                moverDisco(&p1, &temp1);
                break;
            case 0:
                exit(0);
                break;
            default:
                printf("Opção inválida.\n");
        }
    }

    return 0;
}
