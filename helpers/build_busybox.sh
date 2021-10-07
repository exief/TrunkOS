#!/usr/bin/env bash

make -j$(nproc) CROSS_COMPILE="${TRUNKOS_TARGET}-" defconfig
make -j$(nproc) CROSS_COMPILE="${TRUNKOS_TARGET}-" menuconfig
make -j$(nproc) CROSS_COMPILE="${TRUNKOS_TARGET}-"
make -j$(nproc) CROSS_COMPILE="${TRUNKOS_TARGET}-" CONFIG_PREFIX="${BASE_DIR}" install
cp -v examples/depmod.pl ${BASE_DIR}/cross-tools/bin
chmod 755 ${BASE_DIR}/cross-tools/bin/depmod.pl