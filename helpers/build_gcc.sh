#!/usr/bin/env bash

if [ $1 -eq "static" ]; then
    AR=ar LDFLAGS="-Wl,-rpath,${BASE_DIR}/cross-tools/lib" \
        ../../Dependencies/gcc/configure --prefix=${BASE_DIR}/cross-tools \
        --build=${TRUNKOS_HOST} \
        --host=${TRUNKOS_HOST} \
        --target=${TRUNKOS_TARGET} \
        --with-sysroot=${BASE_DIR}/target --disable-nls \
        --disable-shared \
        --without-headers \
        --with-newlib \
        --disable-decimal-float \
        --disable-libgomp \
        --disable-libmudflap \
        --disable-libssp \
        --disable-threads \
        --enable-languages=c,c++ \
        --disable-multilib \
        --with-arch=${TRUNKOS_CPU}
    make -j$(nproc) all-gcc all-target-libgcc && make -j$(nproc) install-gcc install-target-libgcc
    ln -vs libgcc.a $(${TRUNKOS_TARGET}-gcc -print-libgcc-file-name | sed 's/libgcc/&_eh/')
else
    AR=ar LDFLAGS="-Wl,-rpath,${BASE_DIR}/cross-tools/lib" \
        ../../Dependencies/gcc/configure --prefix=${BASE_DIR}/cross-tools \
        --build=${TRUNKOS_HOST} \
        --target=${TRUNKOS_TARGET} \
        --host=${TRUNKOS_HOST} \
        --with-sysroot=${BASE_DIR} \
        --disable-nls \
        --enable-shared \
        --enable-languages=c,c++ \
        --enable-c99 \
        --enable-long-long \
        --disable-multilib \
        --with-arch=${TRUNKOS_CPU}
    make -j$(nproc) && make -j$(nproc) install
    cp -v ${BASE_DIR}/cross-tools/${TRUNKOS_TARGET}/lib64/libgcc_s.so.1 ${BASE_DIR}/lib64
fi
