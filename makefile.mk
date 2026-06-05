# SolarOS Makefile - Hybrid ASM + Rust build system

NASM = nasm
LD = ld
QEMU = qemu-system-x86_64
CARGO = cargo


BOOT_DIR = boot
KERNEL_DIR = kernel
DISK_DIR = disk
DRIVERS_DIR = drivers
GUI_DIR = gui
LIB_DIR = lib
APPS_DIR = apps
RUST_DIR = rust
BUILD_DIR = build


ASM_FLAGS = -f elf32
LD_FLAGS = -m elf_i386 -T link.ld
QEMU_FLAGS = -drive file=$(BUILD_DIR)/solaros.img,format=raw,if=floppy


.PHONY: all clean build_asm build_rust link build_img run

all: build_asm build_rust link build_img


$(BUILD_DIR):
	mkdir -p $(BUILD_DIR)

build_asm: $(BUILD_DIR)
	$(NASM) $(ASM_FLAGS) $(BOOT_DIR)/boot.asm -o $(BUILD_DIR)/boot.o
	$(NASM) $(ASM_FLAGS) $(BOOT_DIR)/initrix.asm -o $(BUILD_DIR)/initrix.o
	$(NASM) $(ASM_FLAGS) $(KERNEL_DIR)/kernel.asm -o $(BUILD_DIR)/kernel.o
	$(NASM) $(ASM_FLAGS) $(DISK_DIR)/disk_params.asm -o $(BUILD_DIR)/disk_params.o
	$(NASM) $(ASM_FLAGS) $(DISK_DIR)/fat12.asm -o $(BUILD_DIR)/fat12.o
	$(NASM) $(ASM_FLAGS) $(DISK_DIR)/read.asm -o $(BUILD_DIR)/read.o
	$(NASM) $(ASM_FLAGS) $(DRIVERS_DIR)/mouse.asm -o $(BUILD_DIR)/mouse.o
	$(NASM) $(ASM_FLAGS) $(DRIVERS_DIR)/vga.asm -o $(BUILD_DIR)/vga.o
	$(NASM) $(ASM_FLAGS) $(DRIVERS_DIR)/font.asm -o $(BUILD_DIR)/font.o
	$(NASM) $(ASM_FLAGS) $(GUI_DIR)/cursor.asm -o $(BUILD_DIR)/cursor.o
	$(NASM) $(ASM_FLAGS) $(GUI_DIR)/desktop.asm -o $(BUILD_DIR)/desktop.o
	$(NASM) $(ASM_FLAGS) $(GUI_DIR)/draw.asm -o $(BUILD_DIR)/draw.o
	$(NASM) $(ASM_FLAGS) $(GUI_DIR)/events.asm -o $(BUILD_DIR)/events.o
	$(NASM) $(ASM_FLAGS) $(GUI_DIR)/icons.asm -o $(BUILD_DIR)/icons.o
	$(NASM) $(ASM_FLAGS) $(GUI_DIR)/start_menu.asm -o $(BUILD_DIR)/start_menu.o
	$(NASM) $(ASM_FLAGS) $(GUI_DIR)/taskbar.asm -o $(BUILD_DIR)/taskbar.o
	$(NASM) $(ASM_FLAGS) $(GUI_DIR)/window.asm -o $(BUILD_DIR)/window.o
	$(NASM) $(ASM_FLAGS) $(LIB_DIR)/math.asm -o $(BUILD_DIR)/math.o
	$(NASM) $(ASM_FLAGS) $(LIB_DIR)/string.asm -o $(BUILD_DIR)/string.o
	$(NASM) $(ASM_FLAGS) $(APPS_DIR)/about.asm -o $(BUILD_DIR)/about.o
	$(NASM) $(ASM_FLAGS) $(APPS_DIR)/calc.asm -o $(BUILD_DIR)/calc.o
	$(NASM) $(ASM_FLAGS) $(APPS_DIR)/cmd.asm -o $(BUILD_DIR)/cmd.o

build_rust:
	cd $(RUST_DIR) && $(CARGO) build --release --target i686-unknown-linux-gnu
	cp $(RUST_DIR)/target/i686-unknown-linux-gnu/release/libsolaros_rust.a $(BUILD_DIR)/

link: $(BUILD_DIR)
	$(LD) $(LD_FLAGS) -o $(BUILD_DIR)/solaros.bin \
		$(BUILD_DIR)/boot.o \
		$(BUILD_DIR)/initrix.o \
		$(BUILD_DIR)/kernel.o \
		$(BUILD_DIR)/disk_params.o \
		$(BUILD_DIR)/fat12.o \
		$(BUILD_DIR)/read.o \
		$(BUILD_DIR)/mouse.o \
		$(BUILD_DIR)/vga.o \
		$(BUILD_DIR)/font.o \
		$(BUILD_DIR)/cursor.o \
		$(BUILD_DIR)/desktop.o \
		$(BUILD_DIR)/draw.o \
		$(BUILD_DIR)/events.o \
		$(BUILD_DIR)/icons.o \
		$(BUILD_DIR)/start_menu.o \
		$(BUILD_DIR)/taskbar.o \
		$(BUILD_DIR)/window.o \
		$(BUILD_DIR)/math.o \
		$(BUILD_DIR)/string.o \
		$(BUILD_DIR)/about.o \
		$(BUILD_DIR)/calc.o \
		$(BUILD_DIR)/cmd.o \
		$(BUILD_DIR)/libsolaros_rust.a
	objcopy -O binary $(BUILD_DIR)/solaros.bin $(BUILD_DIR)/solaros.bin

# Создание загрузочного образа
build_img: $(BUILD_DIR)
	dd if=/dev/zero of=$(BUILD_DIR)/solaros.img bs=512 count=2880 status=none
	dd if=$(BUILD_DIR)/solaros.bin of=$(BUILD_DIR)/solaros.img conv=notrunc status=none
	@echo "Build complete: $(BUILD_DIR)/solaros.img"

run: build_img
	$(QEMU) $(QEMU_FLAGS)

clean:
	rm -rf $(BUILD_DIR)
	cd $(RUST_DIR) && $(CARGO) clean
