#include <stdio.h>
#include <stdlib.h>

void funcaoTroca(int *px, int *py){
    int aux = *px;
    *px = *py;
    *py = aux;
}

void funcaoSoma(int a, int b, int *ps){
    *ps = a + b;
}

int main(){       
    system("clear");
    int x = 10, y = 20;
    printf("\n O valor inicial de X= %d e Y =%d",x, y);

    funcaoTroca(&x,&y); //passagem por valor
    printf("\n O valor final de   X= %d e Y =%d \n",x, y);

    
    int *psoma = (int*)malloc(sizeof(int));
    
    funcaoSoma(x,y,psoma);
    printf("\n A soma de x e y = %d \n",*psoma);

    free(psoma); 
    psoma = NULL;
    printf("\n soma de x e y = %d\n",*psoma); 
           //erro de segmentacao, endereco inválido

}

