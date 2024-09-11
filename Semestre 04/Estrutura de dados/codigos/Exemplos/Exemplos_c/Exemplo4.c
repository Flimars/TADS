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

//PASSAGEM POR VALOR
void mostrarDadosPessoa(Pessoa ps){  
  printf("\nPessoa:\n\t Nome: %s  %s \n",ps.nome,ps.sobrenome);
  printf("\tCodigo: %d  e idade %d \n",ps.cod,ps.idade);
  printf("\tTelefone: %s \n",ps.telefone);
}

//PASSAGEM POR REFERENCIA (ponteiro)
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

int main(){
    system("clear");
    setlocale(LC_ALL, "");    //trabalhar com acentuação pt-br
    int codigo = 1;    
    //declaração e alocação estática
    Pessoa joao, maria;     

    //chamada das funções com Struct
    lerDadosPessoa(&joao,codigo++);    //passagem por referência
    mostrarDadosPessoa(joao);    //passagem por valor;

    lerDadosPessoa(&maria,codigo++);    
    mostrarDadosPessoa(maria);    
    exit(0); 
}