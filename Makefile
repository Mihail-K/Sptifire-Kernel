
# CC - Cross Compiler
CC = i686-elf-gcc
AS = i686-elf-as

# XINC - Cross Include
# Cross Compiler Flags
CFLAGS  = -Wall -Werror -Wextra \
	-ffreestanding -std=c11 -O2
LDFLAGS = -T linker.ld -nostdlib \
	-ffreestanding -O2 -o
LDLIBS  = -lgcc

# Intermediate Files
objects =			\
	kstart.o		\
	kmain.o			\
	kernel.o		\
	kscreen.o		\
	kprintf.o		\
	kgdt.o			\
	kidt.o			\
	kisrs.o

# Output files
bin     = ./bin
kernel  = $(bin)/kernel.bin
image   = $(bin)/kernel.iso

all: $(image) $(kernel) $(objects)

.PHONY: clean
clean:
	rm -rf $(objects) $(kernel) tmp

$(image): $(kernel)
	mkdir -p tmp/boot/grub
	cp $(kernel) tmp/boot/kernel.bin
	cp grub.cfg.template tmp/boot/grub/grub.cfg
	grub-mkrescue -o $(image) tmp
	rm -r tmp

$(kernel): $(objects)
	$(CC) $(LDFLAGS) $@ $^ $(LDLIBS)

%.o: %.asm
	$(AS) $< -o $@
