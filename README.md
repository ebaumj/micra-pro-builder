# MicraPro Builder
Builds Raspberry Pi Image with Micra-Pro Application (https://github.com/ebaumj/micra-pro) installed

## Pre Requisites
- Debian Based Operating System on Build Machine
- .Net 8.0 SDK installed on Build Machine
- Node.js (Version >= 20) installed on Build Machine
- Apt Packages:
    - coreutils
    - quilt
    - parted
    - qemu-user-static
    - debootstrap
    - zerofree
    - zip
    - dosfstools
    - e2fsprogs
    - libarchive-tools
    - libcap2-bin
    - grep
    - rsync
    - xz-utils
    - file
    - git
    - curl
    - bc
    - gpg
    - pigz
    - xxd
    - arch-test
    - bmap-tools
    - kmod

## Build Instructions

### Clone Repository
```bash 
git clone https://github.com/ebaumj/micra-pro-builder.git
cd micra-pro-builder
git submodule update --init --recursive --remote 
```

### Start Build
```bash 
./build.sh
```

## Configuration Options
- Select the Subrepo Versions (branch, tag, commit-hash) in the `buildconfig` file
- Select the config for the Raspbery OS Build in the `src/config` file (see https://github.com/RPi-Distro/pi-gen/)
