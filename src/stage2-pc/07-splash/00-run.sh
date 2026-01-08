#!/bin/bash -e

# Set Splash Screen
cp files/logo.jpg "${ROOTFS_DIR}/root/logo.jpg"
on_chroot << EOF
cd /root
chmod +rw logo.jpg
convert logo.jpg -colors 224 -depth 8 -type TrueColor -alpha off -compress none -define tga:bits-per-sample=8 splash-image.tga
rm logo.jpg
configure-splash splash-image.tga
rm splash-image.tga
EOF
