#include <stdio.h>
#include <stdlib.h>

int main () {

int ladoA, ladoB, area;

printf("\n Digite o lado 'A' do retângulo\n");
scanf("%d", &ladoA);

printf("\n Digite o lado 'B' do retângulo\n");
scanf("%d", &ladoB);

area = ladoA * ladoB;

printf("A área do total do retângulo é: %d\n", area);

}