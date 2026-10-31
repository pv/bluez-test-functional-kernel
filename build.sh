#!/bin/bash
set -e

KERNEL_SRC=https://kernel.googlesource.com/pub/scm/linux/kernel/git/torvalds/linux.git
REV=36aad21d50d1af3f6954bb0c988257a908202477
BASETAG=v7.3
SINCE=1792365298

rm -rf linux
git clone --reference-if-able ../linux --shallow-since="$SINCE" --single-branch --revision="$REV" "$KERNEL_SRC" linux
git -C linux fetch origin tag $BASETAG --no-tags

BRANCH=$(git -C linux describe HEAD)

cp tester.config linux/.config

export KBUILD_BUILD_TIMESTAMP=$(git -C linux log -1 --format=%cd | cut -f1 -d"+")
export KBUILD_BUILD_USER=user
export KBUILD_BUILD_HOST=localhost
export CONFIG_HASH=$(sha256sum tester.config | cut -c1-8)

make -C linux olddefconfig
make -C linux -j$(nproc)

BZIMAGE="bzImage-${BRANCH}-cfg${CONFIG_HASH}"
UML="linux-uml-${BRANCH}-cfg${CONFIG_HASH}"

cp -f linux/arch/x86/boot/bzImage "$BZIMAGE"
sha256sum "$BZIMAGE"

pushd linux
make mrproper
make ARCH=um defconfig
scripts/kconfig/merge_config.sh -m .config ../tester.config
scripts/config -e HOSTFS -e VIRTIO_UML -e UML_TIME_TRAVEL_SUPPORT
make ARCH=um olddefconfig linux -j$(nproc)
popd

cp -f linux/linux "$UML"
sha256sum "$UML"
