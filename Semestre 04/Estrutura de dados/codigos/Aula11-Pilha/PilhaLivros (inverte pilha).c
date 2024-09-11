#include <stdio.h>
#include <stdlib.h>
#include <string.h>

typedef struct livro{   //dados do Livro livro
    char autor [20];
    char titulo [20];
    int ano;
    int id;
    struct livro *proximo;
}Livro;


typedef struct pilha{   //atributos de pilha
    Livro *topo;
    int qtd;
}Pilha;

Pilha* criaPilha(){
    //cria estrutura para pilha
    Pilha *p  = (Pilha *)malloc(sizeof(Pilha));
    p->topo = NULL;
    p->qtd = 0;
    return p;
}

Livro* criaLivroPilha(int id, int ano, char at [] , char tit [] ){
    //cria um Livro de pilha
    Livro *novoLivro = (Livro *)malloc(sizeof(Livro));
    novoLivro->proximo = NULL;
    novoLivro->ano = ano;
    strcpy(novoLivro->autor,at);
    strcpy(novoLivro->titulo,tit);
    novoLivro->id = id;
    return novoLivro;
}


void push(Pilha *p, Livro *lv){
    //empura um Livro na pilha
    lv->proximo = p->topo;
    p->topo = lv;
    p->qtd++;
}

Livro* pop(Pilha *p){
    //salta um Livro da pilha
    Livro *aux = p->topo;
    if(aux != NULL){
        p->topo = p->topo->proximo;
        p->qtd--;
        aux->proximo = NULL;
    }
    return aux;
}

void mostraLivroPilha(Livro lv){
    printf("\n\t %d - Titulo: %s \n\t Autor: %s \n\t Ano: %d \n",lv.id,lv.titulo,lv.autor,lv.ano);
}

void mostraTopo(Pilha *p){
    if(p->topo != NULL){
        printf("\n Mostra TOPO - Pilha");
        mostraLivroPilha(*p->topo);
    }else{
        printf("\n TOPO NULO - Pilha Vazia \n");
    }
}


void apagaPilha(Pilha *p){
    //apaga os Livros da pilha
    while(p->topo !=NULL){
        free(pop(p));
    }
    mostraTopo(p);
}


void mostraPilha(Pilha p){
    Livro *aux = p.topo;
    if(aux == NULL)
        printf("\n  -- Pilha Vazia!!\n");
    else
        while(aux !=NULL){
            mostraLivroPilha(*aux);
            aux = aux->proximo;
        }
}



void menu(Pilha *p1, Pilha *p2, int ct){
    int op, posicao;
    Pilha *nova;
    Livro *lv;
    char ch;
    int ano;
    char titulo[20], autor[20];
    do{
        printf("\n\nInforme uma Opção:");
        printf("\n -- 1 - PUSH:");
        printf("\n -- 2 - POP:");
        printf("\n -- 3 - Mostra TOPO:");   
        printf("\n -- 4 - Mostrar Pilha:");
        printf("\n -- 5 - Apagar Pilha:");
        printf("\n -- 6 - Inverte Pilha:");
        printf("\n -- 0 - Sair do Programa:\n");
        printf("\nInforme sua Opçao:");
        scanf("%d",&op);
        fflush(stdin);
        
        switch(op){
            case 1:                
                printf("\n Função PUSH. \n");
                printf("Informe o Titulo do Livro:");
                scanf("%s",titulo);
                printf("Informe o Autor:");
                scanf("%s",autor);
                printf("Informe o Ano:");
                scanf("%d",&ano);
                push(p1,criaLivroPilha(ct++,ano,autor,titulo));
                printf("\n Inserção Realizada com Sucesso");
             
            break;
            case 2:
                printf("\n Função POP. \n");
                lv = pop(p1);
                if(lv!=NULL){
                    mostraLivroPilha(*lv);
                    printf("\n --- Remoção Realizada com Sucesso!!");
                }else{
                    printf("\n --- ERRO - Remoção inválida!!");
                }               
            break;
            case 3:                
                printf("Mostra TOPO Pilha:");
                mostraTopo(p1);
            break;
            case 4:
                printf("\nMostra Pilha:");
                mostraPilha(*p1);
            break;
            case 5:
                printf("\n Apagar a Pilha !! \n");
                apagaPilha(p1);
            break;
            case 6:
                printf("Inverte Pilha");
                printf("\n Pilha 1 :");
                mostraPilha(*p1);
                printf("\n Pilha P1 - Invertida :");
               // invertePilha(p1);                
                mostraPilha(*p1);
            break;

            case 7:
                printf("Inverte NOVA Pilha");
                printf("\n Pilha 1 :");
                mostraPilha(*p1);
                printf("\n Pilha P2 - Invertida :");
                // nova = invertePilha2(p1);                
                // mostraPilha(nova);
            break;

            default:
                printf("\nFim do programa!!\n");
        }
       
    
    }while(op>0);
}

int main(){

    Pilha *p1,*p2;
    Livro *l1, *l2, *l3, *aux;

    p1 = criaPilha(); //pilha end X
    p2 = criaPilha();

    int ct =1;
    
    l1 = criaLivroPilha(ct++,2016,"Paul Deitel and  Harvey Deitel","Java: Como Programar");
    l2 = criaLivroPilha(ct++,2006,"H. M. Deitel","C++: Como Programar 5°Ed.");
    l3 = criaLivroPilha(ct++,2016,"Allen B. Downey","Pense em Python:");   

    push(p1,l1);
    push(p1,l2);
    push(p1,l3);

    menu(p1,p2,ct);
    
    exit(0);
}