#include <stdio.h>
#include <stdlib.h>

//definicao de uma constante global
#define anoAtual 2024

//declaracao de uma variavel global
int anoNascimento = 1990;

//função passagem por valor
void imprimeCertidaoNascimento(int dia, int mes, int ano){
    printf("\n\n Certidão de Nascimento");
    printf("\n Certifico que Joaozinho nasceu no dia %d/%d/%d\n",dia,mes,ano);
}

//função passagem por referencia
void imprimeCertidaoNascimentoReferencia(int *dia, int *mes, int *ano){
    printf("\n\n Certidão de Nascimento");
    printf("\n Certifico que Mariazinha nasceu no dia %d/%d/%d\n",*dia,*mes,*ano);
}

int calculaIdade(int anoNs){
    int suaIdade = anoAtual - anoNs;
    return suaIdade;
}


int main (){
    //variáveis locais, acesso apenas no Main
    int ano, dia, mes;

    dia = 15; mes = 3; ano = 2024;

    printf("\n Data de Hoje. %d/%d/%d é uma Sexta Feira \n",dia,mes,ano);

    printf("\n Ano passado dia %d/%d/%d era uma Quarta Feira \n",dia,mes,anoAtual);

    printf("\n Quem nasceu no dia  %d/%d/%d era uma Quinta Feira \n",dia,mes,anoNascimento);

    imprimeCertidaoNascimento(1,1,2000);


    imprimeCertidaoNascimentoReferencia(&dia,&mes,&ano);

    printf("\n Você que nasceu no ano de %d tem %d anos de vida\n",anoNascimento,calculaIdade(anoNascimento));

}
