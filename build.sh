#!/usr/bin/env bash

set +h
umask 022
export BASE_DIR=$(pwd)/build

if [[ ! -e $BASE_DIR ]]; then
	mkdir -pv $BASE_DIR
fi

export LC_ALL=POSIX
export PATH=${BASE_DIR}/cross-tools/bin:/bin:/usr/bin

 mkdir -pv ${BASE_DIR}/{bin,boot{,grub},dev,{etc/,}opt,home,lib/{firmware,modules},lib64,mnt}
 mkdir -pv ${BASE_DIR}/{proc,media/{floppy,cdrom},sbin,srv,sys}
 mkdir -pv ${BASE_DIR}/var/{lock,log,mail,run,spool}
 mkdir -pv ${BASE_DIR}/var/{opt,cache,lib/{misc,locate},local}
 install -dv -m 0750 ${BASE_DIR}/root
 install -dv -m 1777 ${BASE_DIR}{/var,}/tmp
 install -dv ${BASE_DIR}/etc/init.d
 mkdir -pv ${BASE_DIR}/usr/{,local/}{bin,include,lib{,64},sbin,src}
 mkdir -pv ${BASE_DIR}/usr/{,local/}share/{doc,info,locale,man}
 mkdir -pv ${BASE_DIR}/usr/{,local/}share/{misc,terminfo,zoneinfo}
 mkdir -pv ${BASE_DIR}/usr/{,local/}share/man/man{1,2,3,4,5,6,7,8}
 for dir in ${BASE_DIR}/usr{,/local}; do
 	ln -sv share/{man,doc,info} ${dir}
 done

 install -dv ${BASE_DIR}/cross-tools{,/bin}
 ln -svf ../proc/mounts ${BASE_DIR}/etc/mtab

cat > ${BASE_DIR}/etc/passwd << "EOF"
root::0:0:root:/root:/bin/ash
EOF
cat > ${BASE_DIR}/etc/group << "EOF"
root:x:0:
bin:x:1:
sys:x:2:
kmem:x:3:
tty:x:4:
daemon:x:6:
disk:x:8:
dialout:x:10:
video:x:12:
utmp:x:13:
usb:x:14:
EOF
cat > ${BASE_DIR}/etc/fstab << "EOF"
# file system  mount-point  type   options          dump  fsck
#                                                         order

rootfs          /               auto    defaults        1      1
proc            /proc           proc    defaults        0      0
sysfs           /sys            sysfs   defaults        0      0
devpts          /dev/pts        devpts  gid=4,mode=620  0      0
tmpfs           /dev/shm        tmpfs   defaults        0      0
EOF
cat > ${BASE_DIR}/etc/profile << "EOF"
export PATH=/bin:/usr/bin

if [ `id -u` -eq 0 ] ; then
        PATH=/bin:/sbin:/usr/bin:/usr/sbin
        unset HISTFILE
fi


# Set up some environment variables.
export USER=`id -un`
export LOGNAME=$USER
export HOSTNAME=`/bin/hostname`
export HISTSIZE=1000
export HISTFILESIZE=1000
export PAGER='/bin/more '
export EDITOR='/bin/vi'
EOF

echo "customos-test" > ${BASE_DIR}/etc/HOSTNAME
cat > ${BASE_DIR}/etc/issue<< "EOF"
Linux Journal OS 0.1a
Kernel \r on an \m

EOF

cat > ${BASE_DIR}/etc/inittab<< "EOF"
::sysinit:/etc/rc.d/startup

tty1::respawn:/sbin/getty 38400 tty1
tty2::respawn:/sbin/getty 38400 tty2
tty3::respawn:/sbin/getty 38400 tty3
tty4::respawn:/sbin/getty 38400 tty4
tty5::respawn:/sbin/getty 38400 tty5
tty6::respawn:/sbin/getty 38400 tty6

::shutdown:/etc/rc.d/shutdown
::ctrlaltdel:/sbin/reboot
EOF
cat > ${BASE_DIR}/etc/mdev.conf<< "EOF"
# Devices:
# Syntax: %s %d:%d %s
# devices user:group mode

# null does already exist; therefore ownership has to
# be changed with command
null    root:root 0666  @chmod 666 $MDEV
zero    root:root 0666
grsec   root:root 0660
full    root:root 0666

random  root:root 0666
urandom root:root 0444
hwrandom root:root 0660

# console does already exist; therefore ownership has to
# be changed with command
console root:tty 0600 @mkdir -pm 755 fd && cd fd && for x in 0 1 2 3 ; do ln -sf /proc/self/fd/$x $x; done

kmem    root:root 0640
mem     root:root 0640
port    root:root 0640
ptmx    root:tty 0666

