#include "../types.h"
#include "../riscv.h"
#include "../defs.h"
#include "../spinlock.h"
#include "../sleeplock.h"
#include "../fs.h"
#include "../file.h"
#include "socket.h"
#include "eth.h"
#include "tcp.h"
#include "net_utils.h"
#include "net.h"
#include "ip4.h"

int 
tcp_bind(struct socket *sock, const struct sockaddr *addr, socklen_t addrlen) {
  if (socket < 0) {
    printf("bind: socket == 0\n");
    return -1;
  } else if (addr == 0) {
    printf("bind: addr == 0\n");
    return -1;
  }

  const struct sockaddr_in *sockaddr = (struct sockaddr_in *)addr;
  uint16 port = ntohs(sockaddr->sin_port);

  if(sockaddr->sin_port < 0 || sockaddr->sin_port > MAX_PORT_BINDINGS) {
    printf("bind: port number %d not valid within range\n", sockaddr->sin_port);
    return -1;
  } else if (tcp_port_binds[port]) {
    printf("bind: port number already bound\n");
    return -1;
  }

  sock->family = addr->sa_family;

  switch(sock->family) {
    case(AF_INET):
      if (addrlen != sizeof(struct sockaddr_in)) {
        printf("bind: incorrect addrlen for ipv4\n");
        return -1;
      }

      if (tcp_port_binds[port]) {
        printf("bind: port %d in use\n", port);
        return -1;
      }

      struct port_binding *binding = (struct port_binding*) kalloc();
      if (binding == 0) {
        printf("ERROR: kalloc\n");
        return -1;
      }
      binding->port = port;
      if (sockaddr->sin_addr.s_addr == INADDR_ANY) {
        sock->src_ip = netconf.ip_addr;
        binding->ip_addr = netconf.ip_addr;
      } else {
        binding->ip_addr = sockaddr->sin_addr.s_addr;
        sock->src_ip = sockaddr->sin_addr.s_addr;
      }

      binding->sock = sock;

      if (insert_port_binding(binding) == -1){
        printf("bind: failed to bind to port\n");
        kfree(binding);
        return -1;
      }

      sock->src_port = port;
      sock->family = sockaddr->sin_family;
      sock->state = BOUND;
      break;
    default:
      return -1;
  }

  return 0;
}

int 
tcp_connect(struct socket *sock, const struct sockaddr *addr, socklen_t addrlen)
{
  return 0;
}

int 
tcp_listen(struct socket *sock, int backlog)
{
  if (sock->type != SOCK_STREAM)  {
    printf("listen: cannot listen from a UDP socket\n");
    return -1;
  } else if (!(sock->state == BOUND)) {
    printf("listen: socket is not bound\n");
    return -1;
  } 

  sock->state = LISTENING;
  return 0;
}

int 
tcp_accept(struct socket *sock, const struct sockaddr *addr, socklen_t addrlen)
{
  return 0;
}

int
tcp_close(struct socket *sock)
{
  return 0;
}

void 
build_tcp(struct tcp_frame *tcp, uint16 src_port, uint16 dst_port, uint32 seq_num,
          uint32 ack_num, uint8 flags, uint16 window, uint8 *payload, int payload_len,
          uint32 src_ip, uint32 dst_ip)
{
  tcp->hdr.src_port = htons(src_port);
  tcp->hdr.dst_port = htons(dst_port);
  tcp->hdr.seq_num = htonl(seq_num);
  tcp->hdr.ack_num = htonl(ack_num);
  tcp->hdr.data_offset = (5 << 4);   // header len = 20 bytes
  tcp->hdr.flags = flags;
  tcp->hdr.window = htons(window);
  tcp->hdr.csum = 0;
  tcp->hdr.urgent_ptr = 0;

  memmove(tcp->payload, payload, payload_len);
  tcp->payload_len = payload_len;

  // tcp->hdr->csum = tcp_checksum(tcp, src_ip, dst_ip);
}

