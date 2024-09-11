/*
    Crie um programa em C, para ler duas variáveis inteira (A,B), referente a
    idade de duas pessoas, após crie uma variável S e um ponteiro para *ps. Arma_
    zene a soma dos valores A e B em S, com o uso do ponteiro *ps.

    1. Mostre o resultado armazenado em S.
    2. Mostre o endereço armazenado pelo ponteiro *ps e o endereço de S.
    3. Mostre o endereço do ponteiro *ps, mostre o conteúdo referenciado por *ps.
    4. Mostre o endereço das variaveis A e B.
*/

#include <stdio.h>
#include <stdlib.h>

int main () {

    //Declaração das variaveis
    int A, B, S, *ps; 
    
    // Leitura de dados
    printf("Pessoa A: Digite sua idade :\n"); 
    scanf("%d", &A);

    printf("Pessoa B: Digite sua idade :\n"); 
    scanf("%d", &B);
   
   //Inicialização do ponteiro e armazenamento da soma
   ps = &S;
   *ps = A + B;

   //Mostrando os resultado
   printf("Resultado armazenado em S: %d\n", S);

   printf("Endereco armazenado pelo ponteiro *ps: %p\nEndereco de S: %p\n.\n", ps, &S);

   printf("Endereco do ponteiro *ps: %x\nConteudo referenciado por *ps: %x\n", &ps, *ps); // Resultado do conteudo refereciado sai em Hexadeciamal

   printf("Endereco das variavel A: %d\nEndereco das variavel B: %d\n", &A, &B);

   return 0;

}   