//
// virtio device definitions.
// for both the mmio interface, and virtio descriptors.
// only tested with qemu.
//
// the virtio spec:
// https://docs.oasis-open.org/virtio/virtio/v1.1/virtio-v1.1.pdf
//

#include "types.h"
#include "spinlock.h"

// virtio mmio control registers, mapped starting at 0x10001000.
// from qemu virtio_mmio.h
#define VIRTIO_MMIO_MAGIC_VALUE		0x000 // 0x74726976
#define VIRTIO_MMIO_VERSION		0x004 // version; should be 2
#define VIRTIO_MMIO_DEVICE_ID		0x008 // device type; 1 is net, 2 is disk
#define VIRTIO_MMIO_VENDOR_ID		0x00c // 0x554d4551
#define VIRTIO_MMIO_DEVICE_FEATURES	0x010
#define VIRTIO_MMIO_DRIVER_FEATURES	0x020
#define VIRTIO_MMIO_QUEUE_SEL		0x030 // select queue, write-only
#define VIRTIO_MMIO_QUEUE_NUM_MAX	0x034 // max size of current queue, read-only
#define VIRTIO_MMIO_QUEUE_NUM		0x038 // size of current queue, write-only
#define VIRTIO_MMIO_QUEUE_READY		0x044 // ready bit
#define VIRTIO_MMIO_QUEUE_NOTIFY	0x050 // write-only
#define VIRTIO_MMIO_INTERRUPT_STATUS	0x060 // read-only
#define VIRTIO_MMIO_INTERRUPT_ACK	0x064 // write-only
#define VIRTIO_MMIO_STATUS		0x070 // read/write
#define VIRTIO_MMIO_QUEUE_DESC_LOW	0x080 // physical address for descriptor table, write-only
#define VIRTIO_MMIO_QUEUE_DESC_HIGH	0x084
#define VIRTIO_MMIO_DRIVER_DESC_LOW	0x090 // physical address for available ring, write-only
#define VIRTIO_MMIO_DRIVER_DESC_HIGH	0x094
#define VIRTIO_MMIO_DEVICE_DESC_LOW	0x0a0 // physical address for used ring, write-only
#define VIRTIO_MMIO_DEVICE_DESC_HIGH	0x0a4

// status register bits, from qemu virtio_config.h
#define VIRTIO_CONFIG_S_ACKNOWLEDGE	1
#define VIRTIO_CONFIG_S_DRIVER		2
#define VIRTIO_CONFIG_S_DRIVER_OK	4
#define VIRTIO_CONFIG_S_FEATURES_OK	8

// device feature bits
#define VIRTIO_BLK_F_RO              5	/* Disk is read-only */
#define VIRTIO_BLK_F_SCSI            7	/* Supports scsi command passthru */
#define VIRTIO_BLK_F_CONFIG_WCE     11	/* Writeback mode available in config */
#define VIRTIO_BLK_F_MQ             12	/* support more than one vq */
#define VIRTIO_F_ANY_LAYOUT         27
#define VIRTIO_RING_F_INDIRECT_DESC 28
#define VIRTIO_RING_F_EVENT_IDX     29

// virtio-net feature bits
#define VIRTIO_NET_F_CSUM 0
#define VIRTIO_NET_F_GUEST_CSUM (1 << 1)
#define VIRTIO_NET_F_CTRL_GUEST_OFFLOADS (1 << 2)
#define VIRTIO_NET_F_MTU (1 << 3)
#define VIRTIO_NET_F_MAC (1 << 5)
#define VIRTIO_NET_F_GUEST_TSO4 (1 << 7)
#define VIRTIO_NET_F_GUEST_TSO6 (1 << 8)
#define VIRTIO_NET_F_GUEST_ECN (1 << 9)
#define VIRTIO_NET_F_GUEST_UFO (1 << 10)
#define VIRTIO_NET_F_HOST_TSO4 (1 << 11)
#define VIRTIO_NET_F_HOST_TSO6 (1 << 12)
#define VIRTIO_NET_F_HOST_ECN (1 << 13)
#define VIRTIO_NET_F_HOST_UFO (1 << 14)
#define VIRTIO_NET_F_MRG_RXBUF (1 << 15)
#define VIRTIO_NET_F_STATUS (1 << 16)
#define VIRTIO_NET_F_CTRL_VQ (1 << 17)
#define VIRTIO_NET_F_CTRL_RX (1 << 18)
#define VIRTIO_NET_F_CTRL_VLAN (1 << 19)
#define VIRTIO_NET_F_GUEST_ANNOUNCE (1 << 21)
#define VIRTIO_NET_F_MQ (1 << 22)
#define VIRTIO_NET_F_CTRL_MAC_ADDR (1 << 23)

// this many virtio descriptors.
// must be a power of two.
#define NUM 8

// a single descriptor, from the spec.
struct virtq_desc {
  uint64 addr;
  uint32 len;
  uint16 flags;
  uint16 next;
};
#define VRING_DESC_F_NEXT  1 // chained with another descriptor
#define VRING_DESC_F_WRITE 2 // device writes (vs read)

// the (entire) avail ring, from the spec.
struct virtq_avail {
  uint16 flags; // always zero
  uint16 idx;   // driver will write ring[idx] next
  uint16 ring[NUM]; // descriptor numbers of chain heads
  uint16 unused;
};

// one entry in the "used" ring, with which the
// device tells the driver about completed requests.
struct virtq_used_elem {
  uint32 id;   // index of start of completed descriptor chain
  uint32 len;
};

struct virtq_used {
  uint16 flags; // always zero
  uint16 idx;   // device increments when it adds a ring[] entry
  struct virtq_used_elem ring[NUM];
};

// these are specific to virtio block devices, e.g. disks,
// described in Section 5.2 of the spec.

#define VIRTIO_BLK_T_IN  0 // read the disk
#define VIRTIO_BLK_T_OUT 1 // write the disk

// the format of the first descriptor in a disk request.
// to be followed by two more descriptors containing
// the block, and a one-byte status.
struct virtio_blk_req {
  uint32 type; // VIRTIO_BLK_T_IN or ..._OUT
  uint32 reserved;
  uint64 sector;
};

struct virtq {
  struct virtq_desc *desc;
  struct virtq_avail *driver_area; // extra data from driver to device
  struct virtq_used *device_area;  // extra data from device to driver
  int num;
  char free[NUM];
  int used_idx;
};

struct virtio_net_config {
  uint8 mac[6];
  uint16 status;
  uint16 max_virtqueue_pairs;
  uint16 mtu;
};

// I want to hold the driver state separate from the device state,
// virtio_net_config. This is because the driver has more data
// that it needs to track than the device does, so I should
// create a separate struct
struct virtio_net {
  struct virtio_net_config cfg;
  struct spinlock vnet_lock;
  struct virtq txq;
  struct virtq rxq;
};

// virtio_net API
void transmit_packet(void *pkt_data, uint16 pkt_len, uint16 protocol);
uint16 receive_packet(void *pkt_buf, uint16 num_bytes);
