#include <stdio.h>
#include <stdlib.h>

void troca1 (int a, int b) {
    int temp;
    temp = a; 
    a = b; 
    b = temp;
}

void troca2 (int *pa, int *pb) {
    int temp;
    temp = *pa; 
    *pa = *pb; 
    *pb = temp;
}


int main()
{
    printf("\n Aula de Ponteiros!! \n");
    int x = 10, y = 20;

    //passagem por valor
    printf("\n Troca 1 - Valor de X=%d e Y=%d",x,y);
    troca1(x,y);
    printf("\n Troca 1 - Valor de X=%d e Y=%d",x,y);
    
    //passagem por referencia
    x = 10, y = 20;
    printf("\n Troca 2 - Valor de X=%d e Y=%d",x,y);
    troca2(&x,&y);
    printf("\n Troca 2 - Valor de X=%d e Y=%d",x,y);

}