#include "types.h"
#include "riscv.h"
#include "defs.h"
#include "param.h"
#include "spinlock.h"
#include "memlayout.h"
#include "virtio.h"

// address of the virtio mmio register r.
#define R(r) ((volatile uint32 *)(VIRTIO1 + (r)))

#define VIRTIO_NET_CONFIG ((volatile uint8 *) (VIRTIO1 + 0x100))

#define QUEUE_RX 0
#define QUEUE_TX 1

#define VIRTIO_NET_S_LINK_UP     1 
#define VIRTIO_NET_S_ANNOUNCE    2
#define VIRTIO_NET_HDR_GSO_NONE        0 

#define HDR_SIZE sizeof(struct virtio_net_hdr)

uint8 *packet_buf;

struct virtio_net_hdr { 
  uint8 flags; 
  uint8 gso_type; 
  uint16 hdr_len; 
  uint16 gso_size; 
  uint16 csum_start; 
  uint16 csum_offset; 
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
} net;

/*
 * This function takes a virtqueue for which a descriptor needs to be allocated
 * and allocates a decsriptor
 *
 * Input:
 *     struct virtq *q: a pointer to a virtqueue
 * 
 * Output: returns the index of the descriptor on success
 *         returns -1 if there are no free descriptors
 *
 */
int alloc_desc(struct virtq *q) {
  for (int i = 0; i < NUM; i++) {
    if (q->free[i]) {
      q->free[i] = 0;
      return i;
    }
  }
  return -1;
}

/*
 * This function takes a virtqueue and an array index and frees the descriptor in 
 * the virtqueue at the given index.
 *
 * Input:
 *     struct virtq *q: a pointer to a virtqueue which has had a descriptor allocated.
 *     int i: the index at which a descriptor has been allocated in q
 * 
 * Output: None
 *
 */
void free_desc(struct virtq *q, int i) {
  if (i >= NUM)
    panic("free_desc 1");
  if (q->free[i])
    panic("free_desc 2");

  q->desc->addr = 0;
  q->desc->len = 0;
  q->desc->flags = 0;
  q->desc->next = 0;
  wakeup(&q->free[i]);
}

/*
 * The purpose of this function is to initialize the connection with the
 * VirtualIO (VIRTIO) device. The process of this function is defined in 
 * section 5.1.5 of the VIRTIO Device specification. Since I'm creating
 * a minimal netowrk driver, I only negotiate VIRTIO_NET_F_MAC
 *
 */
