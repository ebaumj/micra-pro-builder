#!/bin/bash -e

# Hide Cursor
rm -r "${ROOTFS_DIR}/usr/share/icons/Adwaita/cursors"
cp -r files/* "${ROOTFS_DIR}/usr/share/icons/Adwaita/"
