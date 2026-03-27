
#ifndef TCP_H
#define TCP_H

#include "types.h"

#define DEFAULT_SEQ_NUM 1337 // I don't currently have a way of generating a random number
#define DEFAULT_WINDOW 1024

/* tcp flags */
#define URG 0x80
#define ACK 0x40
#define PSH 0x20
#define RST 0x10
#define SYN 0x08
#define FIN 0x04

/* tcp protocol */
#define IPPROTO_TCP 6
#define IPPROTO_UDP 17


struct tcp_hdr {
  uint16 src_port;
  uint16 dst_port;
  uint32 seq_num;
  uint32 ack_num;
  uint8 data_offset;
  uint8 flags;
  uint16 window;
  uint16 csum;
  uint16 urgent_ptr;
} __attribute__((packed));

struct tcp_frame {
  struct tcp_hdr hdr;
  uint8 payload[1500];
  int payload_len;
  struct tcp_frame *next;
} __attribute__((packed));


int tcp_bind(struct socket *sock, const struct sockaddr *address, socklen_t address_len);
int tcp_connect(struct socket *sock, const struct sockaddr *address, socklen_t address_len);
int tcp_listen(struct socket *sock, int backlog);
int tcp_accept(struct socket *sock, const struct sockaddr *address, socklen_t address_len);
int tcp_close(struct socket *sock);

void build_tcp(struct tcp_frame *tcp, uint16 src_port, uint16 dst_port, uint32 seq_num,
          uint32 ack_num, uint8 flags, uint16 window, uint8 *payload, int payload_len,
          uint32 src_ip, uint32 dst_ip);
int parse_tcp_packet(uint8 *buf, int len, struct tcp_frame *tcp_pkt);
void syn_ack(uint16 src_port, uint32 dst_ip, uint16 dst_port, uint32 seq_num);
int handle_tcp_packet(struct tcp_frame *tcp_pkt);

#endif

