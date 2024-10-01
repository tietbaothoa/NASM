section .data
    outp    db  "Helloooo", 0Ah, 0h

section .bss

section .text
global _start

_start:
    ; mov     rbp, rsp

    mov     rdi, 1
    mov     rsi, outp
    mov     rdx, 10
    mov     rax, 1
    syscall

    mov     rax, 60
    mov     rdi, 0
    syscall