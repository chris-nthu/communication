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

using namespace std;

// generate pseudorandom prime number
void generateRandomPrimeNum(mpz_t randomNum) {
    /*--- initialize randomNum ---*/
    mpz_init(randomNum);
    mpz_init_set_str(randomNum, "0", 10);

    /*--- generate random seed ---*/
    unsigned long seed;
    seed = time(NULL);

    gmp_randstate_t rstate;
    gmp_randinit_default(rstate);
    gmp_randseed_ui(rstate, seed);

    /*--- determine if the large number is a prime number ---*/
    int isPrime = 0;
    while(!isPrime){
        // generate random 256-bit number
        mpz_urandomb(randomNum, rstate, RANDOM_NUM_SIZE);
        
        // use miller-rabin method to determine if the large number is a prime number
        isPrime = mpz_probab_prime_p(randomNum, 10);
    }
}

int main(void) {
    /*--- argument ---*/
    mpz_t randomNum;        // pseudorandom prime number
    char *hex_randomNum;    // hexadecimal pesudorandom prime number


    // generate pseudorandom prime number
    generateRandomPrimeNum(randomNum);

    // convert decimal to hexacimal and print out
    hex_randomNum = mpz_get_str(hex_randomNum, 16, randomNum);
    

    cout << KRED_L << "<Miller-Rabin>" << endl;
    for(size_t i=0; i<8; i++) {
        for(size_t j=0; j<8; j++) {
            cout << RESET << *(hex_randomNum + (i * 8 + j));
        }
        cout << " " ;
    }
    cout << endl << endl;;


    cout << KRED_L << "<Rabin Encryption>" << endl;
    cout << KGRN_L << "p = " ;
    cout << endl;
    cout << KGRN_L << "q = " ;
    cout << RESET << endl;
    // 從這開始

    return 0;
}
