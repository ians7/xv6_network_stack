#include "../kernel/spinlock.h"
#include "../kernel/sys/socket.h"

struct stat;

// system calls
int fork(void);
int exit(int) __attribute__((noreturn));
int wait(int*);
int pipe(int*);
int write(int, const void*, int);
int read(int, void*, int);
int close(int);
int kill(int);
int exec(const char*, char**);
int open(const char*, int);
int mknod(const char*, short, short);
int unlink(const char*);
int fstat(int fd, struct stat*);
int link(const char*, const char*);
int mkdir(const char*);
int chdir(const char*);
int dup(int);
int getpid(void);
char* sbrk(int);
int sleep(int);
int uptime(void);
int spoon(void*);
int create_thread(void* (*fn_addr)(void *), void *args, void *stack_addr, void (*exit_fn)(uint64));
int join_thread(int thread_id, int status_addr);
int thread_exit(int status_addr);

// // socket.h
// int socket(int address_family, int address_socktype, int protocol);
// int bind(int socket, const struct sockaddr *address, socklen_t address_len);
// int listen(int socket, int backlog);
// int accept(int socket, struct sockaddr *address, socklen_t address_len);
// int connect(int socket, const struct sockaddr *address,
//             socklen_t address_len);
//
// int send(int socket, void *buf, uint length, int flags);
// int recv(int socket, void *buf, uint length, int flags);
// int sendto(int socket, const void *msg, uint length, int flags, 
//     const struct sockaddr *dst_addr, socklen_t dst_len);
// int recvfrom(int socket, void *buf, uint length, int flags,
//     struct sockaddr *address, socklen_t address_len);
//
// ulib.c
int stat(const char*, struct stat*);
char* strcpy(char*, const char*);
void *memmove(void*, const void*, int);
char* strchr(const char*, char c);
int strcmp(const char*, const char*);
void fprintf(int, const char*, ...);
void printf(const char*, ...);
char* gets(char*, int max);
uint strlen(const char*);
void* memset(void*, int, uint);
void* malloc(uint);
void free(void*);
int atoi(const char*);
int memcmp(const void *, const void *, uint);
void *memcpy(void *, const void *, uint);

// socket.h
int socket(int address_family, int address_socktype, int protocol);
int accept(int socket, struct sockaddr *address, socklen_t address_len);
int bind(int socket, const struct sockaddr *address, socklen_t address_len);
int listen(int socket, int backlog);
int connect(int socket, const struct sockaddr *address,
            socklen_t address_len);
int close(int socket);

int recv(int socket, void *buffer, int length, int flags);
int recvfrom(int socket, void *buffer, int length,
             int flags, const struct sockaddr *address, socklen_t *address_len);
int send(int socket, const void *message, int length, int flags);
int sendto(int socket, const void *message, int length, int flags,
             const struct sockaddr *dest_addr, socklen_t dest_len);
