#ifndef __INTERRUPTS_H
#define __INTERRUPTS_H

#include "gdt.h"
#include "types.h"
#include "port.h"

class InterruptManager
{
protected:
    struct GateDescriptor
    {
        uint16_t handlerAddressLowBits;
        uint16_t handlerAddressHighBits;
        uint16_t gdt_codeSegmentSelector;
        uint8_t access;
        uint8_t reserved;
    } __attribute__((packed));

    static GateDescriptor interruptDescriptorTable[256];

    struct InterruptDescriptorTablePointer
    {
        uint16_t size;
        uint32_t base;
    } __attribute__((packed));
    
    uint16_t hardwareInterruptOffset;

    static void SetInterruptDescriptorTableEntry(
        uint8_t interruptNumber,
        uint16_t codeSegmentSelectorOffset,
        void (*handler)(),
        uint8_t DescriptorPrivilegeLevel,
        uint8_t DescriptorType
    );

    static void IgnoreInterruptRequest();
    static void HandleInterruptRequest0x00();
    static void HandleInterruptRequest0x01();

    static void HandleException0x00();
    static void HandleException0x01();

    static uint32_t HandleInterrupt(uint8_t interruptNumber, uint32_t esp);

    Port8BitSlow programmableInterruptControllerMasterCommandPort;
    Port8BitSlow programmableInterruptControllerMasterDataPort;
    Port8BitSlow programmableInterruptControllerSlaveCommandPort;
    Port8BitSlow programmableInterruptControllerSlaveDataPort;

public:
    InterruptManager(uint16_t hardwareInterruptOffset, GlobalDescriptorTable* globalDescriptorTable);
    ~InterruptManager();
    uint16_t HardwareInterruptOffset();
    void Activate();
};

#endif