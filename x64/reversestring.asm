section .data
    outp1    db  "Nhap chuoi: ", 0Ah, 0h
section .bss
    inp     resb    100
    outp2   resb    100
section .text
global _start

_start:
    mov     rsi, outp1
    mov     rdx, 14
    call    printf

    mov     rsi, inp
    mov     rdx, 100
    call    scanf

    mov     rsi, inp
    call    reversestr

    mov     rsi, inp
    mov     rdx, 100
    call    printf

    mov     rax, 60
    mov     rdi, 0
    syscall

reversestr:
    push    rbp
    mov     rbp, rsp
    push    rax
    push    rcx
    push    rdx
    mov     rdx, rsi
    xor     rax, rax
    xor     rcx, rcx

    .pushstr:
        mov     al, byte[rsi]
        cmp     al, 0Ah  
        jz      .popstr
        push    rax
        inc     rsi
        inc     rcx
        jmp     .pushstr

    .popstr:
        cmp     rcx, 0
        jz      .break
        pop     rax
        mov     byte [rdx], al
        inc     rdx
        dec     rcx
        jmp     .popstr

    .break:  
        pop     rdx
        pop     rcx
        pop     rax
        mov     rsp, rbp
        pop     rbp
        ret

printf:
    mov     rdi, 1
    mov     rax, 1
    syscall
    ret

scanf:
    mov     rdi, 0
    mov     rax, 0
    syscall
    ret