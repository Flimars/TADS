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
} PilhaUnit;

// Implementaçao das funções auxiliares
void inicializarPilha(Pilha *p) {
    p->topo = -1;
}

void inicializarPilhaUnit(PilhaUnit *p) {
    p->ocupado = 0;
}

int pilhaCheia(Pilha *p) {
    return p->topo == MAX_DISCOS - 1;
}

int pilhaVazia(Pilha *p) {
    return p->topo == -1;
}

int pilhaUnitOcupada(PilhaUnit *p) {
    return p->ocupado;
}

void push(Pilha *p, Disco disco) {
    if (!pilhaCheia(p)) {
        p->discos[++(p->topo)] = disco;
    }
}

Disco pop(Pilha *p) {
    if (!pilhaVazia(p)) {
        return p->discos[(p->topo)--];
    }
    Disco vazio = {-1};
    return vazio;
}

void pushUnit(PilhaUnit *p, Disco disco) {
    if (!pilhaUnitOcupada(p)) {
        p->disco = disco;
        p->ocupado = 1;
    }
}

Disco popUnit(PilhaUnit *p) {
    if (pilhaUnitOcupada(p)) {
        p->ocupado = 0;
        return p->disco;
    }
    Disco vazio = {-1};
    return vazio;
}

void distribuirDiscos(Pilha *p1, Pilha *p2, Pilha *p3, Pilha *p4) {
    Disco discos[12];
    int i;

    // Inicializa os discos com cores
    for (i = 0; i < 12; i++) {
        discos[i].cor = (i / 3) + 1; // 4 cores diferentes, 3 discos de cada cor
    }

    // Embaralha os discos
    for (i = 0; i < 12; i++) {
        int j = rand() % 12;
        Disco temp = discos[i];
        discos[i] = discos[j];
        discos[j] = temp;
    }

    // Distribui os discos aleatoriamente nas pilhas
    for (i = 0; i < 12; i++) {
        if (i < 4) {
            push(p1, discos[i]);
        } else if (i < 8) {
            push(p2, discos[i]);
        } else if (i < 10) {
            push(p3, discos[i]);
        } else {
            push(p4, discos[i]);
        }
    }
}

void exibirJogo(Pilha *p1, Pilha *p2, Pilha *p3, Pilha *p4, PilhaUnit *temp1, PilhaUnit *temp2) {
    int i;

    printf("Pilha 1: ");
    for (i = 0; i <= p1->topo; i++) {
        printf("%d ", p1->discos[i].cor);
    }
    printf("\n");

    printf("Pilha 2: ");
    for (i = 0; i <= p2->topo; i++) {
        printf("%d ", p2->discos[i].cor);
    }
    printf("\n");

    printf("Pilha 3: ");
    for (i = 0; i <= p3->topo; i++) {
        printf("%d ", p3->discos[i].cor);
    }
    printf("\n");

    printf("Pilha 4: ");
    for (i = 0; i <= p4->topo; i++) {
        printf("%d ", p4->discos[i].cor);
    }
    printf("\n");

    printf("Temp1: ");
    if (pilhaUnitOcupada(temp1)) {
        printf("%d", temp1->disco.cor);
    } else {
        printf("vazio");
    }
    printf("\n");

    printf("Temp2: ");
    if (pilhaUnitOcupada(temp2)) {
        printf("%d", temp2->disco.cor);
    } else {
        printf("vazio");
    }
    printf("\n");
}


int verificarVitoria(Pilha *p1, Pilha *p2, Pilha *p3, Pilha *p4) {
    Pilha *pilhas[4] = {p1, p2, p3, p4};
    for (int i = 0; i < 4; i++) {
        if (pilhas[i]->topo == 3) {
            int cor = pilhas[i]->discos[0].cor;
            for (int j = 1; j < MAX_DISCOS; j++) {
                if (pilhas[i]->discos[j].cor != cor) {
                    return 0;
                }
            }
            return 1;
        }
    }
    return 0;
}

// Funçao principal
int main() {
    Pilha p1, p2, p3, p4;
    PilhaUnit temp1, temp2;

    inicializarPilha(&p1);
    inicializarPilha(&p2);
    inicializarPilha(&p3);
    inicializarPilha(&p4);
    inicializarPilhaUnit(&temp1);
    inicializarPilhaUnit(&temp2);

    srand(time(NULL)); // Inicializa gerador de números aleatórios

    int nivel;
    printf("Selecione o nivel do jogo (1: Facil, 2: Medio, 3: Dificil): ");
    scanf("%d", &nivel);

    int usoTemp1 = 1, usoTemp2 = 1;
    if (nivel == 2) {
        usoTemp2 = 0;
    } else if (nivel == 3) {
        usoTemp1 = 0;
        usoTemp2 = 0;
    }

    distribuirDiscos(&p1, &p2, &p3, &p4); // Distribui os discos nas pilhas

    time_t inicio, fim;
    time(&inicio);

    int movimento = 0;
    while (1) {
        printf("Jogo Atual:\n");
        exibirJogo(&p1, &p2, &p3, &p4,usoTemp1 ? &temp1 : NULL, usoTemp2 ? &temp2 : NULL);
        
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
                printf("Movimento invalido!\n");
            }

        } else if (movimento == 2 && usoTemp1) {
            int x, temp;
            printf("Digite a pilha de origem (x) e o temporario (1 ou 2): ");
            scanf("%d %d", &x, &temp);

            Pilha *origem = NULL;
            PilhaUnit *temporario = NULL;
            switch (x) {
                case 1: origem = &p1; break;
                case 2: origem = &p2; break;
                case 3: origem = &p3; break;
                case 4: origem = &p4; break;
            }
            // switch (temp) {
            //     case 1: temporario = &temp1; break;
            //     case 2: temporario = &temp2; break;
            // }
             if (temp == 1 && usoTemp1) {
                temporario = &temp1;
            } else if (temp == 2 && usoTemp2) {
                temporario = &temp2;
            }

            if (origem && temporario && !pilhaVazia(origem) && !pilhaUnitOcupada(temporario)) {
                Disco disco = pop(origem);
                pushUnit(temporario, disco);
            } else {
                printf("Movimento invalido!\n");
            }

        } else if (movimento == 3) {
            int temp, x;
            printf("Digite o temporario (1 ou 2) e a pilha de destino (x): ");
            scanf("%d %d", &temp, &x);

            PilhaUnit *temporario = NULL;
            Pilha *destino = NULL;
            // switch (temp) {
            //     case 1: temporario = &temp1; break;
            //     case 2: temporario = &temp2; break;
            // }
            switch (x) {
                case 1: destino = &p1; break;
                case 2: destino = &p2; break;
                case 3: destino = &p3; break;
                case 4: destino = &p4; break;
            }

            if (temp == 1 && usoTemp1) {
                temporario = &temp1;
            } else if (temp == 2 && usoTemp2) {
                temporario = &temp2;
            }

            if (temporario && destino && pilhaUnitOcupada(temporario) && !pilhaCheia(destino)) {
                Disco disco = popUnit(temporario);
                push(destino, disco);
            } else {
                printf("Movimento invalido!\n");
            }
        } else {
            printf("Movimento invalido ou nao permitido para o nivel selecionado!\n");
        }

        if (verificarVitoria(&p1, &p2, &p3, &p4)) {
            printf("Parabens, voce venceu!\n");
            break;
        }
    }

    time(&fim);
    double tempo = difftime(fim, inicio);
    printf("Tempo de jogo: %.2f segundos\n", tempo);
    
    return 0;
}
