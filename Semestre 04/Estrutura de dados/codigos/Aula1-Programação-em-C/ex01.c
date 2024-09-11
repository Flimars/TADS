#include <stdio.h>
#include <stdlib.h>

int main () {

//Declaração das variáveis
int numeroUm, numeroDois, soma;


//Solitação e captura de dados do usuário
printf("\n Digite o primeiro numero:\n");
scanf("%d", &numeroUm);

printf("\n Digite o segundo numero:\n");
scanf("%d", &numeroDois);

//Soma dos dados de entrada
soma = numeroUm + numeroDois;

//Imprime o resultado da soma
printf("\n A soma dos numeros eh: %d\n", soma);

}