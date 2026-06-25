#/bin/bash

# This script is intended to be used on Ubuntu 22.04
# It may work on 22.04 derivatives or other Ubuntu releases, but it has not been tested on them

# Copy docker setup scripts to home (will be moved into autoware dir later)
cp -r ../docker-scripts ~/
# Everything will be installed to the home directory
cd ~/
# Install Nvidia Drivers
# Commands commands from https://docs.nvidia.com/datacenter/tesla/driver-installation-guide/ubuntu.html
# Repo Setup
sudo apt update
sudo apt install -y linux-headers-$(uname -r)
# If you are on a different Ubuntu release, change '2204' to the respective release version
# Ex. 2404 for Ubuntu 24.04
wget https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2204/x86_64/cuda-keyring_1.1-1_all.deb
sudo dpkg -i cuda-keyring_1.1-1_all.deb
sudo apt update
# Install driver package (should be version 610)
sudo apt install cuda-drivers
# Install Docker Engine
# Commands sourced from https://docs.docker.com/engine/install/ubuntu/
# Repo setup
# Add Docker's official GPG key:
sudo apt install -y ca-certificates curl
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc
# Add the repository to Apt sources:
sudo tee /etc/apt/sources.list.d/docker.sources <<EOF
Types: deb
URIs: https://download.docker.com/linux/ubuntu
Suites: $(. /etc/os-release && echo "${UBUNTU_CODENAME:-$VERSION_CODENAME}")
Components: stable
Architectures: $(dpkg --print-architecture)
Signed-By: /etc/apt/keyrings/docker.asc
EOF
sudo apt update
# Install Docker packages
sudo apt install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
# Ensure Docker is enabled and running
sudo systemctl enable docker
sudo systemctl start docker
# Install Autoware 
# Commands sourced from https://autowarefoundation.github.io/autoware-documentation/main/installation/autoware/docker-installation/
# Pull Docker Image
docker pull ghcr.io/autowarefoundation/autoware:universe-cuda-jazzy
# Pull Autoware repo
git clone https://github.com/autowarefoundation/autoware.git
cd autoware
# Install Ansible
bash ansible/scripts/install-ansible.sh
# Run Docker Playbook
ansible-galaxy collection install -f -r ansible-galaxy-requirements.yaml
ansible-playbook autoware.dev_env.install_docker
# Also grab artifacts neccessary for simulations
ansible-playbook autoware.dev_env.install_dev_env --tags artifacts -e "data_dir=$HOME/autoware_data/ml_models" --ask-become-pass
# ROS2 Workspace Setup
# Note that due to githubusercontent.com timeout issues, the vcs imports will likely fail on ClarksonGuest
mkdir -p src
vcs import src < repositories/autoware.repos
vcs import src < repositories/autoware-nightly.repos
cd src
# Additional drivers
# Robosense
git clone https://github.com/RoboSense-LiDAR/rslidar_sdk.git
cd rslidar_sdk
git submodule init
git submodule update
cd ..
# Scout 2.0 & Scout Mini
git clone https://github.com/westonrobot/ugv_sdk
git clone https://github.com/agilexrobotics/scout_ros2 -b origin/jazzy
# Move docker scripts to shared directory
cd ..
mv ~/docker-scripts ./ 
#  Run the docker container and setup script
docker run --rm -it   --net host   --privileged   --gpus all   -e DISPLAY=$DISPLAY   -e NVIDIA_DRIVER_CAPABILITIES=all   -e NVIDIA_VISIBLE_DEVICES=all   -e HOST_UID=$(id -u)   -e HOST_GID=$(id -g)   -e QT_X11_NO_MITSHM=1   -v /tmp/.X11-unix:/tmp/.X11-unix:rw   -v $HOME/autoware_data/maps:/home/aw/autoware_data/maps   -v $HOME/autoware_data/ml_models:/home/aw/autoware_data/ml_models   -v $HOME/autoware:/home/aw/autoware   -w /home/aw/autoware   --runtime=nvidia   --device=/dev/ttyUSB0 autoware:universe-cuda-jazzy   bash -c "source /opt/autoware/setup.bash && exec bash && ./docker-scripts/full-setup.bash"
