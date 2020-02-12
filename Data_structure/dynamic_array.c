#include <stdio.h>
#include <stdlib.h>

// O(1+2+4+8+...+N) = O(2N-1) = O(N)
int* move(int *num, int *size){
    int *buffer = (int*)malloc(sizeof(int)**size);
    
    for(size_t i=0; i<*size; i++){
        buffer[i] = num[i];
    }

    num = (int*)malloc(sizeof(int)**size*2);

    for(size_t i=0; i<*size; i++){
        num[i] = buffer[i];
    }

    free(buffer);
    *size *= 2;

    return num;
}

int main(void) {
    int size = 1;
    int *num = (int*)malloc(sizeof(int)*size);
    int i = 0;

    while(1){
        if(i == size)
            num = move(num, &size);
        
        printf("Input digit: ");
        scanf("\n%d", &num[i]);
        printf("Array: ");
        for(int j=0; j<=i; j++){
            printf("%d ", num[j]);
        }
        printf("\n");
        i++;
    }

    free(num);

    return 0;
}
