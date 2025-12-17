#include "../types.h"
#include "../riscv.h"
#include "../defs.h"
#include "../spinlock.h"
#include "net.h"
#include "tcp.h"
#include "udp.h"
#include "ip4.h"

void 
print_ip4_packet(struct ip4_frame *ip)
{
  printf("\n");
  printf("IPv%d packet from %d.%d.%d.%d to %d.%d.%d.%d",
      ip->hdr.ver_ihl >> 4,
      (ip->hdr.src_ip >> 24) & 0xFF, (ip->hdr.src_ip >> 16) & 0xFF,
      (ip->hdr.src_ip >> 8) & 0xFF,  ip->hdr.src_ip & 0xFF,
      (ip->hdr.dst_ip >> 24) & 0xFF, (ip->hdr.dst_ip >> 16) & 0xFF,
      (ip->hdr.dst_ip >> 8) & 0xFF,  ip->hdr.dst_ip & 0xFF);
  switch(ip->hdr.protocol) {
    case(IPPROTO_TCP):
      printf(", proto TCP");
      break;
    case(IPPROTO_UDP):
      printf(", proto UDP");
      break;
    default:
      printf("unsupported protocol\n");
      break;
  }
  printf(", payload %d bytes\n", ip->payload_len);
  printf("\n");
}

int 
parse_ip4_packet(uint8 *buf, int len, struct ip4_frame *pkt)
{
  // printf("\tparsing ip packet\n");

  pkt->hdr.ver_ihl = buf[0];
  pkt->hdr.tos = buf[1];
  pkt->hdr.total_len = ntohs(*(uint16 *)(buf + 2));
  pkt->hdr.identification = ntohs(*(uint16 *)(buf + 4));
  pkt->hdr.fragment_info = ntohs(*(uint16 *)(buf + 6));
  pkt->hdr.ttl = buf[8];
  pkt->hdr.protocol = buf[9];
  pkt->hdr.hdr_csum = ntohs(*(uint16 *)(buf + 10));
  pkt->hdr.src_ip = ntohl(*(uint32 *)(buf + 12));
  pkt->hdr.dst_ip = ntohl(*(uint32 *)(buf + 16));
  
  pkt->hdr.ver_ihl = buf[0];
  pkt->hdr.tos = buf[1];
  pkt->hdr.total_len = ntohs(*(uint16 *)(buf + 2));
  pkt->hdr.identification = ntohs(*(uint16 *)(buf + 4));
  pkt->hdr.fragment_info = ntohs(*(uint16 *)(buf + 6));
  pkt->hdr.ttl = buf[8];
  pkt->hdr.protocol = buf[9];
  pkt->hdr.hdr_csum = ntohs(*(uint16 *)(buf + 10));
  pkt->hdr.src_ip = ntohl(*(uint32 *)(buf + 12));
  pkt->hdr.dst_ip = ntohl(*(uint32 *)(buf + 16));

  int hdr_len = (pkt->hdr.ver_ihl & 0x0F) * 4;
  if (hdr_len < 20 || hdr_len > len) return -1;
  // printf("\tvalid packet\n");
  if (pkt->hdr.total_len > len) return -1;

  pkt->payload_len = len - hdr_len;
  memmove(pkt->payload, buf + hdr_len, pkt->payload_len);

  return 0;
}


void
build_ip4(struct ip4_frame *ip, uint32 src, uint32 dst, uint8 proto, uint16 len)
{
  ip->hdr.ver_ihl = (4 << 4) | (5);  // v4 + IHL=5 (20 bytes)
  ip->hdr.tos = 0;
  ip->hdr.total_len = htons(len);
  ip->hdr.identification = htons(0);   // you can increment per packet
  ip->hdr.fragment_info = htons(0);
  ip->hdr.ttl = 64;
  ip->hdr.protocol = proto;
  ip->hdr.hdr_csum = 0;
  ip->hdr.src_ip = htonl(src);
  ip->hdr.dst_ip = htonl(dst);
  // ip->hdr_csum = ip4_checksum((uint16*)ip, sizeof(struct ip4_hdr));
}

int 
handle_ip4_packet(struct ip4_frame *ip4_pkt) 
{
  switch(ip4_pkt->hdr.protocol) {
    case IPPROTO_TCP:
      struct tcp_frame *tcp = kalloc();
      if (tcp < 0)
        return -1;
      memset(tcp, 0, PGSIZE);
      if (parse_tcp_packet(ip4_pkt->payload, ip4_pkt->payload_len, tcp) == 0) {
        handle_tcp_packet(tcp);
      }
      break;
    case IPPROTO_UDP:
      struct udp_frame *udp = kalloc();
      if (udp < 0)
        return -1;
      memset(udp, 0, PGSIZE);
      if (parse_udp_packet(ip4_pkt->payload, ip4_pkt->payload_len, udp) == 0) {
        handle_udp_packet(udp);
      }
      break;
    default:
      printf("unsupported ip protocol: %d\n", ip4_pkt->hdr.protocol);
      break;
  }
  return 0;
}
