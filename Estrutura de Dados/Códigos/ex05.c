/*
Faça um algoritmo que leia o valor do raio de um circulo e calcule o valor da sua circunferência e área [Circunferência = 2 * Pi, Área = Pi * r^2 onde Pi = 3,14].

*/

#include <stdio.h>
#include <stdlib.h>

int main() {

float raio; 
float pi = 3.14;

printf("\n Informe o valor do raio:\n");
scanf("%f", &raio);

float circunferencia = (2.0 * pi) * raio;
float area = pi * (raio * raio);

printf("\n A medida da circunferência é: %.2f\n A medida da Área é: %.2f\n", circunferencia, area); // PESQUISAR PORQUE O "%.2f" E "%2.2f" ESTÃO DANDO INCONSISTÊNCIA NO CALCULO.

}