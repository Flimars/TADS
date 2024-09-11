#include <stdio.h>
#include <stdlib.h>
#include <string.h>

// Definições de constantes
#define TAMANHO_TABELA 7
#define TAMANHO_IP 16
#define TAMANHO_DOMINIO 100

// Definição da estrutura de um nó na lista encadeada
typedef struct No
{
    char ip[TAMANHO_IP];
    char dominio[TAMANHO_DOMINIO];
    struct No *proximo;
} No;

// Funções de Hash
// Função para calcular o hash de um IP
unsigned int hash_ip(const char *ip)
{
    unsigned int hash = 0;  // Inicializa a variavel hash sem sinal
    while (*ip)             // Percorre cada caractere do domínio até o final da string
    {
        hash = (hash *32) + *ip++;  // Desloca o hash 5 bits à esquerda e adiciona o valor ASCII do caractere
    }
    return hash % TAMANHO_TABELA;  //Calculo do FC 
}

unsigned int hash_dominio(const char *dominio)
{
    unsigned int hash = 0;
    while (*dominio)
    {
        hash = (hash * 32) + *dominio++;
    }
    return hash % TAMANHO_TABELA;
}

// Função para criar um novo nó na lista encadeada
No *criar_no(const char *ip, const char *dominio)
{
    No *novo = (No *)malloc(sizeof(No));  // Aloca memória para um novo nó
    if (novo)                             // Verifica se a alocação foi bem-sucedida
    {
        strcpy(novo->ip, ip);             // Copia o IP para o campo ip do novo nó
        strcpy(novo->dominio, dominio);   // Copia o domínio para o campo dominio
        novo->proximo = NULL;             // Inicializa o ponteiro como NULL
    }
    return novo;                          // Retorna o ponteiro para o novo nó
}

// Função para inserir um novo site na tabela hash baseado no IP
void inserir_por_ip(No *tabela[], const char *ip, const char *dominio)
{
    unsigned int indice = hash_ip(ip);       // Calcula o índice na tabela hash usando o IP
    No *novo = criar_no(ip, dominio);        // Cria um novo nó com o IP e o domínio fornecidos
    if (novo)                                // Verifica se a criação do nó foi bem-sucedida
    {
        novo->proximo = tabela[indice];      // Aponta o novo nó para o início da lista 
        tabela[indice] = novo;               // Coloca o novo nó na posição correspondente da tabela hash 
    }
}

// Função para inserir um novo site na tabela hash baseado no domínio
void inserir_por_dominio(No *tabela[], const char *dominio, const char *ip)
{
    unsigned int indice = hash_dominio(dominio);
    No *novo = criar_no(ip, dominio);
    if (novo)
    {
        novo->proximo = tabela[indice];
        tabela[indice] = novo;
    }
}

// Função para buscar um site na tabela hash usando o IP
No *buscar_por_ip(No *tabela[], const char *ip)
{
    unsigned int indice = hash_ip(ip);          // Calcula o índice na tabela hash
    No *atual = tabela[indice];                 // Aponta para o início da lista no índice calculado
    while (atual)
    {
        if (strcmp(atual->ip, ip) == 0)         // Compara o IP atual com o IP buscado
        {
            return atual;                       // Retorna o nó encontrado   
        }
        atual = atual->proximo;                 // Avança para o próximo nó na lista
    }
    return NULL;
}

// Busca por Domínio
No *buscar_por_dominio(No *tabela[], const char *dominio)
{
    unsigned int indice = hash_dominio(dominio);
    No *atual = tabela[indice];
    while (atual)
    {
        if (strcmp(atual->dominio, dominio) == 0)
        {
            return atual;
        }
        atual = atual->proximo;
    }
    return NULL;
}

// Função para remover um site da tabela hash usando o IP
void remover_por_ip(No *tabela[], const char *ip)
{
    unsigned int indice = hash_ip(ip);          // Calcula o índice na tabela hash usando o IP
    No *atual = tabela[indice];                 // Aponta para o início da lista no índice calculado
    No *anterior = NULL;                        // Ponteiro para o nó anterior, inicializado como NULL
    while (atual)                               // Percorre a lista no índice
    {
        if (strcmp(atual->ip, ip) == 0)         // Compara o IP atual com o IP a ser removido
        {
            if (anterior)                       // Se houver um nó anterior, faz o anterior apontar para o próximo nó
            {
                anterior->proximo = atual->proximo;
            }
            else                                // Se não houver nó anterior, atualiza o início da lista
            {
                tabela[indice] = atual->proximo;
            }
            free(atual);
            return;
        }
        anterior = atual;                       // Atualiza o ponteiro anterior para o nó atual
        atual = atual->proximo;                  // Avança para o próximo nó na lista
    }
}

// Função para remover um site da tabela hash usando o domínio
void remover_por_dominio(No *tabela[], const char *dominio)
{
    unsigned int indice = hash_dominio(dominio);
    No *atual = tabela[indice];
    No *anterior = NULL;
    while (atual)
    {
        if (strcmp(atual->dominio, dominio) == 0)
        {
            if (anterior)
            {
                anterior->proximo = atual->proximo;
            }
            else
            {
                tabela[indice] = atual->proximo;
            }
            free(atual);
            return;
        }
        anterior = atual;
        atual = atual->proximo;
    }
}

