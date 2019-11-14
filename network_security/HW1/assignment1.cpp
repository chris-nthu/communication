#include <iostream>
#include <gmpxx.h>
#include <sstream>
#include <string.h>

#ifndef _DEBUG_COLOR_
#define _DEBUG_COLOR_
    #define KRED_L "\x1B[1;31m"
    #define KGRN_L "\x1B[1;32m"
    #define KYEL_L "\x1B[1;33m"
    #define KBLU_L "\x1B[1;34m"
    #define RESET "\x1B[0m"
#endif

#define RANDOM_NUM_SIZE 256

using namespace std;

struct GCDstruct {
    mpz_class a, c, d;
};

mpz_class generateRandomPrimeNum(int bits) {
    mpz_class randomNum;

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
        mpz_urandomb(randomNum.get_mpz_t(), rstate, RANDOM_NUM_SIZE);
        
        // use miller-rabin method to determine if the large number is a prime number
        isPrime = mpz_probab_prime_p(randomNum.get_mpz_t(), 10);
    }

    return randomNum;
}

void hex_print(string str) {
    for(size_t i=0; i<str.length()/8; i++) {
        for(size_t j=0; j<8; j++) {
            cout << RESET << str[i*8+j];
        }
        cout << " " ;
    }
    cout << endl << endl;
}

string removeSpaces(string str) {
    str.erase(remove(str.begin(), str.end(), ' '), str.end());
    return str;
}

mpz_class rabinEncryption(mpz_class plaintext, mpz_class n) {
    string plaintext_with_padding;
    mpz_class pow_of_plaintext;
    mpz_class ciphertext;

    plaintext_with_padding = plaintext.get_str(2);
    plaintext_with_padding = plaintext_with_padding.append(plaintext_with_padding, plaintext_with_padding.length()-16, plaintext_with_padding.length()-1);
    plaintext.set_str(plaintext_with_padding, 2);

    mpz_pow_ui(pow_of_plaintext.get_mpz_t(), plaintext.get_mpz_t(), 2);
    mpz_mod(ciphertext.get_mpz_t(), pow_of_plaintext.get_mpz_t(), n.get_mpz_t());

    return ciphertext;
}

// gcd with extended euclidean algorithm
GCDstruct eGCD( mpz_class a, mpz_class b ) {
    if(a%b == 0) {
        GCDstruct s = { b, 0, 1 };
        return s;
    }
    else {
        mpz_class q = a/b;
        mpz_class r = a%b;
        GCDstruct tmp = eGCD(b, r);
        GCDstruct s = { tmp.a, tmp.d, tmp.c-tmp.d*q };
        return s;
    }
} 

mpz_class sortAnswer(mpz_class m1, mpz_class m2, mpz_class m3, mpz_class m4) {
    string tmp1, tmp2;
    mpz_class m[4] = {m1, m2, m3, m4};
    
    for(size_t i=0; i<4; i++) {
        tmp1.append(m[i].get_str(2), m[i].get_str(2).length()-16, m[i].get_str(2).length()-1);
        tmp2.append(m[i].get_str(2), m[i].get_str(2).length()-32, m[i].get_str(2).length()-17);

        if(tmp2.find(tmp1, 0) == 0)
            return m[i];

        tmp1 = "";
        tmp2 = "";
    }
}

mpz_class rabinDecryption(mpz_class ciphertext, mpz_class p, mpz_class q, mpz_class n) {
    GCDstruct gcd;
    mpz_class r;
    mpz_class s;
    mpz_class x;
    mpz_class y;
    mpz_class m1;
    mpz_class m2;
    mpz_class m3;
    mpz_class m4;
    mpz_class tmp("0");

    gcd = eGCD(p, q);

    if(p % 4 == 3) {
        tmp = (p+1)/4;
        mpz_powm(r.get_mpz_t(), ciphertext.get_mpz_t(), tmp.get_mpz_t(), p.get_mpz_t());
        tmp = 0;
    } else if(p % 8 == 5) {
        tmp = (p-1)/4;
        mpz_powm(r.get_mpz_t(), ciphertext.get_mpz_t(), tmp.get_mpz_t(), p.get_mpz_t());
        tmp = 0;
    }

    if(q % 4 == 3) {
        tmp = (q+1)/4;
        mpz_powm(s.get_mpz_t(), ciphertext.get_mpz_t(), tmp.get_mpz_t(), q.get_mpz_t());
        tmp = 0;
    } else if(q % 8 == 5) {
        tmp = (q-1)/4;
        mpz_powm(s.get_mpz_t(), ciphertext.get_mpz_t(), tmp.get_mpz_t(), q.get_mpz_t());
        tmp = 0;
    }

    x = (r * gcd.d * q + s * gcd.c * p) % n;
    y = (r * gcd.d * q - s * gcd.c * p) % n;

    m1 = x;
    m2 = n - x;
    m3 = y;
    m4 = n - y;

    return sortAnswer(m1, m2, m3, m4);
}

void ans_print(string str) {
    int padding = 8 * 7 - str.length();

    if(padding != 0) {
        cout << RESET << "00000000" << " " ;
        hex_print(str);
    }
}

int main(void) {
    mpz_class randomNum("0");
    mpz_class p("0");
    mpz_class q("0");
    mpz_class n("0");
    mpz_class plaintext("0");
    mpz_class ciphertext("0");

    string hex_p;
    string hex_q;
    string hex_plaintext;
    string hex_ciphertext;

    randomNum = generateRandomPrimeNum(RANDOM_NUM_SIZE);
    
    cout << KYEL_L << "[108064535 Wen-Yuan Chen Assignment#1]" << endl << endl;;
    cout << KRED_L << "<Miller-Rabin>" << endl;
    hex_print(randomNum.get_str(16));

    cout << KRED_L << "<Rabin Encryption>" << endl;
    cout << KGRN_L << "p = " << RESET ;
    getline(cin, hex_p);
    hex_p = removeSpaces(hex_p);
    p.set_str(hex_p, 16);

    cout << KGRN_L << "q = " << RESET ;
    getline(cin, hex_q);
    hex_q = removeSpaces(hex_q);
    q.set_str(hex_q, 16);

    cout << KGRN_L << "n = pq = " ;
    n = p * q;
    hex_print(n.get_str(16));

    cout << KBLU_L << "Plaintext = " << RESET ;
    getline(cin, hex_plaintext);
    hex_plaintext = removeSpaces(hex_plaintext);
    plaintext.set_str(hex_plaintext, 16);

    cout << KBLU_L << "Ciphertext = " ;
    ciphertext = rabinEncryption(plaintext, n);
    hex_print(ciphertext.get_str(16));

    cout << KRED_L << "<Rabin Decryption>" << endl;
    cout << KBLU_L << "Ciphertext = " << RESET ;
    getline(cin, hex_ciphertext);
    hex_ciphertext = removeSpaces(hex_ciphertext);
    ciphertext.set_str(hex_ciphertext, 16);

    cout << KRED_L << "Private Key:" << endl;
    cout << KGRN_L << "p = " << RESET ;
    getline(cin, hex_p);
    hex_p = removeSpaces(hex_p);
    p.set_str(hex_p, 16);

    cout << KGRN_L << "q = " << RESET ;
    getline(cin, hex_q);
    hex_q = removeSpaces(hex_q);
    q.set_str(hex_q, 16);

    n = p * q;

    cout << KBLU_L << "Plaintext = " ;
    plaintext = rabinDecryption(ciphertext, p, q, n);
    ans_print(plaintext.get_str(16));

    return 0;
}