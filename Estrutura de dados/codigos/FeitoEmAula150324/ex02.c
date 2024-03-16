/*
2) Crie um procedimento para receber duas referências para inteiros (*pa,*pb),
some o valor *pa com valor de *pb e atribua o resultado a variável A que deu
origem a *pa;

*/

void somaValores(int *pa, int *pb) {
    *pa = *pa + *pb;
}

int main()
{
    int a, b;
    a = 50;
    b = 70;

    somaValores(&a, &b);
    printf("\n O valor final de   A= %d\n",a);
}