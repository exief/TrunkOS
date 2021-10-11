.PHONY: base # default_packages

base: filesystem configure headers binutils glibc gcc busybox kernel boot
# default_packages: autoconf curl git make openssh openssl sqlite

filesystem:
	helpers/make_fhs_filesystem.sh

configure: filesystem
	helpers/configure_system.sh

headers: filesystem kernel_init
	cd Dependencies/linux/
	helpers/build_kernel.sh headers
	cd -

binutils: filesystem binutils_init
	mkdir -p buildenv/binutils && cd buildenv/binutils
	helpers/build_binutils.sh
	cd -

glibc: filesystem static_gcc headers glibc_init
	mkdir -p buildenv/glibc && cd buildenv/glibc
	helpers/build_glibc.sh
	cd -

static_gcc: filesystem gcc_prerequisites gcc_init
	mkdir -p buildenv/gcc-static && cd buildenv/gcc-static
	helpers/build_gcc.sh static
	cd -

gcc_prerequisites: gcc_init
	cd Dependencies/gcc
	./contrib/download_prerequisites
	cd -

gcc: filesystem glibc static_gcc gcc_prerequisites gcc_init
	mkdir -p buildenv/gcc && cd buildenv/gcc
	helpers/build_gcc.sh target
	cd -

busybox: filesystem glibc gcc binutils headers busybox_init
	cd Dependencies/busybox
	helpers/build_busybox.sh
	cd -

kernel: filesystem glibc gcc binutils headers busybox kernel_init
	cd Dependencies/linux
	helpers/build_kernel.sh
	cd -

kernel_init:
	git submodule update --init --remote Dependencies/linux

binutils_init:
	git submodule update --init --remote Dependencies/binutils

gcc_init:
	git submodule update --init --remote Dependencies/gcc

glibc_init:
	git submodule update --init --remote Dependencies/glibc

busybox_init:
	git submodule update --init --remote Dependencies/busybox

bootscript_init:
	git submodule update --init --remote Dependencies/bootscripts-standard