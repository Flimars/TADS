#include <stdio.h>
#include <stdlib.h>
#include <string.h>

// Declaração das estruturas
typedef struct aluno {
    char nome[100];
    int idade;
    int matricula;
    struct aluno *proximo;
} Aluno;

typedef struct lse {
    Aluno *primeiro;
    int n_elementos;
    char turma[20];
} LSE;

// Funções para gerenciar a lista
LSE* criaListaLSE(char turma[]) {
    LSE *nova = (LSE*)malloc(sizeof(LSE));  
    nova->primeiro = NULL;
    nova->n_elementos = 0;
    strcpy(nova->turma, turma);
    return nova;
}

Aluno* cadastraAluno(char nome[], int idade, int matricula) {
    Aluno *novoAluno = (Aluno*)malloc(sizeof(Aluno));
    strcpy(novoAluno->nome, nome);
    novoAluno->idade = idade;
    novoAluno->matricula = matricula;
    novoAluno->proximo = NULL;
    return novoAluno;
}

Aluno* lerAluno() {
    Aluno *novoAluno = (Aluno*)malloc(sizeof(Aluno));
    printf("\nInforme o nome do novo aluno: ");
    scanf("%s", novoAluno->nome);
    printf("Informe a idade do novo aluno: ");
    scanf("%d", &novoAluno->idade);
    printf("Informe a matricula do novo aluno: ");
    scanf("%d", &novoAluno->matricula);
    novoAluno->proximo = NULL;
    return novoAluno;
}

void mostraAluno(Aluno *aluno) {
    if (aluno != NULL) {
        printf("\n\tNome: %s", aluno->nome);
        printf("\tIdade: %d", aluno->idade);
        printf("\tMatricula: %d", aluno->matricula);
    } else {
        printf("\nErro ao imprimir Aluno. Valor = NULL\n");
    }
}

void mostraLista(LSE *ls) {
    Aluno *aux = ls->primeiro;
    printf("\n\nMostra a Lista de %s:", ls->turma);
    while (aux != NULL) {
        mostraAluno(aux);
        aux = aux->proximo;
    }
    printf("\nFim da Lista!!\n");
}

void insereNoInicio(LSE *ls, Aluno *novo) {
    if (ls->primeiro == NULL) {
        novo->proximo = NULL;
    } else {
        novo->proximo = ls->primeiro;
    }
    ls->primeiro = novo;
    ls->n_elementos++;
    printf("\nElemento %s inserido com sucesso!!!", novo->nome);
}

void insereNoFim(LSE *ls, Aluno *novo) {
    Aluno *aux = ls->primeiro;
    if (aux == NULL) {
        insereNoInicio(ls, novo);
    } else {
        while (aux->proximo != NULL) {
            aux = aux->proximo;
        }
        novo->proximo = NULL;
        aux->proximo = novo;
        ls->n_elementos++;
    }
}

// Atividade do TRBL
void insereNaPosicao(LSE *ls, Aluno *novo, int pos) {
    if (pos == 0) {
        insereNoInicio(ls, novo);
        return;
    }
    Aluno *aux = ls->primeiro;
    for (int i = 0; i < pos - 1 && aux != NULL; i++) {
        aux = aux->proximo;
    }
    if (aux == NULL) {
        printf("\nPosicao invalida!\n");
    } else {
        novo->proximo = aux->proximo;
        aux->proximo = novo;
        ls->n_elementos++;
    }
}

Aluno* removeNoInicio(LSE *ls) {
    Aluno *aux = ls->primeiro;
    if (aux == NULL) {
        printf("\n\tErro - Lista Vazia!!");
    } else {
        ls->primeiro = aux->proximo;
        aux->proximo = NULL;
        ls->n_elementos--;
    }
    return aux;
}

// Atividade do TRBL
Aluno* removeNoFim(LSE *ls) {
    if (ls->primeiro == NULL) {
        printf("\n\tErro - Lista Vazia!!");
        return NULL;
    }
    Aluno *aux = ls->primeiro;
    Aluno *anterior = NULL;
    while (aux->proximo != NULL) {
        anterior = aux;
        aux = aux->proximo;
    }
    if (anterior == NULL) {
        ls->primeiro = NULL;
    } else {
        anterior->proximo = NULL;
    }
    ls->n_elementos--;
    return aux;
}

