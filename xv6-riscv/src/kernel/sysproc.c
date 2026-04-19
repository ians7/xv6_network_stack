#include "types.h"
#include "sys/types.h"
#include "riscv.h"
#include "defs.h"
#include "param.h"
#include "memlayout.h"
#include "spinlock.h"
#include "sleeplock.h"
#include "fs.h"
#include "file.h"
#include "sys/net.h"
#include "sys/socket.h"
#include "proc.h"

uint64 sys_exit(void) {
  int n;
  argint(0, &n);
  exit(n);
  return 0; // not reached
}

uint64 sys_getpid(void) { return myproc()->pid; }

uint64 sys_fork(void) { return fork(); }

uint64 sys_wait(void) {
  uint64 p;
  argaddr(0, &p);
  return wait(p);
}

uint64 sys_sbrk(void) {
  uint64 addr;
  int n;

  argint(0, &n);
  addr = myproc()->sz;
  if (growproc(n) < 0)
    return -1;
  return addr;
}

uint64 sys_sleep(void) {
  int n;
  uint ticks0;

  argint(0, &n);
  acquire(&tickslock);
  ticks0 = ticks;
  while (ticks - ticks0 < n) {
    if (killed(myproc())) {
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
  }
  release(&tickslock);
  return 0;
}

uint64 sys_kill(void) {
  int pid;

  argint(0, &pid);
  return kill(pid);
}

// return how many clock tick interrupts have occurred
// since start.
uint64 sys_uptime(void) {
  uint xticks;

  acquire(&tickslock);
  xticks = ticks;
  release(&tickslock);
  return xticks;
}

uint64 sys_spoon(void) {
  // obtain the argument from the stack, we need some special handling
  uint64 addr;
  argaddr(0, &addr);
  return spoon((void *)addr);
}

uint64 sys_create_thread(void *arg) {
  uint64 fn_addr, args_addr, stack_addr, exit_fn;
  argaddr(0, &fn_addr);
  argaddr(1, &args_addr);
  argaddr(2, &stack_addr);
  argaddr(3, &exit_fn);
  return create_thread((void *)fn_addr, (void *)args_addr, (void *)stack_addr,
                       (void *)exit_fn);
}

uint64 sys_join_thread(void *arg) {
  uint64 thread_id, status_addr;
  argaddr(0, &thread_id);
  argaddr(1, &status_addr);
  return join_thread(thread_id, status_addr);
}

uint64 sys_thread_exit(void *arg) {
  uint64 status_addr;
  argaddr(0, &status_addr);
  return thread_exit(status_addr);
}

uint64 sys_bind(void) {
    int fd;
    uint64 uaddr;
    int addrlen;

    argint(0, &fd);
    argaddr(1, &uaddr);
    argint(2, &addrlen);

    struct file *f = myproc()->ofile[fd];
    if (f == 0 || f->type != FD_SOCKET)
        return -1;

    struct socket *sock = f->sock;

    struct sockaddr_in addr;
    if (addrlen > sizeof(addr))
        return -1;

    // Copy user memory → kernel struct
    if (copyin(myproc()->pagetable, (char*)&addr, uaddr, addrlen) < 0)
        return -1;

    return sock->ops->bind(sock, (struct sockaddr*)&addr, addrlen);
}
uint64 sys_listen(void *arg) {
  uint64 socket, backlog;
  argaddr(0, &socket);
  argaddr(1, &backlog);
  return listen(socket, backlog);
}

uint64 sys_accept(void *arg) {
  uint64 socket;
  uint64 address_len;
  struct sockaddr address;
  argaddr(0, &socket);
  argaddr(1, (uint64 *)&address);
  argaddr(2, &address_len);
  return accept(socket, &address, address_len);
}

uint64 sys_socket(void *arg) {;
  uint64 address_family, address_socktype, protocol;
  argaddr(0, &address_family);
  argaddr(1, &address_socktype);
  argaddr(2, &protocol);

  struct socket *sock = (struct socket *)kalloc();
  if (sock == 0) {
    printf("ERROR: kalloc\n");
    return -1;
  }
  memset(sock, 0, PGSIZE);

  initsocket(sock, address_family, address_socktype, protocol);

  struct file *f = filealloc();
  if (f == 0) {
    kfree(sock);
    return -1;
  }

  int fd = fdalloc(f);
  if (fd < 0) {
    fileclose(f);
    kfree(sock);
    return -1;
  }

  f->type = FD_SOCKET;
  f->sock = sock;
  sock->fd = fd;

  return fd;
}

uint64 sys_connect(void *arg) {
  uint64 socket, address_len;
  struct sockaddr address;
  argaddr(0, &socket);
  argaddr(1, (uint64 *)&address);
  argaddr(2, &address_len);
  return connect(socket, &address, address_len);
}

uint64
sys_send(void)
{
  int fd;
  uint64 buf;   // user pointer
  int len;
  int flags;

  argint(0, &fd);
  argaddr(1, &buf);
  argint(2, &len);
  argint(3, &flags);

  struct file *f = myproc()->ofile[fd];
  if (f == 0 || f->type != FD_SOCKET)
    return -1;

  return send(fd, (uint64 *)buf, len, flags);
}

uint64 sys_recv(void *arg) {
  int fd;
  uint64 buf;
  int len;
  int flags;

  argint(0, &fd);
  argaddr(1, &buf);
  argint(2, &len);
  argint(3, &flags);

  struct file *f = myproc()->ofile[fd];
  if (f == 0 || f->type != FD_SOCKET)
    return -1;

  return recv(fd, (uint64 *)buf, len, flags);
}

uint64 sys_sendto(void) {
  int fd;
  uint64 buf;
  int len;
  int flags;
  uint64 dest_addr;
  int addrlen;

  argint(0, &fd);
  argaddr(1, &buf);
  argint(2, &len);
  argint(3, &flags);
  argaddr(4, &dest_addr);
  argint(5, &addrlen);

  struct file *f = myproc()->ofile[fd];
  if (f == 0 || f->type != FD_SOCKET)
    return -1;

  struct socket *sock = f->sock;
  return sock->ops->sendto(sock, (void *)buf, len, flags,
                           (struct sockaddr *)dest_addr, addrlen);
}

uint64 sys_recvfrom(void *arg) {
  int fd;
  uint64 buf;
  int len;
  int flags;
  uint64 src_addr;
  uint64 addrlen;

  argint(0, &fd);
  argaddr(1, &buf);
  argint(2, &len);
  argint(3, &flags);
  argaddr(4, &src_addr);
  argaddr(5, &addrlen);

  struct file *f = myproc()->ofile[fd];
  if (f == 0 || f->type != FD_SOCKET)
    return -1;

  struct socket *sock = f->sock;
  return sock->ops->recvfrom(sock, (void *)buf, len, flags,
                             (struct sockaddr *)src_addr,
                             (socklen_t *)addrlen);
}
