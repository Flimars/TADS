#include <stdio.h>
struct pessoa{
    int cod; 
    char nome [15];
    char sobrenome [20];
    int idade;
    char telefone [10];
};

//REDEFINIÇÃO PARA PESSOA
typedef struct pessoa Pessoa;

//Outra Opção para definir uma Struct Carro
typedef struct carro{
    int cod; 
    char modelo [15];
    char fabricante [20];
    int ano;
}Carro;

int main()
{
//DECLARAÇÃO DO NOVO TIPO Pessoa 
  Pessoa joao;
  Pessoa maria = {2,"Maria","Aparecida",23,"45433333"};

  Carro fusca = {1,"Fusca","Volkswagen",1970};

//ATRIBUIÇÃO DE VALORES
  joao.cod = 1;
  joao.idade = 30;
  strcpy(joao.nome,"Joao Carlos");
  strcpy(joao.sobrenome, "Farias");
  strcpy(joao.telefone, "1212454533");

//SAÍDA DOS VALORES ARMAZENADOS NA STRUCT
  printf("\n\tNome: %s  %s \n",joao.nome,joao.sobrenome);
  printf("\tCodigo: %d  e idade %d \n",joao.cod,joao.idade);
  printf("\tTelefone: %s \n",joao.telefone);

  printf("\n\tNome: %s  %s\n",maria.nome,maria.sobrenome);
  printf("\tCodigo: %d  e idade %d \n",maria.cod,maria.idade);
  printf("\tTelefone: %s \n\n",maria.telefone);
 
  printf("\n\t Carro Modelo = %s", fusca.modelo);
  printf("\n\t Fabricante = %s ",fusca.fabricante);
  printf("\n\t Ano Fabricação %d \n", fusca.ano);

  return 0;
}