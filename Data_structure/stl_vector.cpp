#include <iostream>
#include <vector>

using namespace std;

int main(void){
    vector<int> vec;

    vec.push_back(10);
    vec.push_back(20);
    vec.push_back(30);

    cout << "The length of this vector is " << vec.size() << endl;

    for(int i=0; i<vec.size(); i++)
        cout << vec[i] << " " ;

    cout << endl << endl;

    vec.pop_back();

    cout << "After poping one time." << endl;

    cout << "The length of this vector is " << vec.size() << endl;

    for(int i=0; i<vec.size(); i++)
        cout << vec[i] << " ";
    
    cout << endl;

    cout << vec.front() << endl;

    return 0;
}
