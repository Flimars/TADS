#include <stdio.h>
#include <stdlib.h>
#include <string.h>

typedef struct cliente {
    char nome[20];
    int operacao;  // 1 para Saque, 2 para Depósito, 3 para Empréstimo, 4 para Aplicação
    float valor;
    int id;
    int idade;
    struct cliente *proximo;    
} Cliente;

typedef struct log {
    char message[256];
    struct log *proximo;
} Log;

typedef struct fila {
    Cliente *inicio;
    Cliente *fim;
    int qtd;
} Fila;

typedef struct logFila {
    Log *inicio;
    Log *fim;
    int qtd;
} LogFila;

typedef struct banco {
    Fila *caixaGeral;
    Fila *caixaPrioritaria;
    Fila *gerenteGeral;
    Fila *gerentePrioritaria;
    LogFila *caixaLog;
    LogFila *gerenteLog;
    double saldo;
} Banco;

// Funções para criar filas
Fila* criaFila() {
    Fila *fl = (Fila *)malloc(sizeof(Fila));
    fl->inicio = NULL;
    fl->fim = NULL;
    fl->qtd = 0;
    return fl;
}

LogFila* criaLogFila() {
    LogFila *lf = (LogFila *)malloc(sizeof(LogFila));
    lf->inicio = NULL;
    lf->fim = NULL;
    lf->qtd = 0;
    return lf;
}

// Funções para manipulação de clientes
Cliente* cadastraNovoCliente(char nome[], int idade, int op, double vl, int id) {
    Cliente *novo = (Cliente *)malloc(sizeof(Cliente));
    strcpy(novo->nome, nome);
    novo->idade = idade;
    novo->operacao = op;
    novo->valor = vl;
    novo->proximo = NULL;
    novo->id = id;
    return novo;
}

void enfileirar(Fila *fl, Cliente *cl) {
    if (fl->inicio == NULL) {
        fl->inicio = cl;
    } else {
        fl->fim->proximo = cl;
    }
    fl->fim = cl;
    fl->qtd++;
}

Cliente* desenfileirar(Fila *fl) {
    if (fl->inicio == NULL) {
        return NULL;
    }
    Cliente *aux = fl->inicio;
    fl->inicio = aux->proximo;
    if (fl->inicio == NULL) {
        fl->fim = NULL;
    }
    fl->qtd--;
    aux->proximo = NULL;
    return aux;
}

void mostraCliente(Cliente cl) {
    printf("\nId: %d\nNome: %s\nIdade: %d\nOperacao: %d\nValor: %.2f\n", cl.id, cl.nome, cl.idade, cl.operacao, cl.valor);
}

void mostraFila(Fila *fl) {
    Cliente *aux = fl->inicio;
    while (aux != NULL) {
        mostraCliente(*aux);
        aux = aux->proximo;
    }
}

void apagaCliente(Cliente *cl) {
    free(cl);
}

void apagaFila(Fila *fl) {
    Cliente *aux;
    while ((aux = desenfileirar(fl)) != NULL) {
        apagaCliente(aux);
    }
    free(fl);
}

// Funções para manipulação de logs
void enfileirarLog(LogFila *lf, char message[]) {
    Log *novoLog = (Log *)malloc(sizeof(Log));
    strcpy(novoLog->message, message);
    novoLog->proximo = NULL;
    if (lf->inicio == NULL) {
        lf->inicio = novoLog;
    } else {
        lf->fim->proximo = novoLog;
    }
    lf->fim = novoLog;
    lf->qtd++;
}

char* desenfileirarLog(LogFila *lf) {
    if (lf->inicio == NULL) {
        return NULL;
    }
    Log *aux = lf->inicio;
    char *message = (char *)malloc(256 * sizeof(char));
    strcpy(message, aux->message);
    lf->inicio = aux->proximo;
    if (lf->inicio == NULL) {
        lf->fim = NULL;
    }
    free(aux);
    lf->qtd--;
    return message;
}

