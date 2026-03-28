#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"
#include "user/ithreads.h"
#include "kernel/sys/types.h"
#include "kernel/sys/net.h"
#include "kernel/sys/socket.h"

// Must be < MAX_PORT_BINDINGS (512).
#define CHAT_PORT 400
#define BUF_SIZE  256

void *recv_loop(void *arg)
{
  int sockfd = *(int *)arg;
  char buf[BUF_SIZE];
  struct sockaddr_in from;
  int fromlen = sizeof(from);

  while (1) {
    int n = recvfrom(sockfd, buf, BUF_SIZE - 1, 0,
                     (struct sockaddr *)&from, (socklen_t *)&fromlen);
    if (n > 0) {
      buf[n] = '\0';
      printf("peer> %s\n", buf);
    }
    memset(buf, 0, BUF_SIZE);
  }
  return 0;
}

int main(int argc, char **argv)
{
  if (argc != 2) {
    printf("usage: chat <peer_ip>\n");
    exit(1);
  }

  uint peer_ip = inet_addr(argv[1]);
  if (peer_ip == 0) {
    printf("invalid ip: %s\n", argv[1]);
    exit(1);
  }

  int sockfd = socket(AF_INET, SOCK_DGRAM, 0);
  if (sockfd < 0) {
    printf("socket failed\n");
    exit(1);
  }

  // Bind to CHAT_PORT on all local interfaces.
  struct sockaddr_in local;
  memset(&local, 0, sizeof(local));
  local.sin_family = AF_INET;
  local.sin_port = htons(CHAT_PORT);
  local.sin_addr.s_addr = INADDR_ANY;

  if (bind(sockfd, (struct sockaddr *)&local, sizeof(local)) < 0) {
    printf("bind failed\n");
    exit(1);
  }

  // Spawn receiver thread.
  ithread_create(recv_loop, &sockfd);

  // Peer address — inet_addr returns host byte order, htonl converts to
  // the network byte order that sin_addr.s_addr expects.
  struct sockaddr_in peer;
  memset(&peer, 0, sizeof(peer));
  peer.sin_family = AF_INET;
  peer.sin_port = htons(CHAT_PORT);
  peer.sin_addr.s_addr = htonl(peer_ip);

  printf("chat ready — type a message and press enter\n");
  printf("(peer: %s, port %d)\n", argv[1], CHAT_PORT);

  char buf[BUF_SIZE];
  while (1) {
    int len = fgetstdin(buf, BUF_SIZE);
    if (len == 0)
      continue;
    if (sendto(sockfd, buf, len, 0,
               (struct sockaddr *)&peer, sizeof(peer)) < 0) {
      printf("sendto failed\n");
    }
  }

  close(sockfd);
  exit(0);
}
