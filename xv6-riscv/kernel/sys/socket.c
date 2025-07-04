#include "../types.h"
#include "../riscv.h"
#include "../defs.h"
#include "socket.h"

#define MAX_SOCKET_CAPACITY 512

struct socket_list {
  struct socket **socks;
  int size;
};

struct socket_list *sock_list;

int 
socket(int address_family, int address_socktype, int protocol)
{
  return 0;
}

int
bind(int socket, const struct sockaddr *sock_address, socklen_t address_len)
{
  return 0;
}

int
listen(int socket, int backlog)
{
  return 0;
}

int
accept(int socket, struct sockaddr *address, socklen_t address_len)
{
  return 0;
}

int
connect(int socket, const struct sockaddr *address, socklen_t address_len)
{
  return 0;
}

int socket_list_insert(struct socket_list *sock_list, struct socket* sock) {
  int fd = -1;

  if (sock_list->size == MAX_SOCKET_CAPACITY) {
    return -1;
  }

  for (int i = 0; i < MAX_SOCKET_CAPACITY; i++) {
    if (sock_list->socks[i] == 0) {
      sock_list->socks[sock_list->size] = sock;
      sock_list->size++;
      fd = i;
    }
  }
  return fd;
}

int socket_list_remove(int fd) {
  if (sock_list->socks[fd] == 0) {
    return -1;
  } else {
    sock_list->socks[fd] = 0;
    sock_list->size--;
    return 1;
  }
}

struct socket_list* socket_list_init() {
  sock_list = (struct socket_list *)kalloc();
  if (!sock_list)
    return 0;

  sock_list->socks = (struct socket **)kalloc();
  if (!sock_list->socks)
    return 0;

  sock_list->size = 0;

  return sock_list;
}
