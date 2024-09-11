#include <stdio.h>
#include <stdlib.h>
#include <string.h>

// Define a estrutura de um nó da lista simplesmente encadeada
typedef struct No {
    char ip[16];               // Armazena o endereço IP
    char dominio[50];          // Armazena o domínio associado ao IP
    struct No* prox;           // Ponteiro para o próximo nó da lista
} No;

// Define a estrutura de uma tabela hash
typedef struct {
    No* tabela[7];             // Vetor de ponteiros para listas encadeadas (tabela hash com 7 posições)
} TabelaHash;

// Define a estrutura de uma tabela hash para colisões
typedef struct {
    No* colisoes[7];           // Vetor de ponteiros para listas encadeadas que armazenarão colisões
} TabelaColisoes;

// Função de hash que gera um índice para o IP (converte o IP para um valor numérico)
int funcaoHashIP(char* ip) {
    int hash = 0;
    while (*ip) {              // Percorre cada caractere do IP
        hash += *ip;           // Soma o valor ASCII do caractere ao hash
        ip++;
    }
    return hash % 7;           // Retorna o índice da tabela (0 a 6) correspondente ao hash mod 7
}

// Função de hash que gera um índice para o domínio (converte o domínio para um valor numérico)
int funcaoHashDominio(char* dominio) {
    int hash = 0;
    while (*dominio) {         // Percorre cada caractere do domínio
        hash += *dominio;      // Soma o valor ASCII do caractere ao hash
        dominio++;
    }
    return hash % 7;           // Retorna o índice da tabela (0 a 6) correspondente ao hash mod 7
}

// Função que inicializa uma tabela hash (aponta todas as posições para NULL)
void inicializarTabela(TabelaHash* tabela) {
    for (int i = 0; i < 7; i++) {
        tabela->tabela[i] = NULL;  // Define todas as posições da tabela como vazias (NULL)
    }
}

// Função que inicializa uma tabela de colisões (aponta todas as posições para NULL)
void inicializarTabelaColisoes(TabelaColisoes* tabela) {
    for (int i = 0; i < 7; i++) {
        tabela->colisoes[i] = NULL;  // Define todas as posições da tabela de colisões como vazias (NULL)
    }
}

// Função que cria um novo nó (aloca memória e inicializa valores)
No* criarNo(char* ip, char* dominio) {
    No* novo = (No*)malloc(sizeof(No));  // Aloca memória para o novo nó
    strcpy(novo->ip, ip);                // Copia o IP para o novo nó
    strcpy(novo->dominio, dominio);      // Copia o domínio para o novo nó
    novo->prox = NULL;                   // Inicializa o ponteiro do próximo nó como NULL
    return novo;                         // Retorna o novo nó
}

// Função que insere um novo site na tabela hash e na tabela de colisões, se necessário
void inserir(TabelaHash* tabela, TabelaColisoes* colisoes, char* ip, char* dominio) {
    int indiceIP = funcaoHashIP(ip);         // Calcula o índice na tabela hash para o IP
    int indiceDominio = funcaoHashDominio(dominio); // Calcula o índice na tabela hash para o domínio

    No* novo = criarNo(ip, dominio);         // Cria um novo nó com o IP e domínio fornecidos

    if (tabela->tabela[indiceIP] == NULL) {
        tabela->tabela[indiceIP] = novo;     // Se a posição da tabela estiver vazia, insere o nó diretamente
    } else {
        // Se já houver um nó na posição, trata-se de uma colisão
        novo->prox = tabela->tabela[indiceIP]; // Insere o novo nó no início da lista encadeada na posição
        tabela->tabela[indiceIP] = novo;       // Atualiza a posição da tabela com o novo nó

        // Insere o nó na tabela de colisões
        No* novaColisao = criarNo(ip, dominio);  // Cria um nó para a tabela de colisões
        novaColisao->prox = colisoes->colisoes[indiceIP]; // Encadeia o nó na lista de colisões
        colisoes->colisoes[indiceIP] = novaColisao;       // Atualiza a posição na tabela de colisões
    }
}

