/*
    Vamos implementar uma fila usando uma estrutura de dados dinâmica com ponteiros em C. Abaixo estão as funções principais para gerenciar uma fila:
*/

#include <stdio.h>
#include <stdlib.h>
#include <stdbool.h>

//=============== STRUCTS =========================
typedef struct Node {
    int data;
    struct Node *next;
} Node;

typedef struct Queue {
    Node *front;
    Node *rear;
    int size;
} Queue;

//=============== FUNÇÕES =========================
// Criar uma nova fila
Queue* createQueue() {
    Queue *q = (Queue *)malloc(sizeof(Queue));
    q->front = NULL;
    q->rear = NULL;
    q->size = 0;
    return q;
}

// Enfileirar (enqueue) um novo elemento
void enqueue(Queue *q, int value) {
    Node *newNode = (Node *)malloc(sizeof(Node));
    newNode->data = value;
    newNode->next = NULL;
    if (q->rear == NULL) {
        q->front = newNode;
        q->rear = newNode;
    } else {
        q->rear->next = newNode;
        q->rear = newNode;
    }
    q->size++;
}

//  Desenfileirar (dequeue) o primeiro elemento
int dequeue(Queue *q) {
    if (q->front == NULL) {
        printf("Queue is empty.\n");
        return -1;  // Indicador de fila vazia
    }
    Node *temp = q->front;
    int value = temp->data;
    q->front = q->front->next;
    if (q->front == NULL) {
        q->rear = NULL;
    }
    free(temp);
    q->size--;
    return value;
}


// Verificar se a fila está vazia
bool isEmpty(Queue *q) {
    return q->front == NULL;
}

// Verificar se a fila está cheia
/*
    Para uma fila dinâmica, a fila nunca está cheia a menos que a memória esteja esgotada, então essa função pode simplesmente retornar false.
*/
bool isFull(Queue *q) {
    return false;  // Para filas dinâmicas, sempre retorna false
}

// Obter o tamanho da fila
int queueSize(Queue *q) {
    return q->size;
}

// Programa Principal - Para testar essas funções
int main() {
    Queue *q = createQueue();

    enqueue(q, 10);
    enqueue(q, 20);
    enqueue(q, 30);

    printf("Dequeued: %d\n", dequeue(q));
    printf("Dequeued: %d\n", dequeue(q));

    printf("Queue size: %d\n", queueSize(q));
    printf("Is queue empty? %s\n", isEmpty(q) ? "Yes" : "No");

    enqueue(q, 40);
    enqueue(q, 50);

    printf("Queue size: %d\n", queueSize(q));
    printf("Is queue empty? %s\n", isEmpty(q) ? "Yes" : "No");

    return 0;
}
