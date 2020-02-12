#include <stdio.h>
#include <stdlib.h>

struct Number{
    int num;
    struct Number *next;
};

// Complexity is O(N)
void Search_data(struct Number *head, int num){
    struct Number *current, *previous;

    current = head;

    if(head->num == num){
        head = head->next;
        printf("find\n");
        free(current);
    }

    while((current!=NULL)&&(current->num!=num)){
        printf("flag\n");
        previous = current;
        current = current->next;
    }

    if(current == NULL){
        printf("Not found. \n");
    } else{
        printf("delete\n");
        previous->next = current->next;
        free(current);
    }
}

int main(void){
    struct Number *head = (struct Number*)malloc(sizeof(struct Number));
    int num;

    printf("Enter 10 numbers: \n");
    printf("Input: ");
    scanf("\n%d", &num);

    head->num = num;
    head->next = NULL;

    struct Number *current = head;

    for(size_t i=1; i<10; i++){
        printf("Input: ");
        scanf("\n%d", &num);
        current->next = (struct Number*)malloc(sizeof(struct Number));
        current = current->next;
        current->num = num;
        current->next = NULL;
    }

    current = head;

    printf("Data in linked list: ");
    while(current->next!=NULL){
        printf("%d ", current->num);
        current = current->next;
    }
    printf("%d\n\n", current->num);

    printf("Enter the data you wanna delete: ");
    scanf("\n%d", &num);
    Search_data(head, num);
    printf("New data in linked list: ");
    current = head;
    while(current->next!=NULL){
        printf("%d ", current->num);
        current = current->next;
    }
    printf("%d\n\n", current->num);

    return 0;
}