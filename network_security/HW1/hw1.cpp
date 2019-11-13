#include <iostream>
#include <gmpxx.h>
#include <sstream>
#include <string.h>

#define RANDOM_NUM_SIZE 256

using namespace std;

// generate pseudorandom prime number
void generateRandomPrimeNum(mpz_t randomNum) {
    
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


void hex_print(char hex[]) {
    if (strlen(hex) != 64) {
        cout << endl << "[ERROR] Please ensure the input p and q are 128-bit hexacimal number with spaces." << endl;
        exit(-1);
    }

    for(size_t i=0; i<8; i++) {
        for(size_t j=0; j<8; j++) {
            cout << hex[i*8+j];
        }
        cout << " " ;
    }
    cout << endl << endl;
}


string removeSpaces(string str) {
    str.erase(remove(str.begin(), str.end(), ' '), str.end());
    return str;
}


void rabinEncryption(mpz_t ciphertext, mpz_t plaintext, mpz_t n) {
    mpz_t pow_of_plaintext;
    char* plaintext_with_padding;
    const char* tmp;

    mpz_init_set_str(pow_of_plaintext, "0", 10);

    plaintext_with_padding = mpz_get_str(plaintext_with_padding, 2, plaintext);

    tmp = (const char*)plaintext_with_padding;
    string str(tmp);
    str = str.append(str, str.length()-16, str.length()-1);
    plaintext_with_padding = strdup(str.c_str());

    mpz_set_str(plaintext, plaintext_with_padding, 2);

    mpz_pow_ui(pow_of_plaintext, plaintext, 2);
    mpz_mod(ciphertext, pow_of_plaintext, n);
}


void modInverse(mpz_t c, mpz_t d , mpz_t p, mpz_t q) {
    mpz_mod(p, p, q);

}


void rabinDecryption(mpz_t plaintext, mpz_t ciphertext, mpz_t p, mpz_t q, mpz_t n) {
    mpz_t r;
    mpz_t s;
    mpz_t exp;
    mpz_t c;
    mpz_t d;

    mpz_init_set_str(r, "0", 10);
    mpz_init_set_str(s, "0", 10);
    mpz_init_set_str(exp, "0", 10);
    mpz_init_set_str(c, "0", 10);
    mpz_init_set_str(d, "0", 10);

    mpz_add_ui(exp, p, 1);
    mpz_div_ui(exp, exp, 4);
    mpz_powm(r, ciphertext, exp, p);

    mpz_add_ui(exp, q, 1);
    mpz_div_ui(exp, exp, 4);
    mpz_powm(s, ciphertext, exp, q);

    gmp_printf("r is %Zd\n", r);
    gmp_printf("s is %Zd\n", s);

    modInverse(c, d, p, q);
}


int main(void) {
    mpz_t randomNum;
    mpz_t p;
    mpz_t q;
    mpz_t n;
    mpz_t plaintext;
    mpz_t ciphertext;
    string hex_p;
    string hex_q;
    string hex_plaintext;
    string hex_ciphertext_decryption;
    char* hex_randomNum;
    char* hex_n;
    char* hex_ciphertext;
    const char* tmp;

    mpz_init_set_str(randomNum, "0", 10);
    mpz_init_set_str(p, "0", 10);
    mpz_init_set_str(q, "0", 10);
    mpz_init_set_str(n, "0", 10);
    mpz_init_set_str(plaintext, "0", 10);
    mpz_init_set_str(ciphertext, "0", 10);

    generateRandomPrimeNum(randomNum);

    cout << "<Miller-Rabin>" << endl;
    hex_randomNum = mpz_get_str(hex_randomNum, 16, randomNum);
    hex_print(hex_randomNum);

    cout << "<Rabin Encryption>" << endl;
    cout << "p = " ;
    getline(cin, hex_p);
    hex_p = removeSpaces(hex_p);

    cout << "q = " ;
    getline(cin, hex_q);
    hex_q = removeSpaces(hex_q);

    tmp = hex_p.c_str();
    mpz_set_str(p, tmp, 16);
    tmp = hex_q.c_str();
    mpz_set_str(q, tmp, 16);
    mpz_mul(n, p, q);

    cout << "n = pq = " ;
    hex_n = mpz_get_str(hex_n, 16, n);
    hex_print(hex_n);

    cout << "Plaintext = " ;
    getline(cin, hex_plaintext);
    hex_plaintext = removeSpaces(hex_plaintext);
    tmp = hex_plaintext.c_str();
    mpz_set_str(plaintext, tmp, 16);

    rabinEncryption(ciphertext, plaintext, n);
    hex_ciphertext = mpz_get_str(hex_ciphertext, 16, ciphertext);
    cout << "Ciphertext = ";
    hex_print(hex_ciphertext);

    cout << "<Rabin Decryption>" << endl;
    cout << "Ciphertext = " ;
    getline(cin, hex_ciphertext_decryption);
    tmp = hex_ciphertext_decryption.c_str();
    mpz_set_str(ciphertext, tmp, 16);
    
    cout << "Private Key:" << endl;
    cout << "p = " ;
    getline(cin, hex_p);
    hex_p = removeSpaces(hex_p);

    cout << "q = " ;
    getline(cin, hex_q);
    hex_q = removeSpaces(hex_q);

    tmp = hex_p.c_str();
    mpz_set_str(p, tmp, 16);
    tmp = hex_q.c_str();
    mpz_set_str(q, tmp, 16);
    mpz_mul(n, p, q);

    rabinDecryption(plaintext, ciphertext, p, q, n);
    cout << "Plaintext = " ;
    cout << endl;

    return 0;
}
