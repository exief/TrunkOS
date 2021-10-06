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

Easiest method for installing these packages are via the package manager for respective host (eg. apt, yum). However, these can be installed from source if required.

Prerequisite components for the target are found within submodules and can be retrieved by performing a submodule update.
```bash
git submodule update --init --recursive --remote
```

## Build process
```bash
chmod +x build.sh 
./build.sh
```