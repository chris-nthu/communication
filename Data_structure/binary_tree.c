#include <stdio.h>
#include <stdlib.h>

typedef struct binary_tree_node{
    int data;
    struct binary_tree_node *left_next;
    struct binary_tree_node *right_next;
}Node;

void print_inorder(Node *ptr){
    if(ptr != NULL){
        print_inorder(ptr->left_next);
        printf("[%d] ", ptr->data);
        print_inorder(ptr->right_next);
    }
}

void print_preorder(Node *ptr){
    if(ptr != NULL){
        printf("[%d] ", ptr->data);
        print_inorder(ptr->left_next);
        print_inorder(ptr->right_next);
    }
}

void print_postorder(Node *ptr){
    if(ptr != NULL){
        print_inorder(ptr->left_next);
        print_inorder(ptr->right_next);
        printf("[%d] ", ptr->data);
    }
}

Node* Search_node(Node* ptr, int value){
    Node *temp;

    if(ptr!=NULL){
        printf("data is %d\n", ptr->data);
        if(ptr->data==value)
            return ptr;
        else{
            temp = Search_node(ptr->left_next, value);
            if(temp!=NULL)
                return temp;
            
            temp = Search_node(ptr->right_next, value);
            if(temp!=NULL)
                return temp;
        }
    }

    return NULL;
}

int main(void){
    Node *root = (Node*)malloc(sizeof(Node));
    Node *current;
    int num;

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

    printf("Inorder Traversal:\n");
    print_inorder(root);
    printf("\n\n");

    printf("Preorder Traversal:\n");
    print_preorder(root);
    printf("\n\n");

    printf("Postorder Traversal:\n");
    print_postorder(root);
    printf("\n\n");

    printf("Enter the data you wanna search: ");
    scanf("\n%d", &num);
    current = Search_node(root, num);

    if(current!=NULL){
        printf("\nThe information about this node.\n");
        printf("data = %d\n", current->data);
        printf("left_next = %p\n", current->left_next);
        printf("right_next = %p\n", current->right_next);
    } else printf("The data is not exist.");

    return 0;
}
