#include <iostream>
#include <cstdlib>

#define RANDOMNUMSIZE 256
#define BITS_PER_INT (sizeof(int))

using namespace std;

int * getNBitRandom( unsigned int n ) {
    static int array[RANDOMNUMSIZE/BITS_PER_INT];
    srand(time(NULL));

    for(size_t i=0; i<n/BITS_PER_INT; i++){
        array[i] = rand() % 16;
    }

    return array;
}

int main(){
    int *randomNum;

    randomNum = getNBitRandom(RANDOMNUMSIZE);

    for(size_t i=0; i<RANDOMNUMSIZE/BITS_PER_INT; i++){
        cout << *(randomNum + i) << " " ;
    }

    return 0;
}