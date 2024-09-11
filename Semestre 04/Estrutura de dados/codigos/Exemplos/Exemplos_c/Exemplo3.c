#include <stdio.h>
#include <locale.h> /*permite acentuação*/
#include <stdlib.h>

typedef struct pessoa{
    int cod;
    char nome [15];
    char sobrenome [10];
    int idade;
    char telefone [10];
}Pessoa;

int main(){
    system("clear");
    setlocale(LC_ALL, "");    
    //trabalhar com acentuação pt-br
  
    //Declaração do Ponteiro
    Pessoa maria, *ps_maria;   
    ps_maria = &maria;

    
    ps_maria->cod = 1;
    ps_maria->idade = 30;
    strcpy(ps_maria->nome,"Maria da Graça");
    strcpy(ps_maria->sobrenome, " Farias");
    strcpy(ps_maria->telefone, "1212454533");

    printf("\nPessoa:\n\tNome: %s  %s \n",ps_maria->nome,ps_maria->sobrenome);
    printf("\tCodigo: %d  e idade: %d \n",ps_maria->cod,ps_maria->idade);
    printf("\tTelefone: %s \n",ps_maria->telefone);

    printf("\nPessoa:\n\tNome: %s  %s \n",maria.nome,maria.sobrenome);
    printf("\tCodigo: %d  e idade: %d \n",maria.cod,maria.idade);
    printf("\tTelefone: %s \n",maria.telefone);
    
    exit(0); 
}