#/bin/bash

# Clear any old Nvidia repos from apt
sudo rm /etc/apt/sources.list.d/cuda*
# Install CUDA 13.0.3
sudo dpkg -i cuda-repo-ubuntu2404-13-0-local_13.0.3-580.126.20-1_amd64.deb
sudo cp /var/cuda-repo-ubuntu2404-13-0-local/cuda-*-keyring.gpg /usr/share/keyrings/
sudo cp cuda-ubuntu2404.pin /etc/apt/preferences.d/cuda-repository-pin-600
sudo apt update
sudo apt install -y cuda-toolkit
# Install TensorRT 10.13.3
sudo dpkg -i nv-tensorrt-local-repo-ubuntu2404-10.13.3-cuda-13.0_1.0-1_amd64.deb
sudo cp /var/nv-tensorrt-local-repo-ubuntu2404-10.13.3-cuda-13.0/*-keyring.gpg /usr/share/keyrings/
sudo apt-get update
sudo apt-get install -y tensorrt
# Install TensorRT CMake Module,  ROS Diagnostics, and libpcap
sudo apt update
sudo apt upgrade -y
sudo apt install -y ros-jazzy-tensorrt-cmake-module ros-jazzy-diagnostics
sudo apt-get install -y  libpcap-dev
# Create symlinks to fix thrust include errors
# CUDA 13 moved these to the cccl subdirectory of the cuda include folder, this makes autoware able to find the headers it needs
# Could fix this by manually adding cccl/ in front of every thrust include in src, but that seemed tedious
sudo ln -s /usr/local/cuda/include/cccl/thrust /usr/local/cuda/include/thrust
sudo ln -s /usr/local/cuda/include/cccl/cub /usr/local/cuda/include/cub
sudo ln -s /usr/local/cuda/include/cccl/cuda /usr/local/cuda/include/cuda
# Workspace build (rosdep will likely not work on ClarksonGuest due to githubusercontent.com blocking traffic)
rosdep update
rosdep install -yr --from-paths src --ignore-src --rosdistro $ROS_DISTRO
colcon build --cmake-args -DCMAKE_BUILD_TYPE=Release
source install/setup.bash
