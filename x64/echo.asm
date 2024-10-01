section .data
    outp    db  "Nhap chuoi can in: ", 0Ah, 0h
section .bss
    inp     resb 100

section .text
global _start

_start:
    mov     rbp, rsp

    mov     rdi, 1
    mov     rsi, outp
    mov     rdx, 21
    mov     rax, 1
    syscall

    mov     rdi, 0
    mov     rsi, inp
    mov     rdx, 100
    mov     rax, 0
    syscall

    mov     rdi, 1
    mov     rsi, inp
    mov     rdx, 100
    mov     rax, 1
    syscall

    mov     rax, 60
    mov     rdi, 0
    syscall