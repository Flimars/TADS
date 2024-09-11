#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include <locale.h>

#define MAX_PILHA 4
#define NUM_CORES 4
#define NUM_DISCOS 12

typedef struct {
    int topo;
    int discos[MAX_PILHA];
} Pilha;

// Funções de manipulação da pilha
void inicializarPilha(Pilha *p) {
    p->topo = -1;
}

int isEmpty(Pilha *p) {
    return p->topo == -1;
}

int isFull(Pilha *p) {
    return p->topo == MAX_PILHA - 1;
}

void push(Pilha *p, int cor) {
    if (!isFull(p)) {
        p->discos[++(p->topo)] = cor;
    }
}

int pop(Pilha *p) {
    if (!isEmpty(p)) {
        return p->discos[(p->topo)--];
    }
    return -1; // Valor de erro
}

int peek(Pilha *p) {
    if (!isEmpty(p)) {
        return p->discos[p->topo];
    }
    return -1; // Valor de erro
}

// Função para mostrar o estado atual das pilhas
void mostrarPilhas(Pilha pilhas[], Pilha temp1, Pilha temp2) {
    printf("\nEstado das Pilhas:");
    for (int i = 0; i < 4; i++) {
        printf("\nPilha %d: ", i + 1);
        for (int j = 0; j <= pilhas[i].topo; j++) {
            printf("%d ", pilhas[i].discos[j]);
        }
    }
    printf("\nTemporario 1: ");
    if (!isEmpty(&temp1)) {
        printf("%d", peek(&temp1));
    }
    printf("\nTemporario 2: ");
    if (!isEmpty(&temp2)) {
        printf("%d", peek(&temp2));
    }
    printf("\n");
}

// Função para inicializar o jogo com discos distribuídos aleatoriamente
void inicializarJogo(Pilha pilhas[]) {
    int discos[NUM_DISCOS];
    for (int i = 0; i < NUM_DISCOS; i++) {
        discos[i] = i % NUM_CORES + 1; // Distribui cores de 1 a 4
    }
    // Embaralha os discos
    for (int i = NUM_DISCOS - 1; i > 0; i--) {
        int j = rand() % (i + 1);
        int temp = discos[i];
        discos[i] = discos[j];
        discos[j] = temp;
    }
    // Coloca os discos nas pilhas
    int discoIndex = 0;
    for (int i = 0; i < 4; i++) {
        for (int j = 0; j < MAX_PILHA; j++) {
            push(&pilhas[i], discos[discoIndex++]);
        }
    }
}

// Função para mover discos entre pilhas e temporários
void moverDisco(Pilha *origem, Pilha *destino) {
    if (!isEmpty(origem) && (isEmpty(destino) || peek(origem) == peek(destino))) {
        int disco = pop(origem);
        push(destino, disco);
    }
}

int main() {

    setlocale(LC_ALL, "Portuguese_Brazil");

    srand(time(NULL));
    Pilha pilhas[4];
    Pilha temp1, temp2;
    for (int i = 0; i < 4; i++) {
        inicializarPilha(&pilhas[i]);
    }
    inicializarPilha(&temp1);
    inicializarPilha(&temp2);

    inicializarJogo(pilhas);
    mostrarPilhas(pilhas, temp1, temp2);

    time_t inicio, fim;
    time(&inicio);

    int op, origem, destino;
    do {
        printf("\n1. Mover da pilha para pilha");
        printf("\n2. Mover da pilha para temporario");
        printf("\n3. Mover do temporario para pilha");
        printf("\n0. Sair");
        printf("\nEscolha uma opcao: ");
        scanf("%d", &op);

        switch (op) {
            case 1:
                printf("Mover da pilha (1-4): ");
                scanf("%d", &origem);
                printf("Para pilha (1-4): ");
                scanf("%d", &destino);
                moverDisco(&pilhas[origem - 1], &pilhas[destino - 1]);
                break;
            case 2:
                printf("Mover da pilha (1-4): ");
                scanf("%d", &origem);
                printf("Para temporario (1-2): ");
                scanf("%d", &destino);
                moverDisco(&pilhas[origem - 1], destino == 1 ? &temp1 : &temp2);
                break;
            case 3:
                printf("Mover do temporario (1-2): ");
                scanf("%d", &origem);
                printf("Para pilha (1-4): ");
                scanf("%d", &destino);
                moverDisco(origem == 1 ? &temp1 : &temp2, &pilhas[destino - 1]);
                break;
            case 0:
                break;
            default:
                printf("Opcao invalida!\n");
        }

        mostrarPilhas(pilhas, temp1, temp2);

        // Verifica se o jogador venceu
        int venceu = 0;
        for (int i = 0; i < 4; i++) {
            int cor = peek(&pilhas[i]);
            if (!isEmpty(&pilhas[i]) && pilhas[i].topo == 3) {
                venceu = 1;
                for (int j = 0; j < MAX_PILHA; j++) {
                    if (pilhas[i].discos[j] != cor) {
                        venceu = 0;
                        break;
                    }
                }
            }
            if (venceu) {
                break;
            }
        }

        if (venceu) {
            printf("Parabens, voce venceu!\n");
            break;
        }
    } while (op != 0);

    time(&fim);
    double tempo = difftime(fim, inicio);
    printf("Tempo de jogo: %.2f segundos\n", tempo);

    return 0;
}
