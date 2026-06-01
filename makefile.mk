NASM = nasm
NASMFLAGS = -f elf32
LD = ld
LDFLAGS = -T link.ld -m elf_i386
QEMU = qemu-system-i386
IMG = solaros.img

ASM_OBJS = boot.o initrix.o kernel.o

all: build run

build: $(ASM_OBJS)
	$(LD) $(LDFLAGS) -o kernel.bin $(ASM_OBJS)
	dd if=/dev/zero of=$(IMG) bs=512 count=2880 status=none
	dd if=boot.bin of=$(IMG) conv=notrunc status=none
	dd if=kernel.bin of=$(IMG) seek=2 conv=notrunc status=none

%.o: %.asm
	$(NASM) $(NASMFLAGS) $< -o $@

run:
	$(QEMU) -fda $(IMG)

clean:
	rm -f *.o *.bin $(IMG)

.PHONY: all build run clean
