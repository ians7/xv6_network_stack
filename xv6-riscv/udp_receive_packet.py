import socket

def udp_server(host="0.0.0.0", port=20000):
    # Create a UDP socket
    sock = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
    sock.bind((host, port))

    print(f"UDP server listening on {host}:{port}")

    try:
        while True:
            data, addr = sock.recvfrom(4096)  # buffer size = 4KB
            print(f"Received {len(data)} bytes from {addr}: {data.decode(errors='ignore')}")
            # Optionally, send a reply back
            sock.sendto(b"ACK", addr)
    except KeyboardInterrupt:
        print("\nServer shutting down...")
    finally:
        sock.close()

if __name__ == "__main__":
    udp_server()
