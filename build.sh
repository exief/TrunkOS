#!/usr/bin/env bash

set +h
umask 022
source .env.target

helpers/make_fhs_filesystem.sh
helpers/configure_system.sh

unset CFLAGS
unset CXXFLAGS

# Build target kernel headers
cd Dependencies/linux/
helpers/build_kernel.sh headers
cd -

# Build target binutils
mkdir -p buildenv/binutils && cd buildenv/binutils
helpers/build_binutils.sh
cd -

# Build Initial static gcc
cd Dependencies/gcc
./contrib/download_prerequisites
cd -
mkdir -p buildenv/gcc-static && cd buildenv/gcc-static
helpers/build_gcc.sh static
cd -

# Build glibc
mkdir -p buildenv/glibc && cd buildenv/glibc
helpers/build_glibc.sh
cd -

# Build mainline gcc
mkdir -p buildenv/gcc && cd buildenv/gcc
helpers/build_gcc.sh target
cd -

# Adjust environment variables
source .env.tools

# Build busybox
cd Dependencies/busybox
helpers/build_busybox.sh
cd -

# Build kernel
cd Dependencies/linux
helpers/build_kernel.sh
cd -
