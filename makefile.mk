# SolarOS Makefile
# usage: make build, make run, make clean

NASM = nasm
QEMU = qemu-system-x86_64
IMG = solaros.img

SOURCES = boot.asm initrix.asm kernel.asm
OBJECTS = boot.bin initrix.bin kernel.bin

all: build run

build: $(OBJECTS)
	dd if=/dev/zero of=$(IMG) bs=512 count=2880 status=none
	dd if=boot.bin of=$(IMG) conv=notrunc status=none
	dd if=initrix.bin of=$(IMG) seek=2 conv=notrunc status=none
	dd if=kernel.bin of=$(IMG) seek=4 conv=notrunc status=none
	@echo "Build complete: $(IMG)"

%.bin: %.asm
	$(NASM) -f bin $< -o $@

run:
	$(QEMU) -fda $(IMG)

clean:
	rm -f $(OBJECTS) $(IMG)

.PHONY: all build run clean