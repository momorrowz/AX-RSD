#include <stdlib.h>
#include "../lib.c"

int main(int argc, char *argv[])
{
    long long thd1 = 10;
    serial_out_hex(thd1);
    for (int k = 0; k < 3; ++k) {
        asm volatile ("csrw 0x801, %0" 
                    :
                    : "r"(thd1)
                    :
                    );
        volatile int a = 0;
        for (int j = 0; j < 100; ++j) {
            a += 256;
            asm volatile("ap.begincyclecount");
            int i = 0;
            for (; i < 1000; ++i) {
                asm goto (
                    "ap.bltcycle %l[ENDING]" 
                    :
                    :
                    :
                    : ENDING);
                int b = 16;
                a += b;
                // char* ptr = 0x40002000;
                // *ptr = a;
                // serial_out_hex(a);
                // serial_out_char('\n');
            }
            ENDING:
            serial_out_hex(i);
            serial_out_char('\n');
        }
        thd1 *= 10;
    }
    return 0;
}