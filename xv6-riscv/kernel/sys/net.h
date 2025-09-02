#ifndef IP_H
#define IP_H

#include "socket.h"
#include "types.h"

#define INADDR_ANY 1       // local host address
#define INADDR_BROADCAST 2 // broadcast address

#define LONG_DOMAIN 1
#define LONG_DOMAIN_SECTION 2

#define PROTO_IPV4 0x0800
#define PROTO_ARP  0x0806
#define PROTO_IPV6 0x86DD

struct net_state {
    uint32 ip_addr;       // System IP address in network byte order
    uint8 mac_addr[6];    // Device MAC address
    uint32 subnet_mask;   
    uint32 gateway;      
    // other state like DHCP, DNS, etc.
};

// Export the global state
extern struct net_state netconf;

struct port_binding {
  uint16 ip_addr;
  uint16 port;
  struct socket *sock;
};

extern struct port_binding *udp_port_binds[512];
extern struct port_binding *tcp_port_binds[512];

struct in_addr {
  in_addr_t s_addr; // socket address
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

static inline uint16
htons(uint16 hostshort) {
  return (hostshort >> 8) | (hostshort << 8);
}

static inline uint16
ntohs(uint16 netshort) {
  return (netshort >> 8) | (netshort << 8);
}

static inline uint32
ntohl(uint32 netlong) {
  return ((netlong & 0x000000FFU) << 24) |
    ((netlong & 0x0000FF00U) << 8)  |
    ((netlong & 0x00FF0000U) >> 8)  |
    ((netlong & 0xFF000000U) >> 24);
}

static inline uint32 
htonl(uint32 hostlong) {
    return ((hostlong & 0x000000FFU) << 24) |
           ((hostlong & 0x0000FF00U) << 8)  |
           ((hostlong & 0x00FF0000U) >> 8)  |
           ((hostlong & 0xFF000000U) >> 24);
}


#endif
