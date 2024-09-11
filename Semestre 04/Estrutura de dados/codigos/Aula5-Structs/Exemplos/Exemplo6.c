#include <stdio.h>
#include <locale.h> /*para acentuação*/
#include <stdlib.h>

typedef struct endereco{
    char nomeRua [15];
    int numero;
    int cep;
}Endereco;

typedef struct pessoa{
    int cod;
    char nome [15];
    Endereco endereco;   //Ligação entre as estruturas
}Pessoa;

void mostrarDadosPessoa(Pessoa ps){
  printf("\nPessoa: %s  Código: %d \n",ps.nome,ps.cod);
  printf("Endereço: %s Número:%d Cep:%d \n",ps.endereco.nomeRua,ps.endereco.numero,ps.endereco.cep); 
}

void lerDadosPessoa(Pessoa *ps, int cod){
  ps->cod = cod;   
  printf("\nInfome seu nome:");
  scanf("%s",ps->nome);
  printf("\nInfome sua Rua:");
  scanf("%s",ps->endereco.nomeRua);
  printf("\nInfome Numero Casa:");
  scanf("%d",&ps->endereco.numero);
  printf("\nInfome seu CEP:");
  scanf("%d",&ps->endereco.cep);
}

int main(){
    system("clear");
    setlocale(LC_ALL, "");    
    Pessoa joao, maria; //dois Pessoas novos   
    Endereco minhaCasa;
    joao.cod = 1;
    strcpy(joao.nome,"João Cesar");
    maria.cod = 2;
    strcpy(maria.nome,"Maria Cesar");
    strcpy(minhaCasa.nomeRua,"Rua 24 Maio");
    minhaCasa.numero = 332;
    minhaCasa.cep = 96500333;
    //associação entre Pessoa e endereco
    joao.endereco = minhaCasa;
    maria.endereco = minhaCasa;          
    mostrarDadosPessoa(joao);
    mostrarDadosPessoa(maria);
    exit(0);
}