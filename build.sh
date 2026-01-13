#!/bin/bash -e

# Ask for sudo password
sudo echo "Start"

# shellcheck disable=SC1091
source buildconfig
cd micra-pro
git add .
git reset --hard
git checkout "${MICRA_PRO_VERSION}"
cd ../pi-gen
git add .
git reset --hard
git checkout "${PI_GEN_VERSION}"
cd ../Transparent_Cursor_Theme
git add .
git reset --hard
git checkout "${TRANSPARENT_CURSOR_THEME_VERSION}"
cd ../
# Make Workdir
echo "Make Workdir"
if [ -d work ]; then
	sudo rm -rf work
fi
mkdir work
cp -r src/stage2-pc work/
# Replace Dummy Key for Backend and Asset Server Environment
echo "Replace Dummy Key for Backend and Asset Server Environment"
asset_server_key="$(tr -dc A-Za-z0-9 </dev/urandom | head -c 32)"
backend_content=$(<work/stage2-pc/06-services/files/services/backend.service)
echo -e "${backend_content/REMOTE_ASSET_SERVER_KEY_DUMMY123/$asset_server_key}" > work/stage2-pc/06-services/files/services/backend.service
asset_server_content=$(<work/stage2-pc/06-services/files/services/remote-asset-server.service)
echo -e "${asset_server_content/REMOTE_ASSET_SERVER_KEY_DUMMY123/$asset_server_key}" > work/stage2-pc/06-services/files/services/remote-asset-server.service
# Build Micra Pro Applications
echo "Build Micra Pro Applications"
cd micra-pro
npm install
npx nx reset
npx nx run-many -t build -c production -p backend frontend asset-server --nxBail true --outputStyle static
cd ../
# Copy Output Files
echo "Copy Output Files"
mkdir work/stage2-pc/01-copy-applications/files
mkdir work/stage2-pc/01-copy-applications/files/backend
mkdir work/stage2-pc/01-copy-applications/files/frontend
mkdir work/stage2-pc/01-copy-applications/files/asset-server
mkdir work/stage2-pc/01-copy-applications/files/updater
cp -r micra-pro/apps/backend/bin/Release/net8.0/linux-arm64/publish/* work/stage2-pc/01-copy-applications/files/backend/
if [ ! -f work/stage2-pc/01-copy-applications/files/backend/libe_sqlite3.so ]; then
	cp micra-pro/apps/backend/bin/Release/net8.0/linux-arm64/libe_sqlite3.so work/stage2-pc/01-copy-applications/files/backend/
fi
cp -r micra-pro/dist/apps/frontend/* work/stage2-pc/01-copy-applications/files/frontend/
cp -r micra-pro/apps/asset-server/.output/* work/stage2-pc/01-copy-applications/files/asset-server/
cp micra-pro/apps/updater/updater.sh work/stage2-pc/01-copy-applications/files/updater
# Copy Cursor Theme
echo "Copy Cursor Theme"
mkdir work/stage2-pc/03-hide-cursor/files
cp -r Transparent_Cursor_Theme/Transparent/* work/stage2-pc/03-hide-cursor/files
# Copy Build Instructions to Pi-Gen
echo "Copy Build Instructions to Pi-Gen"
if [ -f pi-gen/config ]; then
	sudo rm -f pi-gen/config
fi
if [ -d pi-gen/stage2-pc ]; then
	sudo rm -rf pi-gen/stage2-pc
fi
sudo cp -r work/* pi-gen/
sudo cp src/config pi-gen/
sudo touch pi-gen/stage2/SKIP_IMAGES
sudo touch pi-gen/stage2/03-accept-mathematica-eula/SKIP
sudo touch pi-gen/stage2/04-cloud-init/SKIP
# Build Pi-Gen Image
echo "Build Pi-Gen Image"
cd pi-gen
if [ -d work ]; then
	sudo rm -rf work
fi
if [ -d deploy ]; then
	sudo rm -rf deploy
fi
sudo bash ./build.sh
cd ../
# Copy Output Image
echo "Copy Output Image"
if [ -d output ]; then
	sudo rm -rf output
fi
mkdir output
cp -r pi-gen/deploy/*.img output/
