#!/bin/bash

aarch64-linux-gnu-gcc -I src/aarch64/ -I src/aarch64/asm/ -o src/aarch64/head.o src/aarch64/head.S -DCONFIG_ARM_64 -D__ASSEMBLY__ -Werror -Wredundant-decls -Wno-pointer-arith -nostdinc -nostdlib -fno-builtin -fno-common -ffreestanding -T src/aarch64/xen.lds
