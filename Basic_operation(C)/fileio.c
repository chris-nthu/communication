#include <stdio.h>

#define FILENAME "record.dat"

int main(void){
    FILE *fp;
    char name[20];
    char cellphone[11];
    
    fp = fopen(FILENAME, "w+");
    fprintf(fp, "Peggy 0913403200\n");
    fprintf(fp, "Chris 0976023510\n");
    fprintf(fp, "Gary 0976671839\n");
    fprintf(fp, "Jasper 0976319637\n");
    fprintf(fp, "Mummy 0953020656\n");
    fprintf(fp, "Daddy 0986870608\n");
    fclose(fp);

    fp = fopen(FILENAME, "r");
    while(fscanf(fp, "%s %s", name, cellphone)!=EOF){  
        printf("[%s, %s]\n", name, cellphone);
    }  
    fclose(fp);

    return 0;
}
