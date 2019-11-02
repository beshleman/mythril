#[lang = "eh_personality"] extern fn eh_personality() {}

use core::panic::PanicInfo;

#[panic_handler]
fn panic(_info: &PanicInfo) -> ! {
    loop {}
}

#[no_mangle]
pub extern fn start_mythril() -> () {
  
  // Do stuff here
  loop {}

}
