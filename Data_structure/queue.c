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

#define MAX 3

int front = -1;
int rear = -1;
char queue[MAX][10];

void enqueue(char num[10]){
    if((rear==MAX-1 && front==-1) || (rear+1)%MAX==front)
        printf(KRED_L"\n[ERROR] Circle Queue is full!\n");
    else{
        rear = (rear+1) % MAX;
        strcpy(queue[rear], num);
        printf(KGRN_L"\n[SUCCESS] Insert ok!\n");
    }
}

void dequeue(){
    if(front==rear)
        printf(KRED_L"\n[ERROR] Circle Queue is empty.\n");
    else{
        front = (front+1) % MAX;
        printf(KGRN_L"\n[SUCCESS] Delete ok!\n");
    }
}

void list(){
    if(front==rear)
        printf(KRED_L"\n[ERROR] Circle Qeueue is empty.\n");
    else{
        printf(KGRN_L"\nITEM\n");
        printf("------------\n");
        for(int i=(front+1)%MAX; ; i=(i+1)%MAX){
            printf("%s\n", queue[i]);
            if(i==rear)
                break;
        }
        printf("------------\n");
    }
}

int main(void){
    int option;
    char num[10];

    while(1){
        puts(KBLU_L"");
        puts("|----------------------------------------|");
        puts("|We provide the following functionality. |");
        puts("|----------------------------------------|");
        puts("|[1] Insert (Enqueue)                    |");
        puts("|[2] Delete (Dequeue)                    |");
        puts("|[3] List all data                       |");
        puts("|[4] Quit                                |");
        puts("|----------------------------------------|");

        printf(KYEL"\nEnter your choice: ");
        option = getchar();
        getchar();

        switch(option){
            case '1':
                printf(KCYN"\nEnter the item(int) you want to add: ");
                fgets(num, sizeof num, stdin);
                strtok(num, "\n");
                enqueue(num);
                break;
            case '2':
                dequeue();
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
