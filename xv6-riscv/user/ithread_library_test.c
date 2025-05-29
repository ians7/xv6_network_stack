#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"
#include "ithreads.h"

void *do_nothing(void *args) {
  int *tidx = (int *)args;
  if (*tidx == 1) {
    sleep(20);
  }
  printf("Thread %d is doing nothing! tid = %d\n", *tidx, getpid());
  exit(0);
  return 0;
}

void *do_nothing2(void *args) {
  int *tidx = (int *)args;
  printf("Thread %d is doing nothing! tid = %d\n", *tidx, getpid());
  exit(0);
  return 0;
}

int main(int argc, char** argv) {
  int *num = malloc(sizeof(int));
  *num = 10;
  int tid = ithread_create(do_nothing, num);
  int tid2 = ithread_create(do_nothing2, num);
  ithread_join(tid);
  ithread_join(tid2);
  return 0;
}
