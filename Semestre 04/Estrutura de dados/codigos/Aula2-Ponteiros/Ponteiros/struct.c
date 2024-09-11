#include <stdio.h>
#include <stdlib.h>
#include <conio.h>

// Estrutura de dados - Struct 

/* Isto NÃO  é uma função, mas SIM uma declaração */
struct componente 
{
    char tipo [20];
    char referencia[4];
    unsigned char num_ref;
    int valor;
    char unidade [10];
}/*Pode declarar o nome (comp) da variavel aqui também*/;

// Declaração da variavel
struct componente comp;

int main(int argc, char const *argv[])
{
    /* code */
    return 0;
}

