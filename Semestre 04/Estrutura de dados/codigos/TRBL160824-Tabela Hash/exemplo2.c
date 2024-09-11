#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define TAMANHO_TABELA 7

// Estrutura para um nó na lista de colisões
typedef struct Proximo {
    char ip[16];
    char dominio[100];
    struct Proximo* proximo;
} Proximo;

// Estrutura para a tabela hash
typedef struct TabelaHash {
    Proximo* tabela[TAMANHO_TABELA];
    Proximo* colisoes[TAMANHO_TABELA];
} TabelaHash;

// Função para criar um novo nó
Proximo* criarProximo(const char* ip, const char* dominio) {
    Proximo* novoProximo = (Proximo*)malloc(sizeof(Proximo));
    strcpy(novoProximo->ip, ip);
    strcpy(novoProximo->dominio, dominio);
    novoProximo->proximo = NULL;
    return novoProximo;
}

// Função hash para gerar o índice baseado no IP
int funcaoHashIP(const char* ip) {
    int soma = 0;
    for (int i = 0; ip[i] != '\0'; i++) {
        soma += ip[i];
    }
    return soma % TAMANHO_TABELA;
}

int hashFunc(const char* chave) {
    int soma = 0;
    for (int i = 0; chave[i] != '\0'; i++) {
        soma += chave[i];
    }
    return soma % TAMANHO_TABELA;
}


// Função hash para gerar o índice baseado no domínio
int funcaoHashDominio(const char* dominio) {
    int soma = 0;
    for (int i = 0; dominio[i] != '\0'; i++) {
        soma += dominio[i];
    }
    return soma % TAMANHO_TABELA;
}

// Função para inicializar a tabela hash
void inicializarTabela(TabelaHash* thash) {
    for (int i = 0; i < TAMANHO_TABELA; i++) {
        thash->tabela[i] = NULL;
    }
}

// Função para inserir um novo elemento na tabela hash
void inserirPorIP(TabelaHash* thash, const char* ip, const char* dominio, int (*hashFunc)(const char*)) {
    int index = hashFunc(ip);
    Proximo* novoProximo = criarProximo(ip, dominio);

    if (thash->tabela[index] == NULL) {
        thash->tabela[index] = novoProximo;
    } else {
        // Colisão encontrada, adicionar à lista simplesmente encadeada
        Proximo* atual = thash->tabela[index];
        while (atual->proximo != NULL) {
            atual = atual->proximo;
        }
        atual->proximo = novoProximo;
    }
}

void inserirPorDominio(TabelaHash* thash, const char* ip, const char* dominio, int (*hashFunc)(const char*)) {
    int index = hashFunc(dominio);
    Proximo* novoProximo = criarProximo(ip, dominio);

    if (thash->tabela[index] == NULL) {
        thash->tabela[index] = novoProximo;
    } else {
        // Colisão encontrada, adicionar à lista simplesmente encadeada
        Proximo* atual = thash->tabela[index];
        while (atual->proximo != NULL) {
            atual = atual->proximo;
        }
        atual->proximo = novoProximo;
    }
}

// Função para buscar um IP na tabela hash
Proximo* buscarPorIP(TabelaHash* thash, const char* ip) {
    int index = funcaoHashIP(ip);
    Proximo* atual = thash->tabela[index];
    while (atual != NULL) {
        if (strcmp(atual->ip, ip) == 0) {
            return atual;
        }
        atual = atual->proximo;
    }
    return NULL;
}

// Função para buscar um domínio na tabela hash
Proximo* buscarPorDominio(TabelaHash* thash, const char* dominio) {
    int index = funcaoHashDominio(dominio);
    Proximo* atual = thash->tabela[index];
    while (atual != NULL) {
        if (strcmp(atual->dominio, dominio) == 0) {
            return atual;
        }
        atual = atual->proximo;
    }
    return NULL;
}

// Função para remover um elemento da tabela hash por IP
void removerPorIP(TabelaHash* thash, const char* ip) {
    int index = funcaoHashIP(ip);
    Proximo* atual = thash->tabela[index];
    Proximo* anterior = NULL;

    while (atual != NULL) {
        if (strcmp(atual->ip, ip) == 0) {
            if (anterior == NULL) {
                thash->tabela[index] = atual->proximo;
            } else {
                anterior->proximo = atual->proximo;
            }
            free(atual);
            return;
        }
        anterior = atual;
        atual = atual->proximo;
    }
}

