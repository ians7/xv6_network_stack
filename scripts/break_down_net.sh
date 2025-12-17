sudo ip link set wlp9s0 nomaster

sudo ip link set br0 down

sudo ip link set tap0 down
sudo ip tuntap del dev tap0 mode tap

sudo ip link set wlp9s0 up
sudo ip link set br0 up

sudo pkill dhclient
sudo dhclient wlp9s0
