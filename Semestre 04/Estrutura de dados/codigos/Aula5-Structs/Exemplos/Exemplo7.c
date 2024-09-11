#include <stdio.h>
#include <locale.h> /*alara acentuação*/
#include <stdlib.h>
#include <string.h>

typedef struct data{
    int dia,mes,ano;
}Data;

typedef struct {
    char nomeRua [15];
    int numero;
    char cep [10];
}Endereco;

typedef struct {
    int cod;
    int idade;
    char nome [15];   
    Endereco endereco;
}Pessoa;

typedef struct casal{
    Data dataCasamento;
    Pessoa *marido; //dois ponteiros para Pessoas
    Pessoa *esposa;
}Casal;

Casal matrimonio(Pessoa *p1,Pessoa *p2, Data data){
    Casal c;
    c.dataCasamento = data;
    c.marido = p1;
    c.esposa = p2;
    return c;
}
void imprimeCertidaoCasamento(Casal cs){ 
    printf("\n\n\t\t Certidão de Casamento!\n");
    printf("\n\t Nada data %d/%d/%d Casaram-se neste cartório\n ",
            cs.dataCasamento.dia,cs.dataCasamento.mes,cs.dataCasamento.ano);
    printf("\n\t\t %s e %s",cs.marido->nome,cs.esposa->nome);
    printf("\n\n\t\t Dou fé a este Matrimonio!\n\n\n");
}

int main(){
    system("clear");
    setlocale(LC_ALL, "");    
    Pessoa joao,maria;     
    Data hoje = {15,03,2023} ;
    joao.cod = 1;
    joao.idade = 30;
    strcpy(joao.nome,"Joao Carlos");
    strcpy(joao.endereco.nomeRua, "Duque de caxias");
    joao.endereco.numero = 54;
    strcpy(joao.endereco.cep, "96234-234"); 
    maria.cod = 2;
    maria.idade = 26;
    strcpy(maria.nome,"Maria Aparecida");
    strcpy(maria.endereco.nomeRua, "Duque de caxias");
    maria.endereco.numero = 45;
    strcpy(maria.endereco.cep, "96234-234"); 

 //matrimonio é o relacionamento entre duas pessoas
    Casal joaoEmaria = matrimonio(&joao,&maria,hoje); 
    imprimeCertidaoCasamento(joaoEmaria);    
    exit(0);
}
