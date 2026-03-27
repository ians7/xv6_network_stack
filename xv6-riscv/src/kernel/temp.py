import socket
import struct

# ETH_P_ALL (0x0003) captures all protocols
s = socket.socket(socket.AF_PACKET, socket.SOCK_RAW, socket.htons(0x0003))

interface = "wlp9s0"  # Replace with your network interface name (e.g., "enp0s3", "wlan0")
s.bind((interface, 0))



# Example: ARP Request
dest_mac = b'\x02\x8f\x8f\x9a\x89\xc0'  # Broadcast MAC
src_mac = b'\x00\x11\x22\x33\x44\x55'   # Your MAC address
eth_type = b'\x7a\x05'                 # ARP EtherType

payload = b"Hi honey!"

# Combine header and payload
packet = dest_mac + src_mac + eth_type + payload

s.send(packet)
