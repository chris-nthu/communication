#include <stdio.h>
#include <stdlib.h>

typedef struct binary_search_tree{
    int data;
    struct binary_search_tree *left_next;
    struct binary_search_tree *right_next;
}Node;

Node *Insert_node(Node *root, int value){
    Node *new = (Node*)malloc(sizeof(Node));
    Node *parent;
    Node *current;

    new->data = value;
    new->left_next = NULL;
    new->right_next = NULL;

    if(root==NULL)
        return new;

    current = root;
    while(current!=NULL){
        parent = current;

        if(current->data>value)
            current = current->left_next;
        else
            current = current->right_next;
    }

    if(parent->data>value)
        parent->left_next = new;
    else
        parent->right_next = new;
    
    return root;
}

Node *Search_node(Node *ptr, int value){
    while(ptr!=NULL){
        if(ptr->data==value)
            return ptr;
        else if(ptr->data>value)
            ptr = ptr->left_next;
        else
            ptr = ptr->right_next;
    }

    return NULL;
}

Node *Delete_node(Node *root, int value){
    
    return NULL;
}

void print_preorder(Node *ptr){
    if(ptr != NULL){
        printf("[%d] ", ptr->data);
        print_preorder(ptr->left_next);
        print_preorder(ptr->right_next);
    }
}

int main(void){
    int value;
    int flag;
    Node *root = NULL;

    while(1){
        printf("[1] Insert node.\n[2] Show all data.\n[3] Search the specific node.\nEnter your choice: ");
        scanf("\n%d", &flag);

        switch(flag){
            case 1:
                printf("Enter the data you wanna insert: ");
                scanf("\n%d", &value);
                root = Insert_node(root, value);
                printf("\n");
                break;
            case 2:
                printf("The data in binary search tree is (preorder traversal):\n");
                print_preorder(root);
                printf("\n\n");
                break;
            case 3:
                printf("Which data you wanna search: ");
                scanf("\n%d", &value);
                printf("The node you search is\n");
                printf("Data = %d\n", Search_node(root, value)->data);
                printf("Left->next = %p\n", Search_node(root, value)->left_next);
                printf("Right->next = %p\n\n", Search_node(root, value)->right_next);
                break;
            case 4:
                printf("Which data you wanna delete: ");
                scanf("\n%d", &value);
                break;
            default:
                printf("You enter the wrong command. Please try again.\n\n");

        }
    }

    return 0;
}
