#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#ifndef _DEBUG_COLOR_
#define _DEBUG_COLOR_
    #define KDRK "\x1B[0;30m"
    #define KGRY "\x1B[1;30m"
    #define KRED "\x1B[0;31m"
    #define KRED_L "\x1B[1;31m"
    #define KGRN "\x1B[0;32m"
    #define KGRN_L "\x1B[1;32m"
    #define KYEL "\x1B[0;33m"
    #define KYEL_L "\x1B[1;33m"
    #define KBLU "\x1B[0;34m"
    #define KBLU_L "\x1B[1;34m"
    #define KMAG "\x1B[0;35m"
    #define KMAG_L "\x1B[1;35m"
    #define KCYN "\x1B[0;36m"
    #define KCYN_L "\x1B[1;36m"
    #define WHITE "\x1B[0;37m"
    #define WHITE_L "\x1B[1;37m"
    #define RESET "\x1B[0m"
#endif

typedef struct Address_book{
    char name[20];
    char cellphone[11];
    struct Address_book *left_next;
    struct Address_book *right_next;
}Node;

Node *Insert_node(Node *root, char name[20], char cellphone[10]){
    Node *new = (Node*)malloc(sizeof(Node));
    Node *parent;
    Node *current;

    for(int i=0; i<20; i++)
        new->name[i] = name[i];
    for(int i=0; i<11; i++)
        new->cellphone[i] = cellphone[i];

    new->left_next = NULL;
    new->right_next = NULL;

    if(root==NULL){
        printf(KGRN_L"\n[SUCCESS] Insert OK!\n");
        return new;
    }

    current = root;
    while(current!=NULL){
        parent = current;

        if(strcmp(current->name, name)>0)
            current = current->left_next;
        else
            current = current->right_next;
    }

    if(strcmp(parent->name, name)>0)
        parent->left_next = new;
    else
        parent->right_next = new;
    
    printf(KGRN_L"\n[SUCCESS] Insert OK!\n");
    return root;
}

Node *Search_node(Node *ptr, char name[20]){
    while(ptr!=NULL){
        if(strcmp(ptr->name, name)==0)
            return ptr;
        else if(strcmp(ptr->name, name)>0)
            ptr = ptr->left_next;
        else
            ptr = ptr->right_next;
    }
    return NULL;
}

void print_preorder(Node *ptr){
    if(ptr != NULL){
        printf(KGRN_L"[%s, %s]\n", ptr->name, ptr->cellphone);
        print_preorder(ptr->left_next);
        print_preorder(ptr->right_next);
    }
}

void Load_file(){

}

int main(void){
    int option;
    Node *root = NULL;
    Node *current;
    char name[20];
    char cellphone[11];
    FILE *fp;
    
    

    while(1){
        puts(KBLU_L"");
        puts("|----------------------------------------|");
        puts("|Welcome to use address book.            |");
        puts("|We provide the following functionality. |");
        puts("|----------------------------------------|");
        puts("|[i] Insert                              |");
        puts("|[d] Delete                              |");
        puts("|[s] Search                              |");
        puts("|[l] List all data                       |");
        puts("|[q] Save and quit                       |");
        puts("|----------------------------------------|");

        printf(KYEL"\nEnter your choice: ");
        option = getchar();
        getchar();

        switch((char)option){
            case 'i':
                printf(KCYN"\nEnter the name you want to add: ");
                fgets(name, sizeof name, stdin);
                strtok(name, "\n");
                printf("Enter the cellphone of the name: ");
                fgets(cellphone, sizeof cellphone, stdin);
                strtok(cellphone, "\n");
                root = Insert_node(root, name, cellphone);
                getchar();
                break;
            case 's':
                printf(KCYN"\nEnter the name you wanna search: ");
                fgets(name, sizeof name, stdin);
                strtok(name, "\n");
                current = Search_node(root, name);
                if(current!=NULL){
                    printf(KGRN_L"\n[Information]\n");
                    printf("The address of the node: %p\n", current);
                    printf("Name: %s\n", current->name);
                    printf("Phone Number: %s\n", current->cellphone);
                    printf("The address of left_next: %p\n", current->left_next);
                    printf("The address of right_next: %p\n", current->right_next);
                } else{
                    printf(KRED_L"\n[ERROR] The node is not exists.\n");
                }
                break;
            case 'l':
                printf(KCYN"\nList all of data in this tree by preorder method.\n");
                puts("");
                print_preorder(root);
                puts("");
                break;
            case 'q':
                printf(KGRN_L"\nQuit the address book.\n\n");
                exit(0);
                break;
            default:
                printf(KRED_L"\n[ERROR] You enter the wrong command. Please try again.\n");
        }

        
    }

    return 0;
}
