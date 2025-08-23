from socket import *

def sendeth(src, dst, eth_type, payload, interface="wlp9s0"):
    assert(len(src)== len(dst) == 6)
    assert(len(eth_type) == 2)
    s = socket(AF_PACKET, SOCK_RAW)
    s.bind((interface, 0))
    return s.send(src + dst + eth_type + payload)

if __name__ == "__main__":
    print("Sent %d-byte Ethernet packet on eth0" %
    sendeth(b"\x52\x54\x00\x12\x34\x56",
            b"\x02\xf3\xa5\x02\x3a\xb8",
            b"\x7a\x05",
            b"Hello, world!"))
