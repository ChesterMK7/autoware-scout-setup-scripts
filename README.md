# autoware-scout-setup-scripts
Bash scripts for setting up Autoware requirements and ROS2 hardware drivers for the Scout 2.0 and Scout Mini. Currently a work-in progress.

## Requirements

Ubuntu 22.04    

Nvidia GPU with current driver support and CUDA compatability
- As of driver 610, this includes Turing (GTX 16XX & RTX 20XX) and newer

### Tested Using

Ubuntu 22.04 x86_64

Intel NUC
- Intel Core i5-1167G
- Nvidia RTX 2060

## Setup and Usage

Clone the repository

``` bash
git clone https://github.com/ChesterMK7/autoware-scout-setup-scripts
```

Run the host setup script

```bash
cd autoware-scout-setup-scripts/host-scripts
./host-setup.bash
```

## After Initial Install

Use the run container script to setup drivers and mount directories

```bash
cd autoware-scout-setup-scripts/host-scripts
./run-container.bash
```

Note that you may need to make the scripts executable
