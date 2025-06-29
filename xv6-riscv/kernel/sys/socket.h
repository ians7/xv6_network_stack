#ifndef SOCKET_H
#define SOCKET_H

#include "types.h"

#define AF_INET 2

#define SOCK_STREAM 1
#define SOCK_DGRAM 2

struct sockaddr {
  sa_family_t sa_family; // addr family (ipv4, ipv6, ...)
  char sa_data[14];      // fixed length placeholder for address data
};

int socket(int address_family, int address_socktype, int protocol);
int accept(int socket, struct sockaddr *address, socklen_t address_len);
int bind(int socket, const struct sockaddr *address, socklen_t address_len);
int listen(int socket, int backlog);
int connect(int socket, const struct sockaddr *address,
            socklen_t address_len);

#endif
