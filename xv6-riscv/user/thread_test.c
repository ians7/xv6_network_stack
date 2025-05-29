#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"
#include "syscall.h"
#include "user/ithreads.h"

#define PGSZ 4096

int *p = (int*) 0xdeadbeef;
int global = 5;

void *do_nothing(void *args) {
  int *tidx = (int *)args;
  if (*tidx == 1) {
    sleep(20);
  }
  printf("Thread %d is doing nothing! tid = %d\n", *tidx, getpid());
  return 0;
}

void *do_nothing2(void *args) {
  int *tidx = (int *)args;
  printf("Thread %d is doing nothing! tid = %d\n", *tidx, getpid());
  printf("Global value: %d\n", global);
  global += 5;
  return 0;
}

void *prop_mem_dealloc1(void *arg)
{
  p = (int *)sbrk(4096);  // allocate a page
  p[0] = 42;
  sleep(50);              // allow thread 2 to read
  p = (int *)sbrk(-4096);            // deallocate
  return 0;
}

void *prop_mem_dealloc2(void *arg)
{
  sleep(50); // wait for allocation
  int val = p[0]; // should be 42 before deallocation
  printf("Read before free: %d\n", val);

  sleep(60); // wait for deallocation

  // Try to access deallocated memory
  int fail = 0;
  if (p == (int *)0xdeadbeef) {
    printf("FAIL: p is invalid\n");
    return 0;
  }

  // Expect a fault or incorrect behavior
  printf("Read after free: ");
  fail = p[0]; // this should ideally trap or fail
  printf("%d (expected trap or garbage)\n", fail);

  return 0;
}

void *prop_mem_add1(void *arg)
{
  p = (int *)sbrk(4096);
  p[0] = 3;
  p[1] = 2;
  return 0;
}

void *prop_mem_add2(void *arg)
{
  sleep(50);
  if(p == (int *)0xdeadbeef) {
    printf("FAIL: p == 0xdeadbeef\n");
    return 0;
  }

  if(p[0] == 3 && p[1] == 2) {
    printf("PASSED\n");
    // SUCCESS
  } else {
    printf("FAIL: values did not change for siblings\n");
    // FAIL
  }
  return 0;
}

void test_global_pointer_alloc() {
  printf("--- BEGIN sbrk(+) TEST ---\n");
  int tid1 = ithread_create(prop_mem_add1, (void *)0);
  int tid2 = ithread_create(prop_mem_add2, (void *)0);
  ithread_join(tid1);
  ithread_join(tid2);

}

void test_global_pointer_free() {
  printf("--- BEGIN sbrk(-) TEST ---\n");
  int tid1 = ithread_create(prop_mem_dealloc1, 0);
  int tid2 = ithread_create(prop_mem_dealloc2, 0);
  // int tid3 = ithread_create(prop_mem_dealloc2, 0);

  ithread_join(tid1);
  ithread_join(tid2);
  // ithread_join(tid3);
}

void test_many_threads() {
  printf("--- BEGIN MANY THREADS TEST ---\n");
  uint64 *tids = malloc(sizeof(uint64)*(MAX_THREADS));
  int *nums = malloc(sizeof(int)*(MAX_THREADS));
  for (int i = 0; i < MAX_THREADS; i++) {
    nums[i] = i;
    tids[i] = ithread_create(do_nothing2, (void *)&nums[i]);
  }
  sleep(10);
  for (int i = 0; i < MAX_THREADS; i++) {
    if (tids[i] != -1) {
      int result = ithread_join(tids[i]);
      printf("Joined thread %d (tid = %d) returned %d!\n", i + 1, tids[i], result);
    }
  }
  free(nums);
  free(tids);
}

int main(int argc, char *argv[]) {
  // uint64 tids[6] = {0, 0, 0, 0, 0, 0};
  // for (int i = 0; i < 3; i++) {
  //   int *num = malloc(sizeof(int));
  //   *num = i;
  //   tids[i] = ithread_create(do_nothing, (void *)num);
  // }
  // sleep(20);
  // for (int i = 3; i < 6; i++) {
  //   int *num = malloc(sizeof(int));
  //   *num = i;
  //   tids[i] = ithread_create(do_nothing2, (void *)num);
  // }
  //
  // sleep(30);
  //
  // for (int i = 0; i < 6; i++) {
  //   int status;
  //   int result = join_thread(tids[i], (uint64)&status);
  //   printf("Joined thread %d (tid = %d) returned %d! status = %d\n", i, tids[i], result, status);
  // }
  //
  // for (int i = 0; i < 6; i++) {
  //   tids[i] = 0;
  // }
  //
  // for (int i = 0; i < 3; i++) {
  //   int *num = malloc(sizeof(int));
  //   *num = i;
  //   tids[i] = ithread_create(do_nothing, (void *)num);
  // }
  //
  // for (int i = 0; i < 3; i++) {
  //   int status;
  //   int result = join_thread(tids[i], (uint64)&status);
  //   printf("Joined thread %d (tid = %d) returned %d! status = %d\n", i, tids[i], result, status);
  // }
  // for (int i = 0; i < MAX_THREADS; i++) {
  // test_global_pointer_alloc();
  test_global_pointer_free();
  // }
  printf("Tests complete!\n");
  return 0;
}



