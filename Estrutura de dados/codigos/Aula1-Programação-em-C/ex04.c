#include <stdio.h>
#include <stdlib.h>

int main () {

int numero;

printf("\n Digite o numero desejado\n"); 
scanf("%d", &numero);

int quadrado = numero * numero;
int cubo =  (numero * numero * numero);
int raizQuadrada = quadrado/numero;
int raizCubica = (cubo/numero)/numero;

// Exibe os resultados
printf("Quadrado de %d: %d\n", numero, quadrado);
printf("Cubo de %d: %d\n", numero, cubo);
printf("Raiz quadrada de %d: %d\n", quadrado, raizQuadrada);
printf("Raiz cubica de %d: %d\n", cubo, raizCubica);

}