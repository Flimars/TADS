#include <stdio.h>
#include <stdlib.h>

int main()
{
    printf("\n Aula de Ponteiros!! \n");

    int *pa, *pb;        // pa e pb são ponteiros para inteiros 
    int a=10, b=5, c;  // a,b,c são variaveis inteiras
    pa = &a;        // o valor de pa é o endereço de a 
    pb = &b;        // o valor de pb é o endereço de b 


    int **ppa;  //ponteiro de ponteiro ppa de pa
    ppa = &pa; //ponteiro ppa recebe o endereço do ponteiro pa
    c = **ppa + *pb;

    printf ("\n A soma de a = %d e b = %d é c = %d \n",**ppa,*pb,c);
    printf ("\n Endereco de A = %x ",&a);
    printf ("\n Endereço armazenado no ponteiro pa = %x ",pa);
    printf ("\n Endereco armazenado no ponteiro pb = %x ",&pb);
    printf ("\n Endereco armazenado no ponteiro **ppa = %x \n ",ppa);    
    printf ("\n Valor no ponteiro **ppa = %d \n ",**ppa);    

    ppa = &pb; //ppa referencia pb que referencia b
    printf ("\n Novo valor no ponteiro **ppa = %d \n\n ",**ppa); 


    return 0;
}