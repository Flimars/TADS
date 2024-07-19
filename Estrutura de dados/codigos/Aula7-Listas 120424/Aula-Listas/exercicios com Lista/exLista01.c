/*
    Implmente a Função da Lista LSE:
        – RemoveNoFim(): Recebe um ponteiro de lista e retorno uma endereço de DadosAluno
*/

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

typedef struct aluno
{
   char nome[50];
   int idade;
   char matricula[5];
   struct aluno *proximo;
} Aluno;

typedef struct lse
{
    Aluno *ptr_inicio;   // Inicio da lista - ponteiro que marca o inicio.
    int numElemetos; // Numero de elementos da lista.
} LSE;

// Declaração dos protótipos das funções.
void criarLista(struct lse *ls);
void cadastrarAluno(struct aluno *aluno, char nome[], int idade, char matricula[]);
void inserirNoInicio(LSE *ls, Aluno *aluno);
void imprimirLista(LSE *ls);

// Função para inicializar os parâmetros de uma nova lista LSE, recebe um ponteiro de lista *ls.
void criarLista(LSE *ls)
{
    ls -> ptr_inicio = NULL;   // inicializa o ponteiro com NULL (Lista está Vazia).
    ls -> numElemetos = 0; // Inicializa a qtdade de elementos para lista vazia = 0.
}

// Função cadastra Aluno() - Cria um novo elemento de Lista.
void cadastrarAluno (Aluno *aluno, char nome[], int idade, char matricula[]) 
{
    strcpy(aluno -> nome, nome);
    aluno -> idade = idade;
    strcpy(aluno -> matricula, matricula);
    aluno -> proximo = NULL;
}

// Função inserir elemento (Aluno()) - Cria um novo elemento no inicio da Lista.
void inserirNoInicio(LSE *ls, Aluno *aluno)
{
    aluno -> proximo = ls -> ptr_inicio;
    ls -> ptr_inicio = aluno;
    ls ->numElemetos ++;
    printf("\n Aluno Inserido com Sucesso!");
}

// Função imprimir a lista.
void imprimirLista(LSE *ls) 
{
    Aluno *atual = ls ->ptr_inicio;
    while (atual != NULL)
    {
      printf("Nome: %s\nIdade: %d\nMatricula: %s\n\n", atual -> nome, atual -> idade, atual -> matricula); 
      atual = atual -> proximo;
    }

    if (ls ->numElemetos == 0)
    {
        printf("A lista esta vazia.\n");
    }    
}

int main() {

    // Declara uma nova lista.
    LSE matematica;
    LSE literatura;

    // Inicializa a nova lista.
    criarLista(&matematica);
    criarLista(&literatura);

    // Imprime a lista vazia.
    printf("Lista antes da insercao:\n");
    imprimirLista(&matematica);
    imprimirLista(&literatura);

    // Declara e aatribui valores ao novo aluno.
    Aluno Paulo;
    Aluno Leticia;

    // Insere novo Aluno na lista de matematica  e literatura.
    cadastrarAluno(&Paulo, "Paulo", 23, "12131");
    cadastrarAluno(&Leticia, "Leticia", 19, "12122");

    // Insere novo Aluno na lista de matematica e literatura.
    inserirNoInicio(&matematica, &Paulo);
    inserirNoInicio(&literatura, &Leticia);
    printf("\n");
    printf("\n");

    // Imprime a lista após a inserção nas listas.
    printf("Lista apos a insercao:\n");
    imprimirLista(&matematica);
    printf("\n");
    imprimirLista(&literatura);

    // Opcional: exibir informações das listas para verificação
    printf("Nome do aluno: %s\n", Paulo.nome);
    printf("Idade do aluno: %d\n", Paulo.idade);
    printf("Matricula do aluno: %s\n\n", Paulo.matricula); 

    printf("Nome do aluno: %s\n", Leticia.nome);
    printf("Idade do aluno: %d\n", Leticia.idade);
    printf("Matricula do aluno: %s\n", Leticia.matricula);

    return 0;

}
