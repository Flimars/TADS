#include <stdio.h>
#include <stdlib.h>
#include <time.h>

#define MAX_DISCOS 4 // Define o número máximo de discos em cada pilha
#define NUM_CORES 4  // Define o número de cores disponíveis

// Structs
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

// Funções auxiliares para manipulação das pilhas
void inicializarPilha(Pilha *p);
void inicializarPilhaUnit(PilhaUnit *p);
void pushUnit(PilhaUnit *p, Disco disco);
void exibirJogo(Pilha *p1, Pilha *p2, Pilha *p3, Pilha *p4, PilhaUnit *temp1, PilhaUnit *temp2);
void distribuirDiscos(Pilha *p1, Pilha *p2, Pilha *p3, Pilha *p4);
void push(Pilha *p, Disco disco);
int pilhaUnitOcupada(PilhaUnit *p);
int pilhaVazia(Pilha *p);
int pilhaCheia(Pilha *p);
Disco pop(Pilha *p);
Disco popUnit(PilhaUnit *p);

// Função principal
int main() {

    srand(time(NULL));  // Inicializa a semente para números aleatórios

    Pilha p1, p2, p3, p4;
    PilhaUnit temp1, temp2;

    inicializarPilha(&p1);
    inicializarPilha(&p2);
    inicializarPilha(&p3);
    inicializarPilha(&p4);

    inicializarPilhaUnit(&temp1);
    inicializarPilhaUnit(&temp2);

    // Exemplo de movimentação de discos e exibição do jogo
     distribuirDiscos(&p1, &p2, &p3, &p4);
    //Disco d1 = {1}, d2 = {2}, d3 = {3}, d4 = {4};

    push(&p1, d1);
    push(&p2, d2);
    pushUnit(&temp1, pop(&p1));
    push(&p3, popUnit(&temp1));

    exibirJogo(&p1, &p2, &p3, &p4, &temp1, &temp2);

    return 0;
}

// Implementação das funções auxiliares
void inicializarPilha(Pilha *p) {
    p->topo = -1;
}

void inicializarPilhaUnit(PilhaUnit *p) {
    p->ocupado = 0; // Pilha unitária começa vazia
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
    Disco vazio = {-1}; // Indica erro
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
    Disco vazio = {-1}; // Indica erro
    return vazio;
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
