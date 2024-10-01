section .data
    oupt        db  "Nhap chuoi: ", 0h
    outmin      db  "min = ", 0h
    outmax      db  "max = ", 0h
section .bss
    array   resb    100
    min     resb    10
    max     resb    10
    num     resb    10


section .text
global _start

_start:
    mov     rbp, rsp

    mov     rdi, 1
    mov     rsi, oupt
    mov     rdx, 13
    mov     rax, 1
    syscall

    mov     rdi, 0
    mov     rsi, array
    mov     rdx, 100
    mov     rax, 0
    syscall

    mov     rsi, array
    call    findmin

    mov     rsi, array
    call    findmax

    mov     rdi, 1
    mov     rsi, outmin
    mov     rdx, 7
    mov     rax, 1
    syscall

    mov     rdi, 1
    mov     rsi, min
    mov     rdx, 10
    mov     rax, 1
    syscall

    mov     rdi, 1
    mov     rsi, outmax
    mov     rdx, 7
    mov     rax, 1
    syscall

    mov     rdi, 1
    mov     rsi, max
    mov     rdx, 10
    mov     rax, 1
    syscall

    mov     rax, 60
    mov     rdi, 0
    syscall

findmin:
    push    rbp
    mov     rbp, rsp
    push    rax ;(int)num
    push    r8  ;(int)min
    mov     r9, rsi
    push    rbx
    push    rcx
    push    rdx
    push    r10
    xor     rax, rax
    xor     r10, r10
    mov     rcx, num
    mov     rdx, min
    mov     r8d, 0fffffffh
 
    .setnum:
        xor     rbx, rbx
        mov     bl, byte[r9]
        inc     r9
        cmp     bl, ' '
        jz      .intnum
        cmp     bl, 0Ah
        jz      .intnum
        mov     byte[rcx+r10], bl
        inc     r10
        jmp     .setnum

    .intnum:
        mov     byte[rcx+r10], 0Ah
        push    rsi
        mov     rsi, rcx
        call    atoi
        pop     rsi

    .compare:
        xor     r10, r10
        cmp     rax, r8
        jl      .resetmin
        cmp     byte[r9-1], 0Ah
        jz      .done
        jmp     .setnum

    .resetmin:
        xor     r8, r8
        mov     r8, rax
        cmp     byte[r9-1], 0Ah
        jz      .done
        jmp     .setnum

    .done: 
        push    rsi
        xor     rbx, rbx
        mov     rbx, min
        mov     rsi, r8
        call    itoa
        pop     rsi
            
    .copy:
        push    rcx
        xor     rcx, rcx
        mov     cl, byte[rbx]
        mov     byte[rdx], cl
        cmp     cl, 0Ah
        jmp     .break
        inc     rbx
        inc     rdx
        pop     rcx
        jmp     .copy

    .break:
        pop     rdx
        pop     rcx
        pop     rbx
        pop     rax
        mov     rsp, rbp
        pop     rbp
        ret

findmax:
    push    rbp
    mov     rbp, rsp
    push    rax ;(int)num
    push    r8  ;(int)max
    mov     r9, rsi
    push    rbx
    push    rcx
    push    rdx
    push    r10
    xor     rax, rax
    xor     r10, r10
    mov     rcx, num
    mov     rdx, max
    mov     r8d, 0h
 
    .setnum:
        xor     rbx, rbx
        mov     bl, byte[r9]
        inc     r9
        cmp     bl, ' '
        jz      .intnum
        cmp     bl, 0Ah
        jz      .intnum
        mov     byte[rcx+r10], bl
        inc     r10
        jmp     .setnum

    .intnum:
        mov     byte[rcx+r10], 0Ah
        push    rsi
        mov     rsi, rcx
        call    atoi
        pop     rsi

    .compare:
        xor     r10, r10
        cmp     rax, r8
        jg      .resetmax
        cmp     byte[r9-1], 0Ah
        jz      .done
        jmp     .setnum

    .resetmax:
        xor     r8, r8
        mov     r8, rax
        cmp     byte[r9-1], 0Ah
        jz      .done
        jmp     .setnum

    .done: 
        push    rsi
        xor     rbx, rbx
        mov     rbx, max
        mov     rsi, r8
        call    itoa
        pop     rsi
            
    .copy:
        push    rcx
        xor     rcx, rcx
        mov     cl, byte[rbx]
        mov     byte[rdx], cl
        cmp     cl, 0Ah
        jmp     .break
        inc     rbx
        inc     rdx
        pop     rcx
        jmp     .copy

    .break:
        pop     rdx
        pop     rcx
        pop     rbx
        pop     rax
        mov     rsp, rbp
        pop     rbp
        ret

atoi:
    push    rbp
    mov     rbp, rsp
    ; push    rax     ;bug
    push    rbx
    push    rcx
    push    rdx
    mov     rcx, 10
    xor     rax, rax

    .transfer:
        xor     rbx, rbx
        mov     bl, byte [rsi]
        cmp     bl, 0Ah
        jz      .break
        cmp     bl, 20h
        jz      .break
        sub     rbx, 30h
        add     rax, rbx
        mul     rcx
        inc     rsi
        jmp     .transfer

    .break:
        xor     rdx, rdx
        div     rcx
        pop     rdx
        pop     rcx
        pop     rbx
        ; pop     rax
        mov     rsp, rbp
        pop     rbp
        ret

itoa:
    push    rbp
    mov     rbp, rsp
    push    rax
    push    rcx
    push    rdx
    push    r8
    xor     r8, r8
    mov     rax, rsi    ; (int) sum
    ; mov     rbx, sum
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
        mov     byte [rbx+r8], dl
        inc     r8
        ; cmp     dl, 69h
        ; jz      .break
        jmp     .popstr

    .break:
        mov     byte [rbx+r8], 0Ah
        pop     r8
        pop     rdx
        pop     rcx
        pop     rax
        mov     rsp, rbp
        ; pop     rsp
        pop     rbp
        ret

