#include <stdio.h>
#include <stdlib.h>
#include <time.h>

static const char ucase[] = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789";

int generateRandomData() {
    const size_t ucase_count = sizeof(ucase) - 1; // ucase includes terminating '\0'
    size_t i, j;
 
    srand(time(NULL));

    for(j = 0; j < ucase_count; j++) {
        char random_char;
        int random_index = (double)rand() / RAND_MAX * ucase_count;
             
        random_char = ucase[random_index];
        printf("%c", random_char);
    }
    printf("\n");
 
    return 0;
}

int main(int argc, char *argv[]) {
    FILE* pFile;
    int buffer[32];

    srand(time(NULL));

    for(int i=0; i<32; i++)
        buffer[i] = rand();

    pFile = fopen("data.bin","wb");

    fclose(pFile);

    generateRandomData();

    return 0;
}