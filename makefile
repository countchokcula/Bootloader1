all: ./build/a.bin
./build/a.bin: ./src/main.asm
	nasm -f bin ./src/main.asm -o ./build/a.bin