// Função que busca um site pelo domínio na tabela hash
No* buscarPorDominio(TabelaHash* tabela, char* dominio) {
    int indice = funcaoHashDominio(dominio); // Calcula o índice na tabela hash para o domínio

    No* atual = tabela->tabela[indice];      // Obtém o primeiro nó na lista encadeada do índice
    while (atual != NULL) {
        if (strcmp(atual->dominio, dominio) == 0) {
            return atual;                    // Se encontrar o domínio, retorna o nó correspondente
        }
        atual = atual->prox;                 // Avança para o próximo nó na lista encadeada
    }
    return NULL;                             // Se não encontrar o domínio, retorna NULL
}

// Função que busca um site pelo IP na tabela hash
No* buscarPorIP(TabelaHash* tabela, char* ip) {
    int indice = funcaoHashIP(ip);           // Calcula o índice na tabela hash para o IP

    No* atual = tabela->tabela[indice];      // Obtém o primeiro nó na lista encadeada do índice
    while (atual != NULL) {
        if (strcmp(atual->ip, ip) == 0) {
            return atual;                    // Se encontrar o IP, retorna o nó correspondente
        }
        atual = atual->prox;                 // Avança para o próximo nó na lista encadeada
    }
    return NULL;                             // Se não encontrar o IP, retorna NULL
}

// Função que remove um site da tabela hash (baseado no IP)
void remover(TabelaHash* tabela, TabelaColisoes* colisoes, char* ip) {
    int indice = funcaoHashIP(ip);           // Calcula o índice na tabela hash para o IP

    No* atual = tabela->tabela[indice];      // Obtém o primeiro nó na lista encadeada do índice
    No* anterior = NULL;

    while (atual != NULL) {
        if (strcmp(atual->ip, ip) == 0) {
            if (anterior == NULL) {
                tabela->tabela[indice] = atual->prox;  // Remove o nó da lista e ajusta o ponteiro
            } else {
                anterior->prox = atual->prox;          // Conecta o nó anterior ao próximo, excluindo o nó atual
            }
            free(atual);                              // Libera a memória do nó removido
            break;
        }
        anterior = atual;
        atual = atual->prox;                          // Avança para o próximo nó na lista encadeada
    }

    // Remove o nó correspondente na tabela de colisões, se existir
    atual = colisoes->colisoes[indice];               // Obtém o primeiro nó na lista de colisões
    anterior = NULL;
    while (atual != NULL) {
        if (strcmp(atual->ip, ip) == 0) {
            if (anterior == NULL) {
                colisoes->colisoes[indice] = atual->prox;  // Remove o nó da lista de colisões e ajusta o ponteiro
            } else {
                anterior->prox = atual->prox;              // Conecta o nó anterior ao próximo na lista de colisões
            }
            free(atual);                                   // Libera a memória do nó removido
            break;
        }
        anterior = atual;
        atual = atual->prox;                              // Avança para o próximo nó na lista de colisões
    }
}

// Função que imprime o conteúdo da tabela hash por IP
void imprimirTabelaHashPorIP(TabelaHash* tabela) {
    printf("Tabela Hash por IP:\n");
    for (int i = 0; i < 7; i++) {
        printf("Indice %d:\n", i);
        No* atual = tabela->tabela[i];
        while (atual != NULL) {
            printf("IP: %s, Dominio: %s\n", atual->ip, atual->dominio);  // Imprime cada IP e domínio na lista
            atual = atual->prox;
        }
    }
}

// Função que imprime o conteúdo da tabela hash por domínio
void imprimirTabelaHashPorDominio(TabelaHash* tabela) {
    printf("Tabela Hash por Dominio:\n");
    for (int i = 0; i < 7; i++) {
        printf("Indice %d:\n", i);
        No* atual = tabela->tabela[i];
        while (atual != NULL) {
            printf("Dominio: %s, IP: %s\n", atual->dominio, atual->ip);  // Imprime cada domínio e IP na lista
            atual = atual->prox;
        }
    }
}

