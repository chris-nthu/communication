#include <stdio.h>
#include <stdlib.h>
#include <string.h>

// Complexity: O(N)
int Search_data(char* data, char c){
    for(size_t i=0; i<strlen(data); i++){
        if(data[i] == c)
            return i;
    }

    exit(-1);
}

// Complexity: O(N)
char* Insert_data(char* data, char c, int index){
    char *result = (char*)malloc(strlen(data)+1);

    for(size_t i=0; i<index; i++)
        result[i] = data[i];
    
    result[index] = c;

    for(size_t i=index; i<strlen(data); i++)
        result[i+1] = data[i];

    return result;
}

// Complexity: O(N)
char* Delete_data(char* data, char c){
    char *result = (char*)malloc(strlen(data)-1);
    size_t j = 0;

    for(size_t i=0; i<strlen(data); i++){
        if(data[i] == c)
            j--;
        else
            result[j] = data[i];
        
        j++;
    }

    return result;
}

int main(void){
    char data[] = {'a', 'b', 'c', 'd', 'e', 'f', 'g'};
    char buff;
    int index;

    printf("Data: %s\n\n", data);

    printf("Which character you wanna search: ");
    scanf("%c", &buff);
    printf("The index of '%c' is %d\n\n", buff, Search_data(data, buff));

    printf("Input the character you wanna insert: ");
    scanf("\n%c", &buff);
    printf("Input the index you wanna insert: ");
    scanf("\n%d", &index);
    printf("Data(new): %s\n\n", Insert_data(data, buff, index));

    printf("Input the character you wanna delete: ");
    scanf("\n%c", &buff);
    printf("Data(new): %s\n\n", Delete_data(data, buff));

    return 0;
}
