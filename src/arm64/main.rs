#![no_std]
#![no_main]
#![crate_type="staticlib"]
#![feature(lang_items)]

#[lang = "eh_personality"] extern fn eh_personality() {}

use core::panic::PanicInfo;

#[panic_handler]
fn panic(_info: &PanicInfo) -> ! {
    loop {}
}

#[no_mangle]
pub fn main() -> () {
  
  // Do stuff here
  loop {}

}

#[no_mangle]
pub extern "C" fn _start() -> ! {
    loop {}
}
