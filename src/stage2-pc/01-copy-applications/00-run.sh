#!/bin/bash -e

# Copy Applications
mkdir "${ROOTFS_DIR}/usr/lib/micra-pro"
cp -r files/* "${ROOTFS_DIR}/usr/lib/micra-pro/"
chmod +x "${ROOTFS_DIR}/usr/lib/micra-pro/backend/MicraPro.Backend"
# Create Appdata directories
mkdir "${ROOTFS_DIR}/mnt/localdata"
mkdir "${ROOTFS_DIR}/mnt/localdata/micra-pro"
mkdir "${ROOTFS_DIR}/mnt/localdata/micra-pro/backend"
mkdir "${ROOTFS_DIR}/mnt/localdata/micra-pro/local-assets"
mkdir "${ROOTFS_DIR}/mnt/localdata/micra-pro/blob-storage"
