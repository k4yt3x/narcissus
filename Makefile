release:
	nasm -f elf64 -gdwarf narcissus.nasm -o narcissus.o
	ld -o narcissus narcissus.o
	strip -s narcissus

debug:
	nasm -f elf64 -gdwarf narcissus.nasm -o narcissus.o
	ld -o narcissus narcissus.o
