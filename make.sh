nasm -f elf bf.asm -o bf.o
ld -m elf_i386 bf.o -o bf
