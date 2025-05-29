// Physical memory allocator, for user processes,
// kernel stacks, page-table pages,
// and pipe buffers. Allocates whole 4096-byte pages.

#include "types.h"
#include "param.h"
#include "memlayout.h"
#include "spinlock.h"
#include "riscv.h"
#include "defs.h"

void freerange(void *pa_start, void *pa_end);

extern char end[]; // first address after kernel.
                   // defined by kernel.ld.

#define MAX_USER_PAGE_COUNT ((PHYSTOP - KERNBASE) / PGSIZE)

uint64 ref_counter[MAX_USER_PAGE_COUNT];

struct run {
  struct run *next;
};

struct {
  struct spinlock lock;
  struct run *freelist;
} kmem;

void add_page_reference(uint64 pointer_in_page){
  acquire(&kmem.lock);
  uint page_num = PGROUNDDOWN((uint64)pointer_in_page)/PGSIZE;
  ref_counter[page_num]++;
  release(&kmem.lock);
}

void
kinit()
{
  initlock(&kmem.lock, "kmem");
  freerange(end, (void*)PHYSTOP);
}

void
freerange(void *pa_start, void *pa_end)
{
  char *p;
  p = (char*)PGROUNDUP((uint64)pa_start);
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    kfree(p);
}

// Free the page of physical memory pointed at by pa,
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(void *pa)
{
  struct run *r;

  if(((uint64)pa % PGSIZE) != 0 || (char*)pa < end || (uint64)pa >= PHYSTOP)
    panic("kfree");

  acquire(&kmem.lock);
  uint64 page_num = PGROUNDDOWN((uint64)pa)/PGSIZE;
  if (ref_counter[page_num] > 1) {
    ref_counter[page_num]--;
    release(&kmem.lock);
    return;
  }
  ref_counter[page_num] = 0; // insurance
  release(&kmem.lock);

  // Fill with junk to catch dangling refs.
  memset(pa, 1, PGSIZE);

  r = (struct run*)pa;

  acquire(&kmem.lock);
  r->next = kmem.freelist;
  kmem.freelist = r;
  release(&kmem.lock);
}

// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
void *
kalloc(void)
{
  struct run *r;

  acquire(&kmem.lock);

  r = kmem.freelist;
  if(r)
    kmem.freelist = r->next;
  uint64 page_num = PGROUNDDOWN((uint64)r)/PGSIZE;
  ref_counter[page_num] = 1;
  release(&kmem.lock);

  if(r)
    memset((char*)r, 5, PGSIZE); // fill with junk
  return (void*)r;
}
