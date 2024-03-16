#include <stdio.h>
#include <stdlib.h>

int main()
{
    printf("\n Aula de Ponteiros!! \n");

    int x, *px;  //x variável e px o ponteiro
    int y, *py;  //y é uma variavel e py e'o ponteiro

    x = 10;   px = &x;
    y = 20;   py = &y;
    
    printf(" Valor referenciado px = %d",*px);
    printf(" Valor referenciado py = %d\n",*py);

    *px = *py;

    printf(" Valor x = %d e y = %d\n",x,y);
    
}