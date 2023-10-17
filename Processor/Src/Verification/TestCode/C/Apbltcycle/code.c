#include <stdlib.h>

int main(int argc, char *argv[])
{
    long long thd1 = atoi(argv[1]);
    asm volatile ("csrw 0x801, %0" 
                  :
                  : "r"(thd1)
                  :
                  );
    asm volatile("ap.begincyclecount");
    for (int i = 0; i < 100; ++i) {
        asm goto (
            "ap.bltcycle %l[ENDING]" 
            :
            :
            :
            : ENDING);
        int a = 42;
        int b = 38;
        int c = a + b;
    }
ENDING:
    return 0;
}