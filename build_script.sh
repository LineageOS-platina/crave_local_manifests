#!/usr/bin/env bash

########################################
# SOURCE SETUP
########################################

echo "==> Resetting manifests..."
rm -rf .repo/local_manifests

echo "==> Initializing repo..."
repo init -u https://github.com/LineageOS/android.git -b lineage-22.2 --depth=1 --git-lfs
git clone https://github.com/LineageOS-platina/crave_local_manifests -b lineage-22.2 .repo/local_manifests

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
lunch lineage_platina-bp1a-userdebug

echo "==> Cleaning previous build outputs..."
m installclean

########################################
# BUILD EXECUTION
########################################

echo "==> Starting target-files build..."
if m target-files-package otatools; then
    echo "==> Build completed successfully"
    echo "==> Running sign_script.sh..."
    bash sign_script.sh
else
    echo "Build failed — signing skipped!"
    exit 1
fi

echo "==> All tasks completed successfully!"
