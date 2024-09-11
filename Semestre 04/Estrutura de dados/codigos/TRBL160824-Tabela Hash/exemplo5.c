#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define TAMANHO_TABELA 7
#define TAMANHO_IP 16
#define TAMANHO_DOMINIO 100

// Estrutura de um nó da lista encadeada
typedef struct No {
    char ip[TAMANHO_IP];
    char dominio[TAMANHO_DOMINIO];
    struct No *proximo;
} No;

// Função de hash para o endereço IP
unsigned int hash_ip(const char *ip) {
    unsigned int hash = 0;
    while (*ip) {
        hash = (hash << 5) + *ip++;
    }
    return hash % TAMANHO_TABELA;
}

// Função de hash para o dominio
unsigned int hash_dominio(const char *dominio) {
    unsigned int hash = 0;
    while (*dominio) {
        hash = (hash << 5) + *dominio++;
    }
    return hash % TAMANHO_TABELA;
}

// Função para criar um novo nó
No* criar_no(const char *ip, const char *dominio) {
    No *novo = (No *)malloc(sizeof(No));
    if (novo) {
        strcpy(novo->ip, ip);
        strcpy(novo->dominio, dominio);
        novo->proximo = NULL;
    }
    return novo;
}

// Função para inserir na tabela hash por IP
void inserir_por_ip(No *tabela[], const char *ip, const char *dominio) {
    unsigned int indice = hash_ip(ip);
    No *novo = criar_no(ip, dominio);
    if (novo) {
        novo->proximo = tabela[indice];
        tabela[indice] = novo;
    }
}

// Função para inserir na tabela hash por dominio
void inserir_por_dominio(No *tabela[], const char *dominio, const char *ip) {
    unsigned int indice = hash_dominio(dominio);
    No *novo = criar_no(ip, dominio);
    if (novo) {
        novo->proximo = tabela[indice];
        tabela[indice] = novo;
    }
}

// Função para buscar por IP na tabela hash
No* buscar_por_ip(No *tabela[], const char *ip) {
    unsigned int indice = hash_ip(ip);
    No *atual = tabela[indice];
    while (atual) {
        if (strcmp(atual->ip, ip) == 0) {
            return atual;
        }
        atual = atual->proximo;
    }
    return NULL;
}

// Função para buscar por dominio na tabela hash
No* buscar_por_dominio(No *tabela[], const char *dominio) {
    unsigned int indice = hash_dominio(dominio);
    No *atual = tabela[indice];
    while (atual) {
        if (strcmp(atual->dominio, dominio) == 0) {
            return atual;
        }
        atual = atual->proximo;
    }
    return NULL;
}

// Função para remover um elemento por IP na tabela hash
void remover_por_ip(No *tabela[], const char *ip) {
    unsigned int indice = hash_ip(ip);
    No *atual = tabela[indice];
    No *anterior = NULL;
    while (atual) {
        if (strcmp(atual->ip, ip) == 0) {
            if (anterior) {
                anterior->proximo = atual->proximo;
            } else {
                tabela[indice] = atual->proximo;
            }
            free(atual);
            return;
        }
        anterior = atual;
        atual = atual->proximo;
    }
}

// Função para remover um elemento por dominio na tabela hash
void remover_por_dominio(No *tabela[], const char *dominio) {
    unsigned int indice = hash_dominio(dominio);
    No *atual = tabela[indice];
    No *anterior = NULL;
    while (atual) {
        if (strcmp(atual->dominio, dominio) == 0) {
            if (anterior) {
                anterior->proximo = atual->proximo;
            } else {
                tabela[indice] = atual->proximo;
            }
            free(atual);
            return;
        }
        anterior = atual;
        atual = atual->proximo;
    }
}

// Função para inicializar a tabela hash
void inicializar_tabela(No *tabela[]) {
    for (int i = 0; i < TAMANHO_TABELA; i++) {
        tabela[i] = NULL;
    }
}

// Função para exibir a tabela hash
void exibir_tabela(No *tabela[]) {
    for (int i = 0; i < TAMANHO_TABELA; i++) {
        printf("Indice %d: ", i);
        No *atual = tabela[i];
        while (atual) {
            printf("(%s, %s) -> ", atual->ip, atual->dominio);
            atual = atual->proximo;
        }
        printf("NULL\n");
    }
}

int main() {
    No *tabela_ip[TAMANHO_TABELA];
    No *tabela_dominio[TAMANHO_TABELA];

    inicializar_tabela(tabela_ip);
    inicializar_tabela(tabela_dominio);

    // Cadastro de 20 sites (exemplo com menos entradas por simplicidade)
    inserir_por_ip(tabela_ip, "8.8.8.8", "www.google.com");
    inserir_por_dominio(tabela_dominio, "www.google.com", "8.8.8.8");
    inserir_por_ip(tabela_ip, "186.192.90.5", "www.g1.com.br");
    inserir_por_dominio(tabela_dominio, "www.g1.com.br", "186.192.90.5");

    // Exibir as tabelas
    printf("Tabela Hash por IP:\n");
    exibir_tabela(tabela_ip);
    printf("\nTabela Hash por Dominio:\n");
    exibir_tabela(tabela_dominio);

    // Buscar por IP
    No *resultado = buscar_por_ip(tabela_ip, "8.8.8.8");
    if (resultado) {
        printf("\nDominio encontrado para IP 8.8.8.8: %s\n", resultado->dominio);
    } else {
        printf("\nIP 8.8.8.8 nao encontrado.\n");
    }

    // Buscar por dominio
    resultado = buscar_por_dominio(tabela_dominio, "www.g1.com.br");
    if (resultado) {
        printf("\nEndereco IP encontrado para www.g1.com.br: %s\n", resultado->ip);
    } else {
        printf("\nDominio www.g1.com.br não encontrado.\n");
    }

    // Remover por IP
    remover_por_ip(tabela_ip, "8.8.8.8");
    printf("\nTabela Hash por IP apos remover 8.8.8.8:\n");
    exibir_tabela(tabela_ip);

    // Remover por dominio
    remover_por_dominio(tabela_dominio, "www.g1.com.br");
    printf("\nTabela Hash por Dominio apos remover www.g1.com.br:\n");
    exibir_tabela(tabela_dominio);

    return 0;
}
