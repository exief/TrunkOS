#!/usr/bin/env bash

if [ $1 -eq "headers" ]; then
    make -j$(nproc) mrproper
    make -j$(nproc) ARCH=${TRUNKOS_ARCH} headers_check && make -j$(nproc) ARCH=${TRUNKOS_ARCH} INSTALL_HDR_PATH=dest headers_install
    cp -rv dest/include/* ${BASE_DIR}/usr/include
else
    make -j$(nproc) ARCH=${TRUNKOS_ARCH} CROSS_COMPILE=${TRUNKOS_TARGET}- x86_64_defconfig
    make -j$(nproc) ARCH=${TRUNKOS_ARCH} CROSS_COMPILE=${TRUNKOS_TARGET}- menuconfig
    make -j$(nproc) ARCH=${TRUNKOS_ARCH} CROSS_COMPILE=${TRUNKOS_TARGET}-
    make -j$(nproc) ARCH=${TRUNKOS_ARCH} CROSS_COMPILE=${TRUNKOS_TARGET}- INSTALL_MOD_PATH=${BASE_DIR} install
    cp -v arch/x86/boot/bzImage ${BASE_DIR}/boot/vmlinuz-5.15.0
    cp -v System.map ${BASE_DIR}/boot/System.map-5.15.0
    cp -v .config ${BASE_DIR}/boot/config-5.15.0
    ${BASE_DIR}/cross-tools/bin/depmod.pl -F ${BASE_DIR}/boot/System.map-5.15.0 -b ${BASE_DIR}/lib/modules/5.15.0
fi