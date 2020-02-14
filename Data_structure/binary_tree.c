#include <stdio.h>
#include <stdlib.h>

typedef struct binary_tree_node{
    int data;
    struct binary_tree_node *left_next;
    struct binary_tree_node *right_next;
}Node;

int main(void){
    Node *root = (Node*)malloc(sizeof(Node));
    Node *current;

    root->data = 5;
    root->left_next = (Node*)malloc(sizeof(Node));
    root->right_next = (Node*)malloc(sizeof(Node));

    current = root;
    current = current->left_next;
    current->data = 4;
    current->left_next = NULL;
    current->right_next = NULL;

    current = root;
    current = current->right_next;
    current->data = 6;
    current->left_next = NULL;
    current->right_next = NULL;

    return 0;
}
