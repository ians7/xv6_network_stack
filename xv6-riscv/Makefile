K=src/kernel
U=src/user
LAB=0

OBJS = \
  $K/entry.o \
  $K/start.o \
  $K/console.o \
  $K/printf.o \
  $K/uart.o \
  $K/kalloc.o \
  $K/spinlock.o \
  $K/string.o \
  $K/main.o \
  $K/vm.o \
  $K/proc.o \
  $K/swtch.o \
  $K/trampoline.o \
  $K/trap.o \
  $K/syscall.o \
  $K/sysproc.o \
  $K/bio.o \
  $K/fs.o \
  $K/log.o \
  $K/sleeplock.o \
  $K/file.o \
  $K/pipe.o \
  $K/exec.o \
  $K/sysfile.o \
  $K/kernelvec.o \
  $K/plic.o \
  $K/virtio_disk.o \
  $K/virtio_net.o \
  $K/sys/ip4.o \
  $K/sys/net.o \
  $K/sys/socket.o \
  $K/sys/eth.o \
  $K/sys/tcp.o \
  $K/sys/udp.o \
  $K/sys/arp.o \
  

# riscv64-unknown-elf- or riscv64-linux-gnu-
# perhaps in /opt/riscv/bin
# TOOLPREFIX=riscv32-unknown-elf-

# Try to infer the correct TOOLPREFIX if not set
ifndef TOOLPREFIX
TOOLPREFIX := $(shell if riscv64-unknown-elf-objdump -i 2>&1 | grep 'elf64-big' >/dev/null 2>&1; \
	then echo 'riscv64-unknown-elf-'; \
	elif riscv64-linux-gnu-objdump -i 2>&1 | grep 'elf64-big' >/dev/null 2>&1; \
	then echo 'riscv64-linux-gnu-'; \
	elif riscv64-unknown-linux-gnu-objdump -i 2>&1 | grep 'elf64-big' >/dev/null 2>&1; \
	then echo 'riscv64-unknown-linux-gnu-'; \
	else echo "***" 1>&2; \
	echo "*** Error: Couldn't find a riscv64 version of GCC/binutils." 1>&2; \
	echo "*** To turn off this error, run 'gmake TOOLPREFIX= ...'." 1>&2; \
	echo "***" 1>&2; exit 1; fi)
endif

QEMU = qemu-system-riscv64

CC = $(TOOLPREFIX)gcc
AS = $(TOOLPREFIX)gas
LD = $(TOOLPREFIX)ld
OBJCOPY = $(TOOLPREFIX)objcopy
OBJDUMP = $(TOOLPREFIX)objdump

CFLAGS = -Werror -O -fno-omit-frame-pointer -ggdb -gdwarf-2
CFLAGS += -MD
CFLAGS += -mcmodel=medany
CFLAGS += -ffreestanding -fno-common -nostdlib -mno-relax
CFLAGS += -I. -Isrc
CFLAGS += $(shell $(CC) -fno-stack-protector -E -x c /dev/null >/dev/null 2>&1 && echo -fno-stack-protector)

# Disable PIE when possible (for Ubuntu 16.10 toolchain)
ifneq ($(shell $(CC) -dumpspecs 2>/dev/null | grep -e '[^f]no-pie'),)
CFLAGS += -fno-pie -no-pie
endif
ifneq ($(shell $(CC) -dumpspecs 2>/dev/null | grep -e '[^f]nopie'),)
CFLAGS += -fno-pie -nopie
endif

LDFLAGS = -z max-page-size=4096

$K/kernel: $(OBJS) $K/kernel.ld $U/initcode
	$(LD) $(LDFLAGS) -T $K/kernel.ld -o $K/kernel $(OBJS) 
	$(OBJDUMP) -S $K/kernel > $K/kernel.asm
	$(OBJDUMP) -t $K/kernel | sed '1,/SYMBOL TABLE/d; s/ .* / /; /^$$/d' > $K/kernel.sym

$U/initcode: $U/initcode.S
	$(CC) $(CFLAGS) -march=rv64g -nostdinc -I. -Isrc/kernel -c $U/initcode.S -o $U/initcode.o
	$(LD) $(LDFLAGS) -N -e start -Ttext 0 -o $U/initcode.out $U/initcode.o
	$(OBJCOPY) -S -O binary $U/initcode.out $U/initcode
	$(OBJDUMP) -S $U/initcode.o > $U/initcode.asm

