#include <stdio.h>
#include <stdlib.h>

#define n_elem 5 

int somaDez(int *vt, int n){
    for(int i=0; i<n; i++)
        *(vt+i) = *(vt+i)+10;
}

void imprimeVetor(int *vt, int n){
    for(int i=0; i<n; i++){
        printf("\n V[%d] = %d",i,*(vt+i));
    }
    printf("\n");
}

void menorDoVetor(int *vt, int *menor, int n){
    int mim = *vt;
    for(int i=1; i<n; i++){
        if(*(vt+i)<mim)
            mim = *(vt+i);
    }
    *menor = mim;
}



int main(){       
    int v[5] = {3,4,5,2,1};
    imprimeVetor(v,5);    
    
    int menorValor;
    menorDoVetor(v,&menorValor,5);
    printf("\n O menor valor do Vetor = %d\n",menorValor);

    //ponteiro e vetor para varrer o vetor 
    int *p = v;
    for(int i=0; i<5;i++)
         printf("\n V[%d] = %d",i,*(p+i));
    printf("\n");

    somaDez(p,5);
    imprimeVetor(p,5);   
}

