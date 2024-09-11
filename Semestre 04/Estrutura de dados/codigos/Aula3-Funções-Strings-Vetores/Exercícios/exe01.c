/*
1) Crie um procedimento para receber dois valores inteiros (A e B) e uma referência
para inteiro (*pc). O ponteiro *pc retornará o resultado da soma de A e B.
*/

#include stdio.h
#include stdlib.h

// Função para somar dois inteiros e armazenar o resultado em um inteiro referenciado por um ponteiro
void somaInteiros(int A, int B, int *pc) {
    // Realiza a soma de A e B e armazena o resultado no inteiro apontado por *pc
    *pc = A + B;
}

int main() {
    int A = 5;
    int B = 10;
    int resultado;

    // Chama a função somaInteiros, passando A, B e o endereço de resultado como argumentos
    somaInteiros(A, B, &resultado);

    // Imprime o resultado da soma
    printf("O resultado da soma de %d e %d é: %d\n", A, B, resultado);

    return 0;
}

