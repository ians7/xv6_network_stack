#!/bin/bash

# Create tap
ip tuntap add dev tap0 mode tap
ip link add br0 type bridge

# Bring interfaces down (safely)
ip link set eth0 down
ip link set tap0 down
ip link set br0 down

# Attach interfaces to bridge
ip link set eth0 master br0
ip link set tap0 master br0

# Flush old IPs from physical interface
ip addr flush dev eth0

# Bring interfaces up
ip link set br0 up
ip link set eth0 up
ip link set tap0 up

# Assign a static IP to the bridge (must match your LAN subnet!)
ip addr add 10.10.0.60/24 dev br0

# Set the default route
ip route add default via 10.10.0.4
