#include <stddef.h>
#include <stdint.h>

extern int __rodata_end;
extern int __data_start;
extern int __data_end;
extern int __bss_start;
extern int __bss_end;
extern int __vram_start;
extern int __vram_end;

#define ram_start 0x80000000

static void* _rsd_memcpy(void* dest_, const void* src_, size_t n)
{
    uint8_t* dest = dest_;
    const uint8_t* src = src_;

    for (size_t i = 0; i < n; i++) {
        dest[i] = src[i];
    }
    return dest;
}

static void* _rsd_memset(void* str_, int c, size_t n)
{
    uint8_t* str = str_;
    for (size_t i = 0; i < n; i++) {
        str[i] = (uint8_t)c;
    }
    return str;
}

static void* _rsd_apmemcpy(void* dest_, const void* src_, size_t n)  //src_からdst_までap.loadでcopy
{
    uint8_t* dest = dest_;
    const uint8_t* src = src_;
    uint8_t dummy;
    //先頭の56Bは正確にロード
    for (size_t i = 0; i < 56; i++) {
        dest[i] = src[i];
    }
    for (size_t i = 56; i < n; i++) {
        //dest[i] = src[i];
        asm(
            "mv t1,%0\n\t"
            //".word 0b00000000000000110010001010001011\n\t"  // ap.lw t0,0(t1)
            ".word 0b00000000000000110000001010001011\n\t"  // ap.load t0,0(t1)
            "sb t0,0(%1) \n\t" ::"r"(&src[i]),
            "r"(&dest[i])
            : "t0", "t1", "memory");
    }
    return dest;
}

void _load()
{
    // The core function of the RSD loader called at the very beggining of run time.
    // It copies data in .data and .sdata sections from ROM to RAM
    // and sets 0 in .bss and .sbss sections in RAM.
    uint32_t data_size = (uint32_t)&__data_end - (uint32_t)&__data_start;
    uint32_t vram_size = (uint32_t)&__vram_end - (uint32_t)&__vram_start;
    uint32_t bss_size = (uint32_t)&__bss_end - (uint32_t)&__bss_start;

    _rsd_memcpy((void*)ram_start, &__rodata_end, data_size);
    _rsd_apmemcpy((void*)&__vram_start, (uint32_t)&__rodata_end + data_size, vram_size);
    _rsd_memset(&__bss_start, 0, bss_size);
}
