#include <stdio.h>
#include <stdlib.h>
#include <string.h>

// Estrutura de um nó da lista simplesmente encadeada (LSE)
typedef struct Node {
    char ip[16];
    char dominio[100];
    struct Node* prox;
} Node;

// Estrutura da tabela Hash
typedef struct HashTable {
    Node* tabela[7];
    Node* colisoes[7];
} HashTable;

// Função para criar um novo nó
Node* criarNo(char* ip, char* dominio) {
    Node* novoNo = (Node*)malloc(sizeof(Node));
    strcpy(novoNo->ip, ip);
    strcpy(novoNo->dominio, dominio);
    novoNo->prox = NULL;
    return novoNo;
}

// Função Hash
int hashFunc(char* chave) {
    int soma = 0;
    for (int i = 0; chave[i] != '\0'; i++) {
        soma += chave[i];
    }
    return soma % 7;
}

// Função para inserir na tabela Hash
void inserir(HashTable* ht, char* ip, char* dominio, int (*hashFunc)(char*)) {
    int indice = hashFunc(ip);
    Node* novoNo = criarNo(ip, dominio);
    
    // Verifica se a posição já está ocupada
    if (ht->tabela[indice] == NULL) {
        ht->tabela[indice] = novoNo;
    } else {
        // Se houver colisão, insere na lista de colisões
        Node* atual = ht->tabela[indice];
        while (atual->prox != NULL) {
            atual = atual->prox;
        }
        atual->prox = novoNo;

        // Insere na tabela de colisões
        Node* novoColisao = criarNo(ip, dominio);
        if (ht->colisoes[indice] == NULL) {
            ht->colisoes[indice] = novoColisao;
        } else {
            Node* atualColisao = ht->colisoes[indice];
            while (atualColisao->prox != NULL) {
                atualColisao = atualColisao->prox;
            }
            atualColisao->prox = novoColisao;
        }
    }
}

// Função para imprimir a tabela Hash
void imprimirTabela(HashTable* ht) {
    printf("Tabela Hash por IP:\n");
    for (int i = 0; i < 7; i++) {
        printf("Indice %d:\n", i);
        if (ht->tabela[i] != NULL) {
            Node* atual = ht->tabela[i];
            while (atual != NULL) {
                printf("%s, ", atual->ip);
                atual = atual->prox;
            }
            printf("\n");
            // Imprime a lista de colisões
            if (ht->colisoes[i] != NULL) {
                printf("Colisoes: ");
                Node* atualColisao = ht->colisoes[i];
                while (atualColisao != NULL) {
                    printf("%s ", atualColisao->ip);
                    atualColisao = atualColisao->prox;
                }
                printf("\n");
            }
        } else {
            printf("vazio\n");
        }
    }
}

// Função principal
int main() {
    HashTable* ht = (HashTable*)malloc(sizeof(HashTable));
    for (int i = 0; i < 7; i++) {
        ht->tabela[i] = NULL;
        ht->colisoes[i] = NULL;
    }

    // Inserindo elementos na tabela Hash
    inserir(ht, "192.168.1.1", "example.com", hashFunc);
    inserir(ht, "10.0.0.1", "test.org", hashFunc);
    inserir(ht, "172.16.0.1", "mysite.net", hashFunc);
    inserir(ht, "8.8.8.8", "google.com", hashFunc);
    inserir(ht, "1.1.1.1", "cloudflare.com", hashFunc);

    // Imprimindo a tabela Hash
    imprimirTabela(ht);

    

    return 0;
}
