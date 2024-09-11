#include <stdio.h>
#include <stdlib.h>

int main()
{
    //alocação dinâmica
    printf("\n Aula de Ponteiros!! \n");
    int *px = NULL;

    px = (int*)malloc(sizeof(int));
    *px = 20;   
    printf ("\n Valor px = %d \n",*px);
}
