#include <set>
#include <iostream>

using namespace std;

int main(void){
    set<int> myset;

    myset.insert(10);
    myset.insert(20);
    myset.insert(30);
    myset.insert(40);

    cout << myset.count(20) << endl;
    cout << myset.count(100) << endl;

    myset.erase(20);

    cout << myset.count(20) << endl;

    return 0;
}