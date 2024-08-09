#include <stdio.h>
#include <stdlib.h>
#include <string.h>

typedef struct cliente {
    char nome[20];
    int operacao;
    float valor;
    int id;
    int idade;
    struct cliente *proximo;
} Cliente;

typedef struct fila {
    Cliente *inicio;
    Cliente *fim;
    int qtd;
} Fila;

typedef struct log {
    char mensagem[256];
    struct log *proximo;
} Log;

typedef struct logFila {
    Log *inicio;
    Log *fim;
    int qtd;
} LogFila;

typedef struct banco {
    Fila *caixaPrioritaria;
    Fila *caixaGeral;
    Fila *gerentePrioritaria;
    Fila *gerenteGeral;
    Fila *atendidos; // Nova fila para registrar atendimentos
    LogFila *caixaLog;
    LogFila *gerenteLog;
    double saldo;
} Banco;

Fila* criaFila() {
    Fila *fl = (Fila *)malloc(sizeof(Fila));
    if (fl == NULL) {
        printf("Erro de alocação de memória.\n");
        exit(EXIT_FAILURE);
    }
    fl->inicio = NULL;
    fl->fim = NULL;
    fl->qtd = 0;
    return fl;
}

LogFila* criaLogFila() {
    LogFila *lf = (LogFila *)malloc(sizeof(LogFila));
    if (lf == NULL) {
        printf("Erro de alocação de memória.\n");
        exit(EXIT_FAILURE);
    }
    lf->inicio = NULL;
    lf->fim = NULL;
    lf->qtd = 0;
    return lf;
}

Cliente* cadastraNovoCliente(char nome[], int idade, int op, float vl, int id) {
    Cliente *novo = (Cliente *)malloc(sizeof(Cliente));
    if (novo == NULL) {
        printf("Erro de alocação de memória.\n");
        exit(EXIT_FAILURE);
    }
    strcpy(novo->nome, nome);
    novo->operacao = op;
    novo->valor = vl;
    novo->id = id;
    novo->idade = idade;
    novo->proximo = NULL;
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
    return aux;
}

void mostraCliente(Cliente cl) {
    printf("\nId: %d\n\tNome: %s\n\tIdade: %d\n\tOperacao: %d\n\tValor: %.2f\n",
           cl.id, cl.nome, cl.idade, cl.operacao, cl.valor);
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
    Cliente *aux = desenfileirar(fl);
    while (aux != NULL) {
        apagaCliente(aux);
        aux = desenfileirar(fl);
    }
}

void enfileirarLog(LogFila *lf, char mensagem[]) {
    Log *novoLog = (Log *)malloc(sizeof(Log));
    if (novoLog == NULL) {
        printf("Erro de alocação de memória.\n");
        exit(EXIT_FAILURE);
    }
    strcpy(novoLog->mensagem, mensagem);
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
    char *mensagem = (char *)malloc(256 * sizeof(char));
    if (mensagem == NULL) {
        printf("Erro de alocação de memória.\n");
        exit(EXIT_FAILURE);
    }
    strcpy(mensagem, aux->mensagem);
    lf->inicio = aux->proximo;
    if (lf->inicio == NULL) {
        lf->fim = NULL;
    }
    free(aux);
    lf->qtd--;
    return mensagem;
}

int isEmptyLog(LogFila *lf) {
    return lf->inicio == NULL;
}

int isEmpty(Fila *fl) {
    return fl->inicio == NULL;
}

Banco* inicializarBanco(double saldoInicial) {
    Banco *bco = (Banco *)malloc(sizeof(Banco));
    if (bco == NULL) {
        printf("Erro de alocação de memória.\n");
        exit(EXIT_FAILURE);
    }
    bco->caixaPrioritaria = criaFila();
    bco->caixaGeral = criaFila();
    bco->gerentePrioritaria = criaFila();
    bco->gerenteGeral = criaFila();
    bco->atendidos = criaFila(); // Inicializa a nova fila atendidos
    bco->caixaLog = criaLogFila();
    bco->gerenteLog = criaLogFila();
    bco->saldo = saldoInicial;
    return bco;
}

void depositar(Banco *banco, Cliente *cl) {
    banco->saldo += cl->valor;
    printf("Deposito: R$%.2f, Saldo Atual: R$%.2f\n", cl->valor, banco->saldo);
    char log[256];
    sprintf(log, "Depósito: R$%.2f, Saldo Atual: R$%.2f", cl->valor, banco->saldo);
    enfileirarLog(banco->caixaLog, log);
}

void sacar(Banco *banco, Cliente *cl) {
    if (cl->valor > banco->saldo) {
        char log[256];
        printf("Tentativa de Saque: R$%.2f, Saldo Insuficiente. Saldo Atual: R$%.2f\n", cl->valor, banco->saldo);
        sprintf(log, "Tentativa de Saque: R$%.2f, Saldo Insuficiente. Saldo Atual: R$%.2f", cl->valor, banco->saldo);
        enfileirarLog(banco->caixaLog, log);
        printf("Aviso ao Gerente: Tentativa de Saque sem Saldo. Valor: R$%.2f\n", cl->valor);
        sprintf(log, "Aviso ao Gerente: Tentativa de Saque sem Saldo. Valor: R$%.2f", cl->valor);
        enfileirarLog(banco->gerenteLog, log);
    } else {
        banco->saldo -= cl->valor;
        char log[256];
        printf("Saque: R$%.2f, Saldo Atual: R$%.2f\n", cl->valor, banco->saldo);
        sprintf(log, "Saque: R$%.2f, Saldo Atual: R$%.2f", cl->valor, banco->saldo);
        enfileirarLog(banco->caixaLog, log);

        if (banco->saldo <= 0) {
            printf("Aviso ao Gerente: Saldo Zerado no Caixa.\n");
            sprintf(log, "Aviso ao Gerente: Saldo Zerado no Caixa.");
            enfileirarLog(banco->gerenteLog, log);
            banco->saldo += 1000.0;
            printf("Caixa Reabastecido: Novo Saldo: R$%.2f\n", banco->saldo);
            sprintf(log, "Caixa Reabastecido: Novo Saldo: R$%.2f", banco->saldo);
            enfileirarLog(banco->caixaLog, log);
        }
    }   
}

