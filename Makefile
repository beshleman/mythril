TARGET_SHORT = arm64
TARGET := aarch64-unknown-linux-gnu
LINKER := linkers/arm64.ld
LD := aarch64-linux-gnu-ld
CC := aarch64-linux-gnu-gcc
BUILD_DIR := build/arm64

all: $(BUILD_DIR)
.PHONY: $(BUILD_DIR) all clean

CFLAGS=-Werror -Wredundant-decls -Wno-pointer-arith -nostdinc      \
	    -nostdlib -fno-builtin -fno-common -ffreestanding -fpic
RUSTC_ARGS := -C link-arg=-nostartfiles -C linker=$(LD) -C link-arg=-T$(LINKER) -C link-args=-export-dynamic
RUST_OBJ = $(BUILD_DIR)/rust-entry.a


# Because head jumps to the start_mythril in Rust,
# make sure that the RUST_OBJ is linked _after_ head
OBJS := $(BUILD_DIR)/head.o $(RUST_OBJ) 

LDFLAGS := 


all: $(BUILD_DIR)/mythril-arm64

$(BUILD_DIR)/mythril-arm64: linkers/arm64.ld $(OBJS)
	$(CC) -o $@ $(OBJS) -T linkers/arm64.ld $(CFLAGS)

$(RUST_OBJ): linkers/arm64.ld src/lib.rs src/arm64/mod.rs
	cargo rustc --target $(TARGET) -- $(RUSTC_ARGS) --emit link=$@

$(BUILD_DIR)/head.o: src/arm64/head.S
	$(CC) -I src/arm64/ -o $@ -c $< $(CFLAGS)

$(BUILD_DIR):
	mkdir -p $(BUILD_DIR)

clean:
	cargo clean
	rm -fR build/
