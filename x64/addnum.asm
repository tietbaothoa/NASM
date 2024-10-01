section .data
    outp1   db  "Vui long nhap so thu nhat: ", 0AH, 0h
    outp2   db  "Vui long nhap so thu hai: ", 0AH, 0h

section .bss
    num1    resb    50
    num2    resb    50
    sum     resb    51
section .text
global _start

_start:

    mov     rsi, outp1
    mov     rdx, 29
    call    printf   

    mov     rsi, num1
    mov     rdx, 50
    call    scanf

    mov     rsi, outp2
    mov     rdx, 29
    call    printf     

    mov     rsi, num2
    mov     rdx, 50
    call    scanf

    mov     rsi, num1
    call    atoi
    push    rax

    mov     rsi, num2
    call    atoi
    pop     rbx
    add     rax, rbx

    mov     rsi, rax     ; (int)sum
    call    itoa

    mov     rsi, sum
    mov     rdx, 51
    call    printf

    mov     rax, 60
    mov     rdi, 0
    syscall

    
itoa:
    push    rbp
    mov     rbp, rsp
    push    rax
    push    rcx
    push    rdx
    mov     rax, rsi    ; (int) sum
    mov     rbx, sum
    mov     rcx, 10
    push    69h
    
    .divide:
        xor     rdx, rdx
        div     rcx
        add     rdx, 30h
        push    rdx
        cmp     rax, 0
        jz      .popstr
        jmp     .divide

    .popstr:
        xor     rdx, rdx
        pop     rdx
        cmp     dl, 69h
        jz      .break
        mov     byte [rbx], dl
        inc     rbx
        ; cmp     dl, 69h
        ; jz      .break
        jmp     .popstr

    .break:
        mov     byte [rbx], 0Ah
        inc     rbx
        pop     rdx
        pop     rcx
        pop     rax
        mov     rsp, rbp
        ; pop     rsp
        pop     rbp
        ret

atoi:
    push    rbp
    mov     rbp, rsp
    ; push    rax     ;bug
    push    rbx
    push    rcx
    mov     rcx, 10
    xor     rax, rax

    .transfer:
        xor     rbx, rbx
        mov     bl, byte [rsi]
        cmp     bl, 0Ah
        jz      .break
        sub     rbx, 30h
        add     rax, rbx
        mul     rcx
        inc     rsi
        jmp     .transfer

    .break:
        xor     rdx, rdx
        div     rcx
        pop     rcx
        pop     rbx
        ; pop     rax
        mov     rsp, rbp
        pop     rbp
        ret

scanf:
    mov     rdi, 0
    mov     rax, 0
    syscall
    ret

printf:
    mov     rdi, 1
    mov     rax, 1
    syscall 
    ret

