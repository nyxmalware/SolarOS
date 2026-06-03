NASM = nasm
QEMU = qemu-system-x86_64
IMG = solaros.img

all: build_img

build_img:
	$(NASM) -f bin boot.asm -o boot.bin
	$(NASM) -f bin initrix.asm -o initrix.bin
	$(NASM) -f bin kernel.asm -o kernel.bin
	dd if=/dev/zero of=$(IMG) bs=512 count=2880 status=none
	dd if=boot.bin of=$(IMG) conv=notrunc status=none
	dd if=initrix.bin of=$(IMG) seek=2 conv=notrunc status=none
	dd if=kernel.bin of=$(IMG) seek=4 conv=notrunc status=none
	@echo "Build complete: $(IMG)"

run:
	$(QEMU) -fda $(IMG)

clean:
	rm -f boot.bin initrix.bin kernel.bin $(IMG)

.PHONY: all build_img run clean
