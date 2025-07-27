#ifndef IP_H
#define IP_H

#include "socket.h"
#include "types.h"

#define INADDR_ANY 1       // local host address
#define INADDR_BROADCAST 2 // broadcast address

#define LONG_DOMAIN 1
#define LONG_DOMAIN_SECTION 2

struct net_state {
    uint32 ip_addr;       // System IP address in network byte order
    uint8 mac_addr[6];    // Device MAC address
    uint32 subnet_mask;   
    uint32 gateway;      
    // other state like DHCP, DNS, etc.
};

struct port_binding {
  uint16 ip_addr;
  uint16 port;
  struct socket *sock;
};

// Export the global state
extern struct net_state netconf;

struct in_addr {
  in_addr_t s_addr; // socket address
};

enum proto_type {
  PROTO_TCP, 
  PROTO_UDP,
};

struct sockaddr_in {
  sa_family_t sin_family;
  in_port_t sin_port;
  struct in_addr sin_addr;
  unsigned char sin_zero[8];
};

struct addrinfo {
  uint32 ai_family;
  uint32 ai_socktype;
  uint32 ai_flags;
  uint32 ai_protocol;
  socklen_t ai_addrlen;
  struct sockaddr *ai_addr;
  struct addrinfo *ai_next;
};

int getaddrinfo(char *node, char *port, const struct addrinfo *hints,
                struct addrinfo *result);
int freeaddrinfo(struct addrinfo *res);
int node_to_dns(char *name, char *res);
int ip_to_u32(const char *ip);
int net_init();
uint16 ntohs(uint16 netshort);
uint16 htons(uint16 hostshort);

#endif
