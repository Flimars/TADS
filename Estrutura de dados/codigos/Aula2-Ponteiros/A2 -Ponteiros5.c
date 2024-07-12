#include <stdio.h>
#include <stdlib.h>

int main()
{
    printf("\n Aula de Ponteiros!! \n");
    int x, y, *px, *py, aux;
    x = 10;   y = 20; 
    px = &x;  py = &y;

    printf ("\n Valor x = %d y = %d",x,y);
    aux = *px;
    *px = *py;
    *py = aux;
    printf ("\n Valor x = %d y = %d\n",x,y);      
}
