#!/usr/bin/env bash

echo "libc_cv_forced_unwind=yes" >config.cache
echo "libc_cv_c_cleanup=yes" >>config.cache
echo "libc_cv_ssp=no" >>config.cache
echo "libc_cv_ssp_strong=no" >>config.cache

BUILD_CC="gcc" CC="${TRUNKOS_TARGET}-gcc" AR="${TRUNKOS_TARGET}-ar" RANLIB="${TRUNKOS_TARGET}-ranlib" CFLAGS="-O2" \
    ../../Dependencies/glibc-2.27/configure --prefix=/usr \
    --host=${TRUNKOS_TARGET} \
    --build=${TRUNKOS_HOST} \
    --disable-profile \
    --enable-add-ons \
    --with-tls \
    --enable-kernel=2.6.32 \
    --with-__thread \
    --with-binutils=${BASE_DIR}/cross-tools/bin \
    --with-headers=${BASE_DIR}/usr/include \
    --cache-file=config.cache
make -j$(nproc) && make -j$(nproc) install_root=${BASE_DIR}/ install
