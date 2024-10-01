
section .data
    outp1   db  "n1 = ", 0h
    outp2   db  "n2 = ", 0h
    outp3   db  "sum = ", 0h

section .bss
    num1    resb    20
    num2    resb    20
    result  resb    21

section .text
global _start

_start:
    mov     rbp, rsp 

    mov     rdi, 1
    mov     rsi, outp1
    mov     rdx, 5
    mov     rax, 1
    syscall

    mov     rdi, 0
    mov     rsi, num1
    mov     rdx, 21
    mov     rax, 0
    syscall

    mov     rdi, 1
    mov     rsi, outp2
    mov     rdx, 5
    mov     rax, 1
    syscall

    mov     rdi, 0
    mov     rsi, num2
    mov     rdx, 21
    mov     rax, 0
    syscall

    mov     rdi, 1
    mov     rsi, outp3
    mov     rdx, 7
    mov     rax, 1
    syscall

    mov     rsi, num1
    call    strlen
    mov     r10, rcx

    mov     rsi, num2
    call    strlen
    mov     r11, rcx

    mov     rsi, num1
    call    reversestr

    mov     rsi, num2
    call    reversestr


    mov     rsi, num1
    mov     rdi, num2
    mov     r9, result
    call    bigsum

    mov     rsi, result
    call    reversestr

    mov     rdi, 1
    mov     rsi, result
    mov     rdx, 21
    mov     rax, 1
    syscall

    mov     rdi, 0
    mov     rax, 60
    syscall

bigsum:
    push    rbp
    mov     rbp, rsp
    push    rax
    push    rbx     ;(int) sum eachchar
    push    rcx
    push    r8
    push    r9
    xor     rax, rax    ;nho
    xor     rcx, rcx   ;len2
    xor     rbx, rbx    ;len1
    mov     r9, result

    .cmplen:
        mov     rbx, r10
        mov     rcx, r11
        cmp     rbx, rcx
        jg      .addzero2
    
    .addzero1:
        cmp     rbx, rcx
        jz      .calc
        mov     byte [rsi+rbx], '0'
        inc     rbx
        jmp     .addzero1


    .addzero2:
        cmp     rbx, rcx
        jz      .calc
        mov     byte [rdi+rcx], '0'
        inc     rcx
        jmp     .addzero2

    .calc:
        xor     rbx, rbx
        mov     bl, byte [rsi]
        cmp     bl, 0Ah
        jz      .break
        cmp     bl, 0h
        jz      .break
        inc     rsi
        sub     rbx, 30h
        mov     r8b, byte [rdi]
        inc     rdi
        sub     r8, 30h
        add     rbx, r8
        add     rbx, rax
        xor     rax, rax
        cmp     rbx, 10
        jnl     .incmem
    .addchar:
        add     rbx, 30h
        mov     byte[r9], bl
        inc     r9
        jmp     .calc

    .incmem:
        inc     rax
        sub     rbx, 10
        jmp     .addchar
    
    .addmem:
        add     rax, 30h
        mov     byte[r9], al
        xor     rax, rax
        inc     r9
        mov     byte[r9], 0Ah
        jmp     .break


    .break:
        cmp     rax, 1
        jz     .addmem
        pop     r9
        pop     r8
        pop     rcx
        pop     rbx
        pop     rax
        mov     rsp, rbp
        pop     rbp
        ret

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
        cmp     al, 0h
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

strlen:
    push    rbp
    mov     rbp, rsp
    push    rdx ;num1
    mov     rdx, rsi
    xor     rcx, rcx

    .len:
        cmp     byte[rdx], 0Ah
        jz      .break
        inc     rdx
        inc     rcx
        jmp     .len
    
    .break:
        pop     rdx
        mov     rsp, rbp
        pop     rbp
        ret





    