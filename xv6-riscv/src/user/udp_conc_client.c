#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"
#include "kernel/sys/types.h"
#include "kernel/sys/net.h"
#include "kernel/sys/socket.h"

#define PORT_A     401
#define PORT_B     402
#define NUM_MSGS   5

int main(int argc, char **argv)
{
    if (argc != 2) {
        printf("usage: udp_conc_client <server_ip>\n");
        exit(1);
    }

    uint server_ip = inet_addr(argv[1]);
    if (server_ip == 0) {
        printf("invalid ip: %s\n", argv[1]);
        exit(1);
    }

    int fd = socket(AF_INET, SOCK_DGRAM, 0);
    if (fd < 0) {
        printf("socket failed\n");
        exit(1);
    }

    struct sockaddr_in dst_a, dst_b;

    memset(&dst_a, 0, sizeof(dst_a));
    dst_a.sin_family      = AF_INET;
    dst_a.sin_port        = htons(PORT_A);
    dst_a.sin_addr.s_addr = htonl(server_ip);

    memset(&dst_b, 0, sizeof(dst_b));
    dst_b.sin_family      = AF_INET;
    dst_b.sin_port        = htons(PORT_B);
    dst_b.sin_addr.s_addr = htonl(server_ip);

    char msg_a[32], msg_b[32];

    for (int i = 0; i < NUM_MSGS; i++) {
        // send to server A
        memset(msg_a, 0, sizeof(msg_a));
        // build "hello A <i>" manually (no sprintf in xv6)
        msg_a[0] = 'h'; msg_a[1] = 'e'; msg_a[2] = 'l'; msg_a[3] = 'l';
        msg_a[4] = 'o'; msg_a[5] = ' '; msg_a[6] = 'A'; msg_a[7] = ' ';
        msg_a[8] = '0' + i;
        if (sendto(fd, msg_a, 9, 0,
                   (struct sockaddr *)&dst_a, sizeof(dst_a)) < 0)
            printf("sendto A failed\n");

        // send to server B
        memset(msg_b, 0, sizeof(msg_b));
        msg_b[0] = 'h'; msg_b[1] = 'e'; msg_b[2] = 'l'; msg_b[3] = 'l';
        msg_b[4] = 'o'; msg_b[5] = ' '; msg_b[6] = 'B'; msg_b[7] = ' ';
        msg_b[8] = '0' + i;
        if (sendto(fd, msg_b, 9, 0,
                   (struct sockaddr *)&dst_b, sizeof(dst_b)) < 0)
            printf("sendto B failed\n");

        printf("sent round %d to both ports\n", i);
    }

    exit(0);
}
