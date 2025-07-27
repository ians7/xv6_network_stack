#include "../types.h"
#include "../riscv.h"
#include "../defs.h"
#include "../fs.h"
#include "../spinlock.h"
#include "../sleeplock.h"
#include "../file.h"
#include "socket.h"
#include "net.h"

#define MAX_SOCKET_CAPACITY 512
#define MAX_PORT_BINDINGS 512

struct socket_list {
  struct socket **socks;
  int size;
};

struct port_binding *port_binds[512];

struct socket_list *tcp_sock_list;
struct socket_list *udp_sock_list;

extern struct net_state netconf;

int insert_port_binding(struct port_binding *bind) {
  port_binds[bind->port] = bind;
  return 0;
}

int remove_port_binding(struct port_binding *bind) {
  if (port_binds[bind->port] == 0)
    return -1;

  port_binds[bind->port] = 0;

  return 0;
}

int tcp_socket_list_insert(struct socket* sock) {
  int fd = -1;

  if (tcp_sock_list->size == MAX_SOCKET_CAPACITY) {
    return -1;
  }

  for (int i = 0; i < MAX_SOCKET_CAPACITY; i++) {
    if (tcp_sock_list->socks[i] == 0) {
      tcp_sock_list->socks[i] = sock;
      tcp_sock_list->size++;
      fd = i;
      break;
    }
  }
  return fd;
}

int
sockalloc(struct socket **sock)
{
  *sock = (struct socket *)kalloc();
  if (sock == 0) {
    printf("ERROR: kalloc\n");
    return -1;
  }
  memset(*sock, 0, PGSIZE);

  int fd = tcp_socket_list_insert(*sock);
  if (fd == -1) {
    printf("socket: fd == -1\n");
    kfree(*sock);
    return -1;
  }
  (*sock)->fd = fd;
  return fd;
}

int
bind(int socket, const struct sockaddr *sock_address, socklen_t address_len)
{
  if (socket < 0) {
    printf("bind: socket == 0\n");
    return -1;
  } else if (sock_address == 0) {
    printf("bind: sock_address == 0\n");
    return -1;
  }

  struct socket *sock = tcp_sock_list->socks[socket];
  const struct sockaddr_in *sockaddr = (struct sockaddr_in *)sock_address;
  uint16 port = ntohs(sockaddr->sin_port);

  if(sockaddr->sin_port < 0 || sockaddr->sin_port > MAX_PORT_BINDINGS) {
    printf("bind: port number not valid within range\n");
    return -1;
  } else if (port_binds[port]) {
    printf("bind: port number already bound\n");
    return -1;
  }

  sock->family = sock_address->sa_family;

  switch(sock->family) {
    case(AF_INET): 
      if (address_len != sizeof(struct sockaddr_in)) {
        printf("bind: incorrect address_len for ipv4\n");
        return -1;
      }

      if (port_binds[port]) {
        printf("bind: port %d in use\n", port);
        return -1;
      }

      struct port_binding *binding = (struct port_binding*) kalloc();
      if (binding == 0) {
        printf("ERROR: kalloc\n");
        return -1;
      }
      binding->port = port;
      if (sockaddr->sin_addr.s_addr == INADDR_ANY) {
        sock->src_ip = netconf.ip_addr;
        binding->ip_addr = netconf.ip_addr;
      } else {
        binding->ip_addr = sockaddr->sin_addr.s_addr;
        sock->src_ip = sockaddr->sin_addr.s_addr;
      }

      binding->sock = sock;

      if (insert_port_binding(binding) == -1){
        printf("bind: failed to bind to port\n");
        kfree(binding);
        return -1;
      }

      sock->src_port = port;
      sock->family = sockaddr->sin_family;
      sock->state = BOUND;

      return 0;
    default:
      break;
  }

  return 0;
}

int
listen(int socket, int backlog)
{
  struct socket *sock = tcp_sock_list->socks[socket];
  if (sock->type != SOCK_STREAM)  {
    printf("listen: cannot listen from a UDP socket\n");
    return -1;
  } else if (!(sock->state == BOUND)) {
    printf("listen: socket is not bound\n");
    return -1;
  } 

  sock->state = LISTENING;

  return 0;
}

