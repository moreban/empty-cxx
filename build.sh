#!/bin/bash

SYNC_DIR=/Volumes/VolHack/work/ops.work/vagrants/armcxxbuilder/lunar-gcc13-builder
TMP_INSTALL=/tmp/install

run_sync() {
    rsync -avz -rtopg --partial --force --progress --delete -8 \
        \
        --exclude=.DS_Store --exclude=.Spotlight-V100 --exclude=.Trashes --exclude=Thumbs.db \
        --exclude build/ --exclude bin/ --exclude out/ \
        --exclude .cache/ --exclude .idea/ --exclude .github/ --exclude .git/ \
        --exclude man1/ --exclude docs/build/ \
        \
        ../empty-cc \
        $SYNC_DIR/
}

# sync in vm, from /vagrant/empty-cc to ~/empty-cc
run_vm_sync() {
    sudo rsync -avrztopg --exclude build/ --delete /vagrant/empty-cc ~/ && sudo chown -R $USER: ~/empty-cc
}

# build in vm
run_build() {
    [ -d ./build ] ||
        sudo mkdir -pv ./build && sudo chmod oga+rwx ./build &&
        cmake -S . -B build/ -DCMAKE_PREFIX_PATH:STRING="$TMP_INSTALL"
    rm -rf ./build/install 2>/dev/null
    cmake --build ./build &&
        cmake --install ./build --prefix "$TMP_INSTALL" &&
        ls -al --color "$TMP_INSTALL"/{s,}bin
}

run_doc() {
    cmake -H. -Bbuild/docs -G "Unix Makefiles" -DCMAKE_BUILD_TYPE="Release" -DBUILD_DOCUMENTATION=1
    cmake --build build/docs
}

run_cpack() {
    cpack --config build/CPackConfig.cmake -B ./build "$@"
}

if (($#)); then
    cmd="run_$1" && shift
else
    cmd=run_build
fi
eval "$cmd" "$@"
