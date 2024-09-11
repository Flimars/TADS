#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int A, B, resultado;

int calculo_ASCII(const int num1, const int num2) {
    int soma = 0;
    soma = num1 + num2;
    return soma;
}

int main() {
    A = 10;
    B = A + 5;

    resultado = calculo_ASCII(A, B);

    printf("O resultado eh: %d\n", resultado);

    return 0;
}