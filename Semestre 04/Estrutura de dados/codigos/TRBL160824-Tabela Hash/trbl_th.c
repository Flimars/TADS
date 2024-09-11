#include <stdio.h>
#include <stdlib.h>
#include <string.h>

// Define o tamanho máximo para as tabelas hash
#define TAMANHO_TABELA 7

// Estrutura que representa um nó na lista encadeada
typedef struct No {
    char ip[16]; // Armazena o endereço IP
    char dominio[50]; // Armazena o domínio
    struct No* proximo; // Ponteiro para o próximo nó na lista
} No;

// Função hash que calcula o índice da tabela com base no endereço IP
int hashIP(char* ip) {
    int hash = 0;
    while (*ip) {
        hash += *ip; // Soma os valores ASCII dos caracteres do IP
        ip++;
    }
    return hash % TAMANHO_TABELA; // Retorna o índice na tabela hash
}

// Função hash que calcula o índice da tabela com base no domínio
int hashDominio(char* dominio) {
    int hash = 0;
    while (*dominio) {
        hash += *dominio; // Soma os valores ASCII dos caracteres do domínio
        dominio++;
    }
    return hash % TAMANHO_TABELA; // Retorna o índice na tabela hash
}

// Função para inserir um novo nó na lista encadeada
void inserirNo(No** tabela, char* ip, char* dominio, int (*hashFunc)(char*)) {
    int indice = hashFunc(ip); // Calcula o índice usando a função hash
    No* novoNo = (No*)malloc(sizeof(No)); // Aloca memória para o novo nó
    strcpy(novoNo->ip, ip); // Copia o IP para o novo nó
    strcpy(novoNo->dominio, dominio); // Copia o domínio para o novo nó
    novoNo->proximo = tabela[indice]; // Aponta para o nó atual da tabela
    tabela[indice] = novoNo; // Insere o novo nó na tabela
}

// Função para remover um nó da tabela hash
void removerNo(No** tabela, char* chave, int (*hashFunc)(char*), int porIP) {
    int indice = hashFunc(chave); // Calcula o índice usando a função hash
    No* atual = tabela[indice];
    No* anterior = NULL;

    // Percorre a lista no índice da tabela hash
    while (atual != NULL) {
        if ((porIP && strcmp(atual->ip, chave) == 0) || 
            (!porIP && strcmp(atual->dominio, chave) == 0)) {
            // Se o nó atual contém a chave, remove-o da lista
            if (anterior == NULL) {
                tabela[indice] = atual->proximo;
            } else {
                anterior->proximo = atual->proximo;
            }
            free(atual); // Libera a memória do nó removido
            return;
        }
        anterior = atual;
        atual = atual->proximo;
    }
}

// Função para buscar um IP na tabela hash usando o domínio
char* buscarIP(No** tabela, char* dominio) {
    int indice = hashDominio(dominio); // Calcula o índice usando a função hash para domínios
    No* atual = tabela[indice]; // Obtém a lista no índice calculado

    // Percorre a lista no índice da tabela hash
    while (atual != NULL) {
        if (strcmp(atual->dominio, dominio) == 0) {
            // Se o domínio for encontrado, retorna o IP correspondente
            return atual->ip;
        }
        atual = atual->proximo;
    }
    return NULL; // Retorna NULL se o domínio não for encontrado
}

// Função para buscar um domínio na tabela hash usando o IP
char* buscarDominio(No** tabela, char* ip) {
    int indice = hashIP(ip); // Calcula o índice usando a função hash para IPs
    No* atual = tabela[indice]; // Obtém a lista no índice calculado

    // Percorre a lista no índice da tabela hash
    while (atual != NULL) {
        if (strcmp(atual->ip, ip) == 0) {
            // Se o IP for encontrado, retorna o domínio correspondente
            return atual->dominio;
        }
        atual = atual->proximo;
    }
    return NULL; // Retorna NULL se o IP não for encontrado
}

