# include <stdio.h>
# include <stdlib.h>

void display(int var, int *ponteiro);
void update(int *p);


int main(int argc, char const *argv[])
{
    int var = 15;
    int *ponteiro;

    ponteiro = &var;

    printf("Conteudo de var = %d\n", var);
    printf("Endereco de var = %p\n", &var);

    printf("Conteudo apontado por ponteiro = %d\n", *ponteiro);
    printf("Endereco apontado por ponteiro = %p\n",  ponteiro);
    printf("Endereco do ponteiro           = %p\n", &ponteiro);


    display(var, ponteiro); // Saída = 15
    update(&var); 
    display(var, ponteiro); // Saída = 16

    /*
    Saída no terninal: 
        PS C:\Student-Dev\TADS\Estrutura de dados\Resumos\output> & .\'Ponteiros.exe'
        Conteudo de var = 15
        Endereco de var = 6422300    
    */ 
        // printf("\n\nEnd.");
        // while (1);
        // return 0;
   
}//end main

void display(int var, int *ponteiro){
    printf("\n\n");
    printf("Conteudo apontado por ponteiro = %d\n", *ponteiro);
    printf("Endereco apontado por ponteiro = %p\n",  ponteiro);
    printf("Endereco do ponteiro           = %p\n", &ponteiro);
}

void update(int *p){
    *p += 1;
}
