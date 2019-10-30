use x86::bits64::paging::VAddr;

#[repr(C)]
#[repr(packed)]
struct IdtInfo {
    limit: u16,
    base_addr: u64,
}

pub struct IdtrBase;
impl IdtrBase {
    pub fn read() -> VAddr {
        let addr = unsafe {
            let mut info = IdtInfo {
                limit: 0,
                base_addr: 0,
            };
            asm!("sidt ($0)"
                 :
                 : "r"(&mut info)
                 : "memory"
                 : "volatile");
            info.base_addr
        };
        VAddr::from_u64(addr)
    }
}

#[repr(C)]
#[repr(packed)]
struct GdtInfo {
    size: u16,
    offset: u64,
}

pub struct GdtrBase;
impl GdtrBase {
    pub fn read() -> VAddr {
        let addr = unsafe {
            let mut info = GdtInfo { size: 0, offset: 0 };
            asm!("sgdtq ($0)"
                 :
                 : "r"(&mut info)
                 : "memory"
                 : "volatile");
            info.offset
        };
        VAddr::new(addr)
    }
}

pub struct Cr4;
impl Cr4 {
    //TODO: this should return a Cr4Flags
    pub fn read() -> u64 {
        let mut current_cr4: u64;
        unsafe {
            asm!("movq %cr4, %rax;"
                 : "={rax}"(current_cr4)
                 ::: "volatile");
        }
        current_cr4
    }
}
