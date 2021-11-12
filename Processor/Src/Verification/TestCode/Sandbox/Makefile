# クロスコンパイル環境の読み込み
include ../Makefile.inc

# CC := gcc
# CC := /mnt/c/Users/kurob/Documents/gitspace_build/git_lab/musl-cross-make/output/bin/riscv64-linux-musl-gcc
XCFLAGS := -Wall -Wno-unknown-pragmas -O3
#LFLAGS := -static 
HEADERS := include
INCLUDE := -I${HEADERS}
LIB :=
D :=

OUTPUT := jpeg.out
C_FILES := $(wildcard src/*.c)
OBJ_FILES := $(addprefix obj/, $(notdir $(C_FILES:.c=.o)))

BASE_PATH := $(shell pwd)
INPUT_FILE_NAME := Lenna.bmp

# $(warning CC = $(CC))
# $(warning CFLAGS = $(CFLAGS))

.PHONY: all clean

all: bin/code.hex

obj/%.o: src/%.c
	$(CC) $(CFLAGS) $(XCFLAGS) $(INCLUDE) $(D) -c $< -o $@

###########################################################
# for RSD
# LD の引数の順にアドレス空間に配置されるため，
# CRTOBJ は必ず先頭に置く必要がある
# また，$(LIBGCC) $(LIBC) -T$(LDSCRIPT) $(LDFLAGS) は
# $(OBJS) が依存しているためその後ろに置く必要がある．
bin/code.elf: $(OBJ_FILES) $(CRTOBJ) $(LDOBJ) Makefile
	$(LD) -o bin/code.elf $(CRTOBJ) $(LDOBJ) $(OBJ_FILES) $(LIBC) $(LIBGCC) -T$(LDSCRIPT) $(LDFLAGS)

# ELF から必要なセクションを取り出した code.rom.bin を作る
# cat を使って，先頭 4KB のダミー，ROM の順に結合
# ダミーは ROM が 0x1000 がはじまるため
bin/code.bin: bin/code.elf $(DUMMY_ROM)
	$(OBJDUMP) -D $< > $(basename $<).dump	# for debug
	$(ROM_COPY) $< $(basename $<).rom.bin
	cat $(DUMMY_ROM) $(basename $<).rom.bin > $@	

bin/code.hex: bin/code.bin
	$(BIN_TO_HEX) bin/code.bin $@ $(BIN_SIZE)
###########################################################

clean:
	rm -f obj/*.o bin/*
