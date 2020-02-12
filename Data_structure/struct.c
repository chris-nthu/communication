#include <stdio.h>
#include <stdlib.h>

typedef struct notebook{
    char model[10];
    char cpu[10];
    char ram[5];
    int price;
}notebook;

void Discount(notebook (*n)[3]){
    for(size_t i=0; i<3; i++)
        (*n)[i].price *= 0.8;
}

int main(void){
    notebook n[3] = {
        {"acer", "i5", "8G", 24000},
        {"asus", "i3", "8G", 19500},
        {"hp", "i7", "8G", 30500},
    };

    int length = (sizeof(n) / sizeof(n[0]));

    for(size_t i=0; i<length; i++){
        printf("Product %ld\n", i+1);
        printf("MODEL: %s\n", n[i].model);
        printf("CPU: %s\n", n[i].cpu);
        printf("RAM: %s\n", n[i].ram);
        printf("Price: NT.%d\n\n", n[i].price);
    }
    printf("=================\n\n");

    printf("After discounting...\n");
    Discount(&n);
    for(size_t i=0; i<length; i++){
        printf("Product %ld\n", i+1);
        printf("MODEL: %s\n", n[i].model);
        printf("CPU: %s\n", n[i].cpu);
        printf("RAM: %s\n", n[i].ram);
        printf("Price: NT.%d\n\n", n[i].price);
    }
    printf("=================\n\n");

    return 0;
}
