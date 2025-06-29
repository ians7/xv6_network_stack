#ifndef IP_H
#define IP_H

#include "socket.h"
#include "types.h"

#define INADDR_ANY 1       // local host address
#define INADDR_BROADCAST 2 // broadcast address

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

#endif
