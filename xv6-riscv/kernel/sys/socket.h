#ifndef SOCKET_H
#define SOCKET_H

#include "net.h"
#include "types.h"

/* address family */
#define AF_INET 0

/* socket type */
#define SOCK_STREAM 1
#define SOCK_DGRAM 2

/* socket protocol */
#define IPPROTO_TCP 6
#define IPPROTO_UDP 17

/* socket state */
#define CLOSED 50
#define BOUND 51
#define LISTENING 52
#define SYN_SENT 53
#define SYN_RECVD 54
#define ESTABLISHED 55

struct socket {
  struct file *f;          // Socket file
  struct socket *pending;  // incoming socket connection
  // int num_connections;     // number of sockets in the backlog
  struct spinlock lock;
  int src_ip;              // ip of the socket source
  int dest_ip;             // ip of the destination socket
  int src_port;            // port of the source application
  int dest_port;           // port of the desination application
  int protocol;            // socket protocol
  int type;                // type of the socket (tcp, udp, etc...)
  int family;              // ip address family
  int state;               // current state of the socket
  int fd;
};

struct sockaddr {
  sa_family_t sa_family; // addr family (ipv4, ipv6, ...)
  char sa_data[14];      // fixed length placeholder for address data
};

int socket(int address_family, int address_socktype, int protocol);
int bind(int socket, const struct sockaddr *address, socklen_t address_len);
int listen(int , int backlog);
int accept(int socket, struct sockaddr *address, socklen_t address_len);
int connect(int socket, const struct sockaddr *address, socklen_t address_len);
void socket_init();

#endif
