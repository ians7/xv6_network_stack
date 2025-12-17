#include "../types.h"
#include "../riscv.h"
#include "../defs.h"
#include "../spinlock.h"
#include "eth.h"
#include "net.h"
#include "arp.h"

#define ARP_PACKET_SIZE sizeof(struct arp_pkt) + sizeof(struct eth_hdr)

struct arp_entry arp_cache[ARP_CACHE_SIZE];
extern struct arp_entry arp_cache[ARP_CACHE_SIZE];


int
arp_lookup(uint32 ip, uint8 *mac)
{
  for (int i = 0; i < ARP_CACHE_SIZE; i++) {
    struct arp_entry *ae = &arp_cache[i];
    if (ae->valid == 1 && ae->ip == ip) {
      memmove(mac, ae->mac, 6);
      return 1;
    }
  }
  return -1;
}

void
arp_insert(uint32 ip, uint8 *mac)
{
  for (int i = 0; i < ARP_CACHE_SIZE; i++) {
    struct arp_entry *ae = &arp_cache[i];
    if (ae->ip == ip) {
      memmove(ae->mac, mac, 6);
      ae->valid = 1;
      break;
    } else if (ae->valid != 1) {
      ae->ip = ip;
      memmove(ae->mac, mac, 6);
      ae->valid = 1;
      break;
    }
  }
}

void
arp_request(uint32 target_ip)
{
  struct eth_frame *frame = kalloc();
  if (frame == 0) {
    printf("ERROR: kalloc\n");
    return;
  }
  uint8 dst_mac[6] = {0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF};
  struct arp_pkt *arp = (struct arp_pkt *)frame->payload;
  build_eth(frame, dst_mac, netconf.mac_addr, PROTO_ARP);

  arp->htype = htons(ARP_HTYPE_ETH);
  arp->ptype = htons(PROTO_IPV4);
  arp->hlen = ARP_HLEN;
  arp->plen = ARP_PLEN;
  arp->oper = htons(ARP_OP_REQUEST); 
  arp->spa = netconf.ip_addr;
  arp->tpa = target_ip;
  memmove(arp->sha, netconf.mac_addr, 6);
  memmove(arp->tha, dst_mac, 6);
  printf("arp_request: sending arp request!\n");
  transmit_packet(frame, ARP_PACKET_SIZE, PROTO_ARP);
  kfree(frame);
}

void 
arp_recv(struct arp_pkt *pkt)  
{
  if (ntohs(pkt->oper) == ARP_OP_REQUEST) {
    struct eth_frame *frame = kalloc();
    if (frame == 0) {
      printf("ERROR: kalloc\n");
      return;
    }
    arp_insert(pkt->spa, pkt->sha);
    if (pkt->tpa == netconf.ip_addr || pkt->tpa == 0xFFFFFFFF) {
      build_eth(frame, pkt->sha, netconf.mac_addr, PROTO_ARP);
    } else {
      return;
    }
    struct arp_pkt *reply = (struct arp_pkt *)frame->payload;

    reply->htype = htons(ARP_HTYPE_ETH);
    reply->ptype = htons(PROTO_IPV4);
    reply->hlen = ARP_HLEN;
    reply->plen = ARP_PLEN;
    reply->oper = htons(ARP_OP_REPLY);
    reply->spa = netconf.ip_addr;
    reply->tpa = pkt->spa;
    memmove(reply->sha, netconf.mac_addr, 6);
    memmove(reply->tha, pkt->sha, 6);
    transmit_packet(frame, ARP_PACKET_SIZE, PROTO_ARP);
    kfree(frame);
  } else if (ntohs(pkt->oper) == ARP_OP_REPLY) {
    arp_insert(pkt->spa, pkt->sha);
  } else {
    for (int i = 0; i < sizeof(struct arp_pkt); i++) {
      printf("%x ", ((uint8*)pkt)[i]);
    }
    printf("\n");
    printf("\tpkt->oper=%x\n", ntohs(pkt->oper));
  }

}
