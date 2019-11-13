#include <iostream>
#include <gmpxx.h>
#include <sstream>
#include <string>

#define RANDOM_NUM_SIZE 256

using namespace std;

string hex_p, hex_q;

// generate pseudorandom prime number
void generateRandomPrimeNum(mpz_t randomNum) {

    /*--- initialze ---*/
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


// remove all spaces from a given string 
string removeSpaces(string str)  { 
    str.erase(remove(str.begin(), str.end(), ' '), str.end()); 
    return str; 
} 


int main(void) {

    /*--- declare argument ---*/
    mpz_t randomNum;        // pseudorandom prime number
    char *hex_randomNum;    // hexadecimal pesudorandom prime number
    

    /*--- generate pseudorandom prime number ---*/
    generateRandomPrimeNum(randomNum);

    /*--- convert decimal to hexacimal and print out ---*/
    hex_randomNum = mpz_get_str(hex_randomNum, 16, randomNum);

    cout << "<Miller-Rabin>" << endl;
    for(size_t i=0; i<8; i++) {
        for(size_t j=0; j<8; j++) {
            cout << *(hex_randomNum + (i * 8 + j));
        }
        cout << " " ;
    }
    cout << endl << endl;

    cout << "<Rabin Encryption>" << endl;
    cout << "p = " ;
    cin >> hex_p ;
    cout << "q = " ;
    cin >> hex_q ;
    cout << "n = pq = " ;
    cout << endl;

    hex_p.erase(remove(hex_p.begin(), hex_p.end(), ' '), hex_p.end());

    return 0;
}
