#include <stdio.h>
#include <stdlib.h>
#include <string.h>

void imprimeString(char *s){
    printf("\n");
    for(int i=0; i<strlen(s); i++){
        printf(" %c",*(s+i));
    }
    printf("\n\n");
}

void imprimeCodigoAsc(char *s){
    printf("\n\n ");
    for(int i=0; i<strlen(s); i++){
        printf(" %c = %d\n ",*(s+i),*(s+i));
    }
    printf("\n\n");
}



int main(){
    //string = Vetor de char
    char vc [] = "Estrutura de Dados";
    imprimeString(vc);

    char *pvc = "Estrutura de Dados";
    imprimeString(pvc);

    imprimeCodigoAsc(pvc);
   
}