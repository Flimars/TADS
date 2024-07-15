#include <stdio.h>

typedef struct Aluno{
    char nome [20];
    int idade;
    int matricula;
    struct Aluno *proximo;
}Aluno;

typedef struct LSE{
    Aluno *primeiro;
    int n;
}LSE;

void criaLista(LSE *ls){
    ls->primeiro = NULL;
    ls->n = 0;
}

void cadastraAluno (Aluno *aluno, char nome[],int idade, int matricula){
    strcpy(aluno->nome, nome);
    aluno->idade = idade;
    aluno->matricula = matricula;
    aluno->proximo = NULL;
}

void insereInicio(LSE *ls, Aluno *aluno){
    aluno->proximo = ls->primeiro;
    ls->primeiro = aluno;
    ls->n++;
    printf("\n Aluno %s Inserido com Sucesso",aluno->nome);
}

void mostraAluno(Aluno aluno){
    printf("\n Dados do Aluno:");
    printf("\n\t Nome: %s",aluno.nome);
    printf("\n\t Idade: %d",aluno.idade);
    printf("\n\t Matricula: %d\n",aluno.matricula);
}

void mostraLista(LSE ls){
    Aluno *aux = ls.primeiro;
    int i = 0;
    printf("\n\n Mostra Lista LSE\n");
    while(aux != NULL){
        printf("\n Elemento E%d",i++);
        mostraAluno(*aux);
        aux = aux->proximo;
    }
    printf("\n Fim da Lista \n");
}


int main(){

    //Declara um nova Lista
    LSE matematica;
    // Inicializa a nova Lista
    criaLista(&matematica);
    //Declara e atribui valores ao aluno;
    Aluno paulo;
    cadastraAluno(&paulo,"Paulo", 23, 12131);

    //Insere novo Aluno na lista de matematica
    insereInicio(&matematica,&paulo);

    Aluno maria;
    cadastraAluno(&maria,"Maria",23,13112);
    insereInicio(&matematica,&maria); 

    Aluno juca;
    cadastraAluno(&juca,"Juca",31,13113);
    insereInicio(&matematica,&juca);
    
    mostraLista(matematica);

/*




    Aluno novosAlunos [4];
    cadastraAluno(&novosAlunos[0],"Luiz", 25, 12133);
    cadastraAluno(&novosAlunos[1],"Julio", 28, 12132);
    cadastraAluno(&novosAlunos[2],"Pedro", 29, 12134);
    cadastraAluno(&novosAlunos[3],"Maria", 22, 12135);

    insereInicio(&matematica,&novosAlunos[0]);
    insereInicio(&matematica,&novosAlunos[1]);
    insereInicio(&matematica,&novosAlunos[2]);
    insereInicio(&matematica,&novosAlunos[3]);
    
    mostraLista(matematica);
*/
}


