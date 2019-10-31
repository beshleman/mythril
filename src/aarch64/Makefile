CC = aarch64-linux-gnu-gcc 

INCLUDE =  -I . -I ./asm

xen.lds: xen.lds.S
	$(CC) -P -E -Ui386 -o $@ $< $(INCLUDE)
	sed -e 's/xen\.lds\.o:/xen\.lds:/g' <.xen.lds.d >.xen.lds.d.new
	mv -f .xen.lds.d.new .xen.lds.d
