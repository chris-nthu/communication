#include <stdio.h>

int main(void){
    int num;
    char str[10];

    printf("Input an integer: ");
    scanf("%d", &num);
    getchar();
    printf("Your input: %d\n\n", num);
    
    printf("Input a character: ");
    num = getchar();
    getchar();
    printf("Your input: %c\n\n", num);

    printf("Input a string: ");
    fgets(str, sizeof str, stdin);
    printf("Your input: %s\n\n", str);

    return 0;
}