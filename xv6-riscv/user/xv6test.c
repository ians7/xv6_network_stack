#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"
#include "user/ithreads.h"
#include "stdint.h"
#include "stddef.h"

//The following are the test thread functions used
//
int* p = (int *)0xdeadbeef;
int shared_counter = 0;

void *exit_all(void *args) {
  int val = *(int*)args;
  if (val == 9) {
    sleep(5);
    exit(0);
  }
  sleep(100);
  printf("Test 6 FAILED: exit_all failed\n");
  return 0;
}
 
void *prop_mem_dealloc1(void *arg)
{
  p = (int *)sbrk(4096);  // allocate a page
  p[0] = 42;
  sleep(80);              // allow thread 2 to read
  p = (int *)sbrk(-4096);            // deallocate
  return 0;
}

void *prop_mem_dealloc2(void *arg)
{
  sleep(60); // wait for allocation
  int val = p[0]; // should be 42 before deallocation
  printf("Read before free: %d\n", val);

  sleep(40); // wait for deallocation

  // Try to access deallocated memory
  int fail = 0;                                                                                                                                                                      if (p == (int *)0xdeadbeef) {
    printf("FAIL: p is invalid\n");
    return 0;
  }

  // Expect a fault or incorrect behavior
  printf("Test 7 PASSED: If this throws a kerneltrap\n");
  fail = p[0]; // this should ideally trap or fail
  printf("Read after free: %d\n", fail);
  printf("Test 7 FAILED: %d (expected trap or garbage)\n", fail);

  return 0;
}

void* thread_func_basic(void *arg) {
  int val = *(int*)arg;
  printf("Thread %d is running\n", val);
  free(arg);
  return (void *)(uintptr_t)(val + 1);
}

void* thread_func_shared(void *arg) {
  int i;
  for (i = 0; i < 50; i++) {
    shared_counter++;
  }

  return 0;
}

void* thread_func_exit(void *arg) {
  ithread_exit(0);
  return 0;
}

//test creation of threads
void test_thread_create() {
  printf("Test 1: Thread creation\n");
  int *arg = malloc(sizeof(int));
  *arg = 0;
  int tid = ithread_create(thread_func_basic, arg);

  if (tid < 0) {
    printf("Test 1 FAILED - Thread not created\n");
  } else {
    printf("Test 1 PASSED - Thread created with tid %d\n", tid);
    ithread_join(tid);
  }
}

void test_global_pointer_dealloc() {
  printf("Test 7: sbrk(-) Test\n");
  int tid1 = ithread_create(prop_mem_dealloc1, 0);
  int tid2 = ithread_create(prop_mem_dealloc2, 0);

  ithread_join(tid1);
  ithread_join(tid2);
}

void *prop_mem_alloc1(void *arg)
{
  p = (int *)sbrk(4096);
  p[0] = 3;
  p[1] = 2;
  return 0;
}

void *prop_mem_alloc2(void *arg)
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
  printf("Test 6: sbrk(+) Test\n");
  int tid1 = ithread_create(prop_mem_alloc1, (void *)0);
  int tid2 = ithread_create(prop_mem_alloc2, (void *)0);
  ithread_join(tid1);
  ithread_join(tid2);

}

//test joining of threads

void test_thread_join() {
  printf("Test 2: Joining threads\n");

  int *arg = malloc(sizeof(int));
  *arg = 100;
  int tid = ithread_create(thread_func_basic, arg);

  if (tid < 0) {
    printf("Test 2 FAILED - Could not create thread\n");
    return;
  }

  int status = ithread_join(tid);
  if (status == 101) {
    printf("Test 2 PASSED - Joined thread, status = %d\n", status);
  } else {
    printf("Test 2 FAILED - Unexpected status %d\n", status);
  }
}


//test shared memory

void test_shared_memory() {
  printf("Test 3: Shared memory between threads\n");

  shared_counter = 0;
  int tids[4];
  for (int i = 0; i < 4; i++) {
    tids[i] = ithread_create(thread_func_shared, 0);
  }

  for (int i = 0; i < 4; i++) {
    ithread_join(tids[i]);
  }

  if (shared_counter == 200) {
    printf("Test 3 PASSED - shared_counter = %d\n", shared_counter);
  } else {
    printf("Test 3 FAILED - shared_counter = %d\n", shared_counter);
  }
}

//test exit off of return

void test_exit() {
  printf("Test 4: Graceful exit via ithread_exit\n");

  int tid = ithread_create(thread_func_exit, 0);
  int status = ithread_join(tid);

  if (status == 0) {
    printf("Test 4 PASSED - Thread exited gracefully with status = %d\n", status);
  } else {
    printf("Test 4 FAILED - Unexpected exit status = %d\n", status);
  }
}

void test_exit_all() {
  printf("Test 5: Graceful exit of all threads via exit\n");
  int *num = malloc(10*sizeof(int));
  int tids[10];
  for (int i = 0; i < 10; i++) {
    num[i] = i;
    tids[i] = ithread_create(exit_all, (void *)&num[i]);
  }
  for (int i = 0; i < 10; i++) {
    ithread_join(tids[i]);
  }
  free(num);
}

int main(int argc, char *argv[]) {
  if (argc > 2) {
    printf("Needs the format: xv6test (1-7)\n", argv[0]);
    exit(1);
  }

  int test = atoi(argv[1]);
  if(argc == 2){ 
  switch (test) {
    case 1:
      test_thread_create();
      break;
    case 2:
      test_thread_join();
      break;
    case 3:
      test_shared_memory();
      break;
    case 4:
      test_exit();
      break;
    case 5:
      test_exit_all();
      break;
    case 6:
      test_global_pointer_alloc();
      break;
    case 7:
      test_global_pointer_dealloc();
      break;
    default:
      printf("Invalid test number. Choose 1-5.\n");
  }
  }else{
   test_thread_create();
   printf("\n");
   test_thread_join();
   printf("\n");
   test_shared_memory();
   printf("\n");
   test_exit();
   printf("\n");
   // test_exit_all();
   printf("\n");
   test_global_pointer_alloc();
   printf("\n");
   test_global_pointer_dealloc();
  }

  exit(0);
}
