#include <stdio.h>
#include <stdlib.h>

#define numsSize 6

int main(){
    int *nums = (int*)malloc(sizeof(int)*numsSize);
    
    nums[0] = 3;
    nums[1] = 2;
    nums[2] = 1;
    nums[3] = 6;
    nums[4] = 0;
    nums[5] = 5;

    for(int i=0; i<numsSize; i++)
        printf("nums[%d]=%d\n\n", i, nums[i]);

    int *nums_new = nums + 1;

    printf("New nums array after shift 1 int address.\n");
    for(int i=0; i<numsSize-1; i++)
        printf("nums_new[%d]=%d\n", i, nums_new[i]);

    free(nums);
    return 0;
}