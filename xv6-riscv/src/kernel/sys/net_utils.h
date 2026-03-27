#pragma once
#include "net.h"

// Internal helpers, not exported to userspace
int insert_port_binding(struct port_binding *bind);
int remove_port_binding(struct port_binding *port);
