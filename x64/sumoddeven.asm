
section .data
    outp1   db  "Nhap mang phan tu: ",  0h
    sodd    db  "Tong cac so le: ", 0h
    seven   db  "Tong cac so chan: ", 0h 

section .bss
    strarr      resb    1000
    strnum      resb    100
    strodd      resb    100
    streven     resb    100
    narr        resb    100
    sumodd      resd    0
    sumeven     resd    0
section .text
global _start

_start:
    mov     rbp, rsp

    mov     rdi, 1
    mov     rsi, outp1
    mov     rdx, 20
    mov     rax, 1
    syscall

    mov     rdi, 0
    mov     rsi, strarr
    mov     rdx, 1000
    mov     rax, 0
    syscall

    mov     rsi, strarr
    call    _split

    mov     rdi, narr
    call    _sumodd

    mov     rsi, [sumodd]
    mov     rbx, strodd
    call    itoa
 
    mov     rdi, narr
    call    _sumeven
  
    mov     rsi, [sumeven]
    mov     rbx, streven
    call    itoa

    mov     rdi, 1
    mov     rsi, sodd
    mov     rdx, 16
    mov     rax, 1
    syscall

    mov     rdi, 1
    mov     rsi, strodd
    mov     rdx, 100
    mov     rax, 1
    syscall

    mov     rdi, 1
    mov     rsi, seven
    mov     rdx, 18
    mov     rax, 1
    syscall

    mov     rdi, 1
    mov     rsi, streven
    mov     rdx, 100
    mov     rax, 1
    syscall

    mov     rax, 60
    mov     rdi, 0
    syscall



_split:
    push    rbp
    mov     rbp, rsp
    push    rax
    push    rbx
    push    rcx
    push    rdx     ; (char)eachnum
    push    rdi
    mov     rdx, strnum
    mov     r12, narr
    xor     rcx, rcx
    xor     rdi, rdi

    .eachnum:
        xor     rbx, rbx
        mov     bl, byte[rsi]
        inc     rsi
        cmp     bl, ' '
        jz      .transtoint
        cmp     bl, 0Ah
        jz      .transtoint
        mov     byte[rdx + rdi], bl     ;bug
        inc     rdi
        jmp     .eachnum 

    .transtoint:
        mov     byte[rdx+rdi], 0Ah
        inc     rdi
        xor     rdi, rdi
        push    rsi
        mov     rsi, rdx
        call    atoi    ; rax = (int)num
        pop     rsi
         
    .savetointsolve:
        mov     dword [r12+rcx*4], eax  ;bug
        inc     rcx
        dec     rsi
        cmp     byte[rsi], 0Ah
        jz      .break
        inc     rsi
        jmp     .eachnum

    .break:
        pop     rdi
        pop     rdx
        pop     rcx
        pop     rbx
        pop     rax
        mov     rsp, rbp
        pop     rbp
        ret

_sumodd:
    push    rbp
    mov     rbp, rsp
    push    rax     ;(int)eachnum
    push    rbx     
    push    rcx
    push    rdx
    push    r8
    push    r9
    mov     rbx, 2
    xor     rcx, rcx

    .calc:
        xor     rax, rax
        mov     eax, dword[rdi+4 * rcx]
        inc     rcx
        mov     r9, rax
        cmp     rax, 0
        jz      .break
        xor     rdx, rdx
        div     rbx
        cmp     rdx, 0
        jnz     .addsumodd
        jmp     .calc

    .addsumodd:
        add     r8, r9
        jmp     .calc

    .break: 
        mov     [sumodd], r8
        pop     r9
        pop     r8
        pop     rdx
        pop     rcx
        pop     rbx
        pop     rbx
        pop     rax
        mov     rsp, rbp
        pop     rbp
        ret

_sumeven:
    push    rbp
    mov     rbp, rsp
    push    rax     ;(int)eachnum
    push    rbx     
    push    rcx
    push    rdx
    push    r8
    push    r9
    mov     rbx, 2
    xor     rcx, rcx

    .calc:
        xor     rax, rax
        mov     eax, dword[rdi+4 * rcx]
        inc     rcx
        mov     r9, rax
        cmp     rax, 0
        jz      .break
        xor     rdx, rdx
        div     rbx
        cmp     rdx, 0
        jz     .addsumeven
        jmp     .calc

    .addsumeven:
        add     r8, r9
        jmp     .calc

    .break: 
        mov     [sumeven], r8
        pop     r8
        pop     rdx
        pop     rcx
        pop     rbx
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
    mov     rax, rsi    ; (int) sum, rbx = str(sum)
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
