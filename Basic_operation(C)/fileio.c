#include <stdio.h>

#define FILENAME "record.dat"

int main(void){
    FILE *fp;
    char name[20];
    char cellphone[11];
    
    fp = fopen(FILENAME, "w+");

    fprintf(fp, "Peggy 0913403200\n");
    fprintf(fp, "Chris 0976023510\n");

    fclose(fp);

    fp = fopen(FILENAME, "r");

    fscanf(fp, "%s %s", name, cellphone);
    printf("[%s, %s]\n", name, cellphone);
    
    fscanf(fp, "%s %s", name, cellphone);
    printf("[%s, %s]\n", name, cellphone);

    fclose(fp);

    return 0;
}
