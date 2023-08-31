#!/bin/bash
# Script to configure the container.
# In case of errors, the script will exit with a non-zero code but the container will still be built.
# This is useful since you can run the script manually inside the container, without rebuilding it.

# Own mounted user cache directory
sudo chown vscode:vscode ~/.cache

# Keras has a bug where it doesn't respect the KERAS_HOME environment variable,
# so we create a symlink for having the cache in the mounted directory
ln -sf ~/.cache/keras ~/.keras

# Docker disables apt cache by default, so we delete that rule
sudo rm /etc/apt/apt.conf.d/docker-clean -f

sudo apt-get update -q

PYTHON_NAME="python3.11"

sudo apt-get install -yq "${PYTHON_NAME}" nano htop vim wget git gh curl ca-certificates command-not-found bash-completion

if [ "$CONTAINER_TYPE" = "with-cuda" ]; then
    CUDA_VERSION="11.8"
    CUDNN_VERSION="8.6.0"

    # Add NVIDIA's package repository to apt so that we can download packages
    # Always use the ubuntu2004 repo because the other repos (e.g., debian11) are missing packages
    NVIDIA_REPO_URL="https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2004/x86_64"
    KEYRING_PACKAGE="cuda-keyring_1.0-1_all.deb"
    KEYRING_PACKAGE_URL="$NVIDIA_REPO_URL/$KEYRING_PACKAGE"
    KEYRING_PACKAGE_PATH="$(mktemp -d)"
    KEYRING_PACKAGE_FILE="$KEYRING_PACKAGE_PATH/$KEYRING_PACKAGE"

    wget -O "$KEYRING_PACKAGE_FILE" "$KEYRING_PACKAGE_URL"
    sudo apt-get install -yq "$KEYRING_PACKAGE_FILE"
    rm -rf "$KEYRING_PACKAGE_PATH"

    sudo apt-get update -yq

    sudo apt-get install -yq "cuda-libraries-${CUDA_VERSION/./-}" "libcudnn8=${CUDNN_VERSION}.*-1+cuda${CUDA_VERSION}" "cuda-nvcc-${CUDA_VERSION/./-}" aptitude

    sudo apt-mark hold libcudnn8

    sudo aptitude install -o "Aptitude::ProblemResolver::Hints::=reject tensorrt :UNINST" --without-recommends tensorrt=8.6.0.12-1+cuda${CUDA_VERSION} -yq
fi


curl -sSL https://install.python-poetry.org | POETRY_VERSION=1.6.1 "${PYTHON_NAME}" -


poetry env use "${PYTHON_NAME}"

poetry lock --no-update

poetry install --no-cache --no-ansi --no-interaction --sync \
    $(if [ "$CONTAINER_TYPE" = "with-cuda" ]; then echo "-E gpu"; else echo "-E cpu"; fi)