// Atividade do TRBL
Aluno* removeNaPosicao(LSE *ls, int pos) {
    if (pos == 0) {
        return removeNoInicio(ls);
    }
    Aluno *aux = ls->primeiro;
    Aluno *anterior = NULL;
    for (int i = 0; i < pos && aux != NULL; i++) {
        anterior = aux;
        aux = aux->proximo;
    }
    if (aux == NULL) {
        printf("\nPosicao invalida!\n");
        return NULL;
    } else {
        anterior->proximo = aux->proximo;
        aux->proximo = NULL;
        ls->n_elementos--;
        return aux;
    }
}

int retornaQuantidade(LSE *ls) {
    return ls->n_elementos;
}

void mostraPosicao(LSE *ls, int pos) {
    Aluno *aux = ls->primeiro;
    for (int i = 0; i < pos && aux != NULL; i++) {
        aux = aux->proximo;
    }
    if (aux == NULL) {
        printf("\nPosicao invalida!\n");
    } else {
        mostraAluno(aux);
    }
}

void apagaLista(LSE *ls) {
    Aluno *aux = ls->primeiro;
    while (aux != NULL) {
        Aluno *temp = aux;
        aux = aux->proximo;
        free(temp);
    }
    ls->primeiro = NULL;
    ls->n_elementos = 0;
}

void menuTesteLista(LSE *lse) {
    int op = 0, posicao = 0;
    Aluno *aux = NULL;
    printf("\nMenu de operacoes sobre um LSE:\n");
    printf("\n\t1 - Insere no Inicio:");
    printf("\n\t2 - Insere no Fim:");
    printf("\n\t3 - Insere na Posicao:");
    printf("\n\t4 - Remove no Inicio:");
    printf("\n\t5 - Remove no Fim:");
    printf("\n\t6 - Remove na Posicao:");
    printf("\n\t7 - Mostra Lista:");
    printf("\n\t8 - Mostra Aluno na Posicao:");
    printf("\n\t9 - Apaga Lista:");
    printf("\n\t0 - Para Sair da Funcao Menu:");
    printf("\n\tInforme a opcao:");
    scanf("%d", &op);
    switch (op) {
        case 1:
            printf("\n\tFuncao Insere no Inicio!!");
            insereNoInicio(lse, lerAluno());
            break;
        case 2:
            printf("\n\tFuncao Insere no Fim!!");
            insereNoFim(lse, lerAluno());
            break;
        case 3:
            printf("\n\tFuncao Insere na Posicao!!");
            printf("\n\t\tInforme a posicao:");
            scanf("%d", &posicao);
            insereNaPosicao(lse, lerAluno(), posicao);
            break;
        case 4:
            printf("\n\tFuncao Remove no Inicio:");
            aux = removeNoInicio(lse);
            if (aux != NULL) {
                mostraAluno(aux);
                free(aux);
            }
            break;
        case 5:
            printf("\n\tFuncao Remove no Fim:");
            aux = removeNoFim(lse);
            if (aux != NULL) {
                mostraAluno(aux);
                free(aux);
            }
            break;
        case 6:
            printf("\n\tFuncao Remove na Posicao!!");
            printf("\n\t\tInforme a posicao:");
            scanf("%d", &posicao);
            aux = removeNaPosicao(lse, posicao);
            if (aux != NULL) {
                mostraAluno(aux);
                free(aux);
            }
            break;
        case 7:
            printf("\n\nMostra Lista %s!!!", lse->turma);
            mostraLista(lse);
            break;
        case 8:
            printf("\n\tFuncao Mostra um Aluno na Posicao - Pos!!");
            printf("\n\t\tInforme a posicao:");
            scanf("%d", &posicao);
            mostraPosicao(lse, posicao);
            break;
        case 9:
            printf("\n\tFuncao Apaga toda Lista!");
            apagaLista(lse);
            break;
        case 0:
            printf("\n\n*** Fim do Programa!!! ***\n");
            break;
        default:
            printf("\n\n*** Opcao Invalida!!! ***\n");
    }
    if (op > 0 && op < 10) {
        menuTesteLista(lse);
    }
}

