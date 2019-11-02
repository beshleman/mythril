# mythril

A rust-based hypervisor currently requiring EFI boot, and VT-x/EPT.

## Testing

- Clone this repository
- `cd` in to the directory
- Build EFI application with `docker run -it -v $(pwd):/src adamschwalm/hypervisor-build:docker-2 cargo +nightly xbuild --target x86_64-unknown-uefi`
- Boot the application with `sudo ./scripts/uefi-run.sh target/x86_64-unknown-uefi/debug/mythril.efi`

## U-Boot

load virtio 0 0x40100000 /head.bin                                                         
go 0x40100040

