#include <map>
#include <iostream>

using namespace std;

int main(void){
    map<string, int> m;

    m["one"] = 1;
    m["two"] = 2;
    m["three"] = 3;
    m["four"] = 4;

    cout << m.count("one") << endl;
    cout << m.count("ten") << endl;

    cout << m["one"] << endl;
    cout << m["two"] << endl;
    cout << m["three"] << endl;
    cout << m["four"] << endl;

    return 0;
}