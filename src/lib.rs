#![no_std]
#![crate_type="staticlib"]
#![feature(lang_items)]

#[cfg(target_arch = "x86_64")]
#[macro_use]
pub mod x86_64;
#[cfg(target_arch = "x86_64")]
pub use self::x86_64::*;

#[cfg(target_arch = "aarch64")]
#[macro_use]
pub mod arm64;
#[cfg(target_arch = "aarch64")]
pub use self::arm64::*;


/*
#[lang = "eh_personality"] extern fn eh_personality() {}

use core::panic::PanicInfo;

#[panic_handler]
fn panic(_info: &PanicInfo) -> ! {
    loop {}
}

*/
