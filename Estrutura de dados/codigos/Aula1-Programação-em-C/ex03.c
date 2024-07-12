#include <stdio.h>
#include <stdlib.h>

int main () {

float temperatura, celsius, farenheit;

printf("\n Digite a temperatura em farenheit °F\n");
scanf("%f", &farenheit);

temperatura = (farenheit - 32) * 9/5;

printf("A temperatura em Celsius °C é: %f\n", temperatura);

printf("\n Digite a temperatura em Celsius °C\n");
scanf("%f", &celsius);

//temperatura = 0;
temperatura = (9/5 * celsius) + 32;

printf("A temperatura em Farenheit °F é: %f\n", temperatura);

}