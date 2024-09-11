## Listas: Definição 

Uma estrutura de dados que representa uma sequência de elementos do mesmo tipo, com operações básicas como criação, destruição, inserção, exclusão e acesso a elementos.


momentos-chave:

#### 00:18 Uma lista é uma sequência de elementos do mesmo tipo com estrutura interna abstraída, onde só as funções podem manipular os dados, facilitando a implementação sem se preocupar com detalhes internos. 
          -As listas podem ter um total de N nós, podendo estar vazias, conter alguns elementos ou estar cheias, dependendo do tipo de lista e são úteis em diversas aplicações como cadastro de funcionários e itens de estoque.

          -Além das operações básicas como criação e destruição da lista, as listas são utilizadas em estruturas de dados abstratas e simplificam a manipulação e organização de dados em diversas situações.
#### 02:25 A alocação de memória em listas pode ser estática ou dinâmica, afetando operações como inserção, exclusão e acesso aos elementos. Alocação estática tem espaço definido, acesso sequencial e limitação de elementos, enquanto a alocação dinâmica cresce conforme novos elementos são adicionados.
          -Alocação estática utiliza espaço de memória definido e acesso sequencial, sendo representada por um vetor com número máximo de elementos.

          -Alocação dinâmica permite alocar memória em tempo de execução, sem tamanho inicial definido, possibilitando a expansão e redução da lista conforme novos elementos são adicionados ou removidos.

### 1. O que é uma lista em estrutura de dados?

Uma lista em estrutura de dados é uma coleção de elementos organizados em uma sequência linear. Cada elemento em uma lista pode ser acessado, inserido ou removido com base em sua posição na sequência. As listas são fundamentais na programação e podem ser usadas para armazenar e gerenciar conjuntos de dados de tamanho variável.

### 2. Quais são as diferenças entre uma lista estática e uma lista dinâmica?

#### Lista Estática

- **Definição**: Uma lista estática tem um tamanho fixo que é definido no momento da sua criação e não pode ser alterado durante a execução do programa.
- **Implementação**: Geralmente implementada usando arrays (vetores).
- **Vantagens**:
  - Acesso rápido aos elementos devido ao uso de índices.
  - Menor overhead de gerenciamento de memória.
- **Desvantagens**:
  - Tamanho fixo, que pode levar ao desperdício de memória se a lista não estiver completamente preenchida.
  - Difícil de aumentar o tamanho se mais elementos precisarem ser armazenados.

**Exemplo**:
```c
#include <stdio.h>

#define MAX_SIZE 100

int main() {
    int listaEstatica[MAX_SIZE];
    int n = 10; // Número de elementos atuais na lista

    // Adicionar elementos à lista
    for (int i = 0; i < n; i++) {
        listaEstatica[i] = i + 1;
    }

    // Imprimir elementos da lista
    for (int i = 0; i < n; i++) {
        printf("%d ", listaEstatica[i]);
    }
    printf("\n");

    return 0;
}
```

#### Lista Dinâmica

- **Definição**: Uma lista dinâmica pode mudar de tamanho durante a execução do programa. Ela cresce ou encolhe conforme elementos são adicionados ou removidos.
- **Implementação**: Geralmente implementada usando estruturas de dados como listas encadeadas (linked lists).
- **Vantagens**:
  - Flexibilidade para crescer ou encolher conforme necessário.
  - Uso eficiente de memória, pois apenas o espaço necessário é alocado.
- **Desvantagens**:
  - Acesso mais lento aos elementos, pois requer travessia da lista.
  - Overhead adicional para gerenciamento de ponteiros.

**Exemplo**:
```c
#include <stdio.h>
#include <stdlib.h>

struct Node {
    int data;
    struct Node* next;
};

void append(struct Node** head_ref, int new_data) {
    struct Node* new_node = (struct Node*)malloc(sizeof(struct Node));
    struct Node* last = *head_ref;
    new_node->data = new_data;
    new_node->next = NULL;

    if (*head_ref == NULL) {
        *head_ref = new_node;
        return;
    }

    while (last->next != NULL) {
        last = last->next;
    }

    last->next = new_node;
}

void printList(struct Node* node) {
    while (node != NULL) {
        printf("%d ", node->data);
        node = node->next;
    }
    printf("\n");
}

int main() {
    struct Node* head = NULL;
    append(&head, 1);
    append(&head, 2);
    append(&head, 3);

    printList(head);

    return 0;
}
```

### 3. Quais são as principais operações realizadas em uma lista?

As principais operações realizadas em uma lista incluem:

1. **Inserção**: Adicionar um novo elemento à lista. Isso pode ser feito no início, no final ou em uma posição específica.

   **Exemplo de inserção no final em uma lista encadeada**:
   ```c
   void append(struct Node** head_ref, int new_data);
   ```

2. **Remoção**: Remover um elemento existente da lista. Isso pode ser feito no início, no final ou em uma posição específica.

   **Exemplo de remoção do início em uma lista encadeada**:
   ```c
   void deleteNode(struct Node** head_ref, int key);
   ```

3. **Acesso**: Recuperar o valor de um elemento em uma posição específica da lista.

   **Exemplo de acesso a um elemento em uma lista estática**:
   ```c
   int element = listaEstatica[pos];
   ```

4. **Pesquisa**: Encontrar um elemento na lista, retornando a posição ou uma indicação de presença.

   **Exemplo de pesquisa em uma lista encadeada**:
   ```c
   struct Node* search(struct Node* head, int key);
   ```

5. **Atualização**: Modificar o valor de um elemento existente na lista.

   **Exemplo de atualização em uma lista estática**:
   ```c
   listaEstatica[pos] = new_value;
   ```

6. **Travessia**: Percorrer todos os elementos da lista para realizar operações como impressão, soma ou contagem.

   **Exemplo de travessia em uma lista encadeada**:
   ```c
   void printList(struct Node* node);
   ```

Essas operações são fundamentais para manipulação de listas e são aplicáveis tanto em listas estáticas quanto dinâmicas, embora a implementação e a eficiência possam variar entre os dois tipos de listas.