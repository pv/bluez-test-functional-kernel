bluez-test-functional-kernel
============================

Prebuilt kernel image:

    export KBUILD_BUILD_TIMESTAMP=$(git log -1 --format=%cd | cut -f1 -d"+")
    export KBUILD_BUILD_USER=user
    export KBUILD_BUILD_HOST=localhost

    cp tester.config .config
    make olddefconfig
    make

Also UML version:

    make ARCH=um defconfig
    scripts/kconfig/merge_config.sh -m .config ../tester.config
    scripts/config -e HOSTFS -e VIRTIO_UML -e UML_TIME_TRAVEL_SUPPORT
    make ARCH=um olddefconfig linux