void emprestimo(Banco *banco, Cliente *cl) {
    printf("Emprestimo solicitado por: %s, ID: %d\n", cl->nome, cl->id);
    char log[256];
    sprintf(log, "Empréstimo solicitado por: %s, ID: %d", cl->nome, cl->id);
    enfileirarLog(banco->gerenteLog, log);
}

void aplicacao(Banco *banco, Cliente *cl) {
    char log[256];
    printf("Aplicacao solicitada por: %s, ID: %d\n", cl->nome, cl->id);
    sprintf(log, "Aplicacao solicitada por: %s, ID: %d", cl->nome, cl->id);
    enfileirarLog(banco->gerenteLog, log);
}

void processarCliente(Banco *banco, Cliente *cl) {
    switch (cl->operacao) {
        case 1: // Depositar
            depositar(banco, cl);
            break;
        case 2: // Sacar
            sacar(banco, cl);
            break;
        case 3: // Emprestimo
            emprestimo(banco, cl);
            break;
        case 4: // Aplicar  
            aplicacao(banco, cl);      
        default:
            printf("Operacao invalida.\n");
    }
}

void atenderClientes(Banco *banco, Fila *fila) {
    while (!isEmpty(fila)) {
        Cliente *cl = desenfileirar(fila);
        processarCliente(banco, cl);
        enfileirar(banco->atendidos, cl); // Registra na fila de atendidos
    }
}

void mostraLogs(LogFila *lf) {
    while (!isEmptyLog(lf)) {
        char *mensagem = desenfileirarLog(lf);
        printf("%s\n", mensagem);
        free(mensagem);
    }
}

void menu(Banco *banco, int *id) {
    int opcao;
    do {
        printf("\n1. Novo cliente\n2. Atender Cliente Caixa\n3. Atender Cliente Gerente\n4. Mostrar Fila Caixa\n5. Mostrar Fila Gerente\n6. Mostrar Logs Caixa\n7. Mostrar Logs Gerente\n8. Mostrar Atendidos\n9. Sair\n");
        scanf("%d", &opcao);

        switch (opcao) {
            case 1: {
                char nome[20];
                int idade, operacao;
                float valor;
                printf("Digite o nome do cliente: ");
                scanf("%s", nome);
                printf("Digite a idade do cliente: ");
                scanf("%d", &idade);
                printf("Escolha a operacao: 1. Depositar 2. Sacar 3. Emprestimo: ");
                scanf("%d", &operacao);
                printf("Digite o valor: ");
                scanf("%f", &valor);

                Cliente *novoCliente = cadastraNovoCliente(nome, idade, operacao, valor, *id);
                (*id)++;

                if (operacao == 3) { // Se operação for empréstimo, direciona ao gerente
                    if (idade >= 60) {
                        enfileirar(banco->gerentePrioritaria, novoCliente);
                    } else {
                        enfileirar(banco->gerenteGeral, novoCliente);
                    }
                } else { // Caso contrário, direciona ao caixa
                    if (idade >= 60) {
                        enfileirar(banco->caixaPrioritaria, novoCliente);
                    } else {
                        enfileirar(banco->caixaGeral, novoCliente);
                    }
                }
                break;
            }
            case 2:
                printf("Atendendo clientes no caixa...\n");
                atenderClientes(banco, banco->caixaPrioritaria);
                atenderClientes(banco, banco->caixaGeral);
                break;
            case 3:
                printf("Atendendo clientes no gerente...\n");
                atenderClientes(banco, banco->gerentePrioritaria);
                atenderClientes(banco, banco->gerenteGeral);
                break;
            case 4:
                printf("Clientes na fila do caixa:\n");
                printf("Prioritária:\n");
                mostraFila(banco->caixaPrioritaria);
                printf("Geral:\n");
                mostraFila(banco->caixaGeral);
                break;
            case 5:
                printf("Clientes na fila do gerente:\n");
                printf("Prioritária:\n");
                mostraFila(banco->gerentePrioritaria);
                printf("Geral:\n");
                mostraFila(banco->gerenteGeral);
                break;
            case 6:
                printf("Logs do caixa:\n");
                mostraLogs(banco->caixaLog);
                break;
            case 7:
                printf("Logs do gerente:\n");
                mostraLogs(banco->gerenteLog);
                break;
            case 8:
                printf("Clientes atendidos:\n");
                mostraFila(banco->atendidos);
                break;
            case 9:
                printf("Saindo...\n");
                break;
            default:
                printf("Opcao invalida.\n");
                break;
        }
    } while (opcao != 9);
}

int main() {
    Banco *banco = inicializarBanco(1000.0);
    int id = 1;

    menu(banco, &id);

    // Liberação de memória
    apagaFila(banco->caixaPrioritaria);
    apagaFila(banco->caixaGeral);
    apagaFila(banco->gerentePrioritaria);
    apagaFila(banco->gerenteGeral);
    apagaFila(banco->atendidos);
    mostraLogs(banco->caixaLog);
    mostraLogs(banco->gerenteLog);
    free(banco->caixaLog);
    free(banco->gerenteLog);
    free(banco);

    return 0;
}