// Função que imprime o conteúdo da tabela de colisões
void imprimirTabelaColisoes(TabelaColisoes* colisoes) {
    printf("Tabela de Colisoes:\n");
    for (int i = 0; i < 7; i++) {
        printf("Indice %d:\n", i);
        No* atual = colisoes->colisoes[i];
        while (atual != NULL) {
            printf("IP: %s, Dominio: %s\n", atual->ip, atual->dominio);  // Imprime cada IP e domínio nas colisões
            atual = atual->prox;
        }
    }
}

int main() {
    TabelaHash tabelaIP, tabelaDominio;      // Cria tabelas hash para IPs e domínios
    TabelaColisoes colisoes;                 // Cria a tabela de colisões

    inicializarTabela(&tabelaIP);            // Inicializa a tabela hash para IPs
    inicializarTabela(&tabelaDominio);       // Inicializa a tabela hash para domínios
    inicializarTabelaColisoes(&colisoes);    // Inicializa a tabela de colisões

    int opcao;
    char ip[16], dominio[50];
    
    do {
        // Exibe o menu de opções
        printf("\nMenu:\n");
        printf("1. Inserir novo site\n");
        printf("2. Buscar IP por dominio\n");
        printf("3. Buscar dominio por IP\n");
        printf("4. Remover site\n");
        printf("5. Imprimir tabelas\n");
        printf("0. Sair\n");
        printf("Escolha uma opcao: ");
        scanf("%d", &opcao);

        switch (opcao) {
            case 1:
                // Inserção de um novo site
                printf("Digite o IP: ");
                scanf("%s", ip);
                printf("Digite o dominio: ");
                scanf("%s", dominio);
                inserir(&tabelaIP, &colisoes, ip, dominio);  // Insere o site na tabela hash e nas colisões se necessário
                inserir(&tabelaDominio, &colisoes, ip, dominio);  // Insere o site na tabela de domínio e colisões
                break;
            case 2:
                // Busca por domínio
                printf("Digite o dominio: ");
                scanf("%s", dominio);
                No* resultadoDominio = buscarPorDominio(&tabelaDominio, dominio);
                if (resultadoDominio) {
                    printf("IP: %s\n", resultadoDominio->ip);  // Exibe o IP correspondente ao domínio encontrado
                } else {
                    printf("Dominio nao encontrado.\n");  // Mensagem de erro se o domínio não for encontrado
                }
                break;
            case 3:
                // Busca por IP
                printf("Digite o IP: ");
                scanf("%s", ip);
                No* resultadoIP = buscarPorIP(&tabelaIP, ip);
                if (resultadoIP) {
                    printf("Dominio: %s\n", resultadoIP->dominio);  // Exibe o domínio correspondente ao IP encontrado
                } else {
                    printf("IP nao encontrado.\n");  // Mensagem de erro se o IP não for encontrado
                }
                break;
            case 4:
                // Remoção de um site
                printf("Digite o IP: ");
                scanf("%s", ip);
                remover(&tabelaIP, &colisoes, ip);  // Remove o site da tabela hash e das colisões
                remover(&tabelaDominio, &colisoes, ip);  // Remove o site da tabela de domínio e colisões
                break;
            case 5:
                // Impressão das tabelas
                imprimirTabelaHashPorIP(&tabelaIP);  // Imprime a tabela hash por IP
                imprimirTabelaHashPorDominio(&tabelaDominio);  // Imprime a tabela hash por domínio
                imprimirTabelaColisoes(&colisoes);  // Imprime a tabela de colisões
                break;
            case 0:
                printf("Saindo...\n");  // Mensagem ao sair do programa
                break;
            default:
                printf("Opcao invalida. Tente novamente.\n");  // Mensagem de erro para opção inválida
        }
    } while (opcao != 0);

    return 0;
}
