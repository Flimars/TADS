#include <stdio.h>
#include <stdlib.h>

// Definição da estrutura para um nó da lista
typedef struct Node {
    int data;
    struct Node* next;
} Node;

// Função para adicionar um nó no início da lista
void insertAtBeginning(Node** head, int newData) {
    Node* newNode = (Node*) malloc(sizeof(Node));
    newNode->data = newData;
    newNode->next = *head;
    *head = newNode;
}

// Função para imprimir a lista
void printList(Node* node) {
    while (node != NULL) {
        printf("%d -> ", node->data);
        node = node->next;
    }
    printf("NULL\n");
}

// Função para trocar os dados de dois nós
void swapData(Node* a, Node* b) {
    int temp = a->data;
    a->data = b->data;
    b->data = temp;
}

// Função para ordenar a lista usando ordenação por seleção
void selectionSort(Node* head) {
    Node* current = head;
    while (current != NULL) {
        Node* min = current;
        Node* r = current->next;
        
        // Encontrar o menor elemento na lista não ordenada
        while (r != NULL) {
            if (r->data < min->data)
                min = r;
            r = r->next;
        }
        
        // Trocar o menor encontrado com o primeiro elemento
        swapData(min, current);
        
        // Mover para o próximo elemento
        current = current->next;
    }
}

// Função principal para demonstrar a ordenação
int main() {
    Node* head = NULL;

    // Criar uma lista desordenada
    insertAtBeginning(&head, 10);
    insertAtBeginning(&head, 30);
    insertAtBeginning(&head, 3);
    insertAtBeginning(&head, 50);
    insertAtBeginning(&head, 23);

    printf("Lista Original: \n");
    printList(head);

    // Ordenar a lista
    selectionSort(head);

    printf("Lista Ordenada: \n");
    printList(head);

    return 0;
}
