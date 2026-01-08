#!/bin/bash -e

# Install libgpiod 1.6.5
on_chroot << EOF
wget https://mirrors.edge.kernel.org/pub/software/libs/libgpiod/libgpiod-1.6.5.tar.xz
tar -xvf ./libgpiod-1.6.5.tar.xz
cd ./libgpiod-1.6.5/
./configure --enable-tools
make
sudo make install
cd ../
rm -r libgpiod-1.6.5
ln -s /usr/local/lib/libgpiod.so.2 /usr/lib/micra-pro/backend/libgpiod.so.2
EOF
