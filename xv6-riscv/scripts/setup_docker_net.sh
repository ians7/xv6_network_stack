#!/bin/bash
# Sets up a bridge (br0) between eth0 and tap0 inside a Docker container,
# so the QEMU VM attached to tap0 is on the same L2 network as the other
# Docker containers.
#
# Run once per container before `make qemu-server` or `make qemu-client`.
# Requires NET_ADMIN capability (cap_add: ALL in docker-compose.yml).

set -e

# Grab eth0's address (e.g. "10.10.0.2/24") and the default gateway.
ETH_ADDR=$(ip -4 addr show eth0 | awk '/inet / {print $2}')
GW=$(ip route show default | awk '/default/ {print $3}')

if [ -z "$ETH_ADDR" ] || [ -z "$GW" ]; then
    echo "ERROR: could not determine eth0 address or default gateway" >&2
    exit 1
fi

# Create tap0 (server) and tap1 (client) if they do not already exist.
if ! ip link show tap0 &>/dev/null; then
    ip tuntap add dev tap0 mode tap
fi
ip link set tap0 up

if ! ip link show tap1 &>/dev/null; then
    ip tuntap add dev tap1 mode tap
fi
ip link set tap1 up

# Create bridge br0 if it does not already exist.
if ! ip link show br0 &>/dev/null; then
    ip link add br0 type bridge
fi

# Attach all interfaces to the bridge.
ip link set eth0 master br0
ip link set tap0 master br0
ip link set tap1 master br0

# Move the container's IP from eth0 to the bridge.
ip addr flush dev eth0
ip addr add "$ETH_ADDR" dev br0
ip link set br0 up

# Restore the default route via the bridge.
ip route add default via "$GW" dev br0 2>/dev/null || true

echo "Bridge ready: eth0 + tap0 -> br0 ($ETH_ADDR, gw $GW)"
