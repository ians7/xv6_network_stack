import socket
import time

def send_udp_packet():
    # Target address and port
    target_ip = "10.10.0.10"
    target_port = 78

    # Message to send
    message = "hello over udp"

    try:
        # Create UDP socket
        sock = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)

        # Optional: Bind to a specific local port for easier tracking
        # sock.bind(('', 12345))  # Uncomment to bind to local port 12345

        print(f"Sending UDP packet to {target_ip}:{target_port}")
        print(f"Payload: {message}")
        print(f"Payload length: {len(message)} bytes")

        # Send the packet
        bytes_sent = sock.sendto(message.encode('utf-8'), (target_ip, target_port))
        print(f"Bytes sent: {bytes_sent}")

        # Keep the program alive for a moment
        time.sleep(1)

    except Exception as e:
        print(f"Error sending UDP packet: {e}")
        import traceback
        traceback.print_exc()

    finally:
        # Close the socket
        sock.close()
        print("Socket closed")


if __name__ == "__main__":
    send_udp_packet()