void virtio_net_init(void) {
  uint32 status = 0;
  initlock(&net.vnet_lock, "virtio_net");

  if (*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
      *R(VIRTIO_MMIO_VERSION) != 2 || 
      *R(VIRTIO_MMIO_DEVICE_ID) != 1 ||
      *R(VIRTIO_MMIO_VENDOR_ID) != 0x554d4551) {
    panic("could not find virtio net");
  }

  // reset device
  *R(VIRTIO_MMIO_STATUS) = status;

  // set ACKNOWLEDGE status bit
  status |= VIRTIO_CONFIG_S_ACKNOWLEDGE;
  *R(VIRTIO_MMIO_STATUS) = status;

  // set DRIVER status bit
  status |= VIRTIO_CONFIG_S_DRIVER;
  *R(VIRTIO_MMIO_STATUS) = status;
  
  // This copies the memory from the config into my driver state struct
  memmove((void *)&net.cfg, (void *)VIRTIO_NET_CONFIG, sizeof(struct virtio_net_config));

  // Negotiate the feature bits
  uint64 features = *R(VIRTIO_MMIO_DEVICE_FEATURES);
  features &= VIRTIO_NET_F_MAC;
  *R(VIRTIO_MMIO_DRIVER_FEATURES) = features;

  // Tell device that feature negotiation is complete
  status |= VIRTIO_CONFIG_S_FEATURES_OK;
  *R(VIRTIO_MMIO_STATUS) = status;

  // Make sure that FEATURES_OK is set
  status = *R(VIRTIO_MMIO_STATUS);
  if (!(status & VIRTIO_CONFIG_S_FEATURES_OK))
    panic("virtio net FEATURES_OK unset");

  // Check max queue size
  uint32 max_queue_size = *R(VIRTIO_MMIO_QUEUE_NUM_MAX);
  if (max_queue_size == 0)
    panic("virtio net has no queue 1 (QUEUE_TX)");
  if (max_queue_size < NUM) 
    panic("virtio net max queue too short");

  /* Initialize QUEUE_TX */
  *R(VIRTIO_MMIO_QUEUE_SEL) = QUEUE_TX;
  net.txq.num = QUEUE_TX;

  // ensure QUEUE_TX is not in use.
  if (*R(VIRTIO_MMIO_QUEUE_READY))
    panic("QUEUE_TX should not be ready\n");

  net.txq.desc = kalloc();
  net.txq.driver_area = kalloc();
  net.txq.device_area = kalloc();
  if (!net.txq.desc || !net.txq.driver_area || !net.txq.device_area) 
    panic("virtio net alloc\n");
  memset(net.txq.desc, 0, PGSIZE);
  memset(net.txq.free, 1, NUM);
  memset(net.txq.driver_area, 0, PGSIZE);
  memset(net.txq.device_area, 0, PGSIZE);

  // set queue size
  *R(VIRTIO_MMIO_QUEUE_NUM) = NUM;

  // init virtqueue
  *R(VIRTIO_MMIO_QUEUE_DESC_LOW) = (uint64)net.txq.desc;
  *R(VIRTIO_MMIO_QUEUE_DESC_HIGH) = ((uint64)net.txq.desc) >> 32;
  *R(VIRTIO_MMIO_DRIVER_DESC_LOW) = (uint64)net.txq.driver_area;
  *R(VIRTIO_MMIO_DRIVER_DESC_HIGH) = ((uint64)net.txq.driver_area) >> 32;
  *R(VIRTIO_MMIO_DEVICE_DESC_LOW) = (uint64)net.txq.device_area;
  *R(VIRTIO_MMIO_DEVICE_DESC_HIGH) = ((uint64)net.txq.device_area) >> 32;

  *R(VIRTIO_MMIO_QUEUE_READY) = 0x1;

  /* Initialize QUEUE_RX */

  *R(VIRTIO_MMIO_QUEUE_SEL) = QUEUE_RX;
  net.rxq.num = QUEUE_RX;
  if (*R(VIRTIO_MMIO_QUEUE_READY))
    panic("QUEUE_RX should not be ready\n");

  net.rxq.desc = kalloc();
  net.rxq.driver_area = kalloc();
  net.rxq.device_area = kalloc();
  if (!net.rxq.desc || !net.rxq.driver_area || !net.rxq.device_area) 
    panic("virtio net alloc");
  memset(net.rxq.desc, 0, PGSIZE);
  memset(net.rxq.free, 1, NUM);
  memset(net.rxq.driver_area, 0, PGSIZE);
  memset(net.rxq.device_area, 0, PGSIZE);

  // set queue size
  *R(VIRTIO_MMIO_QUEUE_NUM) = NUM;

  // init virtqueue
  *R(VIRTIO_MMIO_QUEUE_DESC_LOW) = (uint64)net.rxq.desc;
  *R(VIRTIO_MMIO_QUEUE_DESC_HIGH) = ((uint64)net.rxq.desc) >> 32;
  *R(VIRTIO_MMIO_DRIVER_DESC_LOW) = (uint64)net.rxq.driver_area;
  *R(VIRTIO_MMIO_DRIVER_DESC_HIGH) = ((uint64)net.rxq.driver_area) >> 32;
  *R(VIRTIO_MMIO_DEVICE_DESC_LOW) = (uint64)net.rxq.device_area;
  *R(VIRTIO_MMIO_DEVICE_DESC_HIGH) = ((uint64)net.rxq.device_area) >> 32;

  for (int i = 0; i < NUM/2; i++) {
    int rx_hdr_desc = alloc_desc(&net.rxq);
    int rx_desc = alloc_desc(&net.rxq);
    void *rxbuf = kalloc();
    struct virtio_net_hdr *hdr = kalloc();
    if (!rxbuf) panic("rxbuf alloc failed");

    net.rxq.desc[rx_hdr_desc].addr = (uint64)hdr;
    net.rxq.desc[rx_hdr_desc].len = sizeof(struct virtio_net_hdr);
    net.rxq.desc[rx_hdr_desc].flags = VRING_DESC_F_NEXT;
    net.rxq.desc[rx_hdr_desc].next = rx_desc;

    net.rxq.desc[rx_desc].addr = (uint64)rxbuf;
    net.rxq.desc[rx_desc].len = PGSIZE;
    net.rxq.desc[rx_desc].flags = VRING_DESC_F_WRITE;

    net.rxq.driver_area->ring[net.rxq.driver_area->idx % NUM] = rx_hdr_desc;
    __sync_synchronize();
    net.rxq.driver_area->idx++;
    __sync_synchronize();
  }
  
  // queue is ready
  *R(VIRTIO_MMIO_QUEUE_READY) = 0x1;

  // Notify device
  *R(VIRTIO_MMIO_QUEUE_NOTIFY) = QUEUE_RX;

  // Done initializing
  status |= VIRTIO_CONFIG_S_DRIVER_OK;
  *R(VIRTIO_MMIO_STATUS) = status;

  // initialize packet buffer
  packet_buf = kalloc();
}

/*
 * The purpose of this function is to pad ethernet packets to ensure that the
 * packets are always at least 64 bytes long. This restriction is in place for
 * the sake of detecting collisions in the network
 *
 * Input: 
 *     uint8 num_bytes: the number of bytes needed to pad the packet.
 *
 * Output:
 *      return 0 on success
 *      return 1 when the number of bytes calculated does not make sense
 */
