# python-ml-container
This is a template for a Python machine learning development environment, using devcontainers.

The container is intended to be used with VSCode but can be used with any editor that supports devcontainers (Probably a lot of configuration is required to get it working with other editors, better to use VSCode).

Using a container for development allows for a consistent development environment across different machines and operating systems.
It also allows for easy sharing of development environments, resulting in less time spent on setting up the environment and more time spent on development.

## Features
- VSCode configuration/extensions
- Configuration scripts for installing software and setting up the environment
- Nvidia CUDA and CUDNN support
- Caching support for pip, apt and Keras

## Usage
1. Install [VSCode](https://code.visualstudio.com/)
1. Install [Docker](https://docs.docker.com/get-docker/)
1. (Optional) Install [Nvidia drivers](https://www.nvidia.com/Download/index.aspx?lang=en-us) and [Nvidia Container Toolkit](https://docs.nvidia.com/datacenter/cloud-native/container-toolkit/install-guide.html#docker). Nvidia CUDA Toolkit and Nvidia CUDNN are not required to be installed on the host machine.
1. Install [VSCode Remote Development Extension Pack](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.vscode-remote-extensionpack)
1. Open the repository in VSCode
1. Follow the prompts to open the repository in a container

Building the container may take a while, but once it is built, it will be cached and subsequent builds will be much faster.
The build process requires an internet connection. Building the container for the first time will download about 3GB (Plus 5GB if GPU support is enabled) of data.
