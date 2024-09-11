#include <stdio.h>
#include <stdlib.h>

void funcaoTroca(int x, int y){
    int aux = x;
    x = y;
    y = aux;
}

int main(){       
    int x = 10, y = 20;
    printf("\n O valor inicial de X= %d e Y =%d ",x, y);

    funcaoTroca(x,y); //passagem por valor
    printf("\n O valor final de   X= %d e Y =%d \n\n",x, y);
}