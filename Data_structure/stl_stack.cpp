#include <stack>
#include <iostream>

using namespace std;

int main(){
    stack<int> s;

    s.push(10);
    s.push(20);
    s.push(30);

    while(s.size()!=0){
        cout << s.top() << " ";
        s.pop();
    }
    cout << endl;

    return 0;
}