tags: $(OBJS) _init
	etags *.S *.c

ULIB = $U/ulib.o $U/usys.o $U/printf.o $U/umalloc.o $U/ithreads.o

_%: %.o $(ULIB)
	$(LD) $(LDFLAGS) -T $U/user.ld -o $@ $^
	$(OBJDUMP) -S $@ > $*.asm
	$(OBJDUMP) -t $@ | sed '1,/SYMBOL TABLE/d; s/ .* / /; /^$$/d' > $*.sym

$U/usys.S : $U/usys.pl
	perl $U/usys.pl > $U/usys.S

$U/usys.o : $U/usys.S
	$(CC) $(CFLAGS) -c -o $U/usys.o $U/usys.S

$U/_forktest: $U/forktest.o $(ULIB)
	# forktest has less library code linked in - needs to be small
	# in order to be able to max out the proc table.
	$(LD) $(LDFLAGS) -N -e main -Ttext 0 -o $U/_forktest $U/forktest.o $U/ulib.o $U/usys.o
	$(OBJDUMP) -S $U/_forktest > $U/forktest.asm

src/mkfs/mkfs: src/mkfs/mkfs.c $K/fs.h $K/param.h
	gcc -Werror -Wall -I. -Isrc -o src/mkfs/mkfs src/mkfs/mkfs.c

# Prevent deletion of intermediate files, e.g. cat.o, after first build, so
# that disk image changes after first build are persistent until clean.  More
# details:
# http://www.gnu.org/software/make/manual/html_node/Chained-Rules.html
.PRECIOUS: %.o

UPROGS=\
	$U/_cat\
	$U/_echo\
	$U/_forktest\
	$U/_grep\
	$U/_init\
	$U/_kill\
	$U/_ln\
	$U/_ls\
	$U/_mkdir\
	$U/_rm\
	$U/_sh\
	$U/_stressfs\
	$U/_usertests\
	$U/_grind\
	$U/_wc\
	$U/_debug\
	$U/_zombie\
	$U/_xv6test\
	$U/_net_test\
	$U/_chat\
	# $U/_launch_udp_server\


fs.img: src/mkfs/mkfs README $(UPROGS)
	src/mkfs/mkfs fs.img README $(UPROGS)

