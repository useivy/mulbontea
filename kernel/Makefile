CPPC = clang++
LD = ld.lld
ASM = nasm

INC = -Iinc/																			# inc/ is the header folder
SRC = $(shell find . -type f -name "*.cpp")				# hopefully shell can find files
ASRC = $(shell find . -type f -name "*.asm")

OBJ = ${ASRC:.asm=.o} ${SRC:.cpp=.o}

CPPC_FLAGS = -Iinc -ggdb -c -ffreestanding -target x86_64-none-elf
ASM_FLAGS = -f elf64
LD_FLAGS = -T kernel.ld
LD_FLAGS_BINARY = ${LD_FLAGS} --oformat binary

all: kernel kernel.elf

kernel: ${OBJ}
	${LD} -o $@ ${LD_FLAGS_BINARY} $^
	
kernel.elf: ${OBJ}
	${LD} -o $@ ${LD_FLAGS} $^
	
%.o: %.asm
	${ASM} $< ${ASM_FLAGS} -o $@
	
%.o: %.c
	${CPPC} ${CPPC_FLAGS} ${INC} -o $@ $^
	
clear:
	rm -f kernel kernel.elf *.o **/*.o