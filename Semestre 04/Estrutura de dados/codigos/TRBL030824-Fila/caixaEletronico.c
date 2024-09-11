/*
    Implemente duas filas de LOGs, uma para cada atendimento Caixa ou Gerente;

    - Simule um caixa de banco, os clientes podem realizar duas operações (Depósito ou Saque)

    - O caixa tem um saldo inicial, caso o valor seja zerado, informar o gerente da falta de dinheiro em caixa


*/

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

typedef struct cliente
{
    char nome[20];
    int operacao; // 1 para Depósito, 2 para Saque
    float valor;
    int id;
    struct cliente *proximo;
} Cliente;

typedef struct log
{
    char message[256];
    struct log *proximo;
} Log;

typedef struct fila
{
    Cliente *inicio;
    Cliente *fim;
    int qtd;
} Fila;

typedef struct logFila
{
    Log *inicio;
    Log *fim;
    int qtd;
} LogFila;

typedef struct banco
{
    LogFila *caixaLog;
    LogFila *gerenteLog;
    double saldo;
} Banco;

// Funções para criar filas
Fila *criaFila()
{
    Fila *fl = (Fila *)malloc(sizeof(Fila));
    fl->inicio = NULL;
    fl->fim = NULL;
    fl->qtd = 0;
    return fl;
}

LogFila *criaLogFila()
{
    LogFila *lf = (LogFila *)malloc(sizeof(LogFila));
    lf->inicio = NULL;
    lf->fim = NULL;
    lf->qtd = 0;
    return lf;
}

// Funções para manipulaçao de clientes
Cliente *cadastraNovoCliente(char nome[], int op, double vl, int id)
{
    Cliente *novo = (Cliente *)malloc(sizeof(Cliente));
    strcpy(novo->nome, nome);
    novo->operacao = op;
    novo->valor = vl;
    novo->proximo = NULL;
    novo->id = id;
    return novo;
}

void enfileirar(Fila *fl, Cliente *cl)
{
    if (fl->inicio == NULL)
    { // Fila Vazia
        fl->inicio = cl;
    }
    else
    { // Fila com elementos
        fl->fim->proximo = cl;
    }
    cl->proximo = NULL;
    fl->fim = cl;
    fl->qtd++;
}

Cliente *desenfileirar(Fila *fl)
{
    Cliente *aux = fl->inicio;
    if (aux == NULL) // Fila vazia
        printf("\nErro - Fila Vazia\n");
    else
    { // Lista com elementos
        fl->inicio = aux->proximo;
        fl->qtd--;
        aux->proximo = NULL;
        if (fl->inicio == NULL)
            fl->fim = NULL;
    }
    return aux;
}

void mostraCliente(Cliente cl)
{
    printf("\n Id:%d \n\t Nome: %s \n\t Operacao %d \n\t Valor=%.2f \n", cl.id, cl.nome, cl.operacao, cl.valor);
}

void mostraFila(Fila *fl)
{
    printf("\nInício da Fila\n");
    Cliente *aux = fl->inicio;
    while (aux != NULL)
    {
        mostraCliente(*aux);
        aux = aux->proximo;
    }
    printf("\nFim da Fila\n");
}

void apagaCliente(Cliente *cl)
{
    printf("\n Apagado!");
    free(cl);
}

void apagaFila(Fila *fl)
{
    Cliente *aux = desenfileirar(fl);
    while (aux != NULL)
    {
        apagaCliente(aux);
        aux = desenfileirar(fl);
    }
    printf("\nFila Vazia - Qtd = %d\n", fl->qtd);
}

// Funções para manipulaçao de logs
void enfileirarLog(LogFila *lf, char message[])
{
    Log *novoLog = (Log *)malloc(sizeof(Log));
    strcpy(novoLog->message, message);
    novoLog->proximo = NULL;
    if (lf->inicio == NULL)
    {
        lf->inicio = novoLog;
    }
    else
    {
        lf->fim->proximo = novoLog;
    }
    lf->fim = novoLog;
    lf->qtd++;
}

char *desenfileirarLog(LogFila *lf)
{
    if (lf->inicio == NULL)
    {
        return NULL;
    }
    Log *aux = lf->inicio;
    char *message = (char *)malloc(256 * sizeof(char));
    strcpy(message, aux->message);
    lf->inicio = aux->proximo;
    if (lf->inicio == NULL)
    {
        lf->fim = NULL;
    }
    free(aux);
    lf->qtd--;
    return message;
}

