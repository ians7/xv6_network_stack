#!/bin/bash

# Create tap
sudo ip tuntap add dev tap0 mode tap

# Bring interfaces down (safely)
sudo ip link set enp6s0 down
sudo ip link set tap0 down
sudo ip link set br0 down

# Attach interfaces to bridge
sudo ip link set enp6s0 master br0
sudo ip link set tap0 master br0

# Flush old IPs from physical interface
sudo ip addr flush dev enp6s0

# Bring interfaces up
sudo ip link set br0 up
sudo ip link set enp6s0 up
sudo ip link set tap0 up

# Assign a static IP to the bridge (must match your LAN subnet!)
sudo ip addr add 192.168.254.60/24 dev br0

# Set the default route
sudo ip route add default via 192.168.254.1
