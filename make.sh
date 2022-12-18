#!/bin/bash
nasm -f elf src/bfi.asm -o bin/bfi.o
ld -m elf_i386 bin/bfi.o -o bin/bfi
rm bin/bfi.o
