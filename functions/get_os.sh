#!/usr/bin/env bash

# Echo's the operating system, simplified to:
# - osx
# - ubuntu
# - linux
get_os() {
    # Identify the operating system.
    local name=$(uname -a)
    os="unknown"
    if [[ "$name" =~ [Dd]arwin ]]; then
        echo "osx"
    elif [[ "$name" =~ [Uu]buntu ]]; then
        echo "ubuntu"
    elif [[ "$name" =~ [Ll]inux ]]; then
        echo "linux"
    else
        logger -s "Unable to idenfify operating system from uname '$name'"
        exit 1
    fi
}