# ram.*
ram([0-9]*)     root:disk 0660 >rd/%1
loop([0-9]+)    root:disk 0660 >loop/%1
sd[a-z].*       root:disk 0660 */lib/mdev/usbdisk_link
hd[a-z][0-9]*   root:disk 0660 */lib/mdev/ide_links

tty             root:tty 0666
tty[0-9]        root:root 0600
tty[0-9][0-9]   root:tty 0660
ttyO[0-9]*      root:tty 0660
pty.*           root:tty 0660
vcs[0-9]*       root:tty 0660
vcsa[0-9]*      root:tty 0660

ttyLTM[0-9]     root:dialout 0660 @ln -sf $MDEV modem
ttySHSF[0-9]    root:dialout 0660 @ln -sf $MDEV modem
slamr           root:dialout 0660 @ln -sf $MDEV slamr0
slusb           root:dialout 0660 @ln -sf $MDEV slusb0
fuse            root:root  0666

# misc stuff
agpgart         root:root 0660  >misc/
psaux           root:root 0660  >misc/
rtc             root:root 0664  >misc/

# input stuff
event[0-9]+     root:root 0640 =input/
ts[0-9]         root:root 0600 =input/

# v4l stuff
vbi[0-9]        root:video 0660 >v4l/
video[0-9]      root:video 0660 >v4l/

# load drivers for usb devices
usbdev[0-9].[0-9]       root:root 0660 */lib/mdev/usbdev
usbdev[0-9].[0-9]_.*    root:root 0660
EOF

mkdir -pv ${BASE_DIR}/boot/grub
touch ${BASE_DIR}/boot/grub/grub.cfg
cat > ${BASE_DIR}/boot/grub/grub.cfg<< "EOF"
set default=0
set timeout=5

set root=(hd0,1)

menuentry "Linux Journal OS 0.1a" {
        linux   /boot/vmlinuz-4.16.3 root=/dev/sda1 ro quiet
}
EOF
touch ${BASE_DIR}/var/run/utmp ${BASE_DIR}/var/log/{btmp,lastlog,wtmp}
chmod -v 664 ${BASE_DIR}/var/run/utmp ${BASE_DIR}/var/log/lastlog


unset CFLAGS
unset CXXFLAGS
export CUSTOMOS_HOST=$(echo ${MACHTYPE} | sed "s/-[^-]*/-cross/")
export CUSTOMOS_TARGET=x86_64-unknown-linux-gnu
export CUSTOMOS_CPU=k8
export CUSTOMOS_ARCH=$(echo ${TRUNKOS_TARGET} | sed -e 's/-.*//' -e 's/i.86/i386/')
export CUSTOMOS_ENDIAN=little

