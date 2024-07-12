#include <stdio.h>
#include <stdlib.h>

int main() {
int idade;    
//Solicitação ao usuario
printf("\n Informe sua idade:");

//entrada de dados 
scanf("%d", &idade); 
//printf("sua idade é: %d \n", idade);
printf("\n IDADE esta armazenada memoria = %x\n", &idade);

int *p = &idade;
*p = 100;
printf("sua idade eh: %d \n", idade);

}