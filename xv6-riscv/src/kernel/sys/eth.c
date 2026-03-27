#include "../types.h"
#include "../riscv.h"
#include "../defs.h"
#include "../spinlock.h"
#include "net.h"
#include "eth.h"

void 
print_eth_frame(struct eth_frame *frame)
{
  printf("\n");
  printf("dst_addr: %x:%x:%x:%x:%x:%x\n", frame->hdr.dst_addr[0],
                                          frame->hdr.dst_addr[1],
                                          frame->hdr.dst_addr[2],
                                          frame->hdr.dst_addr[3],
                                          frame->hdr.dst_addr[4],
                                          frame->hdr.dst_addr[5]);
  printf("src_addr: %x:%x:%x:%x:%x:%x\n", frame->hdr.src_addr[0],
                                          frame->hdr.src_addr[1],
                                          frame->hdr.src_addr[2],
                                          frame->hdr.src_addr[3],
                                          frame->hdr.src_addr[4],
                                          frame->hdr.src_addr[5]);

  switch(ntohs(frame->hdr.type)) {
    case(0x0800):
      printf("type: IPv4\n");
      break;
    case(0x0806):
      printf("type: ARP\n");
      break;
    case(0x08DD):
      printf("type: IPv6\n");
      break;
  }

  // printf("payload_len: %d\n", frame->payload_len);
  // printf("payload :\n\t");
  for (int i = 0; i < frame->payload_len; i++) {
    printf("%x", frame->payload[i]);
    if (i > 0 && i % 40 == 0)
      printf("\n\t");
  }
  printf("\n");
}

int
parse_eth_packet(uint8 *buf, int len, struct eth_frame *eth_frame)
{
  uint16 payload_len = len - sizeof(struct eth_hdr);
  memmove(&eth_frame->hdr, buf, sizeof(struct eth_hdr));
  memmove(eth_frame->payload, buf + sizeof(struct eth_hdr), payload_len);
  eth_frame->payload_len = payload_len;
  return 0;
}

void build_eth(struct eth_frame *eth, uint8 *dst, uint8 *src, uint16 type) {
  memmove(eth->hdr.dst_addr, dst, 6);
  memmove(eth->hdr.src_addr, src, 6);
  eth->hdr.type = htons(type);
}

