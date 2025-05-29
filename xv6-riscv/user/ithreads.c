#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"
#include "syscall.h"
#include "user/ithreads.h"

#define INIT_MAX_STACKS 8

extern int create_thread();
extern void free(void *);
extern void* malloc(uint);
extern void* memmove(void*, const void*, int);
extern int thread_exit(uint64);

int threads_done = 0;
int num_threads = 0;
int max_stacks = INIT_MAX_STACKS;
void **stacks = 0;

int free_stacks() {
  for (int i = 0; i < num_threads; i++) {
    free(stacks[i]);
  }
  free(stacks);

  // reset globals
  stacks = 0;
  num_threads = 0;
  max_stacks = INIT_MAX_STACKS;
  threads_done = 0;

  return 0;
}

int expand_num_threads() {
  max_stacks *= 2;
  void **new_stacks = malloc(max_stacks*sizeof(char*));
  memmove(new_stacks, stacks, num_threads*sizeof(char*));
  free(stacks);
  stacks = new_stacks;
  return 0;
}

void ithread_exit(uint64 status) {
  thread_exit(status);
}

int ithread_create(void* (*fn_ptr)(void *), void *args) {
  if (stacks == 0) {
    stacks = malloc(max_stacks*sizeof(char*));
  }
  if (num_threads == max_stacks) {
    if (max_stacks == MAX_THREADS) {
      printf("ERROR: Thread capacity has been reached\n");
      return -1;
    }
    expand_num_threads();
  }

  void *stack_ptr = malloc(PGSIZE);
  stacks[num_threads] = stack_ptr;
  int res = create_thread(fn_ptr, args, stack_ptr, &ithread_exit);
  if (res != -1) {
    num_threads++;
  } else {
    free(stack_ptr);
    stacks[num_threads] = 0;
  }
  return res;
}

int ithread_join(int thread_id) {
  int status;
  join_thread(thread_id, (uint64)&status);
  threads_done++;
  if (threads_done == num_threads) {
    free_stacks();
  }
  return status;
}
