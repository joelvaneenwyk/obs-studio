#!/bin/bash -x

function setup() {
    git submodule update --init --recursive

    DISABLE_PIPEWIRE=TRUE
    export DISABLE_PIPEWIRE

    # shellcheck source=/dev/null
    ./CI/linux/00_install_llvm.sh 13 all
    sudo apt install clang-format-13

    python3 -m pip install cmakelang --user --verbose

    # shellcheck source=/dev/null
    source ./CI/linux/01_install_dependencies.sh
}

setup
