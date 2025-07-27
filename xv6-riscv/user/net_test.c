#include "user.h"
#include "kernel/types.h"
#include "kernel/sys/types.h"
#include "kernel/sys/socket.h"
#include "kernel/sys/net.h"

int socket_test1() {
  struct addrinfo hints, *servinfo, *p;
  p->ai_family = AF_INET;
  p->ai_socktype = SOCK_STREAM;
  p->ai_protocol = 0;
  int fd = socket(p->ai_family, p->ai_socktype, p->ai_protocol);

  if (fd == 0) 
    printf("socket_test1: PASSED\n");
  else
    printf("socket_test1: FAILED\n");

  return 0;
}

int main() {
  socket_test1();
}

