#ifndef UDP_H
#define UDP_H

#include "types.h"

#define UDP_HDR_SIZE sizeof(struct udp_hdr)

struct udp_hdr {
  uint16 src_port;
  uint16 dst_port; 
  uint16 len;
  uint16 csum;
} __attribute__((packed));

struct udp_frame {
  struct udp_hdr hdr;
  uint8 payload[1500];
  int payload_len;
  struct udp_frame *next;
} __attribute__((packed));

int udp_sendto(struct socket *sock, const void *msg, int len, int flags,
    const struct sockaddr *to, socklen_t dest_len);
int udp_recvfrom(struct socket *sock, void *buf, int len, int flags,
    const struct sockaddr *from, socklen_t *src_len);

int udp_bind(struct socket *sock, const struct sockaddr *address, socklen_t address_len);
int udp_connect(struct socket *sock, const struct sockaddr *address, socklen_t address_len);
int udp_close(struct socket *sock);

int handle_udp_packet(struct udp_frame *udp_pkt);
int parse_udp_packet(uint8 *buf, int len, struct udp_frame *udp_pkt);

#endif
