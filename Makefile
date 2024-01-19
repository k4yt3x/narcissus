release:
	nasm -f elf64 -gdwarf narcissus.nasm -o narcissus.o
	ld -o narcissus narcissus.o
	strip -s narcissus

debug:
	nasm -f elf64 -gdwarf narcissus.nasm -o narcissus.o
	ld -o narcissus narcissus.o

original:
	nasm -f elf64 -gdwarf narcissus.orig.nasm -o narcissus.orig.o
	ld -o narcissus.orig narcissus.orig.o
	strip -s narcissus.orig

original-debug:
	nasm -f elf64 -gdwarf narcissus.orig.nasm -o narcissus.orig.o
	ld -o narcissus.orig narcissus.orig.o