// Atividade do TRBL - Funções para troca de turmas
void trocaTurmaPorMat(LSE *lmatematica, LSE *lportugues) {
    printf("\n\tTrocar um aluno da turma de Portugues para turma de Matematica");
    char nome[100];
    printf("\n\tInforme o nome do aluno:");
    scanf("%s", nome);

    Aluno *aux = lportugues->primeiro;
    Aluno *anterior = NULL;
    while (aux != NULL && strcmp(aux->nome, nome) != 0) {
        anterior = aux;
        aux = aux->proximo;
    }
    if (aux == NULL) {
        printf("\nAluno nao encontrado na turma de Portugues.\n");
        return;
    }
    if (anterior == NULL) {
        lportugues->primeiro = aux->proximo;
    } else {
        anterior->proximo = aux->proximo;
    }
    lportugues->n_elementos--;

    aux->proximo = lmatematica->primeiro;
    lmatematica->primeiro = aux;
    lmatematica->n_elementos++;

    printf("\nAluno %s trocado para a turma de Matematica.\n", nome);
}

// Atividade do TRBL  
void trocaTurmaMatPor(LSE *lmatematica, LSE *lportugues) {
    printf("\n\tTrocar um aluno da turma de Matematica para turma de Portugues");
    char nome[100];
    printf("\n\tInforme o nome do aluno:");
    scanf("%s", nome);

    Aluno *aux = lmatematica->primeiro;
    Aluno *anterior = NULL;
    while (aux != NULL && strcmp(aux->nome, nome) != 0) {
        anterior = aux;
        aux = aux->proximo;
    }
    if (aux == NULL) {
        printf("\nAluno nao encontrado na turma de Matematica.\n");
        return;
    }
    if (anterior == NULL) {
        lmatematica->primeiro = aux->proximo;
    } else {
        anterior->proximo = aux->proximo;
    }
    lmatematica->n_elementos--;

    aux->proximo = lportugues->primeiro;
    lportugues->primeiro = aux;
    lportugues->n_elementos++;

    printf("\nAluno %s trocado para a turma de Portugues.\n", nome);
}

// Atividade do TRBL
void mostrarTurmaPorMat(LSE *lmatematica, LSE *lportugues) {
    printf("\n\tMostrar as listas das turmas de Portugues e Matematica");
    mostraLista(lmatematica);
    mostraLista(lportugues);
}

void menuTrocaTurmas(LSE *lmatematica, LSE *lportugues) {
    int op = 0;
    printf("\nMenu de operacoes Troca Turmas:\n");
    printf("\nEscolha uma Opcao:");
    printf("\n\t1 - Trocar um aluno de Portugues para Matematica:");
    printf("\n\t2 - Trocar um aluno de Matematica para Portugues:");
    printf("\n\t3 - Mostrar as Turmas de Portugues e Matematica:");
    printf("\n\t0 - Para Sair do Programa:");
    printf("\n\tInforme a opcao:");
    scanf("%d", &op);
    switch (op) {
        case 1:
            trocaTurmaPorMat(lmatematica, lportugues);
            break;
        case 2:
            trocaTurmaMatPor(lmatematica, lportugues);
            break;
        case 3:
            mostrarTurmaPorMat(lmatematica, lportugues);
            break;
        case 0:
            printf("\n\n*** Fim do Programa!!! ***\n");
            break;
        default:
            printf("\n\n*** Opcao Invalida!!! ***\n");
    }
    if (op > 0 && op < 4) {
        menuTrocaTurmas(lmatematica, lportugues);
    }
}

// Programa lista de alunos de matemática
int main() {
    system("clear");

    // Cria a lista de alunos de matemática 
    LSE *listaMatematica = criaListaLSE("Matematica");

    // Cria o elemento de LSE chamado Pedro
    Aluno *pedro = cadastraAluno("Pedro", 44, 1123301);

    // Insere no início um novo aluno na lista de matemática
    insereNoInicio(listaMatematica, pedro);

    Aluno *novo = cadastraAluno("Joao", 24, 1123321);
    insereNoInicio(listaMatematica, novo);

    mostraLista(listaMatematica);
    printf("\n");

    // Primeira parte da atividade funções de lista
    menuTesteLista(listaMatematica);

    // Segunda parte da atividade - Troca de turmas
    LSE *listaPortugues = criaListaLSE("Portugues");
    menuTrocaTurmas(listaMatematica, listaPortugues);

    return 0;
}
