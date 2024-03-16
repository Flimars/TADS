/*
3) Crie um procedimento para receber três referências para inteiros (*pa, *pb, *ps),
some o valor de *pa com valor de *pb e atribua o resultado a variável referenciada
por *ps;

*/

void somaValores(int *pa, int *pb, int *ps) {
    *ps = *pa +*pb;
}

int main()
{
    int a, b, s;
    a = 120;
    b = 70;
    s = 0;
    

    somaValores(&a, &b, &s);
    printf("\n A soma de A = %d, B = %d e  S= %d\n",a, b, s);
}



