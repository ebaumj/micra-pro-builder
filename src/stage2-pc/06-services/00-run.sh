#!/bin/bash -e

# Create and Enable Systemd Services
cp -r files/services/* "${ROOTFS_DIR}/usr/lib/systemd/system/"
cp -r files/pam/* "${ROOTFS_DIR}/etc/pam.d/"
on_chroot << EOF
systemctl enable frontend-server.service
systemctl enable cage@tty1.service
systemctl set-default graphical.target
systemctl enable local-asset-server.service
systemctl enable remote-asset-server.service
systemctl enable backend.service
EOF
