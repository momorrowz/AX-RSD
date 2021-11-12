#include <math.h>
#include <stdio.h>
#include <string.h>

int fibo(int n)
{
    if (n == 0 || n == 1) {
        return 1;
    } else {
        return fibo(n - 1) + fibo(n - 2);
    }
}

int main()
{
    // printf
    int n = fibo(20);
    printf("20th fibonacci number is %d\n", n);
    // math function
    int i, j;
    int const len = 50;
    for (i = 0; i < len; ++i) {
        int n = 50 * sin(M_PI / len * i);
        for (j = 0; j < n; ++j) {
            printf("*");
        }
        printf("\n");
    }

    // print float
    double a = 2.5;
    printf("%f\n",a*a*a*a);
    return 0;
}
