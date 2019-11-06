#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include <math.h>

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

#define DATASIZE 1024 // the amount of message bits
#define HAMMING_CHECKBITS 11

/* determine if the input integer is a power of 2 */
_Bool isPowerBy2(int n) {
    return n > 0 && (n & n - 1) == 0;
}

void generateRandomData(char *originalBin) {
    srand(time(NULL));

    for(size_t i=0; i<DATASIZE; i++) {
        if (rand() % 2 == 0)
            *(originalBin + i) = '0';
        else
            *(originalBin + i) = '1';
    }
}

char * hammingEncoding(char *originalBin) {
    /*
    int n = DATASIZE;
    int checkbits = 0;
    while(n >= 2) {
        n = n / 2 ;
        checkbits++;
    }
    checkbits += 1;
    */

    int count = 0;
    static char hammingEncodedData[DATASIZE + HAMMING_CHECKBITS];
    char checkbits[HAMMING_CHECKBITS];

    for(size_t i=0; i<DATASIZE+HAMMING_CHECKBITS; i++) {
        if(!isPowerBy2(i+1)) {
            hammingEncodedData[i] = originalBin[count];
            count++;
        }
    }

    for(size_t i=0; i<DATASIZE+HAMMING_CHECKBITS; i++) {
        count = 0;
        if(hammingEncodedData[i] == '1'){
            for (int c = HAMMING_CHECKBITS-1; c >= 0; c--) {
                int k = (i+1) >> c;
                
                if (k & 1) {
                    if(checkbits[count] == '1') checkbits[count] = '0';
                    else checkbits[count] = '1';
                }
                else {
                    if(checkbits[count] == '1') checkbits[count] = '1';
                    else checkbits[count] = '0';
                }
                count++;
            }
        }
    }

    count = HAMMING_CHECKBITS - 1;
    for(size_t i=0; i<DATASIZE+HAMMING_CHECKBITS; i++) {
        if(isPowerBy2(i+1)) {
            // printf("%d, %ld\n", count, i);
            hammingEncodedData[i] = checkbits[count];
            count--;
        }
    }

    return hammingEncodedData;
}

char * ruinData(int amount, char hammingEncodedData[]) {
    static char ruinEncodedData[DATASIZE+HAMMING_CHECKBITS];

    for(size_t i=0; i<DATASIZE+HAMMING_CHECKBITS; i++) {
        ruinEncodedData[i] = *(hammingEncodedData + i);
    }

    srand(time(NULL));
    int randIndex = rand()%(DATASIZE+HAMMING_CHECKBITS);
    //int randIndex = 20;
    //printf("%d\n", randIndex);  
    if(ruinEncodedData[randIndex] == '1')
        ruinEncodedData[randIndex] = '0';
    else ruinEncodedData[randIndex] = '1'; 
    //printf("%d\n", randIndex); 
    
    return ruinEncodedData;
}

char * hammingDecoding(char ruinEncodedData[]) {
    char checkbits[HAMMING_CHECKBITS];

    for(size_t i=0; i<DATASIZE+HAMMING_CHECKBITS; i++) {
        int count = 0;
        if(ruinEncodedData[i] == '1') {
            for (int c = HAMMING_CHECKBITS-1; c >= 0; c--) {
                int k = (i+1) >> c;
                
                if (k & 1) {
                    if(checkbits[count] == '1') checkbits[count] = '0';
                    else checkbits[count] = '1';
                }
                else {
                    if(checkbits[count] == '1') checkbits[count] = '1';
                    else checkbits[count] = '0';
                }
                count++;
            }
        }
    }
    
    //printf("%s\n", checkbits);
    int flag = 0;
    int num = 0;
    for(size_t i=HAMMING_CHECKBITS-1; i>=1; i--) {
        if(checkbits[i] == '1') {
            flag = 1;
            num = num + pow(2, HAMMING_CHECKBITS-1-i);
        }
    }

    if(flag = 1) printf(KGRN_L"(1-bit error detected and corrected.) ");
    
    if(ruinEncodedData[num-1]='1') ruinEncodedData[num-1] = '0';
    else ruinEncodedData[num-1] = '1';

    return ruinEncodedData;
}

int main(int argc, char *argv[]) {
    char originalBin[DATASIZE];
    char *hammingEncodedData;
    char *ruinEncodedData;
    char *hammingDecodedData;

    FILE *fptr;

    fptr = fopen("output.txt", "w");
    if(fptr == NULL) {
        printf("Error!");
        exit(1);
    }

    /* Used to randomly generate 1Kbits data */
    generateRandomData(originalBin);

    printf(KRED_L"Randomly generate 1Kbits binary data: \n");

    for(size_t i=0; i<DATASIZE; i++) {
        printf(RESET"%c", originalBin[i]);
    }
    printf("\n\n");

    /*---- Hamming code ----*/
    hammingEncodedData = hammingEncoding(originalBin);
    printf(KGRN_L"Result of hamming encoded data: \n");
    for(size_t i=0; i<DATASIZE+HAMMING_CHECKBITS; i++)
        printf(RESET"%c", *(hammingEncodedData + i));
    printf("\n\n");

    ruinEncodedData = ruinData(1, hammingEncodedData);
    printf(KGRN_L"Result of hamming defective data: \n");
    for(size_t i=0; i<DATASIZE+HAMMING_CHECKBITS; i++)
        printf(RESET"%c", *(ruinEncodedData + i));
    printf("\n\n");

    hammingDecodedData = hammingDecoding(ruinEncodedData);
    printf(KGRN_L"Result of hamming decoded data: \n");
    for(size_t i=0; i<DATASIZE+HAMMING_CHECKBITS; i++)
        printf(RESET"%c", *(hammingDecodedData + i));
    printf("\n\n");

    fprintf(fptr, "%s", hammingDecodedData);
    printf(KBLU_L"Output the result in output.txt......\n");
    printf(RESET"\n\n");
    /*----------------------*/

    fclose(fptr);
    return 0;
}
