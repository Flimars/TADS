#include <stdio.h>
#include <stdlib.h>

// Definição da estrutura para um nó da lista
typedef struct Node {
    int data;
    struct Node* next;
} Node;

// Função para adicionar um nó no final da lista
void append(Node** head_ref, int new_data) {
    Node* new_node = (Node*) malloc(sizeof(Node));
    Node* last = *head_ref; // usado para percorrer até o último nó

    new_node->data = new_data; // atribuir dados ao nó
    new_node->next = NULL; // o próximo do novo nó é NULL

    // Se a lista estiver vazia, então o novo nó será a cabeça
    if (*head_ref == NULL) {
        *head_ref = new_node;
        return;
    }

    // Caso contrário, percorra até o último nó
    while (last->next != NULL) {
        last = last->next;
    }

    // Mude o próximo do último nó
    last->next = new_node;
}

// Função para imprimir a lista
void printList(Node* node) {
    while (node != NULL) {
        printf("%d -> ", node->data);
        node = node->next;
    }
    printf("NULL\n");
}

// Função para inverter a lista
void reverse(Node** head_ref) {
    Node* prev = NULL;
    Node* current = *head_ref;
    Node* next = NULL;

    while (current != NULL) {
        next = current->next; // Armazena temporariamente o próximo nó
        current->next = prev; // Inverte o atual ponteiro do nó
        prev = current; // Mova os ponteiros uma posição à frente.
        current = next;
    }
    *head_ref = prev; // Prev é a nova cabeça da lista invertida
}

// Função principal para demonstrar a inversão da lista
int main() {
    Node* head = NULL;

    // Criar uma lista: 1->2->3->4->5
    append(&head, 1);
    append(&head, 2);
    append(&head, 3);
    append(&head, 4);
    append(&head, 5);

    printf("Lista Original:\n");
    printList(head);

    // Inverter a lista
    reverse(&head);

    printf("Lista Invertida:\n");
    printList(head);

    return 0;
}