-include src/kernel/*.d src/user/*.d

clean:
	rm -f *.tex *.dvi *.idx *.aux *.log *.ind *.ilg \
	*/*.o */*.d */*.asm */*.sym \
	src/*/*.o src/*/*.d src/*/*.asm src/*/*.sym \
	$U/initcode $U/initcode.out $K/kernel fs.img \
	$K/kernel-server $K/kernel-server.asm $K/kernel-server.sym \
	$K/kernel-client $K/kernel-client.asm $K/kernel-client.sym \
	$K/sys/net_server.o $K/sys/net_client.o \
	fs-server.img fs-client.img \
	src/mkfs/mkfs .gdbinit \
        $U/usys.S \
	$(UPROGS)

##
## Per-IP client/server builds
##

VM_IP_SERVER ?= 0x0b000a0a
VM_IP_CLIENT ?= 0x0a000a0a

# Compile net.o twice with different IP addresses
$K/sys/net_server.o: $K/sys/net.c
	$(CC) $(CFLAGS) -DVM_IP=$(VM_IP_SERVER) -c -o $@ $<

$K/sys/net_client.o: $K/sys/net.c
	$(CC) $(CFLAGS) -DVM_IP=$(VM_IP_CLIENT) -c -o $@ $<

SERVER_OBJS = $(patsubst $K/sys/net.o,$K/sys/net_server.o,$(OBJS))
CLIENT_OBJS = $(patsubst $K/sys/net.o,$K/sys/net_client.o,$(OBJS))

$K/kernel-server: $(SERVER_OBJS) $K/kernel.ld $U/initcode
	$(LD) $(LDFLAGS) -T $K/kernel.ld -o $K/kernel-server $(SERVER_OBJS)
	$(OBJDUMP) -S $K/kernel-server > $K/kernel-server.asm
	$(OBJDUMP) -t $K/kernel-server | sed '1,/SYMBOL TABLE/d; s/ .* / /; /^$$/d' > $K/kernel-server.sym

$K/kernel-client: $(CLIENT_OBJS) $K/kernel.ld $U/initcode
	$(LD) $(LDFLAGS) -T $K/kernel.ld -o $K/kernel-client $(CLIENT_OBJS)
	$(OBJDUMP) -S $K/kernel-client > $K/kernel-client.asm
	$(OBJDUMP) -t $K/kernel-client | sed '1,/SYMBOL TABLE/d; s/ .* / /; /^$$/d' > $K/kernel-client.sym

# Separate disk images so QEMU file locks don't conflict
fs-server.img: src/mkfs/mkfs README $(UPROGS)
	src/mkfs/mkfs fs-server.img README $(UPROGS)

fs-client.img: src/mkfs/mkfs README $(UPROGS)
	src/mkfs/mkfs fs-client.img README $(UPROGS)

QEMUOPTS_SERVER = -machine virt -bios none -kernel $K/kernel-server -m 128M -smp $(CPUS) -nographic
QEMUOPTS_SERVER += -global virtio-mmio.force-legacy=false
QEMUOPTS_SERVER += -drive file=fs-server.img,if=none,format=raw,id=x0
QEMUOPTS_SERVER += -device virtio-blk-device,drive=x0,bus=virtio-mmio-bus.0
QEMUOPTS_SERVER += -netdev tap,id=net0,ifname=tap0,script=no,downscript=no
QEMUOPTS_SERVER += -device virtio-net-device,netdev=net0,bus=virtio-mmio-bus.1,mac=52:54:00:00:00:01

QEMUOPTS_CLIENT = -machine virt -bios none -kernel $K/kernel-client -m 128M -smp $(CPUS) -nographic
QEMUOPTS_CLIENT += -global virtio-mmio.force-legacy=false
QEMUOPTS_CLIENT += -drive file=fs-client.img,if=none,format=raw,id=x0
QEMUOPTS_CLIENT += -device virtio-blk-device,drive=x0,bus=virtio-mmio-bus.0
QEMUOPTS_CLIENT += -netdev tap,id=net0,ifname=tap1,script=no,downscript=no
QEMUOPTS_CLIENT += -device virtio-net-device,netdev=net0,bus=virtio-mmio-bus.1,mac=52:54:00:00:00:02

qemu-server: $K/kernel-server fs-server.img
	$(QEMU) $(QEMUOPTS_SERVER)

qemu-client: $K/kernel-client fs-client.img
	$(QEMU) $(QEMUOPTS_CLIENT)

# try to generate a unique GDB port
GDBPORT = $(shell expr `id -u` % 5000 + 25000)
# QEMU's gdb stub command line changed in 0.11
QEMUGDB = $(shell if $(QEMU) -help | grep -q '^-gdb'; \
	then echo "-gdb tcp::$(GDBPORT)"; \
	else echo "-s -p $(GDBPORT)"; fi)
ifndef CPUS
CPUS := 3
endif

QEMUOPTS = -machine virt -bios none -kernel $K/kernel -m 128M -smp $(CPUS) -nographic
QEMUOPTS += -global virtio-mmio.force-legacy=false
QEMUOPTS += -drive file=fs.img,if=none,format=raw,id=x0
QEMUOPTS += -device virtio-blk-device,drive=x0,bus=virtio-mmio-bus.0

QEMUOPTS += -netdev tap,id=net0,ifname=tap0,script=no,downscript=no 
QEMUOPTS += -device virtio-net-device,netdev=net0,bus=virtio-mmio-bus.1
QEMUOPTS +=

qemu: $K/kernel fs.img
	$(QEMU) $(QEMUOPTS)

.gdbinit: .gdbinit.tmpl-riscv
	sed "s/:1234/:$(GDBPORT)/" < $^ > $@

qemu-gdb: $K/kernel .gdbinit fs.img
	@echo "*** Now run 'gdb' in another window." 1>&2
	$(QEMU) $(QEMUOPTS) -S $(QEMUGDB)


##
## FOR testing lab grading script
##

#
# ifneq ($(V),@)
# GRADEFLAGS += -v
# endif
#
# print-gdbport:
# 	@echo $(GDBPORT)
#
# grade:
# 	@echo $(MAKE) clean
# 	@$(MAKE) clean || \
#           (echo "'make clean' failed.  HINT: Do you have another running instance of xv6?" && exit 1)
# 	./grade-lab-$(LAB).py $(GRADEFLAGS)
#
#