// Função para imprimir todos os elementos da tabela hash
void imprimirTabela(No** tabela, int porIP) {
    for (int i = 0; i < TAMANHO_TABELA; i++) {
        No* atual = tabela[i];
        printf("Indice %d:\n", i);

        // Percorre a lista no índice da tabela hash
        while (atual != NULL) {
            if (porIP) {
                printf("IP: %s, Dominio: %s\n", atual->ip, atual->dominio);
            } else {
                printf("Dominio: %s, IP: %s\n", atual->dominio, atual->ip);
            }
            atual = atual->proximo;
        }
    }
}

// Função principal para interagir com o usuário e manipular a tabela hash
int main() {
    // Inicializa as tabelas hash para IPs e domínios
    No* tabelaHashIP[TAMANHO_TABELA] = {NULL};
    No* tabelaHashDominio[TAMANHO_TABELA] = {NULL};

    // Preenche as tabelas com dados iniciais
    inserirNo(tabelaHashIP, "192.0.10.1", "www.xxx.zzz.br", hashIP);
    inserirNo(tabelaHashIP, "196.0.10.1", "www.xxz.zzz.br", hashIP);

    inserirNo(tabelaHashDominio, "192.0.10.1", "www.xxx.zzz.br", hashDominio);
    inserirNo(tabelaHashDominio, "196.0.10.1", "www.xxz.zzz.br", hashDominio);

    // Variáveis para interagir com o usuário
    int opcao;
    char ip[16], dominio[50];

    do {
        // Exibe o menu de opções
        printf("\nMenu:\n");
        printf("1. Inserir novo site\n");
        printf("2. Buscar IP por dominio\n");
        printf("3. Buscar dominio por IP\n");
        printf("4. Remover site\n");
        printf("5. Imprimir tabela\n");
        printf("0. Sair\n");
        printf("Escolha uma opcao: ");
        scanf("%d", &opcao);

        switch (opcao) {
            case 1:
                // Insere um novo site na tabela hash
                printf("Digite o IP: ");
                scanf("%s", ip);
                printf("Digite o dominio: ");
                scanf("%s", dominio);

                inserirNo(tabelaHashIP, ip, dominio, hashIP);
                inserirNo(tabelaHashDominio, ip, dominio, hashDominio);
                break;

            case 2:
                // Busca um IP pelo domínio
                printf("Digite o dominio: ");
                scanf("%s", dominio);

                char* ipEncontrado = buscarIP(tabelaHashDominio, dominio);
                if (ipEncontrado != NULL) {
                    printf("IP encontrado: %s\n", ipEncontrado);
                } else {
                    printf("Dominio nao encontrado.\n");
                }
                break;

            case 3:
                // Busca um domínio pelo IP
                printf("Digite o IP: ");
                scanf("%s", ip);

                char* dominioEncontrado = buscarDominio(tabelaHashIP, ip);
                if (dominioEncontrado != NULL) {
                    printf("Dominio encontrado: %s\n", dominioEncontrado);
                } else {
                    printf("IP nao encontrado.\n");
                }
                break;

            case 4:
                // Remove um site da tabela hash
                printf("Digite o IP ou dominio para remover: ");
                scanf("%s", dominio);

                removerNo(tabelaHashIP, dominio, hashIP, 0);
                removerNo(tabelaHashDominio, dominio, hashDominio, 1);
                break;

            case 5:
                // Imprime o conteúdo da tabela hash
                printf("\nTabela Hash por IP:\n");
                imprimirTabela(tabelaHashIP, 1);

                printf("\nTabela Hash por Dominio:\n");
                imprimirTabela(tabelaHashDominio, 0);
                break;

            case 0:
                // Sai do programa
                printf("Saindo...\n");
                break;

            default:
                // Opção inválida
                printf("Opcao invalida. Tente novamente.\n");
        }
    } while (opcao != 0);

    return 0;
}
