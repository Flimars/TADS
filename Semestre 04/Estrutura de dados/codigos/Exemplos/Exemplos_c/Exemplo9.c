#include <stdio.h>

typedef struct pessoa{
    int cod;
    char nome [15];
    char sobrenome [20];
    int idade;
    char telefone [10];
}Pessoa;

int main()
{
  //DECLARAÇÃO DE UM VETOR DE PONTEIROS PARA 5 Pessoas
  //Cada posição do vetor é um ponteiro para uma struct.
  Pessoa *vetorPessoas[4]; 

  for(int i=0;i<4;i++){
    //alocação de memória para cada um dos Pessoas
    vetorPessoas[i] = (Pessoa*)malloc(sizeof(Pessoa)); 
    vetorPessoas[i]->cod = i+1;    //Entrada de Dados com ponteiros
    printf("\nInfome seu nome:");
    scanf("%s",vetorPessoas[i]->nome);
    printf("\nInfome seu Sobrenome:");
    scanf("%s",vetorPessoas[i]->sobrenome);
    printf("\nInfome sua idade:");
    scanf("%d",&vetorPessoas[i]->idade);
    printf("\nInfome seu telefone:");
    scanf("%s",vetorPessoas[i]->telefone);
  }
  return 0;
}