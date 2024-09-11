#include <stdio.h>
#include <stdlib.h>

#define n_elem 5 

void imprimeVetor(int vt[], int n){
    printf ("\n Função imprime vetor");
    printf("\n V = ["); 
    int i;
    for(i=0; i<n-1; i++){
        printf(" %d,",vt[i]);
    }
    printf(" %d ] \n",vt[i]);
}

void imprimeVetorInvertido(int vt[], int n){
    printf("\n Função imprime vetor Invertido ");
    printf("\n V = ["); 
    int i;
    for(i=n-1; i>0; i--){
        printf(" %d,",vt[i]);
    }
    printf(" %d ] \n",vt[i]);
}

// função com ponteiro de vetor
void imprimeVetorPonteiro(int *vt, int n){
    printf ("\n Função imprime vetor Ponteiro");
    printf("\n V = ["); 
    int i;
    for(i=0; i<n-1; i++){
        printf(" %d,",*(vt+i));
    }
    printf(" %d ] \n",*(vt+i));
}

// função com ponteiro de vetor
void imprimeVetorInvertidoPonteiro(int *vt, int n){
    printf("\n Função imprime vetor Invertido Ponteiro ");
    printf("\n V = ["); 
    int i;
    for(i=n-1; i>0; i--){
        printf(" %d,",*(vt+i));
    }
    printf(" %d ] \n",*(vt+i));
}


int main(){       

    int v[5] = {3,4,5,2,1};

    //passagem de um vetor para função
    imprimeVetor(v,5);
    imprimeVetorInvertido(v,5);

    //passagem de um ponteiro de vetor para função
    imprimeVetorPonteiro(v,5);
    imprimeVetorInvertidoPonteiro(v,5);

}