void mostraLogs(LogFila *lf) {
    while (!isEmptyLog(lf)) {
        char *log = desenfileirarLog(lf);
        printf("%s\n", log);
        free(log);
    }
}

int isEmptyLog(LogFila *lf) {
    return lf->inicio == NULL;
}

// Funções para operações bancárias
Banco* initializeBank(double initialBalance) {
    Banco *bank = (Banco *)malloc(sizeof(Banco));
    bank->caixaGeral = criaFila();
    bank->caixaPrioritaria = criaFila();
    bank->gerenteGeral = criaFila();
    bank->gerentePrioritaria = criaFila();
    bank->caixaLog = criaLogFila();
    bank->gerenteLog = criaLogFila();
    bank->saldo = initialBalance;
    return bank;
}

void depositar(Banco *banco, Cliente *cl) {
    banco->saldo += cl->valor;
    char log[256];
    printf("Depósito: R$%.2f, Saldo Atual: R$%.2f\n", cl->valor, banco->saldo);
    sprintf(log, "Depósito: R$%.2f, Saldo Atual: R$%.2f", cl->valor, banco->saldo);
    enfileirarLog(banco->caixaLog, log);
}

void sacar(Banco *banco, Cliente *cl) {
    if (cl->valor > banco->saldo) {
        char log[256];
        printf("Tentativa de Saque: R$%.2f, Saldo Insuficiente. Saldo Atual: R$%.2f\n", cl->valor, banco->saldo);
        sprintf(log, "Tentativa de Saque: R$%.2f, Saldo Insuficiente. Saldo Atual: R$%.2f", cl->valor, banco->saldo);
        enfileirarLog(banco->caixaLog, log);
        sprintf(log, "Aviso ao Gerente: Tentativa de Saque sem Saldo. Valor: R$%.2f", cl->valor);
        enfileirarLog(banco->gerenteLog, log);
    } else {
        banco->saldo -= cl->valor;
        char log[256];
        printf("Saque: R$%.2f, Saldo Atual: R$%.2f\n", cl->valor, banco->saldo);
        sprintf(log, "Saque: R$%.2f, Saldo Atual: R$%.2f", cl->valor, banco->saldo);
        enfileirarLog(banco->caixaLog, log);
        
        if (banco->saldo == 0) {
            printf("Aviso ao Gerente: Saldo Zerado no Caixa.\n");
            sprintf(log, "Aviso ao Gerente: Saldo Zerado no Caixa.");
            enfileirarLog(banco->gerenteLog, log);
        }
    }
}

void emprestimo(Banco *banco, Cliente *cl) {
    char log[256];
    printf("Empréstimo solicitado por %s\n", cl->nome);
    sprintf(log, "Empréstimo solicitado por %s", cl->nome);
    enfileirarLog(banco->gerenteLog, log);
}

void aplicacao(Banco *banco, Cliente *cl) {
    char log[256];
    printf("Aplicação solicitada por %s\n", cl->nome);
    sprintf(log, "Aplicação solicitada por %s", cl->nome);
    enfileirarLog(banco->gerenteLog, log);
}

