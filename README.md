# xv6 Network Stack (RISC-V)

## Overview

This project is an **independent implementation of a network stack for xv6 (RISC-V)**. It adds kernel-level networking support starting from a VirtIO network device driver and extending upward through Ethernet, ARP, IPv4, and UDP, with a Berkeley-style socket API exposed to user space.

The primary goal was to implement **UDP support** while designing the stack in a way that leaves room for future expansion (most notably TCP). The project focuses on clarity of data flow, realistic OS abstractions, and integration with xv6’s kernel and syscall model rather than feature completeness.

---

## Project Goals & Constraints

* Implement a real network stack inside xv6 rather than a user-space simulation
* Support **UDP sockets** with blocking semantics
* Follow a layered protocol design (NIC → Ethernet → ARP → IP → UDP)
* Keep the architecture flexible enough to support TCP in the future
* Favor simplicity over completeness (e.g., no routing or fragmentation initially)

---

## Environment

* **xv6 variant:** RISC-V
* **Architecture:** RISC-V
* **Emulator:** QEMU
* **Network device:** VirtIO network interface

---

## Building and Running

### Requirements

* QEMU with VirtIO networking support
* Root privileges (required for TAP device setup)
* A TAP interface bridged to a host network

### Build & Run

```bash
sudo make qemu
```

### Networking Setup

* A **TAP device is required** for networking
* Scripts are included to:

  * Create and configure the TAP device
  * Tear it down when finished
* A **network bridge must be active** on the host

    * I found the (Cockpit)[https://cockpit-project.org/documentation.htm] tool to be incredibly helpful for managing the bridge configuration

---

## Network Stack Architecture

The stack follows a conventional layered design:

```
VirtIO NIC
   ↓
Ethernet
   ↓
ARP / IPv4
   ↓
UDP
   ↓
Socket API
```

### Packet Flow

1. The VirtIO NIC places received packets into a shared buffer
2. The device raises an interrupt
3. The kernel interrupt handler begins packet processing
4. Each protocol layer:

   * Inspects the payload
   * Determines the encapsulated protocol
   * Dispatches to the appropriate handler

This design keeps each protocol layer isolated while allowing clear, linear packet flow through the stack.

---

## VirtIO Network Driver

* **Interrupt-driven** receive and transmit model
* Uses descriptor rings for packet buffers
* If descriptor exhaustion occurs, **incoming packets are dropped**
* Designed for correctness and simplicity rather than throughput optimization

---

## Socket API

The project exposes a **Berkeley-style socket API** to user space.

### Supported Features

* **Protocol:** UDP only
* **Blocking semantics:**

  * `recvfrom` blocks until data is available
  * `sendto` is synchronous

### Notes

* Error handling is intentionally minimal and undocumented
* API design closely mirrors traditional BSD sockets where possible

---

## Limitations & Non-Goals

The following features are **not currently implemented**:

* Packet transmission (sending packets is non-functional)
* Routing
* TCP
* IP fragmentation
* Checksum validation

These omissions are intentional and reflect the project’s focus on structure and extensibility rather than completeness.

---

## Testing & Validation

The stack was tested using:

* **ICMP ping** to and from another machine on the local network
* **Wireshark** packet captures to validate protocol correctness and packet structure

---

## Code Organization

### Drivers

* `kernel/virtio.h`
* `kernel/virtio_net.c`

### Protocol Implementations

* `kernel/sys/`

### System Call Integration

* `kernel/sysproc.c`

---

## References

* VirtIO specification and documentation
* Berkeley socket API documentation (used as the reference model for the socket interface)

---

## Future Work

* Implement packet transmission
* Add TCP support
* Introduce routing and fragmentation
* Improve error handling and robustness
