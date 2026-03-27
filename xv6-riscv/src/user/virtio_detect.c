#define VIRTIO_MMIO_MAGIC_VALUE     0x000
#define VIRTIO_MMIO_VERSION         0x004
#define VIRTIO_MMIO_DEVICE_ID       0x008
#define VIRTIO_MMIO_VENDOR_ID       0x00c

// In a loop:
uint32_t dev_id = *(volatile uint32_t *)(base + VIRTIO_MMIO_DEVICE_ID);
if (dev_id == 1) {
    printf("virtio-net device found at MMIO base %x\n", base);
}
