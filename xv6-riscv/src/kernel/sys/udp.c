#include "../types.h"
#include "../riscv.h"
#include "../defs.h"
#include "../spinlock.h"
#include "../sleeplock.h"
#include "../fs.h"
#include "../file.h"
#include "../param.h"
#include "../proc.h"
#include "arp.h"
#include "net_utils.h"
#include "net.h"
#include "eth.h"
#include "ip4.h"
#include "socket.h"
#include "udp.h"

void
build_udp(struct udp_frame *udp, uint16 src_port, uint16 dst_port, uint8 *payload, int payload_len, uint32 src_ip, uint32 dst_ip)
{
  udp->hdr.src_port = htons(src_port);
  udp->hdr.dst_port = (dst_port);
  udp->hdr.len = htons(payload_len + UDP_HDR_SIZE);
  udp->payload_len = payload_len;
  memmove(udp->payload, payload, payload_len);
  udp->hdr.csum = 0;
  udp->hdr.csum = udp_checksum(src_ip, dst_ip, &udp->hdr, udp->payload, payload_len);
}

void
enqueue_udp_packet(struct udp_frame *pkt, struct socket *sock) 
{
  if (sock->rx_head == 0) {
    sock->rx_head = pkt;
    sock->rx_tail = pkt;
  } else {
    struct udp_frame *temp = sock->rx_tail;
    sock->rx_tail = pkt;
    pkt->next = temp;
  }
  wakeup(&sock->rx_head);
}

struct udp_frame*
dequeue_udp_packet(struct socket *sock)
{
  struct udp_frame *ret = 0;

  if (sock->rx_head) {
    ret = sock->rx_head;
    sock->rx_head = ret->next;
    if (sock->rx_head == 0)
      sock->rx_tail = 0;   // queue is now empty
  }
  return ret;   // caller owns ret and must free after use}
}

int 
udp_bind(struct socket *sock, const struct sockaddr *sock_address, socklen_t addrlen) {
  if (sock == 0) {
    printf("bind: socket == 0\n");
    return -1;
  } else if (sock_address == 0) {
    printf("bind: sock_address == 0\n");
    return -1;
  }

  const struct sockaddr_in *sockaddr = (struct sockaddr_in *)sock_address;
  uint16 port = ntohs(sockaddr->sin_port);

  if(port <= 0 || port >= MAX_PORT_BINDINGS) {
    printf("bind: port number %d not valid within range\n", port);
    return -1;
  } else if (udp_port_binds[port]) {
    printf("bind: port number already bound\n");
    return -1;
  }

  switch(sock->family) {
    case(AF_INET):
      if (addrlen != sizeof(struct sockaddr_in)) {
        printf("bind: incorrect addrlen for ipv4\n");
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
      sock->state = BOUND;
      return 0;
    default:
      return -1;
  }

  return 0;
}

int 
udp_connect(struct socket *sock, const struct sockaddr *addr, socklen_t addrlen)
{
  return 0;
}

int
udp_close(struct socket *sock)
{
  return 0;
}

int 
udp_sendto(struct socket *sock, const char *buf, int len, int flags, 
    const struct sockaddr *dest, socklen_t addrlen)
{
  struct sockaddr_in kaddr;
  if (addrlen < sizeof(kaddr))
    return -1;

  if (copyin(myproc()->pagetable, (char *)&kaddr, (uint64)dest, sizeof(kaddr)) < 0)
    return -1;

  uint32 dst_ip = (&kaddr)->sin_addr.s_addr;
  uint8 dst_mac[6];
  if (arp_lookup(dst_ip, dst_mac) == -1) {
    arp_request(dst_ip);
    while (arp_lookup(dst_ip, dst_mac) == -1) {
    }
  }

  char kbuf[1500];
  if (len > 1500) return -1;
  if (copyin(myproc()->pagetable, kbuf, (uint64)buf, len) < 0)
    return -1;

  struct eth_frame *eth = kalloc();
  struct ip4_frame *ip = (struct ip4_frame *)eth->payload;
  struct udp_frame *udp = (struct udp_frame *)ip->payload;

  build_udp(udp, sock->src_port, ((struct sockaddr_in *)&kaddr)->sin_port, (uint8 *)kbuf, len, netconf.ip_addr, dst_ip);
  build_ip4(ip, ntohl(netconf.ip_addr), ntohl(dst_ip), IPPROTO_UDP, len + sizeof(struct udp_hdr) + sizeof(struct ip4_hdr));
  build_eth(eth, dst_mac, netconf.mac_addr, PROTO_IPV4);

  transmit_packet(eth, len + sizeof(struct udp_hdr) + sizeof(struct ip4_hdr) + sizeof(struct eth_hdr), PROTO_IPV4);
  kfree(eth);
  eth = 0;
  ip = 0;
  udp = 0;

  return 0;
}

int 
udp_recvfrom(struct socket *sock, char *buf, int len, int flags,
    const struct sockaddr *src, socklen_t *addrlen)
{
  struct udp_frame *pkt = 0;
  acquire(&sock->lock);
  while (!sock->rx_head) {
    sleep(&sock->rx_head, &sock->lock);
  }
  // printf("received a packet!\n");
  pkt = dequeue_udp_packet(sock);

  int payload_len = len - sizeof(struct udp_hdr);
  release(&sock->lock);

  // Copy payload
  int n;
  if (pkt->payload_len < len) {
    n = pkt->payload_len;
  } else {
    n = len;
  }

  if (copyout(myproc()->pagetable, (uint64)buf, (char *)pkt->payload, pkt->payload_len) < 0) {;;
      kfree(pkt);
      return -1;;
  }

  kfree(pkt);
  return n;
}

int 
handle_udp_packet(struct udp_frame *udp_pkt) 
{
  // printf("\tUDP packet: src_port=%d dst_port=%d len=%d csum=%d\n",
      // udp_pkt->hdr.src_port, udp_pkt->hdr.dst_port, udp_pkt->hdr.len, udp_pkt->hdr.csum);

  // validate the port number
  if (udp_pkt->hdr.dst_port < 0 || udp_pkt->hdr.dst_port >= MAX_PORT_BINDINGS) 
    return -1;

  // validate the socket is listening for datagrams
  if (udp_port_binds[udp_pkt->hdr.dst_port] == 0) {
    printf("port is not bound to socket\n");
    return -1;
  };

  struct socket *sock = udp_port_binds[udp_pkt->hdr.dst_port]->sock;
  if (sock->proto == IPPROTO_UDP) {
    // printf("enqeueing packet\n");
    enqueue_udp_packet(udp_pkt, sock);
  }
  return 0;
}

int 
parse_udp_packet(uint8 *buf, int len, struct udp_frame *udp_pkt) 
{
  if (len < 8) return -1;  // too short for UDP header

  udp_pkt->hdr.src_port = ntohs(*(uint16 *)(buf));
  udp_pkt->hdr.dst_port = ntohs(*(uint16 *)(buf + 2));
  udp_pkt->hdr.len      = ntohs(*(uint16 *)(buf + 4));
  udp_pkt->hdr.csum     = ntohs(*(uint16 *)(buf + 6));

  if (udp_pkt->hdr.len < 8 || udp_pkt->hdr.len > len)
      return -1;  // malformed length

  udp_pkt->payload_len = len - sizeof(struct udp_hdr);
  memmove(udp_pkt->payload, buf + sizeof(struct udp_hdr), udp_pkt->payload_len);

  return 0;
}

