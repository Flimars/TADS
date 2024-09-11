#include <stdio.h>
#include <stdlib.h>
#include <string.h>

// Definição de uma estrutura para armazenar os elementos da tabela hash
typedef struct No {
    char ip[16];
    char dominio[100];
    struct No* prox;
} No;

// Definição da estrutura da tabela hash
#define TAMANHO 7
No* tabelaHashIP[TAMANHO];
No* tabelaHashDominio[TAMANHO];

// Tabela de colisões
No* tabelaColisoes[TAMANHO];

// Função hash simples para IPs e domínios
int hash(char* chave) {
    int soma = 0;
    for (int i = 0; chave[i] != '\0'; i++) {
        soma += chave[i];
    }
    return soma % TAMANHO;
}

// Função para inserir um novo elemento na tabela hash
void inserir(char* ip, char* dominio, No* tabela[], No* tabelaColisoes[]) {
    int indiceIP = hash(ip);
    int indiceDominio = hash(dominio);

    No* novoNoIP = (No*)malloc(sizeof(No));
    strcpy(novoNoIP->ip, ip);
    strcpy(novoNoIP->dominio, dominio);
    novoNoIP->prox = NULL;

    No* novoNoDominio = (No*)malloc(sizeof(No));
    strcpy(novoNoDominio->ip, ip);
    strcpy(novoNoDominio->dominio, dominio);
    novoNoDominio->prox = NULL;

    // Verificando colisão na tabela de IPs
    if (tabela[indiceIP] != NULL) {
        // Colisão detectada
        novoNoIP->prox = tabela[indiceIP];
        tabelaColisoes[indiceIP] = novoNoIP;
    } else {
        tabela[indiceIP] = novoNoIP;
    }

    // Verificando colisão na tabela de domínios
    if (tabela[indiceDominio] != NULL) {
        // Colisão detectada
        novoNoDominio->prox = tabela[indiceDominio];
        tabelaColisoes[indiceDominio] = novoNoDominio;
    } else {
        tabela[indiceDominio] = novoNoDominio;
    }
}

// Função para imprimir uma tabela hash
void imprimirTabela(No* tabela[]) {
    for (int i = 0; i < TAMANHO; i++) {
        printf("Indice %d:\n", i);
        No* atual = tabela[i];
        while (atual != NULL) {
            printf("IP: %s, Dominio: %s\n", atual->ip, atual->dominio);
            atual = atual->prox;
        }
    }
}

// Função para imprimir a tabela de colisões
void imprimirTabelaColisoes(No* tabela[]) {
    printf("Tabela de Colisoes:\n");
    imprimirTabela(tabela);
}

int main() {
    // Inicializando as tabelas
    for (int i = 0; i < TAMANHO; i++) {
        tabelaHashIP[i] = NULL;
        tabelaHashDominio[i] = NULL;
        tabelaColisoes[i] = NULL;
    }

    int opcao;
    char ip[16];
    char dominio[100];

    do {
        printf("\nMenu:\n");
        printf("1. Inserir novo site\n");
        printf("2. Imprimir tabela de IPs\n");
        printf("3. Imprimir tabela de dominios\n");
        printf("4. Imprimir tabela de colisoes\n");
        printf("0. Sair\n");
        printf("Escolha uma opcao: ");
        scanf("%d", &opcao);

        switch (opcao) {
            case 1:
                printf("Digite o IP: ");
                scanf("%s", ip);
                printf("Digite o dominio: ");
                scanf("%s", dominio);
                inserir(ip, dominio, tabelaHashIP, tabelaColisoes);
                inserir(dominio, ip, tabelaHashDominio, tabelaColisoes);
                break;
            case 2:
                printf("Tabela Hash por IP:\n");
                imprimirTabela(tabelaHashIP);
                break;
            case 3:
                printf("Tabela Hash por Dominio:\n");
                imprimirTabela(tabelaHashDominio);
                break;
            case 4:
                imprimirTabelaColisoes(tabelaColisoes);
                break;
            case 0:
                printf("Saindo...\n");
                break;
            default:
                printf("Opcao invalida!\n");
                break;
        }
    } while (opcao != 0);

    return 0;
}
