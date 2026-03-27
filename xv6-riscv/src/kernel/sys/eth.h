
#ifndef ETH_H
#define ETH_H

struct eth_hdr {
  uint8 dst_addr[6];
  uint8 src_addr[6];
  uint16 type;
} __attribute__((packed));

struct eth_frame {
  struct eth_hdr hdr;
  uint8 payload[1500];
  uint8 payload_len;
} __attribute__((packed));

int parse_eth_packet(uint8 *buf, int len, struct eth_frame *eth_frame);
void build_eth(struct eth_frame *eth, uint8 *dst, uint8 *src, uint16 type);

#endif
