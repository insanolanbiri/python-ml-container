#!/bin/bash
# Script to configure the host machine.
# This script runs on the host machine every time the container is started.

CONTAINER_TYPE=$1

cache_path="./.devcontainer/.cache"

# Test this file's existence to determine if we're in the right directory
if [ ! -f "./.devcontainer/initialize.sh" ]; then
    echo "This script must be run from the root of the project directory." >&2
    exit 1
fi

# Create cache directories for the container
mkdir -p "${cache_path}/xdg_cache"
mkdir -p "${cache_path}/xdg_cache/keras" # required for symlinking on the container
mkdir -p "${cache_path}/var_cache"
