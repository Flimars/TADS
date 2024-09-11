#include <stdio.h>

typedef struct pessoa{
    int cod;
    char nome [15];
    char sobrenome [20];
    int idade;
    char telefone [10];
}Pessoa;

void mostraVetor(Pessoa **ps, int n){
//Mostra  UM STRUCT
  Pessoa *p;
  for(int i=0;i<n;i++){
    p = ps[i];
    printf("Pessoa: %s  %s \n",p->nome,p->sobrenome);
    printf("\tCodigo: %d  e idade %d \n",p->cod,p->idade);
    printf("\tTelefone: %s \n",p->telefone);
  }
}


void preencheVetor(Pessoa **ps, int n){
    for(int i=0;i<n;i++){
        //alocação de memória para cada um dos Pessoas
        ps[i] = (Pessoa*)malloc(sizeof(Pessoa)); 
        ps[i]->cod = i+1;    //Entrada de Dados com ponteiros
        printf("\nInfome seu nome:");
        scanf("%s",ps[i]->nome);
        printf("\nInfome seu Sobrenome:");
        scanf("%s",ps[i]->sobrenome);
        printf("\nInfome sua idade:");
        scanf("%d",&ps[i]->idade);
        printf("\nInfome seu telefone:");
        scanf("%s",ps[i]->telefone);
    }
}



int main()
{
  
  //DECLARAÇÃO DE UM VETOR DE PONTEIROS PARA 4 Pessoas
  //Cada posição do vetor é um ponteiro para uma struct.
  Pessoa *vetorPessoas[2];

  preencheVetor(vetorPessoas, 2);

  mostraVetor(vetorPessoas, 2);
       
  return 0;
}