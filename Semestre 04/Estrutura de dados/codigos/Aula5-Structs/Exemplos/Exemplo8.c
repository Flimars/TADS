#include <stdio.h>

typedef struct pessoa{
    int cod;
    char nome [15];
    char sobrenome [20];
    int idade;
    char telefone [10];
}Pessoa;

// void mostraDadosPessoas (Pessoa *ps){
//   Pessoa *p = ps;
//   for(int i=0;i<4;i++){
//     p = ps[i];  //copia o endereço da strut para o ponteiro
//     printf("Pessoa: %s  %s \n",p->nome,p->sobrenome);
//     printf("\tCodigo: %d  e idade %d \n",p->cod,p->idade);
//     printf("\tTelefone: %s \n",p->telefone);
//   }

// }



int main()
{
  //DECLARAÇÃO DE UM VETOR DE 4 Pessoas
  Pessoa vetorPessoas[4]; 

  //Cada posição do vetor é uma Pessoa struct.

  for(int i=0;i<4;i++){      
    vetorPessoas[i].cod = i+1;    
    //Entrada de Dados
    printf("\nInfome seu nome:");
    scanf("%s",vetorPessoas[i].nome);
    printf("\nInfome seu Sobrenome:");
    scanf("%s",vetorPessoas[i].sobrenome);
    printf("\nInfome sua idade:");
    scanf("%d",&vetorPessoas[i].idade);
    printf("\nInfome seu telefone:");
    scanf("%s",vetorPessoas[i].telefone);
  }

Pessoa *p;

//LEITURA DE UM STRUCT
  for(int i=0;i<4;i++){
    p = &vetorPessoas[i];  //copia o endereço da strut para o ponteiro
    printf("Pessoa: %s  %s \n",p->nome,p->sobrenome);
    printf("\tCodigo: %d  e idade %d \n",p->cod,p->idade);
    printf("\tTelefone: %s \n",p->telefone);
  }
       
  return 0;
}