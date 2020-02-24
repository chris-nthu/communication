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

#define MAX 10

int top = -1;
char item[MAX][20];

void push(char str[20]){
    if(top>=MAX-1)
        printf(KRED_L"\n[ERROR] Stack is full!\n");
    else{
        top++;
        strcpy(item[top], str);
        printf(KGRN_L"\n[SUCCESS] Insert OK!\n");
    }
}

void pop(){
    if(top<0)
        printf(KRED_L"\n[ERROR] No data in stack.\n");
    else{
        top--;
        printf(KGRN_L"\n[SUCCESS] Pop the top item.\n");
    }
}

void list(){
    printf(KGRN_L"\nITEM\n");
    printf("------------\n");
    for(int i=top; i>-1; i--)
        printf("%s\n", item[i]);
    printf("------------\n");
}

int main(void){
    int option;
    char str[20];

    while(1){
        puts(KBLU_L"");
        puts("|----------------------------------------|");
        puts("|We provide the following functionality. |");
        puts("|----------------------------------------|");
        puts("|[1] Insert (Push)                       |");
        puts("|[2] Delete (Pop)                        |");
        puts("|[3] List all data                       |");
        puts("|[4] Quit                                |");
        puts("|----------------------------------------|");

        printf(KYEL"\nEnter your choice: ");
        option = getchar();
        getchar();

        switch((char)option){
            case '1':
                printf(KCYN"\nEnter the item(string) you want to add: ");
                fgets(str, sizeof str, stdin);
                strtok(str, "\n");
                push(str);
                break;
            case '2':
                pop();
                break;
            case '3':
                list();
                break;
            case '4':
                printf(KGRN_L"\n[SUCCESS] Quit.\n\n");
                exit(0);
            default:
                printf(KRED_L"\n[ERROR] You enter the wrong command. Please try again.\n");
        }
    }

    return 0;
}