#include <stdio.h>
#include <stdlib.h>
#include <time.h>

#define MAX_DISCOS 4  // Cada pilha pode ter no máximo 4 discos
#define NUM_CORES 4   // Número de cores diferentes

// Estrutura do disco
typedef struct {
    int cor;
} Disco;

// Estrutura da pilha
typedef struct {
    Disco discos[MAX_DISCOS];
    int topo;
} Pilha;

// Funções auxiliares para manipulação das pilhas
void inicializarPilha(Pilha *p);
int pilhaVazia(Pilha *p);
int pilhaCheia(Pilha *p);
void push(Pilha *p, Disco disco);
Disco pop(Pilha *p);
void exibirJogo(Pilha *p1, Pilha *p2, Pilha *p3, Pilha *p4, Pilha *temp1, Pilha *temp2);
void distribuirDiscos(Pilha *p1, Pilha *p2, Pilha *p3, Pilha *p4);

// Função principal
int main() {
    srand(time(NULL));  // Inicializa a semente para números aleatórios

    Pilha p1, p2, p3, p4, temp1, temp2;
    inicializarPilha(&p1);
    inicializarPilha(&p2);
    inicializarPilha(&p3);
    inicializarPilha(&p4);
    inicializarPilha(&temp1);
    inicializarPilha(&temp2);

    distribuirDiscos(&p1, &p2, &p3, &p4);

    int movimento = 0;
    while (1) {
        printf("Jogo Atual:\n");
        exibirJogo(&p1, &p2, &p3, &p4, &temp1, &temp2);

        printf("\nDigite seu movimento (1: PUSH pilha x e POP pilha y, 2: PUSH pilha x e POP para temporario, 3: PUSH do temporario e POP na pilha x, 0: Sair): ");
        scanf("%d", &movimento);

        if (movimento == 0) {
            break;
        } else if (movimento == 1) {
            int x, y;
            printf("Digite a pilha de origem (y) e a pilha de destino (x): ");
            scanf("%d %d", &y, &x);

            Pilha *origem = NULL, *destino = NULL;
            switch (y) {
                case 1: origem = &p1; break;
                case 2: origem = &p2; break;
                case 3: origem = &p3; break;
                case 4: origem = &p4; break;
            }
            switch (x) {
                case 1: destino = &p1; break;
                case 2: destino = &p2; break;
                case 3: destino = &p3; break;
                case 4: destino = &p4; break;
            }

            if (origem && destino && !pilhaVazia(origem) && !pilhaCheia(destino)) {
                Disco disco = pop(origem);
                push(destino, disco);
            } else {
                printf("Movimento inválido!\n");
            }

        } else if (movimento == 2) {
            int x, temp;
            printf("Digite a pilha de origem (x) e o temporário (1 ou 2): ");
            scanf("%d %d", &x, &temp);

            Pilha *origem = NULL, *temporario = NULL;
            switch (x) {
                case 1: origem = &p1; break;
                case 2: origem = &p2; break;
                case 3: origem = &p3; break;
                case 4: origem = &p4; break;
            }
            switch (temp) {
                case 1: temporario = &temp1; break;
                case 2: temporario = &temp2; break;
            }

            if (origem && temporario && !pilhaVazia(origem) && pilhaVazia(temporario)) {
                Disco disco = pop(origem);
                push(temporario, disco);
            } else {
                printf("Movimento inválido!\n");
            }

        } else if (movimento == 3) {
            int temp, x;
            printf("Digite o temporário (1 ou 2) e a pilha de destino (x): ");
            scanf("%d %d", &temp, &x);

            Pilha *temporario = NULL, *destino = NULL;
            switch (temp) {
                case 1: temporario = &temp1; break;
                case 2: temporario = &temp2; break;
            }
            switch (x) {
                case 1: destino = &p1; break;
                case 2: destino = &p2; break;
                case 3: destino = &p3; break;
                case 4: destino = &p4; break;
            }

            if (temporario && destino && !pilhaVazia(temporario) && !pilhaCheia(destino)) {
                Disco disco = pop(temporario);
                push(destino, disco);
            } else {
                printf("Movimento inválido!\n");
            }
        }
    }

    return 0;
}

// Implementação das funções auxiliares
void inicializarPilha(Pilha *p) {
    p->topo = -1;
}

int pilhaVazia(Pilha *p) {
    return p->topo == -1;
}

int pilhaCheia(Pilha *p) {
    return p->topo == MAX_DISCOS - 1;
}

void push(Pilha *p, Disco disco) {
    if (!pilhaCheia(p)) {
        p->discos[++(p->topo)] = disco;
    } else {
        printf("Pilha cheia!\n");
    }
}

Disco pop(Pilha *p) {
    if (!pilhaVazia(p)) {
        return p->discos[(p->topo)--];
    } else {
        printf("Pilha vazia!\n");
        Disco vazio;
        vazio.cor = -1;  // Indica um disco inválido
        return vazio;
    }
}

void exibirJogo(Pilha *p1, Pilha *p2, Pilha *p3, Pilha *p4, Pilha *temp1, Pilha *temp2) {
    printf("P1: ");
    for (int i = 0; i <= p1->topo; i++) printf("%d ", p1->discos[i].cor);
    printf("\n");

    printf("P2: ");
    for (int i = 0; i <= p2->topo; i++) printf("%d ", p2->discos[i].cor);
    printf("\n");

    printf("P3: ");
    for (int i = 0; i <= p3->topo; i++) printf("%d ", p3->discos[i].cor);
    printf("\n");

    printf("P4: ");
    for (int i = 0; i <= p4->topo; i++) printf("%d ", p4->discos[i].cor);
    printf("\n");

    printf("Temp1: ");
    for (int i = 0; i <= temp1->topo; i++) printf("%d ", temp1->discos[i].cor);
    printf("\n");

    printf("Temp2: ");
    for (int i = 0; i <= temp2->topo; i++) printf("%d ", temp2->discos[i].cor);
    printf("\n");
}

void distribuirDiscos(Pilha *p1, Pilha *p2, Pilha *p3, Pilha *p4) {
    int cores[NUM_CORES * MAX_DISCOS];
    int index = 0;

    // Preencher o array de cores
    for (int i = 0; i < NUM_CORES; i++) {
        for (int j = 0; j < MAX_DISCOS; j++) {
            cores[index++] = i + 1;
        }
    }

    // Embaralhar as cores
    for (int i = 0; i < NUM_CORES * MAX_DISCOS; i++) {
        int j = rand() % (NUM_CORES * MAX_DISCOS);
        int temp = cores[i];
        cores[i] = cores[j];
        cores[j] = temp;
    }

    // Distribuir as cores nas pilhas
    index = 0;
    for (int i = 0; i < MAX_DISCOS; i++) {
        push(p1, (Disco){cores[index++]});
        push(p2, (Disco){cores[index++]});
        push(p3, (Disco){cores[index++]});
        push(p4, (Disco){cores[index++]});
    }
}
