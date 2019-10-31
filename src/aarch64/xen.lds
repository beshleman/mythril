ENTRY(start)
OUTPUT_ARCH(aarch64)
PHDRS
{
  text PT_LOAD ;
}
SECTIONS
{
  . = 0x00200000;
  _start = .;
  .text : {
        _stext = .;
       *(.text)
       *(.text.cold)
       *(.text.unlikely)
       *(.fixup)
       *(.gnu.warning)
       _etext = .;
  } :text = 0x9090
  . = ALIGN(((1) << 12));
  .rodata : {
        _srodata = .;
       __start_bug_frames = .;
       *(.bug_frames.0)
       __stop_bug_frames_0 = .;
       *(.bug_frames.1)
       __stop_bug_frames_1 = .;
       *(.bug_frames.2)
       __stop_bug_frames_2 = .;
       *(.rodata)
       *(.rodata.*)
       *(.data.rel.ro)
       *(.data.rel.ro.*)
       . = ALIGN((1 << 2));
       __param_start = .;
       *(.data.param)
       __param_end = .;
       __proc_info_start = .;
       *(.proc.info)
       __proc_info_end = .;
  } :text
  _erodata = .;
  .data : {
       . = ALIGN(((1) << 12));
       *(.data.page_aligned)
       *(.data)
       . = ALIGN(8);
       __start_schedulers_array = .;
       *(.data.schedulers)
       __end_schedulers_array = .;
       *(.data.rel)
       *(.data.rel.*)
       CONSTRUCTORS
  } :text
    /* ARM_L1_CACHE_SHIFT from Xen */
  . = ALIGN(1 << 7);
  .data.read_mostly : {
       __start___ex_table = .;
       *(.ex_table)
       __stop___ex_table = .;
       __start___pre_ex_table = .;
       *(.ex_table.pre)
       __stop___pre_ex_table = .;
       *(.data.read_mostly)
  } :text
  . = ALIGN(8);
  .arch.info : {
      _splatform = .;
      *(.arch.info)
      _eplatform = .;
  } :text
  . = ALIGN(8);
  .dev.info : {
      _sdevice = .;
      *(.dev.info)
      _edevice = .;
  } :text
  . = ALIGN(8);
  .adev.info : {
      _asdevice = .;
      *(.adev.info)
      _aedevice = .;
  } :text
  . = ALIGN(8);
  .teemediator.info : {
      _steemediator = .;
      *(.teemediator.info)
      _eteemediator = .;
  } :text
  . = ALIGN(((1) << 12));
  __init_begin = .;
  .init.text : {
       _sinittext = .;
       *(.init.text)
       _einittext = .;
  } :text
  . = ALIGN(((1) << 12));
  .init.data : {
       *(.init.rodata)
       *(.init.rodata.*)
       . = ALIGN((1 << 2));
       __setup_start = .;
       *(.init.setup)
       __setup_end = .;
       __initcall_start = .;
       *(.initcallpresmp.init)
       __presmp_initcall_end = .;
       *(.initcall1.init)
       __initcall_end = .;
       . = ALIGN(4);
       __alt_instructions = .;
       *(.altinstructions)
       __alt_instructions_end = .;
       . = ALIGN(4);
       *(.altinstr_replacement)
       *(.init.data)
       *(.init.data.rel)
       *(.init.data.rel.*)
       . = ALIGN(8);
       __ctors_start = .;
       *(.ctors)
       *(.init_array)
       *(SORT(.init_array.*))
       __ctors_end = .;
  } :text
  __init_end_efi = .;
  . = ALIGN((((1) << 12) << 3));
  __init_end = .;
  .bss : {
       __bss_start = .;
       *(.bss.stack_aligned)
       . = ALIGN(((1) << 12));
       *(.bss.page_aligned)
       . = ALIGN(((1) << 12));
       __per_cpu_start = .;
       *(.bss.percpu.page_aligned)
       *(.bss.percpu)
        /* ARM_L1_CACHE_SHIFT from Xen */
      . = ALIGN(1 << 7);
       *(.bss.percpu.read_mostly)
        /* ARM_L1_CACHE_SHIFT from Xen */
      . = ALIGN(1 << 7);
       __per_cpu_data_end = .;
       *(.bss)
       . = ALIGN((1 << 2));
       __bss_end = .;
  } :text
  _end = . ;
  /DISCARD/ : {
       *(.exit.text)
       *(.exit.data)
       *(.exitcall.exit)
       *(.eh_frame)
  }
  .stab 0 : { *(.stab) }
  .stabstr 0 : { *(.stabstr) }
  .stab.excl 0 : { *(.stab.excl) }
  .stab.exclstr 0 : { *(.stab.exclstr) }
  .stab.index 0 : { *(.stab.index) }
  .stab.indexstr 0 : { *(.stab.indexstr) }
  .comment 0 : { *(.comment) }
}
ASSERT( _end_boot - start <= ((1) << 12), "Boot code is larger than 4K")
