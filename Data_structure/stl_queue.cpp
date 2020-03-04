#include <queue>
#include <iostream>

using namespace std;

int main(void){
    queue<int> q;

    q.push(10);
    q.push(20);
    q.push(30);
    q.push(40);

    while(q.size()!=0){
        cout << q.front() << " ";
        q.pop();
    }
    cout << endl;

    return 0;
}
