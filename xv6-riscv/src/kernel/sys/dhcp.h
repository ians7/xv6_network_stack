#ifndef DHCP_H
#define DHCP_H

#define DHCP_REQUEST 1
#define DHCP_ACK     2

void dhcp_init();
void dhcp_request();
void dhcp_handle_packet(char *packet, int len);

#endif
