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
fi
