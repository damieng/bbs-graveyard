typedef struct _PCI_CLASSTABLE {
    unsigned short Class;
    char *ClassName;
} PCI_CLASSTABLE, *PPCI_CLASSTABLE;

PCI_CLASSTABLE PciClassTable [] = {
    { 0xFF, "Unknown" },
    { 0x00, "Early card" },
    { 0x01, "Storage" },
    { 0x02, "Network" },
    { 0x03, "Display" },
    { 0x04, "Multimedia" },
    { 0x05, "Memory" },
    { 0x06, "Bridge" },
    { 0x07, "Communication" },
    { 0x08, "System peripheral" },
    { 0x09, "Input" },
    { 0x0A, "Docking station" },
    { 0x0B, "CPU" },
    { 0x0C, "Serial bus"},
};

typedef struct _PCI_SUBCLASSTABLE {
    unsigned short Class;
    unsigned short Subclass;
    char *SubclassName;
}  PCI_SUBCLASSTABLE, *PPCI_SUBCLASSTABLE ;

PCI_SUBCLASSTABLE PciSubclassTable [] = {
    { 0x00, 0x00, "Unknown" },
    { 0x00, 0x01, "VGA Display Card" },
    // Storage
    { 0x01, 0x00, "SCSI Controller" },
    { 0x01, 0x01, "IDE Controller" },
    { 0x01, 0x02, "Floppy Controller" },
    { 0x01, 0x03, "IPI Controller" },
    { 0x01, 0x04, "RAID Controller" },
    { 0x01, 0x80, "Storage Controller" },
    // Network
    { 0x02, 0x00, "Ethernet LAN Adapter" },
    { 0x02, 0x01, "Token Ring LAN Adapter" },
    { 0x02, 0x02, "FDDI LAN Adapter" },
    { 0x02, 0x03, "ATM Adapter" },
    { 0x02, 0x80, "Network Adapter" },
    // Display
    { 0x03, 0x00, "Graphics Card" },
    { 0x03, 0x01, "XGA Display Card" },
    { 0x03, 0x80, "Display Card" },
    // Multimedia
    { 0x04, 0x00, "Video Device" },
    { 0x04, 0x01, "Audio Device" },
    { 0x04, 0x80, "Multimedia Device" },
    // Memory
    { 0x05, 0x00, "RAM Controller" },
    { 0x05, 0x01, "Flash Memory Controller" },
    { 0x05, 0x80, "Memory Controller" },
    // Bridge
    { 0x06, 0x00, "CPU Host Bridge" },
    { 0x06, 0x01, "ISA Bridge" },
    { 0x06, 0x02, "EISA Bridge" },
    { 0x06, 0x03, "MCA/MicroChannel Bridge" },
    { 0x06, 0x04, "PCI-to-PCI Bridge" },
    { 0x06, 0x05, "PCMCIA/PC-Card Bridge" },
    { 0x06, 0x06, "NuBus Bridge" },
    { 0x06, 0x07, "CardBus Bridge" },
    { 0x06, 0x80, "Bridge" },
    // Communications
    { 0x07, 0x00, "Serial Port" },
    { 0x07, 0x01, "Parallel Port" },
    { 0x07, 0x80, "Communications Port" },
    // System
    { 0x08, 0x00, "PIC (Peripheral interrupt controller)" },
    { 0x08, 0x01, "DMAC (Direct memory access controller)" },
    { 0x08, 0x02, "Timer" },
    { 0x08, 0x03, "RTC" },
    { 0x08, 0x80, "System Device" },
    // Input
    { 0x09, 0x00, "Keyboard" },
    { 0x09, 0x01, "Pen" },
    { 0x09, 0x02, "Mouse" },
    { 0x08, 0x80, "Input Device" },
    // Docking
    { 0x0A, 0x00, "Generic Docking" },
    { 0x0A, 0x01, "Docking" },
    // Processor
    { 0x0B, 0x00, "Intel 386 CPU" },
    { 0x0B, 0x01, "Intel 486 CPU" },
    { 0x0B, 0x02, "Intel Pentium CPU" },
    { 0x0B, 0x10, "Digital Alpha CPU" },
    { 0x0B, 0x20, "IBM/Motorola PowerPC CPU" },
    { 0x0B, 0x40, "Co-processor" },
    // Serial
    { 0x0C, 0x00, "Firewire IEE-1394 Bus" },
    { 0x0C, 0x01, "ACCESS Bus" },
    { 0x0C, 0x02, "SSA Bus" },
    { 0x0C, 0x03, "USB (Universal Serial Bus)" },
    { 0x0C, 0x04, "Fibre Channel Bus" }
};

typedef struct _PCI_APITABLE {
    unsigned short Class;
    unsigned short Subclass;
    unsigned short Api;
    char *ApiName;
} PCI_APITABLE, *PPCI_APITABLE;

PCI_APITABLE PciApiTable [] = {
    { 0x00, 0x00, 0x00, "Unknown" },
    { 0x01, 0x01, 0x80, "Bus Mastering" },
    { 0x07, 0x00, 0x00, "8250" },
    { 0x07, 0x00, 0x01, "16450" },
    { 0x07, 0x00, 0x02, "16550 (16-byte FIFO buffer)" },
    { 0x07, 0x01, 0x00, "Standard" },
    { 0x07, 0x01, 0x01, "Bidirectional" },
    { 0x07, 0x01, 0x02, "ECP 1.x Enhanced" },
    { 0x08, 0x00, 0x00, "Generic 8259 PIC" },
    { 0x08, 0x00, 0x01, "ISA PIC" },
    { 0x08, 0x00, 0x02, "EISA PIC" },
    { 0x08, 0x01, 0x00, "Generic 8237 DMA" },
    { 0x08, 0x01, 0x01, "ISA DMA" },
    { 0x08, 0x01, 0x02, "EISA DMA" },
    { 0x08, 0x02, 0x00, "Generic 8254 Timer" },
    { 0x08, 0x02, 0x01, "ISA Timer" },
    { 0x08, 0x02, 0x02, "EISA Dual Timers" },
    { 0x08, 0x03, 0x00, "Generic RTC" },
    { 0x08, 0x03, 0x01, "ISA RTC" }
};