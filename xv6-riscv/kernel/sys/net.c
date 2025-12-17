#include "../types.h"
#include "../riscv.h"
#include "../defs.h"
#include "../spinlock.h"
#include "../virtio.h"
#include "arp.h"
#include "net.h"

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

// const int temp_ip = 0x0200A8C0;
const int temp_ip = 0x89fea8c0;

struct net_state netconf = {
  .ip_addr = temp_ip,
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
  arp_insert(temp_ip, netconf.mac_addr);
  return 0;
}
