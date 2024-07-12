#include <stdio.h>
#include <locale.h> /*permite acentuação*/
#include <stdlib.h>

typedef struct pessoa{
    int cod;
    char nome [15];
    char sobrenome [20];
    int idade;
    char telefone [10];
}Pessoa;

 //passagem por Valor
void mostrarDadosPessoa(Pessoa ps){
  printf("\nPessoa:\n\t Nome: %s  %s \n",ps.nome,ps.sobrenome);
  printf("\tCodigo: %d  e idade %d \n",ps.cod,ps.idade);
  printf("\tTelefone: %s \n",ps.telefone);
}

//passagem por referência (ponteiro)
void lerDadosPessoa(Pessoa *ps, int cod){  
  ps->cod = cod;   
  printf("\nInfome seu nome:");
  scanf("%s",ps->nome);
  printf("\nInfome seu Sobrenome:");
  scanf("%s",ps->sobrenome);
  printf("\nInfome sua idade:");
  scanf("%d",&ps->idade);
  printf("\nInfome seu telefone:");
  scanf("%s",ps->telefone);
}

int main()
{
    system("clear");
    setlocale(LC_ALL, "");    
    int codigo = 1;    

    //declaração de um ponteiro de Pessoa
    Pessoa *paulo;
    //inicialização do ponteiro;
    paulo = NULL;

    //Alocação dinâmica de memória para um STRUCT
    paulo = (Pessoa*)malloc(sizeof(Pessoa));

    //passagem por referência
    lerDadosPessoa(paulo, 1);    
    
    //passagem por valor
    mostrarDadosPessoa(*paulo); 
    
    //Liberar memória para reciclagem
    free(paulo);

    exit(0);
}