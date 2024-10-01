section .data
    outpt   db  "Nhap chuoi: ", 0Ah, 0h

section .bss
    inp     resb    100
    outp    resb    100

section .text
global _start

_start:
    mov     rbp, rsp

    mov     rdi, 1      ;handle file in
    mov     rsi, outpt
    mov     rdx, 14
    mov     rax, 1      ;sys_write
    syscall

    mov     rdi, 0      ;handle file out
    mov     rsi, inp
    mov     rdx, 100
    mov     rax, 0      ;sys_read
    syscall
    mov     rcx, inp

    .upper:
        cmp     byte [rcx], 'a'
        jl      .notlowercase
        cmp     byte [rcx], 'z'
        jg      .notlowercase
        sub     byte [rcx], 20h
        inc     rcx
        jmp     .upper

        .notlowercase:
            inc     rcx
            cmp     byte [rcx], 0h
            jz      .print
            jmp     .upper

        .print:
            mov     rdi, 1
            mov     rsi, inp
            mov     rdx, 100
            mov     rax, 1
            syscall

            mov     rax, 60     ;sys_exit
            mov     rdi, 0      ;exit code 0
            syscall