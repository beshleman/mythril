#!/bin/bash


MEM_START=0x40000000
MEM_END=0x48000000
LOAD_ADDR=0x40100000

aarch64-linux-gnu-gcc -I src/aarch64/ -I src/aarch64/asm/ -o src/aarch64/head.elf src/aarch64/head.S \
    -g \
    -DCONFIG_ARM_64 -D__ASSEMBLY__ -Werror -Wredundant-decls -Wno-pointer-arith -nostdinc \
    -nostdlib -fno-builtin -fno-common -ffreestanding -T src/aarch64/xen.lds

aarch64-linux-gnu-objcopy -O binary -S src/aarch64/head.elf src/aarch64/head.bin

qemu-system-aarch64 -M virt -cpu cortex-a57 -nographic -smp 1 -bios ../u-boot/u-boot.bin \
    -drive if=none,id=hd0,file=disk.img \
    -device virtio-blk-device,drive=hd0 -S -s

