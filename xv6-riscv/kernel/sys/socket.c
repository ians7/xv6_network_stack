#include "../types.h"
#include "../riscv.h"
#include "../defs.h"
#include "../fs.h"
#include "../spinlock.h"
#include "../sleeplock.h"
#include "socket.h"
#include "../file.h"
#include "net_utils.h"
#include "udp.h"
#include "tcp.h"
#include "net.h"

struct port_binding *udp_port_binds[MAX_PORT_BINDINGS];
struct port_binding *tcp_port_binds[MAX_PORT_BINDINGS];

struct socket_list *sock_list;
struct socket_list *tcp_sock_list;
struct socket_list *udp_sock_list;

struct socket_ops udp_ops = {
  .bind     = udp_bind,
  .connect  = udp_connect,  // often optional for UDP
  .listen   = 0,         // not valid
  .accept   = 0,         // not valid
  .sendto   = udp_sendto,
  .recvfrom = udp_recvfrom,
  .close    = udp_close,
};
struct socket_ops tcp_ops = {
  .bind     = tcp_bind,
  .connect  = tcp_connect,  // often optional for UDP
  .listen   = tcp_listen,         // not valid
  .accept   = tcp_accept,         // not valid
  .sendto   = 0,
  .recvfrom = 0,
  .close    = tcp_close,
};

int insert_port_binding(struct port_binding *bind) {
  if (bind->sock->proto == IPPROTO_TCP)
    tcp_port_binds[bind->port] = bind;
  else if (bind->sock->proto == IPPROTO_UDP)
    udp_port_binds[bind->port] = bind;
  return 0;
}

int remove_port_binding(struct port_binding *bind) {
  if (bind->sock->proto == IPPROTO_TCP) {
    if (tcp_port_binds[bind->port] == 0)
      return -1;
    tcp_port_binds[bind->port] = bind;
  } else if (bind->sock->proto == IPPROTO_UDP) {
    if (udp_port_binds[bind->port] == 0)
      return -1;
    udp_port_binds[bind->port] = 0;
  }
  return 0;
}

int tcp_socket_list_insert(struct socket *sock) {
  for (int i = 0; i < MAX_SOCKET_CAPACITY; i++) {
    if (tcp_sock_list->socks[i] == 0) {
      tcp_sock_list->socks[i] = sock;
      tcp_sock_list->size++;
      break;
    }
  }
  return 0;
}

int udp_socket_list_insert(struct socket *sock) {
  for (int i = 0; i < MAX_SOCKET_CAPACITY; i++) {
    if (udp_sock_list->socks[i] == 0) {
      udp_sock_list->socks[i] = sock;
      udp_sock_list->size++;
      break;
    }
  }
  return 0;
}

struct socket* getsock(int fd) {
  for (int i = 0; i < sock_list->size; i++) {
    if (sock_list->socks[i]->fd == fd) {
      return sock_list->socks[i];
    }
  }
  return 0;
}

int socket_list_remove(int fd) {
  if (sock_list->socks[fd] == 0) {
    return -1;
  } else {
    struct socket *sock = getsock(fd);
    if (!sock)
      return -1;
    sock_list->size--;
    if (sock->type == SOCK_STREAM) {
      for (int i = 0; i < MAX_SOCKET_CAPACITY; i++) {
        if (tcp_sock_list->socks[i]->fd == fd) {
          tcp_sock_list->socks[i] = 0;
          tcp_sock_list->size--;
          break;
        }
      }
    } else if (sock->type == SOCK_DGRAM) {
      for (int i = 0; i < MAX_SOCKET_CAPACITY; i++) {
        if (udp_sock_list->socks[i]->fd == fd) {
          udp_sock_list->socks[i] = 0;
          udp_sock_list->size--;
          break;
        }
      }
    }
    kfree(sock);
    return 1;
  }
}

int
sock_list_insert(struct socket *sock)
{
  int idx = -1;
  if (sock_list->size == MAX_SOCKET_CAPACITY) {
    return -1;
  }
  
  for (int i = 0; i < MAX_SOCKET_CAPACITY; i++) {
    if (sock_list->socks[i] == 0) {
      sock_list->socks[i] = sock;
      sock_list->size++;
      idx = i;
      break;
    }
  }
  if (sock->type == SOCK_DGRAM) {
    if (udp_socket_list_insert(sock) == -1) {
      sock_list->socks[idx] = 0;
      sock_list->size--;
      return -1;
    }
  } else if (sock->type == SOCK_STREAM) {
    if (tcp_socket_list_insert(sock) == -1) {
      sock_list->socks[idx] = 0;
      sock_list->size--;
      return -1;
    }
  }
  return 0;
}

int
bind(int socket, const struct sockaddr *sock_address, socklen_t address_len)
{
  struct socket *sock = getsock(socket);
  if (!sock)
    return -1;
  return sock->ops->bind(sock, sock_address, address_len);
}

int
listen(int socket, int backlog)
{
  struct socket *sock = getsock(socket);
  if (!sock)
    return -1;
  sock->ops->listen(sock, backlog);
  return 0;
}

int
accept(int socket, struct sockaddr *address, socklen_t address_len)
{
  struct sockaddr_in *sockaddr = (struct sockaddr_in *)address;
  struct socket *sock = getsock(socket);
  if (!sock)
    return -1;

  if (sock->proto != IPPROTO_TCP || sock->type != SOCK_STREAM) {
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
  release(&sock->lock);

  return sock->fd;
}

int
connect(int socket, const struct sockaddr *address, socklen_t address_len)
{
  return 0;
}

int 
initsocket(struct socket *sock, int sock_family, int sock_type, int protocol)
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

  sock->proto = protocol;
  sock->src_ip = netconf.ip_addr;
  sock->type = sock_type;
  sock->family = sock_family;
  sock->state = CLOSED;
  sock->rx_head = 0;
  sock->rx_tail = 0;

  if (protocol == IPPROTO_TCP)
    sock->ops = &tcp_ops;
  if (protocol == IPPROTO_UDP)
    sock->ops = &udp_ops;

  if (sock_list_insert(sock) == -1)
    return -1;

  return 0;
}

int 
close(int fd)
{
  return 0;
}

int 
send(int socket, const void *msg, int length, int flags)
{
  return 0;
}

int 
recv(int socket, void *buf, int length, int flags)
{
  return 0;
}

int 
sendto(int socket, const void *msg, int length, int flags, 
    const struct sockaddr *dst_addr, socklen_t dst_len)
{
  struct socket *sock = getsock(socket);
  if (!sock)
    return -1;
  return sock->ops->sendto(sock, msg, length, flags, dst_addr, dst_len);
}

int 
recvfrom(int socket, void *buffer, int length, int flags,
    const struct sockaddr *addr, socklen_t *addrlen)
{
  struct socket *sock = getsock(socket);
  if (!sock)
    return -1;
  return sock->ops->recvfrom(sock, buffer, length, flags, addr, addrlen);
}

void sock_list_init() {
  sock_list = (struct socket_list *)kalloc();
  if (!sock_list) {
    printf("ERROR: failed to allocate tcp_sock_list\n");
    return;
  }

  sock_list->socks = (struct socket **)kalloc();
  if (!sock_list->socks) {
    printf("ERROR: failed to allocate tcp_sock_list->socks\n");
    kfree(sock_list);
    return;
  }
  memset(sock_list->socks, 0, PGSIZE);
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
  sock_list_init();
  tcp_sock_list_init();
  udp_sock_list_init();
}
