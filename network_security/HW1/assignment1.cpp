#include <iostream>
#include <cstdlib>
#include <math.h>

#define RANDOM_NUM_SIZE 256
#define BITS_PER_INT (sizeof(int)*8)

using namespace std;

struct uint256_t {
    uint32_t bits[RANDOM_NUM_SIZE/BITS_PER_INT];
};

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
    for(int j=i-1; j>=0; j--)  cout << hexaDeciNum[j] ;
    cout << " " ; 
} 

int main() {
    srand(time(NULL));

    uint256_t randomNum;
    for(size_t i=0; i<RANDOM_NUM_SIZE/BITS_PER_INT; i++)
            randomNum.bits[i] = rand() % ( 1 << (BITS_PER_INT - 1));

    for(size_t i=0; i<RANDOM_NUM_SIZE/BITS_PER_INT; i++)
        decToHexa(randomNum.bits[i]);

    cout << endl ;

    return 0;
}