int parse_tcp_packet(uint8 *buf, int len, struct tcp_frame *tcp_pkt) {
  if (len < 20) return -1; // minimum TCP header

  tcp_pkt->hdr.src_port = ntohs(*(uint16*)(buf));
  tcp_pkt->hdr.dst_port = ntohs(*(uint16*)(buf+2));
  tcp_pkt->hdr.seq_num  = ntohl(*(uint32*)(buf+4));
  tcp_pkt->hdr.ack_num  = ntohl(*(uint32*)(buf+8));
  tcp_pkt->hdr.data_offset = (buf[12] >> 4) & 0xF;
  tcp_pkt->hdr.flags = buf[13];
  tcp_pkt->hdr.window = ntohs(*(uint16*)(buf+14));
  tcp_pkt->hdr.csum = ntohs(*(uint16*)(buf+16));
  tcp_pkt->hdr.urgent_ptr = ntohs(*(uint16*)(buf+18));

  int hdr_len = tcp_pkt->hdr.data_offset * 4;
  if (hdr_len < 20 || hdr_len > len) return -1;

  tcp_pkt->payload_len = len - hdr_len;
  memmove(tcp_pkt->payload, buf + hdr_len, tcp_pkt->payload_len);

  return 0;
}

int 
syn(uint16 src_port, uint32 dst_ip, uint16 dst_port, uint32 seq_num) 
{
  uint8 DEFAULT_MAC[6] = {0x63, 0xb0, 0xce, 0xf6, 0xeb, 0x50};

  struct tcp_frame *syn_tcp = kalloc();
  if (syn_tcp == 0) {
    printf("ERROR: kalloc");
    return -1;
  }
  struct ip4_frame *ip = kalloc();
  if (ip == 0) {
    printf("ERROR: kalloc");
    return -1;
  }
  struct eth_frame *eth = kalloc();
  if (eth == 0) {
    printf("ERROR: kalloc");
    return -1;
  }

  build_tcp(syn_tcp, src_port, dst_port, DEFAULT_SEQ_NUM, seq_num + 1, SYN & ACK,
            DEFAULT_WINDOW, 0, 0, netconf.ip_addr, dst_ip);
  build_ip4(ip, netconf.ip_addr, dst_ip, IPPROTO_TCP, sizeof(struct tcp_hdr));
  build_eth(eth, DEFAULT_MAC, netconf.mac_addr, PROTO_IPV4);

  ip->payload_len = sizeof(struct tcp_hdr);
  memmove(ip->payload, syn_tcp, ip->payload_len);

  eth->payload_len = sizeof(struct ip4_hdr);
  memmove(eth->payload, ip, eth->payload_len);

  transmit_packet((uint8 *)eth, eth->payload_len + sizeof(struct eth_hdr), PROTO_IPV4);
  
  return 0;
}

int 
handle_tcp_packet(struct tcp_frame *tcp_pkt) 
{
  printf("TCP packet: src_port=%d dst_port=%d seq=%d ack=%d\n",
      tcp_pkt->hdr.src_port, tcp_pkt->hdr.dst_port, tcp_pkt->hdr.seq_num, tcp_pkt->hdr.ack_num);
  
  // verify the dest port is open
  struct port_binding *port_bind = tcp_port_binds[tcp_pkt->hdr.dst_port];
  if (port_bind == 0) {
    return -1;
  } else {
    printf("port_bind->port=%d port_bind.ip4_addr=%d port_bind->sock.state=%d",
        port_bind->port, port_bind->ip_addr, port_bind->sock->state);
  }

  if (tcp_pkt->hdr.flags & SYN && tcp_pkt->hdr.flags & ACK) {
    printf("SYN+ACK received!\n");

  } else if (tcp_pkt->hdr.flags & SYN) {
    printf("SYN received!\n");

    // verify that it's sending to a tcp socket
    if (port_bind->sock->type != IPPROTO_TCP) {
      return -1;
    }

    // verify the dest port is listening for connections
    if (port_bind->sock->state != LISTENING) {
      return -1;
    }
    
    // change the state of the socket
    port_bind->sock->state = SYN_RECVD;

    // syn(port_bind->ip4_addr, port_bind->port);
  
  } else if (tcp_pkt->hdr.flags & ACK) {
    printf("ACK received!\n");
  }
  
  return 0;
}


