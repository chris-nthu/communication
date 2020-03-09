#include <vector>
#include <iostream>

using namespace std;

int main(void){
    int arr[] = {1, 2, 3, 4, 5};
    vector<int> vec(arr, arr+5);
    int len = vec.size();

    for(int i=0; i<len; i++)
        cout << vec[i] << endl;

    vector<int>::iterator begin = vec.begin();
    vector<int>::iterator end = vec.end();
    vector<int>::iterator it;
    for(it=begin; it!=end; it++)
        cout << *it << endl;

    return 0;
}
