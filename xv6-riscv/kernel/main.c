#include "types.h"
#include "param.h"
#include "memlayout.h"
#include "riscv.h"
#include "defs.h"

volatile static int started = 0;

void transmit_pkt_test1() {
  char *pkt1_str = "Hello, world!";
  uint16 pkt1_len = strlen(pkt1_str);
  transmit_packet(pkt1_str, pkt1_len, 0x7a05);
  printf("finished transmit_packet test 1\n");
}

void transmit_pkt_test2() {
  char *pkt1_str = "Hello, world!";
  uint16 pkt1_len = strlen(pkt1_str);
  char *pkt2_str = "Goodbye, world!";
  uint16 pkt2_len = strlen(pkt2_str);
  transmit_packet(pkt1_str, pkt1_len, 0x7a05);
  transmit_packet(pkt2_str, pkt2_len, 0x7a05);
  printf("finished transmit_packet test 2\n");
}

// void receive_pkt_test1() {
//   char *pkt_str = "Hi honey!";
//   uint16 pkt_len = strlen(pkt_str);
//   transmit_packet(pkt_str, pkt_len);
//   
//   char buf[128];
//   uint16 len = receive_packet(buf, 127);
//   buf[len] = '\0';
//   printf("received: %s", buf);
// }

// start() jumps here in supervisor mode on all CPUs.
void
main()
{
  if(cpuid() == 0){
    consoleinit();
    printfinit();
    printf("\n");
    printf("xv6 kernel is booting\n");
    printf("\n");
    kinit();         // physical page allocator
    kvminit();       // create kernel page table
    kvminithart();   // turn on paging
    procinit();      // process table
    trapinit();      // trap vectors
    trapinithart();  // install kernel trap vector
    plicinit();      // set up interrupt controller
    plicinithart();  // ask PLIC for device interrupts
    binit();         // buffer cache
    iinit();         // inode table
    fileinit();      // file table
    virtio_disk_init(); // emulated hard disk
    virtio_net_init(); // emulated NIC driver 
    transmit_pkt_test1();
    // transmit_pkt_test2();
    userinit();      // first user process
    __sync_synchronize();
    started = 1;
  } else {
    while(started == 0)
      ;
    __sync_synchronize();
    printf("hart %d starting\n", cpuid());
    kvminithart();    // turn on paging
    trapinithart();   // install kernel trap vector
    plicinithart();   // ask PLIC for device interrupts
  }

  scheduler();        
}