int
accept(int socket, struct sockaddr *address, socklen_t address_len)
{
  struct sockaddr_in *sockaddr = (struct sockaddr_in *)address;
  struct socket *sock = tcp_sock_list->socks[socket];

  if (sock->protocol != IPPROTO_TCP || sock->type != SOCK_STREAM) {
    printf("accept: improper protocol and sock_type combination\n");
    return -1;
  }

  if (sock->state != LISTENING){
    printf("accept: socket is not listening\n");
    return -1;
  }

  acquire(&sock->lock);
  while (!sock->pending) {
    sleep(sock, &sock->lock);
  }
  struct socket *new_sock = sock->pending;
  new_sock->pending = 0;
  new_sock->pending = 0;
  release(&sock->lock);

  new_sock->f = filealloc();
  if (new_sock->f == 0) {
    printf("accept: failed to allocate a file\n");
    return -1;
  }

  return new_sock->fd;
}

int
connect(int socket, const struct sockaddr *address, socklen_t address_len)
{
  return 0;
}

int tcp_socket_list_remove(int fd) {
  if (tcp_sock_list->socks[fd] == 0) {
    printf("socket to remove does not exist\n");
    return -1;
  } else {
    tcp_sock_list->socks[fd] = 0;
    tcp_sock_list->size--;
    return 1;
  }
}

int 
socket(int sock_family, int sock_type, int protocol)
{
  if (sock_family != AF_INET)  {
    printf("socket: invalid sock_family\n");
    return -1;
  }

  if (sock_type != SOCK_STREAM && sock_type != SOCK_DGRAM) {
    printf("socket: invalid sock_type\n");
    return -1;
  }

  if (protocol == 0) {
    if (sock_type == SOCK_STREAM)
      protocol = IPPROTO_TCP;
    else if (sock_type == SOCK_DGRAM)
      protocol = IPPROTO_UDP;
  }

  if (protocol != IPPROTO_TCP && protocol != IPPROTO_UDP) {
    printf("socket: invalid protocol\n");
    return -1;
  }

  if ((protocol == IPPROTO_TCP && sock_type != SOCK_STREAM) ||
      (protocol == IPPROTO_UDP && sock_type != SOCK_DGRAM)) {
    printf("socket: invalid protocol-socktype combination\n");
    return -1;
  }

  struct socket *sock;
  int fd = sockalloc(&sock);
  if (fd == -1) {
    printf("socket: sockalloc failed\n");
    return -1;
  }

  sock->f = filealloc();
  if (sock->f == 0) {
    printf("ERROR: filealloc\n");
    return -1;
  }

  // TODO: Write the methods for sock_read and sock_write, set the fields of file to those methods

  switch(protocol){
    case(IPPROTO_TCP):
      tcp_sock_list->socks[fd] = sock;
      break;
    case(IPPROTO_UDP):
      udp_sock_list->socks[fd] = sock;
      break;
    default:
      printf("socket: invalid protocol\n");
      if ((tcp_socket_list_remove(fd)) < 0) 
        printf("socket: failed to remove sock from tcp_socklist\n");
      kfree(sock);
      return -1;
  }

  sock->protocol = protocol;
  sock->src_ip = netconf.ip_addr;
  sock->type = sock_type;
  sock->family = sock_family;
  sock->state = CLOSED;

  return fd;
}

int 
close()
{
  return 0;
}

void tcp_sock_list_init() {
  tcp_sock_list = (struct socket_list *)kalloc();
  if (!tcp_sock_list) {
    printf("ERROR: failed to allocate tcp_sock_list\n");
    return;
  }

  tcp_sock_list->socks = (struct socket **)kalloc();
  if (!tcp_sock_list->socks) {
    printf("ERROR: failed to allocate tcp_sock_list->socks\n");
    kfree(tcp_sock_list);
    return;
  }
  memset(tcp_sock_list->socks, 0, PGSIZE);
}

void udp_sock_list_init() {
  udp_sock_list = (struct socket_list *)kalloc();
  if (!udp_sock_list) {
    printf("ERROR: failed to allocate udp_sock_list\n");
    return;
  }

  udp_sock_list->socks = (struct socket **)kalloc();
  if (!udp_sock_list->socks) {
    printf("ERROR: failed to allocate udp_sock_list->socks\n");
    kfree(udp_sock_list);
    return;
  }
  memset(udp_sock_list->socks, 0, PGSIZE);
}

void socket_init() {
  tcp_sock_list_init();
  udp_sock_list_init();
}
