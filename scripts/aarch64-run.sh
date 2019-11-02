#!/bin/bash

set -e

aarch64-linux-gnu-gcc -I src/aarch64/ -o src/aarch64/head.elf   \
    src/aarch64/head.S                                          \
    -g                                                          \
    -T src/aarch64/linker.ld                                    \
    -Werror -Wredundant-decls -Wno-pointer-arith -nostdinc      \
    -nostdlib -fno-builtin -fno-common -ffreestanding -fpic


aarch64-linux-gnu-objcopy -O binary -S src/aarch64/head.elf src/aarch64/head.bin

sudo cp src/aarch64/head.elf /mnt/head.elf
sudo cp src/aarch64/head.bin /mnt/head.bin

set +e
killall -q -s 9 $(which qemu-system-aarch64)
set -e

qemu-system-aarch64 -M virt -cpu cortex-a57 -nographic -smp 1 -bios ../u-boot/u-boot.bin \
    -drive if=none,id=hd0,file=../disk.img \
    -device virtio-blk-device,drive=hd0 -S -s

