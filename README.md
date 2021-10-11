# Custom Linux OS From Scratch

> Jake Cooke 2021
-----------------------------------------

## Cross compilation toolchain

For the purposes of this project, the cross-compilation toolchain will be stored within toolchain subdirectory.

## Prerequisites
The host system is required to have the following installed in order for this to work:
- make
- gcc
- texinfo
- grub-install
- perl
- ncurses
- gmp-dev
- bison
- flex

Easiest method for installing these packages are via the package manager for respective host (eg. apt, yum). However, these can be installed from source if required.

Prerequisite components for the target are found within submodules and can be retrieved by performing a submodule update.
```bash
git submodule update --init --recursive --remote
```

## Build process

This project can be built in two ways; shell script or using make.

### Build from shell
```bash
chmod +x build.sh 
./build.sh
```

### Build with make
Make support is still work in progress 
```bash
# Build base OS and default included packages
make
# Build image that can be installed
make image
# Install image onto disk
make DD=/dev/sdd install
```

## Default installed packages
The following packages are installed by default to make usage and further installation of packages easier.

- OpenSSH
- OpenSSL
- Curl
- git
- Make
- autoconf
- zlib


## Optionally included packages
The following packages install scripts are found within the packages.d/optional folder and can be included in the initial os build by copying the shell script to the packages.d directory prior to build

- CMake
- LLVM (Requires CMake)
- Python (Requires SQLite3)
- SQLite3

Adding these will increase footprint of installed system and boot time.