
#ifndef ARP_H
#define ARP_H

#define ARP_HTYPE_ETH 1   // hardware type = Ethernet
#define ARP_PTYPE_IP  0x0800 // protocol type = IPv4
#define ARP_HLEN 6       // MAC length
#define ARP_PLEN 4       // IPv4 length

#define ARP_CACHE_SIZE 16

#define ARP_OP_REQUEST 1
#define ARP_OP_REPLY   2

struct arp_pkt {
  uint16 htype;   // hardware type
  uint16 ptype;   // protocol type
  uint8  hlen;    // hardware address length
  uint8  plen;    // protocol address length
  uint16 oper;    // opcode (request=1, reply=2)
  uint8  sha[6];  // sender hardware address (MAC)
  uint32  spa;  // sender protocol address (IPv4)
  uint8  tha[6];  // target hardware address (MAC)
  uint32  tpa;  // target protocol address (IPv4)
} __attribute__((packed));

struct arp_entry {
  uint32 ip;      // IPv4 address in network byte order
  uint8  mac[6];  // MAC address
  int    valid;   // 1 if valid
};

// Lookup MAC by IP, return 1 if found
int arp_lookup(uint32 ip, uint8 mac[6]);
// Insert or update cache entry
void arp_insert(uint32 ip, uint8 mac[6]);
// Send an ARP request (broadcast)
void arp_request(uint32 target_ip);
// Handle incoming ARP packet
void arp_recv(struct arp_pkt *pkt);

#endif

