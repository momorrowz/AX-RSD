#include <stdlib.h>

int main(int argc, char *argv[])
{
    long long thd1 = 100;
    asm volatile ("csrw 0x801, %0" 
                  :
                  : "r"(thd1)
                  :
                  );
    int a = 0;
    for (int j = 0; j < 10; ++j) {
        a += 1;
        asm volatile("ap.begincyclecount");
        for (int i = 0; i < 1000; ++i) {
            asm goto (
                "ap.bltcycle %l[ENDING]" 
                :
                :
                :
                : ENDING);
            int b = 42;
            a += b;
            char* ptr = 0x40002000;
            *ptr = a;
        }
    }
ENDING:
    return 0;
}