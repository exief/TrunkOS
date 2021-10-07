#!/usr/bin/env bash

../../Dependencies/binutils-gdb/configure --prefix="${BASE_DIR}/cross-tools" \
    --target=${TRUNKOS_TARGET} \
    --with-sysroot=${BASE_DIR} \
    --disable-nls \
    --enable-shared \
    --disable-multilib
make -j$(nproc) configure-host && make -j$(nproc)
ln -sv lib ${BASE_DIR}/cross-tools/lib64
make -j$(nproc) install
cp -v ../../Dependencies/binutils-gdb/include/libiberty.h ${BASE_DIR}/usr/include
