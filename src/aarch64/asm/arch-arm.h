/******************************************************************************
 * arch-arm.h
 *
 * Guest OS interface to ARM Xen.
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to
 * deal in the Software without restriction, including without limitation the
 * rights to use, copy, modify, merge, publish, distribute, sublicense, and/or
 * sell copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
 * FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
 * DEALINGS IN THE SOFTWARE.
 *
 * Copyright 2011 (C) Citrix Systems
 */

#ifndef __XEN_PUBLIC_ARCH_ARM_H__
#define __XEN_PUBLIC_ARCH_ARM_H__

/* PSR bits (CPSR, SPSR) */

#define PSR_THUMB       (1<<5)        /* Thumb Mode enable */
#define PSR_FIQ_MASK    (1<<6)        /* Fast Interrupt mask */
#define PSR_IRQ_MASK    (1<<7)        /* Interrupt mask */
#define PSR_ABT_MASK    (1<<8)        /* Asynchronous Abort mask */
#define PSR_BIG_ENDIAN  (1<<9)        /* arm32: Big Endian Mode */
#define PSR_DBG_MASK    (1<<9)        /* arm64: Debug Exception mask */
#define PSR_IT_MASK     (0x0600fc00)  /* Thumb If-Then Mask */
#define PSR_JAZELLE     (1<<24)       /* Jazelle Mode */

/* 32 bit modes */
#define PSR_MODE_USR 0x10
#define PSR_MODE_FIQ 0x11
#define PSR_MODE_IRQ 0x12
#define PSR_MODE_SVC 0x13
#define PSR_MODE_MON 0x16
#define PSR_MODE_ABT 0x17
#define PSR_MODE_HYP 0x1a
#define PSR_MODE_UND 0x1b
#define PSR_MODE_SYS 0x1f

/* 64 bit modes */
#define PSR_MODE_BIT  0x10 /* Set iff AArch32 */
#define PSR_MODE_EL3h 0x0d
#define PSR_MODE_EL3t 0x0c
#define PSR_MODE_EL2h 0x09
#define PSR_MODE_EL2t 0x08
#define PSR_MODE_EL1h 0x05
#define PSR_MODE_EL1t 0x04
#define PSR_MODE_EL0t 0x00

#define PSR_GUEST32_INIT  (PSR_ABT_MASK|PSR_FIQ_MASK|PSR_IRQ_MASK|PSR_MODE_SVC)
#define PSR_GUEST64_INIT (PSR_ABT_MASK|PSR_FIQ_MASK|PSR_IRQ_MASK|PSR_MODE_EL1h)

#define SCTLR_GUEST_INIT    xen_mk_ullong(0x00c50078)

/*
 * Virtual machine platform (memory layout, interrupts)
 *
 * These are defined for consistency between the tools and the
 * hypervisor. Guests must not rely on these hardcoded values but
 * should instead use the FDT.
 */

/* Physical Address Space */

/*
 * vGIC mappings: Only one set of mapping is used by the guest.
 * Therefore they can overlap.
 */

/* vGIC v2 mappings */
#define GUEST_GICD_BASE   xen_mk_ullong(0x03001000)
#define GUEST_GICD_SIZE   xen_mk_ullong(0x00001000)
#define GUEST_GICC_BASE   xen_mk_ullong(0x03002000)
#define GUEST_GICC_SIZE   xen_mk_ullong(0x00002000)

/* vGIC v3 mappings */
#define GUEST_GICV3_GICD_BASE      xen_mk_ullong(0x03001000)
#define GUEST_GICV3_GICD_SIZE      xen_mk_ullong(0x00010000)

#define GUEST_GICV3_RDIST_REGIONS  1

#define GUEST_GICV3_GICR0_BASE     xen_mk_ullong(0x03020000) /* vCPU0..127 */
#define GUEST_GICV3_GICR0_SIZE     xen_mk_ullong(0x01000000)

/* ACPI tables physical address */
#define GUEST_ACPI_BASE xen_mk_ullong(0x20000000)
#define GUEST_ACPI_SIZE xen_mk_ullong(0x02000000)

/* PL011 mappings */
#define GUEST_PL011_BASE    xen_mk_ullong(0x22000000)
#define GUEST_PL011_SIZE    xen_mk_ullong(0x00001000)

/*
 * 16MB == 4096 pages reserved for guest to use as a region to map its
 * grant table in.
 */
#define GUEST_GNTTAB_BASE xen_mk_ullong(0x38000000)
#define GUEST_GNTTAB_SIZE xen_mk_ullong(0x01000000)

#define GUEST_MAGIC_BASE  xen_mk_ullong(0x39000000)
#define GUEST_MAGIC_SIZE  xen_mk_ullong(0x01000000)

#define GUEST_RAM_BANKS   2

#define GUEST_RAM0_BASE   xen_mk_ullong(0x40000000) /* 3GB of low RAM @ 1GB */
#define GUEST_RAM0_SIZE   xen_mk_ullong(0xc0000000)

#define GUEST_RAM1_BASE   xen_mk_ullong(0x0200000000) /* 1016GB of RAM @ 8GB */
#define GUEST_RAM1_SIZE   xen_mk_ullong(0xfe00000000)

#define GUEST_RAM_BASE    GUEST_RAM0_BASE /* Lowest RAM address */
/* Largest amount of actual RAM, not including holes */
#define GUEST_RAM_MAX     (GUEST_RAM0_SIZE + GUEST_RAM1_SIZE)
/* Suitable for e.g. const uint64_t ramfoo[] = GUEST_RAM_BANK_FOOS; */
#define GUEST_RAM_BANK_BASES   { GUEST_RAM0_BASE, GUEST_RAM1_BASE }
#define GUEST_RAM_BANK_SIZES   { GUEST_RAM0_SIZE, GUEST_RAM1_SIZE }

/* Current supported guest VCPUs */
#define GUEST_MAX_VCPUS 128

/* Interrupts */
#define GUEST_TIMER_VIRT_PPI    27
#define GUEST_TIMER_PHYS_S_PPI  29
#define GUEST_TIMER_PHYS_NS_PPI 30
#define GUEST_EVTCHN_PPI        31

#define GUEST_VPL011_SPI        32

/* PSCI functions */
#define PSCI_cpu_suspend 0
#define PSCI_cpu_off     1
#define PSCI_cpu_on      2
#define PSCI_migrate     3

#endif /*  __XEN_PUBLIC_ARCH_ARM_H__ */

/*
 * Local variables:
 * mode: C
 * c-file-style: "BSD"
 * c-basic-offset: 4
 * tab-width: 4
 * indent-tabs-mode: nil
 * End:
 */
