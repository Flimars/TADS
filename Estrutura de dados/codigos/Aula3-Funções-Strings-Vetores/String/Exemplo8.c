#include <stdio.h>
#include <stdlib.h>
#include <string.h>

void mostraString(char *s){
    printf("\n");
    for(int i=0; i<strlen(s); i++){
        printf(" %c",*(s+i));
    }
    printf("\n\n");
}

void copiaString(char *s, char *scp){
    for(int i=0; i<strlen(s); i++){
        scp[i] = s[i];
    }
}

void removeVogais(char *s, char *sv){
    char vogais[] = {'a','A','e','E','i','I','o','O','u','U'};
    int i,j,l=0, fl;
    for(i=0; i<strlen(s); i++){
        fl = 1;
        for(j=0; j<strlen(vogais); j++){
            if(s[i] == vogais[j]){
                //sv[j] = '';
                fl = 0;
                break;
            }
        }
        if(fl){
            //printf(" %c -",s[i]);
            *(sv+l)= *(s+i);
            l++;
        }
    }
}


char* removeConsoantes(char *s){
    char *vcon = (char*) malloc (sizeof(char)*strlen(s));
    char vogais[] = {'a','A','e','E','i','I','o','O','u','U'};
    int i,j,l=0, fl;
    for(i=0; i<strlen(s); i++){
        fl = 1;
        for(j=0; j<strlen(vogais); j++){
            if(s[i] == vogais[j]){
                //sv[j] = '';
                fl = 0;
                break;
            }
        }
        if(fl==0){
            //printf(" %c -",s[i]);
            *(vcon+l)= *(s+i);
            l++;
        }
    }
    return vcon;
}


int main(){
    //string = Vetor de char
    char vc [] = "Estrutura de Dados";
    mostraString(vc);

    char *pvc = "Estrutura de Dados";
    mostraString(pvc);


   // char copia[strlen(v)];
    
//     char *copia = (char*) malloc (sizeof(char)*strlen(v));

//     copiaString(v,copia);

//   //  mostraString(copia);

//     char *semVogal = (char*) malloc (sizeof(char)*strlen(v));

//     removeVogais(v,semVogal);

//  //   mostraString(semVogal);


//     char *semConsoante = NULL;

//     semConsoante = removeConsoantes(v);
//     mostraString(semConsoante);







   
}