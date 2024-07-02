#include <stdio.h>
#include <stdlib.h>
#include <string.h>

typedef struct Pessoa {
    char* nome;
    int idade;
} Pessoa;

Pessoa* criaPessoa(const char* nome, int idade) {
    Pessoa* novaPessoa = (Pessoa*) malloc(sizeof(Pessoa));
    if (novaPessoa == NULL) {
        return NULL;
    }

    novaPessoa->nome = (char*) malloc(strlen(nome) + 1);
    if (novaPessoa->nome == NULL) {
        free(novaPessoa);
        return NULL;
    }

    strcpy(novaPessoa->nome, nome);
    novaPessoa->idade = idade;

    return novaPessoa;
}

int main() {
    
    Pessoa* pessoa1 = criaPessoa("Vinicius Machado", 32);
    if (pessoa1 == NULL) {
        printf("Falha ao alocar memória para a pessoa.\n");
        return 1;
    }

    printf("Pessoa: %s, Idade: %d\n", pessoa1->nome, pessoa1->idade);

}