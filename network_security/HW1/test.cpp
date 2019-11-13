#include <iostream> 
#include <string>
using namespace std; 

int main() { 
    const char* t = "000101011011";
    string str2(t); 
    cout << str2.length() << endl;
    str2 = str2.append(str2, str2.length()-5, str2.length()-1);

    cout << str2 << endl;
    cout << str2.length() << endl;
 
    return 0; 
}