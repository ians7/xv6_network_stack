#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"
#include "user/ithreads.h"
#include "kernel/sys/types.h"
#include "kernel/sys/net.h"
#include "kernel/sys/socket.h"

#define PORT_A   401
#define PORT_B   402
#define BUF_SIZE 256

struct server_args {
    uint16 port;
    char   *name;
};

static struct server_args args_a = { PORT_A, "A" };
static struct server_args args_b = { PORT_B, "B" };

static int print_lock = 0;

static void acquire_print() {
    while (__sync_lock_test_and_set(&print_lock, 1) != 0);
}
static void release_print() {
    __sync_lock_release(&print_lock);
}

void *server_thread(void *arg)
{
    struct server_args *sa = (struct server_args *)arg;

    int fd = socket(AF_INET, SOCK_DGRAM, 0);
    if (fd < 0) {
        acquire_print();
        printf("server %s: socket failed\n", sa->name);
        release_print();
        ithread_exit(1);
        return 0;
    }

    struct sockaddr_in local;
    memset(&local, 0, sizeof(local));
    local.sin_family      = AF_INET;
    local.sin_port        = htons(sa->port);
    local.sin_addr.s_addr = INADDR_ANY;

    if (bind(fd, (struct sockaddr *)&local, sizeof(local)) < 0) {
        acquire_print();
        printf("server %s: bind failed on port %d\n", sa->name, sa->port);
        release_print();
        ithread_exit(1);
        return 0;
    }

    acquire_print();
    printf("server %s: listening on port %d\n", sa->name, sa->port);
    release_print();

    char buf[BUF_SIZE];
    struct sockaddr_in from;
    int fromlen = sizeof(from);

    while (1) {
        int n = recvfrom(fd, buf, BUF_SIZE - 1, 0,
                         (struct sockaddr *)&from, (socklen_t *)&fromlen);
        if (n > 0) {
            buf[n] = '\0';
            acquire_print();
            printf("server %s (port %d): %s\n", sa->name, sa->port, buf);
            release_print();
        }
    }

    ithread_exit(0);
    return 0;
}

int main(void)
{
    int t1 = ithread_create(server_thread, &args_a);
    int t2 = ithread_create(server_thread, &args_b);

    if (t1 < 0 || t2 < 0) {
        printf("ithread_create failed\n");
        exit(1);
    }

    ithread_join(t1);
    ithread_join(t2);
    exit(0);
}
