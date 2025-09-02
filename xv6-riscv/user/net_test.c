#include "kernel/types.h"
#include "user.h"
#include "kernel/sys/types.h"
#include "kernel/sys/net.h"
#include "kernel/sys/socket.h"

#define SERVER_PORT 20000
#define CLIENT_PORT 78
#define MSG "hello over udp"

void
udp_basic_test(void)
{
  int server_fd, client_fd;
  struct sockaddr_in server_addr, client_addr;
  char buf[64];

  printf("udp_basic_test...\n");

  // --- Create server socket
  // server_fd = socket(AF_INET, SOCK_DGRAM, 0);
  // if (server_fd < 0) {
  //   printf("server socket failed\n");
  //   exit(1);
  // }
  //
  memset(&server_addr, 0, sizeof(server_addr));
  server_addr.sin_family = AF_INET;
  server_addr.sin_port = htons(SERVER_PORT);
  server_addr.sin_addr.s_addr = htonl(0xc0a8fe74);

  // if (bind(server_fd, (struct sockaddr *)&server_addr, sizeof(server_addr)) < 0) {
  //   printf("server bind failed\n");
  //   exit(1);
  // }
  //
  // --- Create client socket
  client_fd = socket(AF_INET, SOCK_DGRAM, 0);
  if (client_fd < 0) {
    printf("client socket failed\n");
    exit(1);
  }

  memset(&client_addr, 0, sizeof(client_addr));
  client_addr.sin_family = AF_INET;
  client_addr.sin_port = htons(CLIENT_PORT);
  client_addr.sin_addr.s_addr = INADDR_ANY;

  if (bind(client_fd, (struct sockaddr *)&client_addr, sizeof(client_addr)) < 0) {
    printf("client bind failed\n");
    exit(1);
  }

  // --- Client sends message to server
  printf("sending payload\n");
  if (sendto(client_fd, MSG, strlen(MSG), 0,
             (struct sockaddr *)&server_addr, sizeof(server_addr)) < 0) {
    printf("sendto failed\n");
    exit(1);
  }

  // --- Server receives message
  // int fromlen = sizeof(client_addr);
  // while (1) {
  // printf("receiving payload\n");
  //   int n = recvfrom(server_fd, buf, sizeof(buf)-1, 0,
  //       (struct sockaddr *)&client_addr, &fromlen);
  //   buf[n] = '\0';
  //
  //   printf("UDP PACKET RECEIVED: \n\t");
  //   printf("%s\n", buf);
  // }

  // close(client_fd);
  close(client_fd);
}
int tcp_test3() {
  struct addrinfo *hints, *servinfo, *p;
  p->ai_family = AF_INET;
  p->ai_socktype = SOCK_STREAM;
  p->ai_protocol = 0;
  // int fd = socket(p->ai_family, p->ai_socktype, p->ai_protocol);
  //
  // if (fd != 2) {
  //   printf("socket_test3: SOCKET FAILED\n");
  //   return -1;
  // }
  //
  // if (bind(fd, p->ai_addr, p->ai_addrlen) == -1) {
  //   printf("socket_test3: BIND FAILED\n");
  //   return -1;
  // }
  //
  // if (listen(fd, 10) == -1) {
  //   printf("socket_test3: LISTEN FAILED\n");
  //   return -1;
  // }
  // 
  // printf("socket_test3: PASSED\n");
  return 0;
}

int tcp_test2() {
  struct addrinfo *hints, *servinfo, *p;
  p->ai_family = AF_INET;
  p->ai_socktype = SOCK_STREAM;
  p->ai_protocol = 0;
  int fd = socket(p->ai_family, p->ai_socktype, p->ai_protocol);

  if (fd != 1) {
    printf("socket_test2: SOCKET FAILED\n");
    return -1;
  }

  if (bind(fd, p->ai_addr, p->ai_addrlen) == -1) {
    printf("socket_test2: BIND FAILED\n");
    return -1;
  }
  
  printf("socket_test2: PASSED\n");

  return 0;
}

int tcp_test1() {
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
  udp_basic_test();
  // tcp_test1();
  // tcp_test2();
  // tcp_test3();
}

