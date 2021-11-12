#include <stdint.h>
#include <stdlib.h>
#include <sys/stat.h>
#include <sys/types.h>

caddr_t _sbrk(int incr);
int _close(void* reent, int fd);
int _fstat(void* reent, int fd, struct stat* pstat);
off_t _lseek(void* reent, int fd, off_t pos, int whence);
int _read(int file, char* ptr, int len);
int _write(int file, char* ptr, int len);
void _exit(int code);
int _getpid(void);
int _isatty(int file);
void _kill(int pid, int sig);
int _open(const char* name, int flags, int mode);

register char* stack_ptr asm("sp");
caddr_t _sbrk(int incr)
{
    extern char __bss_end; /* Defined by the linker */
    static char* heap_end;
    char* prev_heap_end;

    if (heap_end == 0) {
        heap_end = &__bss_end;
    }

    prev_heap_end = heap_end;

    if (heap_end + incr > stack_ptr) {
        _write(1, "Heap and stack collision\n", 25);
        abort();
    }

    heap_end += incr;

    return (caddr_t)prev_heap_end;
}

int _close(void* reent, int fd)
{
    return (0);
}

int _fstat(void* reent, int fd, struct stat* pstat)
{
    pstat->st_mode = S_IFCHR;
    return (0);
}

off_t a;
off_t _lseek(void* reent, int fd, off_t pos, int whence)
{
    return (a);
}

int _read(int file, char* ptr, int len)
{
    return 0;
}

int _write(int file, char* ptr, int len)
{
    int r;
    volatile char* outputAddr = (char*)0x40002000;
    for (r = 0; r < len; r++) {
        *outputAddr = ptr[r];
    }
    return len;
}

void _exit(int code)
{
    return;
}

int _getpid(void)
{
    return (-1);
}

int _isatty(int file)
{
    return (-1);
}

void _kill(int pid, int sig)
{
    return;
}

int _open(const char* name, int flags, int mode)
{
    return -1;
}
