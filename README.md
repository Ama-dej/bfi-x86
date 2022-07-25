A brainfuck interpreter written in linux x86 asm.

To compile, use:

``
$ nasm -f elf bf.asm -o bf.o
``

``
$ ld -m elf_i386 bf.o -o bf
``

To interpret a brainfuck file, use:

``
$ ./bf example_file
``
