
#ifndef IP4_H
#define IP4_H

#include "types.h"

struct ip4_hdr {
  uint8 ver_ihl; // upper 4 vits version, lower 4 bits IHL
  uint8 tos; 
  uint16 total_len; 

  uint16 identification; 
  uint16 fragment_info; // 3 bits flags, 13 bits fragment offset

  uint8 ttl; 
  uint8 protocol; 
  uint16 hdr_csum; 

  uint32 src_ip; 
  uint32 dst_ip;
} __attribute__((packed));

struct ip4_frame {
  struct ip4_hdr hdr;
  uint8 payload[1500];
  uint16 payload_len;
} __attribute__((packed));

void print_ip4_packet(struct ip4_frame *ip);
int parse_ip4_packet(uint8 *buf, int len, struct ip4_frame *pkt);
void build_ip4(struct ip4_frame *ip, uint32 src, uint32 dst, uint8 proto, uint16 len);
int handle_ip4_packet(struct ip4_frame *ip_pkt);

#endif
