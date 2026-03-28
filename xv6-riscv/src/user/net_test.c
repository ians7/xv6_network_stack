#include "kernel/types.h"
#include "user.h"
#include "kernel/sys/types.h"
#include "kernel/sys/net.h"
#include "kernel/sys/socket.h"

#define SRVTEST_SERVER_PORT 78

#define CLITEST_SERVER_PORT 20000
#define CLITEST_CLIENT_PORT 78

#define CLITEST_SERVER_ADDR "10.10.0.3"

void udp_cli(void) {
  int sockfd;
  int msglen = strlen("hello over udp");
  char *msg = malloc(msglen);
  memmove(msg, "hello over udp", strlen("hello over udp"));
  struct sockaddr_in server_addr, client_addr;
  char buf[64];

  printf("TESTING UDP CLIENT...\n");

  memset(&server_addr, 0, sizeof(server_addr));
  server_addr.sin_family = AF_INET;
  server_addr.sin_port = htons(CLITEST_SERVER_PORT);
  server_addr.sin_addr.s_addr = htonl(inet_addr(CLITEST_SERVER_ADDR));

  /* --- Create client socket --- */
  sockfd = socket(AF_INET, SOCK_DGRAM, 0);
  if (sockfd < 0) {
    printf("client socket failed\n");
    exit(1);
  }

  memset(&client_addr, 0, sizeof(client_addr));
  client_addr.sin_family = AF_INET;
  client_addr.sin_port = htons(CLITEST_CLIENT_PORT);
  client_addr.sin_addr.s_addr = INADDR_ANY;

  if (bind(sockfd, (struct sockaddr *)&client_addr, sizeof(client_addr)) <
      0) {
    printf("client bind failed\n");
    exit(1);
  }

  /* --- Client sends message to server --- */
  printf("sending payload\n");
  if (sendto(sockfd, msg, msglen, 0, (struct sockaddr *)&server_addr,
             sizeof(server_addr)) < 0) {
    printf("sendto failed\n");
    exit(1);
  }

  close(sockfd);
}

void udp_srv(void) {
  int sockfd;
  struct sockaddr_in server_addr, client_addr;
  char buf[64];


  printf("TESTING UDP SERVER...\n");

  // --- Create server socket
  sockfd = socket(AF_INET, SOCK_DGRAM, 0);
  if (sockfd < 0) {
    printf("server socket failed\n");
    exit(1);
  }

  memset(&server_addr, 0, sizeof(server_addr));
  server_addr.sin_family = AF_INET;
  server_addr.sin_port = htons(SRVTEST_SERVER_PORT);
  server_addr.sin_addr.s_addr = htonl(0xc0a8fe74);

  if (bind(sockfd, (struct sockaddr *)&server_addr, sizeof(server_addr)) <
  0) {
    printf("server bind failed\n");
    exit(1);
  }

  // --- Server receives message
  int fromlen = sizeof(client_addr);
  while (1) {
  printf("waiting for packet...\n");
    int n = recvfrom(sockfd, buf, sizeof(buf)-1, 0,
        (struct sockaddr *)&client_addr, &fromlen);
    buf[n] = '\0';

    printf("UDP PACKET RECEIVED: \n\t");
    printf("%s\n", buf);
  }

  close(sockfd);
}

int main(int argc, char **argv) {

  if (argc != 2) {
    printf("Usage: net_test [ srv | cli | all ]\n");
  }

  if (strcmp(argv[1], "srv") == 0) {
    udp_srv();
  } else if (strcmp(argv[1], "cli") == 0) {
    udp_cli();
  } else if (strcmp(argv[1], "all") == 0) {
    // udp_all();
  }
}