// Função para inicializar a tabela hash, preenchendo-a com NULL
void inicializar_tabela(No *tabela[])
{
    for (int i = 0; i < TAMANHO_TABELA; i++)            // Itera sobre todos os índices da tabela
    {
        tabela[i] = NULL;                               // Define todos os elementos da tabela como NULL
    }
}

// Função para exibir o conteúdo da tabela hash
void exibir_tabela(No *tabela[])
{
    for (int i = 0; i < TAMANHO_TABELA; i++)            // Itera sobre todos os índices da tabela
    {
        printf("Indice %d: ", i);                       // Exibe o índice atual
        No *atual = tabela[i];                          // Aponta para o início da lista no índice atual
        while (atual)                                   // Percorre a lista no índice atual
        {
            printf("(%s, %s) -> ", atual->ip, atual->dominio);  // Exibe o IP e o domínio no nó atual
            atual = atual->proximo;                     // Avança para o próximo nó na lista
        }
        printf("NULL\n");                               // Indica o fim da lista com NULL
    }
}

int main()
{
    No *tabela_ip[TAMANHO_TABELA];          // Declara a tabela hash para IPs
    No *tabela_dominio[TAMANHO_TABELA];     // Declara a tabela hash para Dominio
    int opcao;
    char ip[TAMANHO_IP];                     // Variável para armazenar o IP inserido pelo usuário
    char dominio[TAMANHO_DOMINIO];            // Variável para armazenar o dominio inserido pelo usuário

// Inicializa as tabelas IP e Dominio
    inicializar_tabela(tabela_ip);
    inicializar_tabela(tabela_dominio);

    // Cadastro de 20 sites (exemplo com menos entradas por simplicidade)
    // Inserção de IP e domínio para o Google
    inserir_por_ip(tabela_ip, "8.8.8.8", "www.google.com");
    inserir_por_dominio(tabela_dominio, "www.google.com", "8.8.8.8");

    // Inserção de IP e domínio para o G1
    inserir_por_ip(tabela_ip, "186.192.90.5", "www.g1.com.br");
    inserir_por_dominio(tabela_dominio, "www.g1.com.br", "186.192.90.5");
    // Cadastro de 20 sites

    
    // Inserção de IP e domínio para o Facebook
    inserir_por_ip(tabela_ip, "31.13.71.36", "www.facebook.com");           
    inserir_por_dominio(tabela_dominio, "www.facebook.com", "31.13.71.36"); 

    // Inserção de IP e domínio para o Twitter
    inserir_por_ip(tabela_ip, "104.244.42.129", "www.twitter.com");           
    inserir_por_dominio(tabela_dominio, "www.twitter.com", "104.244.42.129"); 

    // Inserção de IP e domínio para o LinkedIn
    inserir_por_ip(tabela_ip, "108.174.10.10", "www.linkedin.com");           
    inserir_por_dominio(tabela_dominio, "www.linkedin.com", "108.174.10.10"); 

    // Inserção de IP e domínio para o Yahoo
    inserir_por_ip(tabela_ip, "98.138.219.231", "www.yahoo.com");           
    inserir_por_dominio(tabela_dominio, "www.yahoo.com", "98.138.219.231"); 

    // Inserção de IP e domínio para a Amazon
    inserir_por_ip(tabela_ip, "205.251.242.103", "www.amazon.com");        
    inserir_por_dominio(tabela_dominio, "www.amazon.com", "205.251.242.103"); 

    // Inserção de IP e domínio para o Netflix
    inserir_por_ip(tabela_ip, "54.235.240.0", "www.netflix.com");     
    inserir_por_dominio(tabela_dominio, "www.netflix.com", "54.235.240.0"); 

    // Inserção de IP e domínio para o YouTube
    inserir_por_ip(tabela_ip, "172.217.1.14", "www.youtube.com");           
    inserir_por_dominio(tabela_dominio, "www.youtube.com", "172.217.1.14"); 

    // Inserção de IP e domínio para o Instagram
    inserir_por_ip(tabela_ip, "157.240.22.35", "www.instagram.com");          
    inserir_por_dominio(tabela_dominio, "www.instagram.com", "157.240.22.35"); 
    // Inserção de IP e domínio para o Pinterest
    inserir_por_ip(tabela_ip, "151.101.0.84", "www.pinterest.com");          
    inserir_por_dominio(tabela_dominio, "www.pinterest.com", "151.101.0.84"); 

    // Inserção de IP e domínio para o Reddit
    inserir_por_ip(tabela_ip, "151.101.1.140", "www.reddit.com");           
    inserir_por_dominio(tabela_dominio, "www.reddit.com", "151.101.1.140"); 
    // Inserção de IP e domínio para o WhatsApp
    inserir_por_ip(tabela_ip, "157.240.0.0", "www.whatsapp.com");           
    inserir_por_dominio(tabela_dominio, "www.whatsapp.com", "157.240.0.0"); 

    // Inserção de IP e domínio para o eBay
    inserir_por_ip(tabela_ip, "66.135.196.12", "www.ebay.com");           
    inserir_por_dominio(tabela_dominio, "www.ebay.com", "66.135.196.12"); 

    // Inserção de IP e domínio para o Reddit
    inserir_por_ip(tabela_ip, "151.101.0.140", "www.reddit.com");           
    inserir_por_dominio(tabela_dominio, "www.reddit.com", "151.101.0.140"); 

    // Inserção de IP e domínio para o Dropbox
    inserir_por_ip(tabela_ip, "162.125.6.1", "www.dropbox.com");           
    inserir_por_dominio(tabela_dominio, "www.dropbox.com", "162.125.6.1"); 

    // Inserção de IP e domínio para o GitHub
    inserir_por_ip(tabela_ip, "140.82.113.3", "www.github.com");           
    inserir_por_dominio(tabela_dominio, "www.github.com", "140.82.113.3"); 

    // Inserção de IP e domínio para o Stack Overflow
    inserir_por_ip(tabela_ip, "151.101.1.69", "www.stackoverflow.com");           
    inserir_por_dominio(tabela_dominio, "www.stackoverflow.com", "151.101.1.69"); 

    // Inserção de IP e domínio para o WordPress
    inserir_por_ip(tabela_ip, "192.0.64.8", "www.wordpress.com");           
    inserir_por_dominio(tabela_dominio, "www.wordpress.com", "192.0.64.8"); 

    // Inserção de IP e domínio para o Mozilla
    inserir_por_ip(tabela_ip, "63.245.215.3", "www.mozilla.org");           
    inserir_por_dominio(tabela_dominio, "www.mozilla.org", "63.245.215.3"); 

    // Inserção de IP e domínio para o Quora
    inserir_por_ip(tabela_ip, "99.84.190.66", "www.quora.com");           
    inserir_por_dominio(tabela_dominio, "www.quora.com", "99.84.190.66"); 

    // Inserção de IP e domínio para o Slack
    inserir_por_ip(tabela_ip, "51.128.168.38", "www.slack.com");           
    inserir_por_dominio(tabela_dominio, "www.slack.com", "51.128.168.38"); 

    // Exibir as tabelas

    printf("\n|========== Tabela Hash por IP ==========\n");
    exibir_tabela(tabela_ip);
    printf("\n|========Tabela Hash por Dominio =========\n");
    exibir_tabela(tabela_dominio);
    printf("============================================\n");

    // Menu para interação com o usuário
    do
    {
        printf("\n|============= MENU =============|\n");
        printf("| 1. Inserir novo site...........|\n");
        printf("| 2. Buscar IP por dominio.......|\n");
        printf("| 3. Buscar dominio por IP.......|\n");
        printf("| 4. Remover site................|\n");
        printf("| 5. Imprimir tabela IP..........|\n");
        printf("| 6. Imprimir tabela Dominio.....|\n");
        printf("| 0. Sair........................|\n");
        printf("|======= Escolha uma opcao =======\n");
        scanf("%d", &opcao);

        switch (opcao)
        {
        case 1:
            printf("Digite o IP: ");
            scanf("%s", ip);                // Lê entrada do usuário
            printf("Digite o dominio: ");
            scanf("%s", dominio);           // Lê entrada do usuário
            inserir_por_ip(tabela_ip, ip, dominio);               // Insere o novo site na tabela
            inserir_por_dominio(tabela_dominio, dominio, ip);     // Insere o novo site na tabela
            break;
        case 2:
            printf("Digite o dominio: ");
            scanf("%s", dominio);
            No *resultIP = buscar_por_dominio(tabela_dominio, dominio);   // Busca o IP correspondente ao domínio
            if (resultIP)
            {
                printf("IP encontrado: %s\n", resultIP->ip);
            }
            else
            {
                printf("Dominio nao encontrado.\n");
            }
            break;
        case 3:
            printf("Digite o IP: ");
            scanf("%s", ip);
            No *resultDominio = buscar_por_ip(tabela_ip, ip);             // Busca o domínio correspondente ao IP
            if (resultDominio)
            {
                printf("Dominio encontrado: %s\n", resultDominio->dominio);
            }
            else
            {
                printf("IP nao encontrado.\n");
            }
            break;
        case 4:
            printf("Digite o IP ou dominio para remover: ");
            scanf("%s", ip);
            remover_por_ip(tabela_ip, ip);
            remover_por_dominio(tabela_dominio, ip);
            break;
        case 5:
            printf("Tabela Hash por IP:\n");
            exibir_tabela(tabela_ip);
            break;
        case 6:
            printf("Tabela Hash por Dominio:\n");
            exibir_tabela(tabela_dominio);
            break;
        case 0:
            printf("Saindo...\n");
            break;
        default:
            printf("Opcao invalida.\n");
            break;
        }
    } while (opcao != 0);

    return 0;
}
