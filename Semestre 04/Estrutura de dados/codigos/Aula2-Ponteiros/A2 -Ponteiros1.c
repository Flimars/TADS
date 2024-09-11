#include <stdio.h>
#include <stdlib.h>

int main()
{
    printf("\n Aula de Ponteiros!! \n");

    int x, *px;  //x variável e px o ponteiro
    
    x = 10;
    px = &x;
    
    printf(" Valor X = %d e o endereco de X = %x \n",x,&x);
    printf(" Valor px = endereco de %x \n",px);

    printf(" Conteudo de X = %d e o conteudo referenciado por px = %d\n",x,*px);

    
}