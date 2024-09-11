



```
#include <stdio.h>   // Inclui a biblioteca padrão de entrada e saída
#include <stdlib.h>  // Inclui a biblioteca para gerenciamento de memória, conversões e outras funções
#include <string.h>  // Inclui a biblioteca para manipulação de strings

// Definições de constantes
#define TAMANHO_TABELA 7        // Define o tamanho da tabela hash como 7
#define TAMANHO_IP 16           // Define o tamanho máximo do IP como 16 caracteres
#define TAMANHO_DOMINIO 100     // Define o tamanho máximo do domínio como 100 caracteres

// Definição da estrutura de um nó na lista encadeada
typedef struct No {
    char ip[TAMANHO_IP];        // Armazena o IP
    char dominio[TAMANHO_DOMINIO]; // Armazena o domínio
    struct No *proximo;         // Ponteiro para o próximo nó na lista encadeada
} No;

// Funções de Hash

// Função para calcular o hash de um IP
unsigned int hash_ip(const char *ip) {
    unsigned int hash = 0;  // Inicializa a variável hash com 0
    while (*ip) {           // Percorre cada caractere do IP até o final da string
        hash = (hash << 5) + *ip++; // Desloca o hash 5 bits à esquerda e adiciona o valor ASCII do caractere
    }
    return hash % TAMANHO_TABELA; // Retorna o índice correspondente na tabela, baseado no tamanho da tabela
}

// Função para calcular o hash de um domínio
unsigned int hash_dominio(const char *dominio) {
    unsigned int hash = 0;  // Inicializa a variável hash com 0
    while (*dominio) {      // Percorre cada caractere do domínio até o final da string
        hash = (hash << 5) + *dominio++; // Desloca o hash 5 bits à esquerda e adiciona o valor ASCII do caractere
    }
    return hash % TAMANHO_TABELA; // Retorna o índice correspondente na tabela, baseado no tamanho da tabela
}

// Função para criar um novo nó na lista encadeada
No* criar_no(const char *ip, const char *dominio) {
    No *novo = (No *)malloc(sizeof(No)); // Aloca memória para um novo nó
    if (novo) {                          // Verifica se a alocação foi bem-sucedida
        strcpy(novo->ip, ip);            // Copia o IP para o campo ip do novo nó
        strcpy(novo->dominio, dominio);  // Copia o domínio para o campo dominio do novo nó
        novo->proximo = NULL;            // Inicializa o ponteiro para o próximo nó como NULL
    }
    return novo; // Retorna o ponteiro para o novo nó
}

// Função para inserir um novo site na tabela hash baseado no IP
void inserir_por_ip(No *tabela[], const char *ip, const char *dominio) {
    unsigned int indice = hash_ip(ip); // Calcula o índice na tabela hash usando o IP
    No *novo = criar_no(ip, dominio);  // Cria um novo nó com o IP e o domínio fornecidos
    if (novo) {                        // Verifica se a criação do nó foi bem-sucedida
        novo->proximo = tabela[indice]; // Aponta o novo nó para o início da lista no índice calculado
        tabela[indice] = novo;          // Coloca o novo nó na posição correspondente da tabela hash
    }
}

// Função para inserir um novo site na tabela hash baseado no domínio
void inserir_por_dominio(No *tabela[], const char *dominio, const char *ip) {
    unsigned int indice = hash_dominio(dominio); // Calcula o índice na tabela hash usando o domínio
    No *novo = criar_no(ip, dominio);            // Cria um novo nó com o IP e o domínio fornecidos
    if (novo) {                                  // Verifica se a criação do nó foi bem-sucedida
        novo->proximo = tabela[indice];           // Aponta o novo nó para o início da lista no índice calculado
        tabela[indice] = novo;                    // Coloca o novo nó na posição correspondente da tabela hash
    }
}

// Função para buscar um site na tabela hash usando o IP
No* buscar_por_ip(No *tabela[], const char *ip) {
    unsigned int indice = hash_ip(ip); // Calcula o índice na tabela hash usando o IP
    No *atual = tabela[indice];        // Aponta para o início da lista no índice calculado
    while (atual) {                    // Percorre a lista no índice calculado
        if (strcmp(atual->ip, ip) == 0) { // Compara o IP atual com o IP buscado
            return atual;              // Retorna o nó encontrado
        }
        atual = atual->proximo;        // Avança para o próximo nó na lista
    }
    return NULL; // Retorna NULL se o IP não for encontrado
}

// Função para buscar um site na tabela hash usando o domínio
No* buscar_por_dominio(No *tabela[], const char *dominio) {
    unsigned int indice = hash_dominio(dominio); // Calcula o índice na tabela hash usando o domínio
    No *atual = tabela[indice];                  // Aponta para o início da lista no índice calculado
    while (atual) {                              // Percorre a lista no índice calculado
        if (strcmp(atual->dominio, dominio) == 0) { // Compara o domínio atual com o domínio buscado
            return atual;                        // Retorna o nó encontrado
        }
        atual = atual->proximo;                  // Avança para o próximo nó na lista
    }
    return NULL; // Retorna NULL se o domínio não for encontrado
}

// Função para remover um site da tabela hash usando o IP
void remover_por_ip(No *tabela[], const char *ip) {
    unsigned int indice = hash_ip(ip); // Calcula o índice na tabela hash usando o IP
    No *atual = tabela[indice];        // Aponta para o início da lista no índice calculado
    No *anterior = NULL;               // Ponteiro para o nó anterior, inicializado como NULL
    while (atual) {                    // Percorre a lista no índice calculado
        if (strcmp(atual->ip, ip) == 0) { // Compara o IP atual com o IP a ser removido
            if (anterior) {            // Se houver um nó anterior, faz o anterior apontar para o próximo nó
                anterior->proximo = atual->proximo;
            } else {                   // Se não houver nó anterior, atualiza o início da lista
                tabela[indice] = atual->proximo;
            }
            free(atual); // Libera a memória do nó removido
            return;
        }
        anterior = atual;              // Atualiza o ponteiro anterior para o nó atual
        atual = atual->proximo;        // Avança para o próximo nó na lista
    }
}

// Função para remover um site da tabela hash usando o domínio
void remover_por_dominio(No *tabela[], const char *dominio) {
    unsigned int indice = hash_dominio(dominio); // Calcula o índice na tabela hash usando o domínio
    No *atual = tabela[indice];                  // Aponta para o início da lista no índice calculado
    No *anterior = NULL;                         // Ponteiro para o nó anterior, inicializado como NULL
    while (atual) {                              // Percorre a lista no índice calculado
        if (strcmp(atual->dominio, dominio) == 0) { // Compara o domínio atual com o domínio a ser removido
            if (anterior) {                    // Se houver um nó anterior, faz o anterior apontar para o próximo nó
                anterior->proximo = atual->proximo;
            } else {                           // Se não houver nó anterior, atualiza o início da lista
                tabela[indice] = atual->proximo;
            }
            free(atual); // Libera a memória do nó removido
            return;
        }
        anterior = atual;                      // Atualiza o ponteiro anterior para o nó atual
        atual = atual->proximo;                // Avança para o próximo nó na lista
    }
}

// Função para inicializar a tabela hash, preenchendo-a com NULL
void inicializar_tabela(No *tabela[]) {
    for (int i = 0; i < TAMANHO_TABELA; i++) { // Itera sobre todos os índices da tabela
        tabela[i] = NULL; // Define todos os elementos da tabela como NULL
    }
}

// Função para exibir o conteúdo da tabela hash
void exibir_tabela(No *tabela[]) {
    for (int i = 0; i < TAMANHO_TABELA; i++) { // Itera sobre todos os índices da tabela
        printf("Indice %d: ", i);              // Exibe o índice atual
        No *atual = tabela[i];                 // Aponta para o início da lista no índice atual
        while (atual) {                        // Percorre a lista no índice atual
            printf("(%s, %s) -> ", atual->ip, atual->dominio); // Exibe o IP e o domínio no nó atual
            atual = atual->proximo;            // Avança para o próximo nó na lista
        }
        printf("NULL\n"); // Indica o fim da lista com NULL
    }
}

int main() {
    No *tabela_ip[TAMANHO_TABELA];   // Declara a tabela hash para IPs
    No *tabela_dominio[TAMANHO_TABELA]; // Declara a tabela hash para domínios
    int opcao;  // Variável para armazenar a opção do menu
    char ip[TAMANHO_IP]; // Variável para armazenar o IP inserido pelo usuário
    char dominio[TAMANHO_DOMINIO]; // Variável para armazenar o domínio inserido pelo usuário

    inicializar_tabela(tabela_ip);     // Inicializa a tabela hash para IPs
    inicializar_tabela(tabela_dominio); // Inicializa a tabela hash para domínios

    // Cadastro de 20 sites (exemplo com menos entradas por simplicidade)
    inserir_por_ip(tabela_ip, "8.8.8.8", "www.google.com"); // Insere o IP e domínio do Google na tabela IP
    inserir_por_dominio(tabela_dominio, "www.google.com", "8.8.8.8"); // Insere o domínio e IP do Google na tabela de domínios
    inserir_por_ip(tabela_ip, "186.192.90.5", "www.g1.com.br"); // Insere o IP e domínio do G1 na tabela IP
    inserir_por_dominio(tabela_dominio, "www.g1.com.br", "186.192.90.5"); // Insere o domínio e IP do G1 na tabela de domínios

    // Exibir as tabelas hash
    printf("Tabela Hash por IP:\n");
    exibir_tabela(tabela_ip); // Exibe a tabela hash de IPs
    printf("\nTabela Hash por Domínio:\n");
    exibir_tabela(tabela_dominio); // Exibe a tabela hash de domínios

    // Menu para interação com o usuário
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
        scanf("%d", &opcao); // Lê a opção do usuário

        switch (opcao) {
            case 1:
                printf("Digite o IP: ");
                scanf("%s", ip); // Lê o IP do usuário
                printf("Digite o dominio: ");
                scanf("%s", dominio); // Lê o domínio do usuário
                inserir_por_ip(tabela_ip, ip, dominio); // Insere o novo site na tabela de IPs
                inserir_por_dominio(tabela_dominio, dominio, ip); // Insere o novo site na tabela de domínios
                break;
            case 2:
                printf("Digite o dominio: ");
                scanf("%s", dominio); // Lê o domínio do usuário
                No* resultIP = buscar_por_dominio(tabela_dominio, dominio); // Busca o IP correspondente ao domínio
                if (resultIP) { // Se o domínio foi encontrado
                    printf("IP encontrado: %s\n", resultIP->ip); // Exibe o IP encontrado
                } else {
                    printf("Dominio nao encontrado.\n"); // Exibe mensagem de erro
                }
                break;
            case 3:
                printf("Digite o IP: ");
                scanf("%s", ip); // Lê o IP do usuário
                No* resultDominio = buscar_por_ip(tabela_ip, ip); // Busca o domínio correspondente ao IP
                if (resultDominio) { // Se o IP foi encontrado
                    printf("Dominio encontrado: %s\n", resultDominio->dominio); // Exibe o domínio encontrado
                } else {
                    printf("IP nao encontrado.\n"); // Exibe mensagem de erro
                }
                break;
            case 4:
                printf("Digite o IP ou dominio para remover: ");
                scanf("%s", ip); // Lê o IP ou domínio do usuário
                remover_por_ip(tabela_ip, ip); // Remove o site da tabela de IPs
                remover_por_dominio(tabela_dominio, ip); // Remove o site da tabela de domínios
                break;
            case 5:
                printf("Tabela Hash por IP:\n");
                exibir_tabela(tabela_ip); // Exibe a tabela de IPs
                break;
            case 6:
                printf("Tabela Hash por Dominio:\n");
                exibir_tabela(tabela_dominio); // Exibe a tabela de domínios
                break;
            case 0:
                printf("Saindo...\n"); // Mensagem de saída
                break;
            default:
                printf("Opcao invalida.\n"); // Mensagem para opção inválida
                break;
        }
    } while (opcao != 0); // Continua no loop até que o usuário escolha sair

    return 0; // Finaliza o programa
}





```