// Função para remover um elemento da tabela hash por domínio
void removerPorDominio(TabelaHash* thash, const char* dominio) {
    int index = funcaoHashDominio(dominio);
    Proximo* atual = thash->tabela[index];
    Proximo* anterior = NULL;

    while (atual != NULL) {
        if (strcmp(atual->dominio, dominio) == 0) {
            if (anterior == NULL) {
                thash->tabela[index] = atual->proximo;
            } else {
                anterior->proximo = atual->proximo;
            }
            free(atual);
            return;
        }
        anterior = atual;
        atual = atual->proximo;
    }
}

// Função para imprimir a tabela hash e as listas de colisões
void imprimirTabela(TabelaHash* thash) {
    for (int i = 0; i < TAMANHO_TABELA; i++) {
        printf("Indice %d: ", i);
        if (thash->tabela[i] == NULL) {
            printf("vazio\n");
        } else {
            Proximo* atual = thash->tabela[i];
            while (atual != NULL) {
                printf("%s ", atual->ip);
                atual = atual->proximo;
            }
            printf("\n");
        }
    } 

    printf("\nTabela Hash Dominio\n");
    for (int i = 0; i < TAMANHO_TABELA; i++) {
        printf("Indice %d: ", i);
        if (thash->tabela[i] == NULL) {
            printf("vazio\n");
        } else {
            Proximo* atual = thash->tabela[i];
            while (atual != NULL) {
                printf("%s ", atual->dominio);
                atual = atual->proximo;
            }
            printf("\n");
        }
    }  
}  


// Função principal
int main() {
    TabelaHash tabelaHashIP, tabelaHashDominio;
    inicializarTabela(&tabelaHashIP);
    inicializarTabela(&tabelaHashDominio);

    int opcao;
    char ip[16];
    char dominio[100];

     // Criar a tabela hash
    TabelaHash* thash = (TabelaHash*)malloc(sizeof(TabelaHash));
    for (int i = 0; i < TAMANHO_TABELA; i++) {
        thash->tabela[i] = NULL;
        thash->colisoes[i] = NULL;   
    }
    // Realizar 5 inserções na tabela hash
    inserirPorIP(thash, "192.168.1.1", "example.com", hashFunc);
    inserirPorDominio(thash, "10.0.0.1", "test.org", hashFunc);
    inserirPorIP(thash, "172.16.0.1", "mysite.net", hashFunc);
    inserirPorDominio(thash, "8.8.8.8", "google.com", hashFunc);
    // inserir(thash, "1.1.1.1", "cloudflare.com", hashFunc);

    imprimirTabela(&tabelaHashIP);
    // imprimirTabela(&tabelaHashDominio);

    do {
        printf("\nMenu:\n");
        printf("1. Inserir novo site\n");
        printf("2. Buscar IP por dominio\n");
        printf("3. Buscar dominio por IP\n");
        printf("4. Remover site\n");
        printf("5. Imprimir tabela IP\n");
        printf("6. Imprimir tabela Dominio\n");
        printf("0. Sair\n");
        printf("Escolha uma opcao: ");
        scanf("%d", &opcao);

        switch (opcao) {
            case 1:
                printf("Digite o IP: ");
                scanf("%s", ip);
                printf("Digite o dominio: ");
                scanf("%s", dominio);
                inserir(&tabelaHashIP, ip, dominio, funcaoHashIP);
                inserir(&tabelaHashDominio, dominio, ip, funcaoHashDominio);
                break;
            case 2:
                printf("Digite o dominio: ");
                scanf("%s", dominio);
                Proximo* resultIP = buscarPorDominio(&tabelaHashDominio, dominio);
                if (resultIP) {
                    printf("IP encontrado: %s\n", resultIP->ip);
                } else {
                    printf("Dominio nao encontrado.\n");
                }
                break;
            case 3:
                printf("Digite o IP: ");
                scanf("%s", ip);
                Proximo* resultDominio = buscarPorIP(&tabelaHashIP, ip);
                if (resultDominio) {
                    printf("Dominio encontrado: %s\n", resultDominio->dominio);
                } else {
                    printf("IP nao encontrado.\n");
                }
                break;
            case 4:
                printf("Digite o IP ou dominio para remover: ");
                scanf("%s", ip);
                removerPorIP(&tabelaHashIP, ip);
                removerPorDominio(&tabelaHashDominio, ip);
                break;
            case 5:
                imprimirTabela(&tabelaHashIP);
                break;
            case 6:
                imprimirTabela(&tabelaHashDominio);
                break;
            case 0:
                printf("Saindo...\n");
                break;
            default:
                printf("Opcao invalida.\n");
                break;
        }
    } while (opcao != 0);
    // free(thash);
    return 0;
}
