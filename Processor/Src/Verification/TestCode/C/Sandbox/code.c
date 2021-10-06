#include "../lib.c"

int a[500];

int main(void){

    volatile char* outputAddr = (char*)0x40002000;
    for(int i=0;i<500;++i){
        a[i] = i;
    }
    int j=0;
    for(int i=0;i<500;++i){
        j += i;
    }

    return 0;
}
