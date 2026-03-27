#ifndef SOCKET_H
#define SOCKET_H

// #include "net.h"
#include "types.h"

/* address family */
#define AF_INET 2

/* socket type */
#define SOCK_STREAM 1
#define SOCK_DGRAM 2

/* socket protocol */
#define IPPROTO_TCP 6
#define IPPROTO_UDP 17

/* socket flags */

#define URG 0x80
#define ACK 0x40
#define PSH 0x20
#define RST 0x10
#define SYN 0x08
#define FIN 0x04

/* socket state */
#define CLOSED 50
#define BOUND 51
#define LISTENING 52
#define SYN_SENT 53
#define SYN_RECVD 54
#define ESTABLISHED 55

#define MAX_SOCKET_CAPACITY 512
#define MAX_PORT_BINDINGS 512

struct socket_list {
  struct socket **socks;
  int size;
};


struct sockaddr {
  sa_family_t sa_family; // addr family (ipv4, ipv6, ...)
  char sa_data[14];      // fixed length placeholder for address data
};

struct socket {
  struct socket *pending;  // incoming socket connection
  // int num_connections;     // number of sockets in the backlog
  struct spinlock lock;
  int src_ip;              // ip of the socket source
  int dest_ip;             // ip of the destination socket
  int src_port;            // port of the source application
  int dest_port;           // port of the desination application
  int proto;            // socket protocol
  int type;                // type of the socket (tcp, udp, etc...)
  int family;              // ip address family
  int state;               // current state of the socket
  int fd;
  struct socket_ops *ops;

  void *rx_head;
  void *rx_tail;
};

struct socket_ops {
    int (*bind)(struct socket *sock, const struct sockaddr *addr, socklen_t addrlen);
    int (*connect)(struct socket *sock, const struct sockaddr *addr, socklen_t addrlen);
    int (*listen)(struct socket *sock, int backlog);
    int (*accept)(struct socket *sock, const struct sockaddr *address, socklen_t address_len);
    int (*sendto)(struct socket *sock, const void *buf, int len,
                  int flags, const struct sockaddr *dest, socklen_t addrlen);
    int (*recvfrom)(struct socket *sock, void *buf, int len,
                    int flags, const struct sockaddr *src, socklen_t *addrlen);
    int (*close)(struct socket *sock);
};

extern struct socket_list *sock_list;

int socket(int address_family, int address_socktype, int protocol);
int bind(int socket, const struct sockaddr *address, socklen_t address_len);
int listen(int socket, int backlog);
int accept(int socket, struct sockaddr *address, socklen_t address_len);
int connect(int socket, const struct sockaddr *address, socklen_t address_len);
int close(int socket);

int send(int socket, const void *message, int length, int flags);
int recv(int socket, void *buffer, int length, int flags);

int sendto(int socket, const void *message, int length, int flags,
             const struct sockaddr *dest_addr, socklen_t dest_len);
int recvfrom(int socket, void *buffer, int length,
             int flags, const struct sockaddr *address, socklen_t *address_len);

void socket_init();

#endif
