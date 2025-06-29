from scapy.all import Ether, IP, UDP, sendp
import socket

def send_ethernet_message(mac_address, message):
    # Creating an Ethernet frame with the specified MAC address
    ether = Ether(dst=mac_address)
    # You can add a UDP payload here to simulate a network message
    udp = UDP(dport=12345, sport=12345) / message
    # Combine the Ethernet frame and UDP packet
    packet = ether / udp
    # Send the packet on the network
    sendp(packet, iface="br0")  # Change the interface if needed

# Sending the message
mac_address = "52:54:00:12:34:56"
message = "Hello, honey!"
send_ethernet_message(mac_address, message)
