.set IRQ_BASE, 0x20

.section .text

.extern _ZN16InterruptManager15HandleInterruptEhj


.macro HandleException num
.global _ZN16InterruptManager19HandleException\num\()Ev
_ZN16InterruptManager19HandleException\num\()Ev:
    jmp 0x0000
    movb $\num, (interruptnumber)
    jmp int_bottom
.endm


.macro HandleInterruptRequest num
.global _ZN16InterruptManager26HandleInterruptRequest\num\()Ev
_ZN16InterruptManager26HandleInterruptRequest\num\()Ev:
    jmp 0x0000
    movb $\num + IRQ_BASE, (interruptnumber)
    # pushl $0
    jmp int_bottom
.endm

HandleException 0x00
HandleException 0x01

HandleInterruptRequest 0x00
HandleInterruptRequest 0x01


int_bottom:
    # save registers
    pusha
    pushl %ds
    pushl %es
    pushl %fs
    pushl %gs
    # pushl %ebp
    # pushl %edi
    # pushl %esi

    # pushl %edx
    # pushl %ecx
    # pushl %ebx
    # pushl %eax

    # load ring 0 segment register
    # cld
    # mov $0x10, %eax
    # mov %eax, %eds
    # mov %eax, %ees

    # call C++ Handler
    pushl %esp
    push (interruptnumber)
    call _ZN16InterruptManager15HandleInterruptEhj
    add %esp, 6
    mov %eax, %esp # switch the stack

    # restore registers
    # popl %eax
    # popl %ebx
    # popl %ecx
    # popl %edx

    # popl %esi
    # popl %edi
    # popl %ebp
    popl %gs
    popl %fs
    popl %es
    popl %ds
    popa

    # add $4, %esp


.global _ZN16InterruptManager22IgnoreInterruptRequestEv
_ZN16InterruptManager22IgnoreInterruptRequestEv:
    jmp 0x0000
    iret


.data
    interruptnumber: .byte 0