void menu(Banco *banco, int id) {
    int op, recurso, idade;
    Cliente *cl;
    char nome[20];
    float vl;

    do {
        printf("\n\nInforme uma Opção:");
        printf("\n -- 1 - para Insere:");
        printf("\n -- 2 - para Remove:");
        printf("\n -- 3 - Mostra Fila:");
        printf("\n -- 4 - Apaga Fila:");
        printf("\n -- 5 - Mostra Logs Caixa:");
        printf("\n -- 6 - Mostra Logs Gerente:");
        printf("\n -- 0 - para Sair do Programa:\n");
        printf("\nInforme sua Opção: ");
        scanf("%d", &op);
        fflush(stdin);

        switch (op) {
            case 1:
                printf("\nFunção Insere na Fila.\n");
                printf("Informe o seu nome: ");
                scanf("%s", nome);
                printf("Informe a idade: ");
                scanf("%d", &idade);
                printf("Informe a operacao (1 para Saque, 2 para Depósito, 3 para Empréstimo, 4 para Aplicação): ");
                scanf("%d", &op);
                printf("Informe o recurso (1 para Caixa, 2 para Gerente): ");
                scanf("%d", &recurso);
                if (op == 1 || op == 2) {
                    printf("Informe o Valor: ");
                    scanf("%f", &vl);
                } else {
                    vl = 0.0;
                }
                cl = cadastraNovoCliente(nome, idade, op, vl, id++);
                if (recurso == 1) {
                    if (idade > 60) {
                        enfileirar(banco->caixaPrioritaria, cl);
                    } else {
                        enfileirar(banco->caixaGeral, cl);
                    }
                } else if (recurso == 2) {
                    if (idade > 60) {
                        enfileirar(banco->gerentePrioritaria, cl);
                    } else {
                        enfileirar(banco->gerenteGeral, cl);
                    }
                }
                printf("\nInserção Realizada com Sucesso\n");
                break;
            case 2:
                printf("\nFunção Remove da Fila.\n");
                if (!isEmpty(banco->caixaPrioritaria)) {
                    cl = desenfileirar(banco->caixaPrioritaria);
                } else if (!isEmpty(banco->caixaGeral)) {
                    cl = desenfileirar(banco->caixaGeral);
                } else if (!isEmpty(banco->gerentePrioritaria)) {
                    cl = desenfileirar(banco->gerentePrioritaria);
                } else if (!isEmpty(banco->gerenteGeral)) {
                    cl = desenfileirar(banco->gerenteGeral);
                } else {
                    cl = NULL;
                    printf("Todas as filas estão vazias.\n");
                }

                if (cl != NULL) {
                    mostraCliente(*cl);
                    if (cl->operacao == 1) {
                        sacar(banco, cl);
                    } else if (cl->operacao == 2) {
                        depositar(banco, cl);
                    } else if (cl->operacao == 3) {
                        emprestimo(banco, cl);
                    } else if (cl->operacao == 4) {
                        aplicacao(banco, cl);
                    }
                    apagaCliente(cl);
                }
                printf("\nRemoção Realizada com Sucesso\n");
                break;
            case 3:
                printf("Mostra Fila:\n");
                printf("Fila Caixa Prioritária:\n");
                mostraFila(banco->caixaPrioritaria);
                printf("Fila Caixa Geral:\n");
                mostraFila(banco->caixaGeral);
                printf("Fila Gerente Prioritária:\n");
                mostraFila(banco->gerentePrioritaria);
                printf("Fila Gerente Geral:\n");
                mostraFila(banco->gerenteGeral);
                break;
            case 4:
                printf("\nApagar a Fila!!\n");
                apagaFila(banco->caixaPrioritaria);
                apagaFila(banco->caixaGeral);
                apagaFila(banco->gerentePrioritaria);
                apagaFila(banco->gerenteGeral);
                printf("Todas as filas foram apagadas.\n");
                break;
            case 5:
                printf("\nLogs do Caixa Eletrônico:\n");
                mostraLogs(banco->caixaLog);
                break;
            case 6:
                printf("\nLogs do Gerente:\n");
                mostraLogs(banco->gerenteLog);
                break;
            default:
                if (op != 0)
                    printf("\nOpção Inválida!!\n");
        }

    } while (op != 0);
}

int main() {
    int id = 0;
    Banco *banco = initializeBank(1000.0);

    menu(banco, id);

    apagaFila(banco->caixaPrioritaria);
    apagaFila(banco->caixaGeral);
    apagaFila(banco->gerentePrioritaria);
    apagaFila(banco->gerenteGeral);
    free(banco->caixaLog);
    free(banco->gerenteLog);
    free(banco);

    return 0;
}

