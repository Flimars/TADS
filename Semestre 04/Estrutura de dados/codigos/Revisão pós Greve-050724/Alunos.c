#include <stdio.h>
#include <string.h>

typedef struct data{
    int dia, mes, ano;
}Data;

typedef struct aluno{
    int cod;
    char nome [20];
    int matricula;
    Data datanascimento;
    Data *ingresso;
}Aluno;


void mostraAluno(Aluno aluno);
void cadastraAluno(Aluno **novo, Data *ingresso);

int main(){
    //alocação estática
    Aluno joao;

    Data d1 = {01,8,2022};

    //atribuir valores a um espaço de memória
    joao.cod = 1;
    joao.matricula = 202323;
    strcpy(joao.nome,"Joao Miguel");
    joao.datanascimento.dia = 21;
    joao.datanascimento.mes = 10;
    joao.datanascimento.ano = 2010;
    joao.ingresso = &d1;

   // mostraAluno(joao);

  //  Aluno paulo = {2,"Paulo Cesar",202324,{01,05,2014},&d1};

   // mostraAluno(paulo);
    
    d1.ano = 2024;

   // mostraAluno(joao);
   // mostraAluno(paulo);

    Aluno *julia;    

    cadastraAluno(&julia,&d1);

    mostraAluno(*julia);




}

void mostraAluno(Aluno aluno){
    printf("\n Aluno: %s",aluno.nome);
    printf("\n Código %d  e Matricula: %d",aluno.cod,aluno.matricula);
    printf("\n Data de Nascimento: %d/%d/%d",aluno.datanascimento.dia,aluno.datanascimento.mes,aluno.datanascimento.ano);
    printf("\n Data de Ingresso: %d/%d/%d \n",aluno.ingresso->dia,aluno.ingresso->mes,aluno.ingresso->ano);
}


void cadastraAluno(Aluno **novo, Data *ingresso){
    (*novo) = (Aluno*) malloc(sizeof(Aluno));
    printf("\nInforme o Código:");
    scanf("%d",&(*novo)->cod);
    printf("\nInforme o Nome:");
    scanf("%s",(*novo)->nome);
    printf("\nInforme a Matricula:");
    scanf("%d",&(*novo)->matricula);
    printf("\nInforme o data de Nascimento:");
    scanf("%d %d %d",&(*novo)->datanascimento.dia,&(*novo)->datanascimento.mes,&(*novo)->datanascimento.ano);
    (*novo)->ingresso = ingresso;
}