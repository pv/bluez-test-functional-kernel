#!/bin/bash
set -e

KERNEL_SRC=https://kernel.googlesource.com/pub/scm/linux/kernel/git/torvalds/linux.git
REV=refs/tags/v7.0-rc2

rm -rf linux
git clone --reference-if-able ../linux --revision="$REV" "$KERNEL_SRC" linux
git -C linux fetch --tags

BRANCH=$(git -C linux describe HEAD)

cp tester.config linux/.config

export KBUILD_BUILD_TIMESTAMP=$(git -C linux log -1 --format=%cd | cut -f1 -d"+")
export KBUILD_BUILD_USER=user
export KBUILD_BUILD_HOST=localhost
export CONFIG_HASH=$(sha256sum tester.config | cut -c1-8)

make -C linux olddefconfig
make -C linux -j12

BZIMAGE="bzImage-${BRANCH}-cfg${CONFIG_HASH}"

cp -f linux/arch/x86/boot/bzImage "$BZIMAGE"
sha256sum "$BZIMAGE"
