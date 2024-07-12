#include <stdio.h>
#include <stdlib.h>

int retornaMaiorValor (int vt[], int n){
    int maior = vt[0];
    for(int i=0; i<n; i++ ){
        if(vt[i]> maior)
            maior = vt[i];
    }
    return maior;
}

int retornaMaiorValorPonteiro (int *vt, int n){ 
    int maior = *vt;
    for(int i=0; i<n; i++ ){
        if(vt[i]> maior)
            maior = *(vt+i);
    }
    return maior;
}

void somaDezVetor(int vt[], int n){
     for(int i=0; i<n; i++ ){
        vt[i]+=10;
     }
}

void imprimeVetor(int *vt, int n){
    for(int i=0; i<5;i++)
        printf("\n V[%d] = %d",i,*(vt+i));
    printf("\n");
}


int main(){       
    int v[5] = {3,4,5,2,1};
    
    system("clear");
    //ponteiro e vetor para varrer o vetor 
    
    imprimeVetor(v,5);

    printf("\n O maior valor do vetor = %d\n", retornaMaiorValor(v,5));
   
    somaDezVetor(v,5);

    imprimeVetor(v,5);

    printf("\n O maior valor do vetor = %d\n", retornaMaiorValorPonteiro(v,5));


}

