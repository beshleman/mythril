#!/bin/bash

set -e

aarch64-linux-gnu-gcc -I src/arm64/ -o src/arm64/head.elf   \
    src/arm64/head.S                                          \
    -g                                                          \
    -T src/arm64/linker.ld                                    \
    -Werror -Wredundant-decls -Wno-pointer-arith -nostdinc      \
    -nostdlib -fno-builtin -fno-common -ffreestanding -fpic


aarch64-linux-gnu-objcopy -O binary -S src/arm64/head.elf src/arm64/head.bin

sudo cp src/arm64/head.elf /mnt/head.elf
sudo cp src/arm64/head.bin /mnt/head.bin

set +e
killall -q -s 9 $(which qemu-system-aarch64)
set -e

qemu-system-aarch64 -M virt -cpu cortex-a57 -nographic -smp 1 -bios ../u-boot/u-boot.bin \
    -drive if=none,id=hd0,file=../disk.img \
    -device virtio-blk-device,drive=hd0 -S -s