int apply_padding(uint8 num_bytes) {
  uint8 *pkt_ptr = packet_buf + sizeof(struct virtio_net_hdr) + (64 - num_bytes);
  if (num_bytes > 64 - sizeof(struct virtio_net_hdr) || num_bytes < 1) {
    printf("malformed packet data");
    return 1;
  }
  for (int i = 0; i < num_bytes; i++) {
    pkt_ptr[i] = 0;
  }
  return 0;
}

/*
 * This function allocates descriptors for an ethernet packet, creates the
 * packet header, and gives the NIC a reference to the packet so that it may 
 * send it over ethernet. It calls the apply_padding() function if the packet
 * data would not make the packet at least 64 bytes.
 *
 * Input:
 *     void *pkt_data: the data to be transmitted over the wire
 *     uint16 pkt_len: the length of the data to be transmitted. The max length
 *                     of the data is 1500 (defined by the ethernet protocol)
 *
 * Output: There is no return value from the function, but the packet frame
 *         is given to the NIC to be transmitted.
 */
void transmit_packet(void *pkt_data, uint16 pkt_len) {
  /* Create the header for transmission */
  acquire(&net.vnet_lock);
  *R(VIRTIO_MMIO_QUEUE_SEL) = QUEUE_TX;
  // allocate for packet header and packet_frame
  struct virtio_net_hdr *hdr = kalloc();
  if (hdr == 0) 
    panic("failed to allocate header\n");
  // initialize the header and packet
  memset(hdr, 0, PGSIZE);

  int hdr_desc = alloc_desc(&net.txq);
  int pkt_desc = alloc_desc(&net.txq);

  hdr->flags = 0;
  hdr->gso_type = VIRTIO_NET_HDR_GSO_NONE;
  hdr->hdr_len = 0;
  
  memmove(packet_buf , "\x02\xf3\xa5\x02\x3a\xb8", 6);
  memmove(packet_buf + 6, net.cfg.mac, 6);
  packet_buf[12] = 0x7a;
  packet_buf[13] = 0x05;
  memmove(packet_buf + 14, pkt_data, pkt_len);

  net.txq.desc[hdr_desc].flags |= VRING_DESC_F_NEXT; // This tells the device it's a chain
  net.txq.desc[hdr_desc].len =  HDR_SIZE;
  net.txq.desc[hdr_desc].addr = (uint64)hdr;
  net.txq.desc[hdr_desc].next = pkt_desc;

  net.txq.desc[pkt_desc].len = 14 + pkt_len;
  net.txq.desc[pkt_desc].addr = (uint64)packet_buf;
  net.txq.desc[pkt_desc].flags = 0;

  if (pkt_len < 64) {
    int res = apply_padding(64 - pkt_len);
    net.txq.desc[pkt_desc].len = 64;
    if (res != 0) 
      panic("failed to apply padding");
  }
  
  // Tell the device first index in chain of descriptors
  net.txq.driver_area->ring[net.txq.driver_area->idx % NUM] = hdr_desc;
  __sync_synchronize();
  // Tell the device another avail ring entry is available
  net.txq.driver_area->idx++;
  __sync_synchronize();

  uint16 prev_used_idx = net.txq.device_area->idx;
  *R(VIRTIO_MMIO_QUEUE_NOTIFY) = QUEUE_TX;
  release(&net.vnet_lock);

  // Wait for the device to use the descriptor. It indicates this by decrementing
  // the index. Polling helps to avoid race conditions
  while (net.txq.device_area->idx == prev_used_idx) {
    __sync_synchronize();
  }
  printf("mac: %x:%x:%x:%x:%x:%x\n", net.cfg.mac[0], net.cfg.mac[1], net.cfg.mac[2], net.cfg.mac[3], net.cfg.mac[4], net.cfg.mac[5]);
}

uint16 receive_packet(void *pkt_buf, uint16 num_bytes) {
  acquire(&net.vnet_lock);
  while (net.rxq.used_idx != net.rxq.device_area->idx) {
    int id = net.rxq.device_area->ring[net.rxq.used_idx % NUM].id;
    uint len = net.rxq.device_area->ring[net.rxq.used_idx % NUM].len;

    char *packet = (char *)net.rxq.desc[net.rxq.desc[id].next].addr;

    printf("Interrupt: received packet of length %d\n", len - 10);
    // Optional: do something with 'packet'
    
    for (int i = 0; i < len; i++) {
      printf("%x", packet[i]);
    } 

    // Requeue the buffer
    net.rxq.driver_area->ring[net.rxq.driver_area->idx % NUM] = id;
    __sync_synchronize();
    net.rxq.driver_area->idx++;
    net.rxq.used_idx++;
  }
  release(&net.vnet_lock);
}