int isEmptyLog(LogFila *lf)
{
    return lf->inicio == NULL;
}

// Funções para operações bancárias
Banco *inicializarBanco(double saldoInicial)
{
    Banco *banco = (Banco *)malloc(sizeof(Banco));
    banco->caixaLog = criaLogFila();
    banco->gerenteLog = criaLogFila();
    banco->saldo = saldoInicial;
    return banco;
}

void deposit(Banco *banco, Cliente *cl)
{
    banco->saldo += cl->valor;
    char log[256];
    sprintf(log, "Deposito: R$%.2f, Saldo Atual: R$%.2f", cl->valor, banco->saldo);
    enfileirarLog(banco->caixaLog, log);
}

void saque(Banco *banco, Cliente *cl)
{
    if (cl->valor > banco->saldo)
    {
        char log[256];
        sprintf(log, "Tentativa de Saque: R$%.2f, Saldo Insuficiente. Saldo Atual: R$%.2f", cl->valor, banco->saldo);
        enfileirarLog(banco->caixaLog, log);
        sprintf(log, "Aviso ao Gerente: Tentativa de Saque sem Saldo. Valor: R$%.2f", cl->valor);
        enfileirarLog(banco->gerenteLog, log);
    }
    else
    {
        banco->saldo -= cl->valor;
        char log[256];
        sprintf(log, "Saque: R$%.2f, Saldo Atual: R$%.2f", cl->valor, banco->saldo);
        enfileirarLog(banco->caixaLog, log);

        if (banco->saldo == 0)
        {
            sprintf(log, "Aviso ao Gerente: Saldo Zerado no Caixa.");
            enfileirarLog(banco->gerenteLog, log);
        }
    }
}

void menu(Fila *fl, Banco *banco, int id) {
    int op;
    Cliente *cl;
    char nome[20];
    float vl;
    do {
        printf("\n\nInforme uma Opcao:");
        printf("\n -- 1 - para Insere:");
        printf("\n -- 2 - para Remove:");
        printf("\n -- 3 - MostraFila:");
        printf("\n -- 4 - Apaga Fila:");
        printf("\n -- 5 - Mostra Logs ATM:");
        printf("\n -- 6 - Mostra Logs Gerente:");
        printf("\n -- 7 - Mostra Saldo:");
        printf("\n -- 0 - para Sair do Programa:\n");
        printf("\nInforme sua Opcao:");
        scanf("%d", &op);
        fflush(stdin);
        
        switch(op) {
            case 1:                
                printf("\n Funçao Insere na Fila. \n");
                printf("Informe o seu nome:");
                scanf("%s", nome);
                printf("Informe a operacao (1 para Deposito, 2 para Saque):");
                scanf("%d", &op);
                printf("Informe o Valor:");
                scanf("%f", &vl);
                cl = cadastraNovoCliente(nome, op, vl, id++);
                enfileirar(fl, cl);
                printf("\n Insercao Realizada com Sucesso");
            break;
            case 2:
                printf("\n Funcao Remove da Fila. \n");
                cl = desenfileirar(fl);
                if (cl != NULL) {
                    mostraCliente(*cl);
                    if (cl->operacao == 1) {
                        deposito(banco, cl);
                    } else if (cl->operacao == 2) {
                        saque(banco, cl);
                    }
                    apagaCliente(cl);
                }
                printf("\n Remoçao Realizada com Sucesso");
            break;
            case 3:                
                printf("Mostra Fila:");
                mostraFila(fl);
            break;
            case 4:
                printf("\n Apagar a Fila !! \n");
                apagaFila(fl);
            break;
            case 5:
                printf("\n Logs do Caixa Eletronico:\n");
                while (!isEmptyLog(banco->caixaLog)) {
                    char *log = desenfileirarLog(banco->caixaLog);
                    printf("%s\n", log);
                    free(log);
                }
            break;
            case 6:
                printf("\n Logs do Gerente:\n");
                while (!isEmptyLog(banco->gerenteLog)) {
                    char *log = desenfileirarLog(banco->gerenteLog);
                    printf("%s\n", log);
                    free(log);
                }
            break;
            case 7:
                mostraSaldo(banco);
            break;
            default:
                printf("\nOpcao Invalida!!\n");
        }
    
    } while(op > 0);
}


int main()
{
    int id = 0;
    Fila *fl = criaFila();
    Banco *banco = inicializarBanco(1000.0);

    menu(fl, banco, id);

    free(fl);
    free(banco->caixaLog);
    free(banco->gerenteLog);
    free(banco);

    return 0;
}