# Build target kernel headers
cd Dependencies/linux/
make -j$(nproc) mrproper
make -j$(nproc) ARCH=${TRUNKOS_ARCH} headers_check && make -j$(nproc) ARCH=${TRUNKOS_ARCH} INSTALL_HDR_PATH=dest headers_install
cp -rv dest/include/* ${BASE_DIR}/usr/include
cd -

# Build target binutils
mkdir -p buildenv/binutils
cd buildenv/binutils
../../Dependencies/binutils-gdb/configure --prefix="${BASE_DIR}/cross-tools" \
                                          --target=${TRUNKOS_TARGET}         \
                                          --with-sysroot=${BASE_DIR}         \
                                          --disable-nls                      \
                                          --enable-shared                    \
                                          --disable-multilib
make -j$(nproc) configure-host && make -j$(nproc)
ln -sv lib ${BASE_DIR}/cross-tools/lib64
make -j$(nproc) install
cp -v ../../Dependencies/binutils-gdb/include/libiberty.h ${BASE_DIR}/usr/include
cd -

# Build Initial static gcc
cd Dependencies/gcc
./contrib/download_prerequisites
cd -
mkdir -p buildenv/gcc-static
cd buildenv/gcc-static
AR=ar LDFLAGS="-Wl,-rpath,${BASE_DIR}/cross-tools/lib"                           \
../../Dependencies/gcc/configure --prefix=${BASE_DIR}/cross-tools                \
                                 --build=${TRUNKOS_HOST}                        \
                                 --host=${TRUNKOS_HOST}                         \
                                 --target=${TRUNKOS_TARGET}                     \
                                 --with-sysroot=${BASE_DIR}/target --disable-nls \
                                 --disable-shared                                \
                                 --without-headers                               \
                                 --with-newlib                                   \
                                 --disable-decimal-float                         \
                                 --disable-libgomp                               \
                                 --disable-libmudflap                            \
                                 --disable-libssp                                \
                                 --disable-threads                               \
                                 --enable-languages=c,c++                        \
                                 --disable-multilib                              \
                                 --with-arch=${TRUNKOS_CPU}
make -j$(nproc) all-gcc all-target-libgcc && make -j$(nproc) install-gcc install-target-libgcc
ln -vs libgcc.a `${TRUNKOS_TARGET}-gcc -print-libgcc-file-name | sed 's/libgcc/&_eh/'`
cd -

# Build glibc
mkdir -p buildenv/glibc
cd buildenv/glibc
echo "libc_cv_forced_unwind=yes" > config.cache
echo "libc_cv_c_cleanup=yes" >> config.cache
echo "libc_cv_ssp=no" >> config.cache
echo "libc_cv_ssp_strong=no" >> config.cache

BUILD_CC="gcc" CC="${TRUNKOS_TARGET}-gcc" AR="${TRUNKOS_TARGET}-ar" RANLIB="${TRUNKOS_TARGET}-ranlib" CFLAGS="-O2" \
../../Dependencies/glibc-2.27/configure --prefix=/usr                                                                 \
	                                    --host=${TRUNKOS_TARGET}                                                     \
	                                    --build=${TRUNKOS_HOST}                                                      \
	                                    --disable-profile                                                             \
	                                    --enable-add-ons                                                              \
	                                    --with-tls                                                                    \
	                                    --enable-kernel=2.6.32                                                        \
	                                    --with-__thread                                                               \
	                                    --with-binutils=${BASE_DIR}/cross-tools/bin                                   \
	                                    --with-headers=${BASE_DIR}/usr/include                                        \
	                                    --cache-file=config.cache
make -j$(nproc) && make -j$(nproc) install_root=${BASE_DIR}/ install
cd -

# Build mainline gcc
mkdir -p buildenv/gcc
cd buildenv/gcc
AR=ar LDFLAGS="-Wl,-rpath,${BASE_DIR}/cross-tools/lib"            \
../../Dependencies/gcc/configure --prefix=${BASE_DIR}/cross-tools \
                                 --build=${TRUNKOS_HOST}         \
                                 --target=${TRUNKOS_TARGET}      \
                                 --host=${TRUNKOS_HOST}          \
                                 --with-sysroot=${BASE_DIR}       \
                                 --disable-nls                    \
                                 --enable-shared                  \
                                 --enable-languages=c,c++         \
                                 --enable-c99                     \
                                 --enable-long-long               \
                                 --disable-multilib               \
                                 --with-arch=${TRUNKOS_CPU}
make -j$(nproc) && make -j$(nproc) install
cp -v ${BASE_DIR}/cross-tools/${TRUNKOS_TARGET}/lib64/libgcc_s.so.1 ${BASE_DIR}/lib64
cd -

# Adjust environment variables
export CC="${TRUNKOS_TARGET}-gcc"
export CXX="${TRUNKOS_TARGET}-g++"
export CPP="${TRUNKOS_TARGET}-gcc -E"
export AR="${TRUNKOS_TARGET}-ar"
export AS="${TRUNKOS_TARGET}-as"
export LD="${TRUNKOS_TARGET}-ld"
export RANLIB="${TRUNKOS_TARGET}-ranlib"
export READELF="${TRUNKOS_TARGET}-readelf"
export STRIP="${TRUNKOS_TARGET}-strip"

# Build busybox
cd Dependencies/busybox
make -j$(nproc) CROSS_COMPILE="${CUSTOMOS-TARGET}-" defconfig
make -j$(nproc) CROSS_COMPILE="${CUSTOMOS-TARGET}-" menuconfig
make -j$(nproc) CROSS_COMPILE="${CUSTOMOS-TARGET}-"
make -j$(nproc) CROSS_COMPILE="${CUSTOMOS-TARGET}-" CONFIG_PREFIX="${BASE_DIR}" install
cp -v examples/depmod.pl ${BASE_DIR}/cross-tools/bin
chmod 755 ${BASE_DIR}/cross-tools/bin/depmod.pl
cd -

# Build kernel
cd Dependencies/linux
make -j$(nproc) ARCH=${TRUNKOS_ARCH} CROSS_COMPILE=${TRUNKOS_TARGET}- x86_64_defconfig
make -j$(nproc) ARCH=${TRUNKOS_ARCH} CROSS_COMPILE=${TRUNKOS_TARGET}- menuconfig
make -j$(nproc) ARCH=${TRUNKOS_ARCH} CROSS_COMPILE=${TRUNKOS_TARGET}-
make -j$(nproc) ARCH=${TRUNKOS_ARCH} CROSS_COMPILE=${TRUNKOS_TARGET}- INSTALL_MOD_PATH=${BASE_DIR} install
cd -
