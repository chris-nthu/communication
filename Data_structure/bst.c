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
    char cellphone[10];
    struct Address_book *left_next;
    struct Address_book *right_next;
}Node;

Node *Load_file(void){
    FILE *fptr;
    char name[20];
    char cellphone[10];
    Node *root = NULL;

    puts("File is loading...");
    if((fptr=fopen("bst.dat", "r"))==NULL){
        puts(KRED_L"[Error] bst.dat not found!");
        return NULL;
    }

    while(fscanf(fptr, "%s %s", name, cellphone)!=EOF)
        if(strcmp(name, "")!=0)
            root = Insert_node(root, name, cellphone);
    
    puts(KGRN_L"[Success] Loading file OK!");
    fclose(fptr);

    return root;
}

Node *Insert_node(Node *root, char name[20], char cellphone[10]){
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

int main(void){
    char option;
    Node *root;

    root = Load_file();

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
        scanf("\n%c", &option);

        
    }

    return 0;
}
