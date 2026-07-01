# autoware-scout-setup-scripts
Bash scripts for setting up Autoware requirements and ROS2 hardware drivers for the Scout 2.0 and Scout Mini. Currently a work-in-progress.

## Requirements

Ubuntu 22.04    

Nvidia GPU with current driver support and CUDA compatability
- As of driver 610, this includes Turing (GTX 16XX & RTX 20XX) and newer

### Tested Using

Ubuntu 22.04.5 x86_64

Intel NUC
- Intel Core i5-1165G
- Nvidia RTX 2060 Mobile
- 32GB DDR4

## Setup and Usage

Clone the repository

``` bash
git clone https://github.com/ChesterMK7/autoware-scout-setup-scripts
```

Make the scripts executable

```bash
cd autoware-scout-setup-scripts
sudo chmod +x host-scripts/*.bash
sudo chmod +x docker-scripts/*.bash
```

Run the host setup script

```bash
cd host-scripts
./host-setup.bash
```

Run the container setup script

```bash
./full-setup.bash
```

If using the Livox HAP, run the Livox script instead

```bash
./full-setup-livox.bash
```

## After Initial Install

Use the run container script to setup container options and mount directories

```bash
cd autoware-scout-setup-scripts/host-scripts
./run-container.bash
```

Run the respective package setup script in the container

```bash
# For Robosense
./package-setup.bash
```

```bash
# For Livox
./package-setup.bash
```
