#include <stdio.h>
#include <stdlib.h>
#include <time.h>

#define DATASIZE 128

static const char ucase[] = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789";
const size_t ucase_count = sizeof(ucase) - 1; // ucase includes terminating '\0'

void generateRandomData() {
    FILE* pFile;
    size_t j;
    static char data[DATASIZE];

    srand(time(NULL));

    pFile = fopen("data.bin", "wb");

    for(j = 0; j < DATASIZE; j++) {
        char random_char;
        int random_index = (double)rand() / RAND_MAX * ucase_count;
             
        random_char = ucase[random_index];
        data[j] = random_char;
        printf("%c", random_char);
    }
    
    printf("\n");

    if(pFile) {
        fwrite(data, 1, DATASIZE, pFile);
    }
 
    fclose(pFile);
}

int main(int argc, char *argv[]) {
    FILE* pFile;
    char buffer[128];

    generateRandomData();

    pFile = fopen("data.bin", "rb");

    fread(buffer, 1, DATASIZE, pFile);

    printf("%s\n", buffer);

    printf("%ld\n", sizeof(buffer));

    fclose(pFile);
    return 0;
}