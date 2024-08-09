1. As diferenças entre printf, fprintf e sprintf em C. 
2. Quando você deve utilizar cada uma delas? 

Exemplos: 

**printf:**
A função printf é usada para imprimir uma sequência de caracteres formatados na saída padrão (normalmente o console/terminal).
Sintaxe: printf(const char *format, ...);

Exemplo:

```
    #include <stdio.h>

    int main() {
        int x = 10, y = 20;
        printf("A soma de %d e %d é %d\n", x, y, x + y);
        return 0;
    }
    Saída: A soma de 10 e 20 é 30

```

**fprintf:**
A função fprintf é usada para imprimir uma sequência de caracteres formatados em um arquivo ou stream de saída específico.
Sintaxe: fprintf(FILE *stream, const char *format, ...);

Exemplo:

```
#include <stdio.h>

int main() {
    FILE *file = fopen("output.txt", "w");
    if (file == NULL) {
        printf("Erro ao abrir o arquivo.\n");
        return 1;
    }

    int x = 10, y = 20;
    fprintf(file, "A soma de %d e %d é %d\n", x, y, x + y);
    fclose(file);
    return 0;
}
O resultado será escrito no arquivo output.txt.

```
**sprintf:**
A função sprintf é usada para formatar uma sequência de caracteres e armazená-la em uma string.
Sintaxe: sprintf(char *str, const char *format, ...);

Exemplo:
```
#include <stdio.h>

int main() {
    int x = 10, y = 20;
    char buffer;
    sprintf(buffer, "A soma de %d e %d é %d", x, y, x + y);
    printf("%s\n", buffer);
    return 0;
}
Saída: A soma de 10 e 20 é 30
```
Agora, vamos entender em quais casos você deve utilizar cada uma dessas funções:

> **printf:** Use printf quando você quiser imprimir a saída diretamente no console/terminal.

> **fprintf:** Use fprintf quando você quiser imprimir a saída em um arquivo ou stream de saída específico, como um arquivo de log ou um socket de rede.

> **sprintf:** Use sprintf quando você quiser armazenar a saída formatada em uma string, por exemplo, para exibir a informação em uma interface gráfica ou para enviar a string por meio de uma rede.
> 
A escolha da função dependerá do seu caso de uso específico. printf é útil para depuração e saída simples, fprintf é útil quando você precisa gravar a saída em um arquivo ou stream, e sprintf é útil quando você precisa armazenar a saída formatada em uma string.

### Saiba mais:

c - Quais as diferenças entre printf, fprintf, sprintf, snprintf, printf_s e fprintf_s? - Stack Overflow em Português

Quais as diferenças entre printf, fprintf, sprintf, snprintf, printf_s e fprintf_s em C? - Quora

What is the difference between printf, sprintf and fprintf? - GeeksforGeeks