#!/bin/bash -e

# Remove Lighttpd service
on_chroot << EOF
systemctl disable lighttpd.service
EOF
rm -f "${ROOTFS_DIR}/usr/lib/systemd/system/lighttpd.service"
# Install aspdotnet 8.0 runtime
on_chroot << EOF
wget https://dot.net/v1/dotnet-install.sh -O dotnet-install.sh
chmod +x ./dotnet-install.sh
./dotnet-install.sh --runtime aspnetcore --channel 8.0
rm dotnet-install.sh
EOF
cp -r "${ROOTFS_DIR}/root/.dotnet" "${ROOTFS_DIR}/usr/bin"
rm -rf "${ROOTFS_DIR}/root/.dotnet"
# Install aspdotnet nodejs 22.x
on_chroot << EOF
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.3/install.sh | bash
\. "/root/.nvm/nvm.sh"
nvm install 22.21.1
EOF
cp -r "${ROOTFS_DIR}/root/.nvm/versions/node/v22.21.1" "${ROOTFS_DIR}/usr/bin/"
mv "${ROOTFS_DIR}/usr/bin/v22.21.1" "${ROOTFS_DIR}/usr/bin/.nodejs"
rm -rf "${ROOTFS_DIR}/root/.nvm"
