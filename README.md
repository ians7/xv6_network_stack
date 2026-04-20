# Xv6 Network Stack (RISC-V)

## Overview

This project is an independent implementation of a network stack for Xv6 (RISC-V). It adds kernel-level networking support starting from a VirtIO network device driver and extending upward through Ethernet, ARP, IPv4, and UDP, with a Berkeley-style socket API exposed to user space.

The primary goal was to implement UDP support while designing the stack in a way that leaves room for future expansion (notably TCP). The project focuses on clarity of data flow, realistic OS abstractions, and integration with Xv6’s kernel and syscall model rather than feature completeness.

---

## Project Goals & Constraints

* Implement a real network stack inside the Xv6 kernel
* Support UDP sockets
* Follow a layered protocol design (NIC → Ethernet → ARP → IP → UDP)
* Keep the architecture flexible enough to support TCP in the future
* Favor simplicity over completeness (no fragmentation or DHCP)

---

## Building and Running

### Requirements

* QEMU with VirtIO networking support
* Root privileges (required for TAP device setup)
* A TAP interface bridged to a host network
* Docker, for now... (all of the above are handled by the docker container)

### Build & Run

Because I haven't written a DHCP protocol (yet), this project only supports the use of this system in docker. It has
two containers that are completely identical for the sake of testing.

Inside of the `xv6_network_stack/xv6-riscv` directory,
```bash
$ docker build
$ docker compose up -d
```

This launches two docker containers — hostA (10.10.0.11) and hostB (10.10.0.10). Next,

```bash
$ scripts/connect_hostA.sh
```

This launches a shell into the hostA docker container. Similarly, run the hostB shell script to remote into the hostB container.

Once in the container, 

```bash
$ cd /volumes
```

This will drop you into the project directory. Before either container can accomodate the Xv6 machine, run the following script
to set up the network,

```bash
$ scripts/setup_docker_net.sh
```
Now, to run Xv6, 

```bash
$ sudo make qemu-hostA
```

If you want to run the second machine in another container, you will run the following command instead,

```bash
$ sudo make qemu-hostB
```

You'll notice that you've been dropped into a simple shell. In here, typing the `ls` command will reveal all
of the user programs that currently exist on the system. Currently, the only actual network program that 
exists is a simple UDP chat program. Both instances of Xv6 will need to be up for this, of course. Consider
trying it out with the following command,

```bash
$ chat <other-ip>
```

### Networking Setup

* Docker for an isolated network, simplifying testing
* A tap device is required to connect the operating system to the network
* A network bridge is needed to connect the tap device to
* There are scripts to be run in the docker container to set up the network before booting into Xv6

I was initially just doing all of this on my home network, which was an absolute nightmare. Shoutout
to Dr. Mohammad Noureddine and his Network Security class for showing me the value of Docker in network
application testing.

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

   * Inspects the packet
   * Determines the inner protocol
   * Routes the payload to the appropriate handler

This design allows for a clear logical flow, making debugging the system relatively straightforward while having
an efficient flow of packets through the system.

---

## VirtIO Network Driver

* Interrupt-driven receive and transmit model
* Uses descriptor rings for packet buffers
* If descriptor exhaustion occurs, incoming packets are dropped
* Designed for correctness and simplicity rather than throughput optimization

---

## Socket API

The project exposes a Berkeley-style socket API to user space.

### Supported Features

* UDP protocol
* Blocking:

  * `recvfrom` blocks until data is available
  * `sendto` is synchronous

### Notes

* Error handling is intentionally minimal and undocumented
* API design closely mirrors traditional BSD sockets where possible

---

## Limitations & Non-Goals

The following features are **not currently implemented**:

* TCP
* IP fragmentation

Error handling is generally minimal, as this isn't intended to be a project that anyone was reasonably use ever. I also
haven't done any security analyis of the system. 

Given that this project was completed for educational reasons and I have limited free time, these omissions and limitations
are likely to remain until the end of time.

---

## Testing & Validation

The stack was tested using:

* **Wireshark** packet captures to validate protocol correctness and packet structure
* Tests that I wrote for Xv6 to test concurrency and routing of the packets.

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

## Potential Future Work

* Add TCP support
* Introduce fragmentation
* Improve error handling and robustness
