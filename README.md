bluez-test-functional-kernel
============================

Prebuilt kernel image:

    export KBUILD_BUILD_TIMESTAMP=$(git log -1 --format=%cd | cut -f1 -d"+")
    export KBUILD_BUILD_USER=user
    export KBUILD_BUILD_HOST=localhost

    cp tester.config .config
    make olddefconfig
    make

