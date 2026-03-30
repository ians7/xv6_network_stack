#include "../types.h"
#include "../riscv.h"
#include "../defs.h"
#include "../spinlock.h"
#include "../virtio.h"
#include "arp.h"
#include "net.h"
#include "tcp.h"
#include "udp.h"

struct DNS_packet_header {
  uint16 id;
  uint16 flags;
  uint16 q_count;
  uint16 a_count;
  uint16 ns_count;
  uint16 ar_count;
};

struct DNS_question {
  char* q_name;
  uint16 q_type;
  uint16 q_class;
};

#ifndef VM_IP
#define VM_IP 0x0a000a0a
#endif

struct net_state netconf = {
  .ip_addr = VM_IP,
  .gateway = 0,
  .subnet_mask = 0,
};

int my_strlen(char *string) {
  for (int i = 0; ; i++) {
    if (string[i] == '\0')
      return i;
  }
}

int 
getaddrinfo(char *node, char *port, const struct addrinfo *hints,
                struct addrinfo *result)
{
  return 0;
}

int 
freeaddrinfo(struct addrinfo *res)
{
  return 0;
}

int ip_to_u32(const char *ip) {
  int parts[4] = {0};
  int i = 0;

  // Parse the dotted decimal parts
  while (*ip && i < 4) {
    int num = 0;
    while (*ip >= '0' && *ip <= '9') {
      num = num * 10 + (*ip - '0');
      ip++;
    }
    if (num < 0 || num > 255)
      return 0xFFFFFFFF;  // invalid
    parts[i++] = num;

    if (*ip == '.')
      ip++;
    else if (*ip && i < 4)
      return 0xFFFFFFFF;  // invalid format
  }

  if (i != 4)
    return 0xFFFFFFFF;

  // Convert to big-endian 32-bit representation
  return (parts[0] << 24) | (parts[1] << 16) | (parts[2] << 8) | (parts[3]);
}

int
node_to_dns(char *name, char *res)
{
  int name_len = my_strlen(name);
  if (name_len > 253)
    return LONG_DOMAIN;

  int len_index = 0;
  for (int i = 0, res_index = 1; i < name_len + 1; res_index++, i++) {
    if (i - len_index == 64)
      return LONG_DOMAIN_SECTION;

    if (name[i] == '.' || name[i] == '\0') {
      res[len_index] = i - len_index;
      len_index = res_index;
    } else {
      res[res_index] = name[i];
    }
  }
  res[name_len + 1] = 0;
  return 0;
}

int net_init() {
  for (int i = 0; i < 6; i++) {
    netconf.mac_addr[i] = net.cfg.mac[i];
  }
  arp_insert(netconf.ip_addr, netconf.mac_addr);
  return 0;
}

// Computes the UDP checksum per RFC 768.
// src_ip and dst_ip must be in network byte order.
// udp_hdr and payload must already be populated; udp_hdr->csum must be 0.
uint16
udp_checksum(uint32 src_ip, uint32 dst_ip, struct udp_hdr *hdr, uint8 *payload, uint16 payload_len)
{
  // UDP pseudo-header: src_ip, dst_ip, zero, protocol, udp_length
  struct {
    uint32 src_ip;
    uint32 dst_ip;
    uint8  zero;
    uint8  protocol;
    uint16 udp_len;
  } pseudo;

  pseudo.src_ip   = src_ip;
  pseudo.dst_ip   = dst_ip;
  pseudo.zero     = 0;
  pseudo.protocol = IPPROTO_UDP; // IPPROTO_UDP
  pseudo.udp_len  = hdr->len; // already in network byte order

  unsigned long cksum = 0;

  // Sum the pseudo-header
  uint16 *p = (uint16 *)&pseudo;
  for (int i = 0; i < (int)sizeof(pseudo) / 2; i++)
    cksum += p[i];

  // Sum the UDP header (with csum field set to 0).
  // Copy into an aligned buffer first to avoid unaligned access on packed struct.
  uint8 hdr_buf[sizeof(struct udp_hdr)];
  memmove(hdr_buf, hdr, sizeof(struct udp_hdr));
  p = (uint16 *)hdr_buf;
  for (int i = 0; i < (int)sizeof(struct udp_hdr) / 2; i++)
    cksum += p[i];

  // Sum the payload
  p = (uint16 *)payload;
  uint16 len = payload_len;
  while (len > 1) {
    cksum += *p++;
    len -= 2;
  }
  if (len)
    cksum += *(uint8 *)p;

  // Fold 32-bit sum into 16 bits
  cksum = (cksum >> 16) + (cksum & 0xffff);
  cksum += (cksum >> 16);
  return (uint16)(~cksum);
}

int chksum(uint16 *hdr, uint32 len) {
  unsigned long cksum = 0;
  while(len > 1) {
    cksum += *hdr++;
    len -= sizeof(uint16);
  }

  if(len) {
    cksum += *(uint8 *)hdr;
  }

  cksum = (cksum >> 16) + (cksum & 0xffff);
  cksum += (cksum >> 16);
  return (uint16)(~cksum);
}
