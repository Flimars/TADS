#include <stdio.h>
#include <stdlib.h>
#include <string.h>

typedef struct cliente {
    char nome[20];
    int operacao;  // 1 para Depósito, 2 para Saque
    float valor;
    int id;
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

typedef struct bank {
    LogFila *atmLog;
    LogFila *managerLog;
    double atmBalance;
} Bank;

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
Cliente* cadastraNovoCliente(char nome[], int op, double vl, int id) {
    Cliente *novo = (Cliente *)malloc(sizeof(Cliente));
    strcpy(novo->nome, nome);
    novo->operacao = op;
    novo->valor = vl;
    novo->proximo = NULL;
    novo->id = id;
    return novo;
}

void enfileirar(Fila *fl, Cliente *cl) {
    if (fl->inicio == NULL) {  // Fila Vazia
        fl->inicio = cl;
    } else {  // Fila com elementos
        fl->fim->proximo = cl;     
    }
    cl->proximo = NULL;
    fl->fim = cl;
    fl->qtd++;
}

Cliente* desenfileirar(Fila *fl) {
    Cliente *aux = fl->inicio;
    if (aux == NULL)  // Fila vazia
        printf("\nErro - Fila Vazia\n");
    else {  // Lista com elementos
        fl->inicio = aux->proximo;
        fl->qtd--;
        aux->proximo = NULL;
        if (fl->inicio == NULL)
            fl->fim = NULL;
    }
    return aux;
}

void mostraCliente(Cliente cl) {
    printf("\n Id:%d \n\t Nome: %s \n\t Operacao %d \n\t Valor=%.2f \n", cl.id, cl.nome, cl.operacao, cl.valor);
}

void mostraFila(Fila *fl) {
    printf("\nInício da Fila\n");
    Cliente *aux = fl->inicio;
    while (aux != NULL) {
        mostraCliente(*aux);
        aux = aux->proximo;
    }
    printf("\nFim da Fila\n");
}

void apagaCliente(Cliente *cl) {
    printf("\n Apagado!");
    free(cl);
}

void apagaFila(Fila *fl) {
    Cliente *aux = desenfileirar(fl);
    while (aux != NULL) {
        apagaCliente(aux);
        aux = desenfileirar(fl);
    }
    printf("\nFila Vazia - Qtd = %d\n", fl->qtd);
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

int isEmptyLog(LogFila *lf) {
    return lf->inicio == NULL;
}

// Funções para operações bancárias
Bank* initializeBank(double initialBalance) {
    Bank *bank = (Bank *)malloc(sizeof(Bank));
    bank->atmLog = criaLogFila();
    bank->managerLog = criaLogFila();
    bank->atmBalance = initialBalance;
    return bank;
}

void deposit(Bank *bank, Cliente *cl) {
    bank->atmBalance += cl->valor;
    char log[256];
    sprintf(log, "Depósito: R$%.2f, Saldo Atual: R$%.2f", cl->valor, bank->atmBalance);
    enfileirarLog(bank->atmLog, log);
}

void withdraw(Bank *bank, Cliente *cl) {
    if (cl->valor > bank->atmBalance) {
        char log[256];
        sprintf(log, "Tentativa de Saque: R$%.2f, Saldo Insuficiente. Saldo Atual: R$%.2f", cl->valor, bank->atmBalance);
        enfileirarLog(bank->atmLog, log);
        sprintf(log, "Aviso ao Gerente: Tentativa de Saque sem Saldo. Valor: R$%.2f", cl->valor);
        enfileirarLog(bank->managerLog, log);
    } else {
        bank->atmBalance -= cl->valor;
        char log[256];
        sprintf(log, "Saque: R$%.2f, Saldo Atual: R$%.2f", cl->valor, bank->atmBalance);
        enfileirarLog(bank->atmLog, log);
        
        if (bank->atmBalance == 0) {
            sprintf(log, "Aviso ao Gerente: Saldo Zerado no Caixa.");
            enfileirarLog(bank->managerLog, log);
        }
    }
}

void mostraSaldo(Bank *bank) {
    printf("\nSaldo Atual do Caixa Eletrônico: R$%.2f\n", bank->atmBalance);
}

void menu(Fila *fl, Bank *bank, int id) {
    int op;
    Cliente *cl;
    char nome[20];
    float vl;
    do {
        printf("\n\nInforme uma Opção:");
        printf("\n -- 1 - para Insere:");
        printf("\n -- 2 - para Remove:");
        printf("\n -- 3 - MostraFila:");
        printf("\n -- 4 - Apaga Fila:");
        printf("\n -- 5 - Mostra Logs ATM:");
        printf("\n -- 6 - Mostra Logs Gerente:");
        printf("\n -- 7 - Mostra Saldo:");
        printf("\n -- 0 - para Sair do Programa:\n");
        printf("\nInforme sua Opçao:");
        scanf("%d", &op);
        fflush(stdin);
        
        switch(op) {
            case 1:                
                printf("\n Função Insere na Fila. \n");
                printf("Informe o seu nome:");
                scanf("%s", nome);
                printf("Informe a operacao (1 para Depósito, 2 para Saque):");
                scanf("%d", &op);
                printf("Informe o Valor:");
                scanf("%f", &vl);
                cl = cadastraNovoCliente(nome, op, vl, id++);
                enfileirar(fl, cl);
                printf("\n Inserção Realizada com Sucesso");
            break;
            case 2:
                printf("\n Função Remove da Fila. \n");
                cl = desenfileirar(fl);
                if (cl != NULL) {
                    mostraCliente(*cl);
                    if (cl->operacao == 1) {
                        deposit(bank, cl);
                    } else if (cl->operacao == 2) {
                        withdraw(bank, cl);
                    }
                    apagaCliente(cl);
                }
                printf("\n Remoção Realizada com Sucesso");
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
                printf("\n Logs do Caixa Eletrônico:\n");
                while (!isEmptyLog(bank->atmLog)) {
                    char *log = desenfileirarLog(bank->atmLog);
                    printf("%s\n", log);
                    free(log);
                }
            break;
            case 6:
                printf("\n Logs do Gerente:\n");
                while (!isEmptyLog(bank->managerLog)) {
                    char *log = desenfileirarLog(bank->managerLog);
                    printf("%s\n", log);
                    free(log);
                }
            break;
            case 7:
                mostraSaldo(bank);
            break;
            default:
                printf("\nOpção Inválida!!\n");
        }
    
    } while(op > 0);
}

int main() {
    int id = 0;
    Fila *fl;
    Bank *bank;
    double initialBalance = 1000.0;  // Saldo inicial do caixa eletrônico

    fl = criaFila();
    bank = initializeBank(initialBalance);

    menu(fl, bank, id);
    
    free(fl);
    free(bank->atmLog);
    free(bank->managerLog);
    free(bank);
    
    return 0;
}
