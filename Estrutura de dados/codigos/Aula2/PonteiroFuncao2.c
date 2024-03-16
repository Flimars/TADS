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

void troca3 (int *pa, int *pb) {
    int *temp;   //temp não está alocado
    *temp = *pa; //   temp = (int *)malloc(sizeof(int));
    *temp = *pa;
    *pa = *pb; 
    *pb = *temp;
}

void troca4 (int *pa, int *pb) {
    int c, *temp;
    temp = &c;
    *temp = *pa; 
    *pa = *pb; 
    *pb = *temp;
}

int main()
{
    printf("\n Aula de Ponteiros!! \n");
    int x = 10, y = 20;

    printf("\n Troca 1 - Valor de X=%d e Y=%d",x,y);
    troca1(x,y);
    printf("\n Troca 1 - Valor de X=%d e Y=%d",x,y);

    x = 10, y = 20;
    printf("\n Troca 2 - Valor de X=%d e Y=%d",x,y);
    troca2(&x,&y);
    printf("\n Troca 2 - Valor de X=%d e Y=%d",x,y);

    x = 10, y = 20;
    printf("\n Troca 3 - Valor de X=%d e Y=%d",x,y);
    troca3(&x,&y);  //erro de segmentação
    printf("\n Troca 3 - Valor de X=%d e Y=%d",x,y);

    x = 10, y = 20;
    printf("\n Troca 4 - Valor de X=%d e Y=%d",x,y);
    troca4(&x,&y);
    printf("\n Troca 4 - Valor de X=%d e Y=%d \n",x,y);

}