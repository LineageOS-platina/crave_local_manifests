#!/usr/bin/env bash

########################################
# SOURCE SETUP
########################################

echo "==> Resetting manifests and toolchain..."
rm -rf .repo/local_manifests prebuilts/clang/host/linux-x86

echo "==> Initializing repo..."
repo init -u https://github.com/LineageOS/android.git -b lineage-23.2 --git-lfs
git clone https://github.com/LineageOS-platina/crave_local_manifests -b lineage-23.2 .repo/local_manifests

########################################
# SYNC SOURCE
########################################

echo "==> Syncing source..."
/opt/crave/resync.sh
/opt/crave/resync.sh
/opt/crave/resync.sh

########################################
# BUILD SETUP
########################################

echo "==> Preparing environment..."
. build/envsetup.sh

export BUILD_USERNAME=han
export BUILD_HOSTNAME=crave
export TZ=Asia/Jakarta
export KBUILD_USERNAME="$BUILD_USERNAME"
export KBUILD_HOSTNAME="$BUILD_HOSTNAME"

echo "==> Lunching target..."
lunch lineage_platina-bp4a-userdebug

echo "==> Cleaning previous build outputs..."
m clean

########################################
# BUILD EXECUTION
########################################

echo "==> Starting bacon build..."
if m bacon; then
    echo "==> Build completed successfully"
else
    echo "Build failed!"
    exit 1
fi

echo "==> All tasks completed successfully!"
