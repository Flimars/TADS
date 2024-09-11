#include <stdio.h>
struct pessoa{
    int cod;
    char nome [15];
    char sobrenome [20];
    int idade;
    char telefone [10];
};
int main() {
//DECLARACAO DE OUTRA PESSOA E ATRIBUICAO
  struct pessoa maria = {2,"Maria","Aparecida",23,"45433333"};
//DECLARAÇÃO DE STRUCT
  struct pessoa joao; 
//ATRIBUIÇÃO DE VALORES
  joao.cod = 1;
  joao.idade = 30;
  strcpy(joao.nome,"Joao Carlos");
  strcpy(joao.sobrenome, "Farias");
  strcpy(joao.telefone, "1212454533");
//SAIDA DA STRUCT JOAO
  printf("Pessoa: %s  %s \n",joao.nome,joao.sobrenome);
  printf("\tCodigo: %d  e idade %d \n",joao.cod,joao.idade);
  printf("\tTelefone: %s \n\n",joao.telefone);  
//SAÍDA DA STRUCT MARIA
  printf("Pessoa: %s %s \n",maria.nome,maria.sobrenome);
  printf("\tCodigo: %d  e idade %d \n",maria.cod,maria.idade);
  printf("\tTelefone: %s \n\n",maria.telefone);  
//PARA ALTERAR O VALOR DE UM MEMBRO
  maria.idade = 45;
  strcpy(maria.telefone ,"2222333");  
//SAÍDA NO TERMINA - PRINT
  printf("Pessoa: %s %s \n",maria.nome,maria.sobrenome);
  printf("\tCodigo: %d  e idade %d \n",maria.cod,maria.idade);
  printf("\tTelefone: %s \n\n",maria.telefone);  
return 0;  }