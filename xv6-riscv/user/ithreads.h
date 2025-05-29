// typedef struct {
//   struct proc *proc;
// } ithread_t;

#define MAX_THREADS 64
#define PGSIZE 4096

int free_stacks();
int expand_stacks();
void ithread_exit(uint64 status);
int ithread_create(void* (*func)(), void *args);
int ithread_join(int ithread);
