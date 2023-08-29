#!/bin/bash -x
# This script will convert all your git submodules into git subtrees.
# This script ensures that your new subtrees point to the same commits as the
# old submodules did, unlike most other scripts that do this.
# THIS SCRIPT MUST BE PLACED OUTSIDE OF YOUR REPOSITORY!!!!!!!!!!
# Otherwise, the script will interfere with the git commits (unless you add it to .gitignore).
# Save the script in your home directory as `~/subtrees.sh`
# `cd` into your repository
# Run `~/subtrees.sh`
# Enjoy!

function add_submodules() {
    git submodule add "https://github.com/Xaymar/cmake-clang.git" ./cmake/clang
    git submodule add "https://github.com/Xaymar/cmake-version.git" ./cmake/version
    git submodule add "https://github.com/nlohmann/json.git" ./third-party/nlohmann-json
    git submodule add "https://github.com/Xaymar/msvc-redist-helper.git" ./third-party/msvc-redist-helper
    git submodule add "https://github.com/NVIDIA/MAXINE-AR-SDK.git" ./third-party/nvidia-maxine-ar-sdk
    git submodule add "https://github.com/NVIDIA/MAXINE-VFX-SDK.git" ./third-party/nvidia-maxine-vfx-sdk
}

function convert_submodule_to_subtree() {
    # extract the list of submodules from .gitmodule
    while IFS= read -r i; do
        if [[ $i == \[submodule* ]]; then
            echo converting "$i"
            read -r i

            # extract the module's prefix
            mpath=$(echo "$i" | grep -E "(\S+)$" -o)

            echo path: "$mpath"
            read -r i

            # extract the url of the submodule
            murl=$(echo "$i" | cut -d= -f2 | xargs)
            echo url: "$murl"

            # extract the module name
            mname=$(basename "$mpath")
            echo name: "$mname"

            # extract the referenced commit
            mcommit=$(git submodule status "$mpath" | grep -E "\S+" -o | head -1)
            echo commit: "$mcommit"

            # deinit the module
            git submodule deinit "$mpath"

            # remove the module from git
            git rm -r --cached "$mpath"

            # remove the module from the filesystem
            rm -rf "$mpath"

            # commit the change
            git commit -m "Removed $mpath submodule at commit $mcommit"

            # add the remote
            git remote add -f "$mname" "$murl"

            # add the subtree
            git subtree add --prefix "$mpath" "$mcommit" --squash

            # commit any left over uncommited changes
            git commit -a -m "$mname cleaned up"

            # fetch the files
            git fetch "$murl" master

            echo
        fi
    done <.gitmodules
    git rm .gitmodules
    git commit -a -m "Removed .gitmodules"
}

function build() {
    git submodule update --init --recursive

    DISABLE_PIPEWIRE=1
    export DISABLE_PIPEWIRE

    # shellcheck source=/dev/null
    source ./CI/build-linux.sh
}

build
