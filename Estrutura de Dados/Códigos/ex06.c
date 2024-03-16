/*Faça um algoritmo que leia o valor de um salário e mostre este salário com aumento de 20%.
*/

#include <stdio.h>
#include <stdlib.h>

int main() {

double salario;

printf("\n Informe o valor do salário desejado\n");
scanf("%lf", &salario);

double salarioAtual = salario + (salario * 20) / 100;

printf("Salário atual é de %.2lf\n", salarioAtual);

}
