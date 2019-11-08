#include <iostream>
#include <gmpxx.h>
#include <sstream>

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

#define RANDOM_NUM_SIZE 256
#define BITS_PER_INT (sizeof(int)*8)

using namespace std;

// function to convert decimal to hexadecimal 
void decToHexa(unsigned int n) 
{    
    // char array to store hexadecimal number 
    char hexaDeciNum[RANDOM_NUM_SIZE/BITS_PER_INT]; 
      
    // counter for hexadecimal number array 
    int i = 0; 
    while(n!=0) {    
        // temporary variable to store remainder 
        int temp  = 0; 
          
        // storing remainder in temp variable. 
        temp = n % 16; 
          
        // check if temp < 10
        if(temp < 10) {
            hexaDeciNum[i] = temp + 48; 
            i++; 
        } else { 
            hexaDeciNum[i] = temp + 55; 
            i++; 
        }
          
        n = n/16;
    } 

    // printing hexadecimal number array in reverse order 
    //for(int j=i-1; j>=0; j--)  cout << hexaDeciNum[j] ;
    //cout << " " ; 
} 

void generateRandomPrimeNum(mpz_t randomNum) {
    mpz_init(randomNum);
    mpz_init_set_str(randomNum, "0", 10);

    unsigned long seed;
    seed = time(NULL);

    gmp_randstate_t rstate;
    gmp_randinit_default(rstate);
    gmp_randseed_ui(rstate, seed);

    int isPrime = 0;
    while(!isPrime){
        mpz_urandomb(randomNum, rstate, RANDOM_NUM_SIZE);
        isPrime = mpz_probab_prime_p(randomNum, 10);
        // cout << isPrime << " ";
    }

    // gmp_printf("randNum = %Zd\n", randomNum);
}

int main() {
    mpz_t randomNum;        // pseudorandom prime number
    char *hex_randomNum;    // hexadecimal pesudorandom prime number

    generateRandomPrimeNum(randomNum);
    hex_randomNum = mpz_get_str(hex_randomNum, 16, randomNum);
    
    cout << KRED_L << "<Miller-Rabin>" << endl;
    for(size_t i=0; i<8; i++) {
        for(size_t j=0; j<8; j++) {
            cout << RESET << *(hex_randomNum +) //從這開始!!!!!!
        }
    }

    return 0;
}
