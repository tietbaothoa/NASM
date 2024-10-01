
section .data
    nl      db 0Ah, 0h
section .bss
    solve   resb 26
    str1    resb 25
    str2    resb 25
    len1    resd 1
    len2    resd 1
    nho     resd 1
    count   resd 1

section .text
global _start

_start:
    push    25
    push    str1
    call    read

    push    str1
    call    reversestring

    push    str1
    call    strlen
    mov    [len1], ecx

    push    25
    push    str2
    call    read

    push    str2
    call    reversestring

    push    str2
    call    strlen
    mov     [len2], ecx

    push    str1
    push    str2
    call    addnum

    push    solve
    call    reversestring

    push    26
    push    solve
    call    write

    push    2
    push    nl
    call    write

    mov     ebx, 0
    mov     eax, 1
    int     80h


addnum:
    push    ebp
    mov     ebp, esp
    push    edx     ;str1
    push    ecx     ;str2
    mov     edx, [ebp+0Ch]
    mov     ecx, [ebp+08h]

    .addzero:
        xor     eax, eax
        xor     ebx, ebx
        mov     eax, [len1]  ; eax = len(str1)
        mov     ebx, [len2]  ; ebx = len(str2)
        cmp     eax, ebx     ; len(str1) < len(str2) --> addzero str1
        jl      .addzero1
        cmp     eax, ebx
        jg      .addzero2
        jmp     .addnum

    .addzero1:
        mov     byte[edx+eax], '0'
        inc     eax
        cmp     eax, ebx 
        jnz     .addzero1
        jmp     .addnum

    .addzero2:
        mov     byte[ecx+ebx], '0'
        inc     ebx
        cmp     eax, ebx 
        jnz     .addzero2

    .addnum:
        cmp     byte[edx], 0h
        jz      .break
        xor     esi, esi
        mov     esi, [nho]
        xor     eax, eax
        xor     ebx, ebx
        mov     al, byte[edx]
        mov     bl, byte[ecx]
        inc     edx
        inc     ecx
        sub     al, '0'
        sub     bl, '0'
        add     eax, ebx
        add     eax, esi
        xor     esi, esi
        mov     [nho], esi
        cmp     eax, 10
        jnl     .a 

    .addchr:    
        add     al, '0'
        push    ebx
        push    esi
        mov     ebx, solve
        mov     esi, [count]
        mov     byte[ebx+esi], al
        inc     esi
        mov     [count], esi
        pop     esi
        pop     ebx
        jmp     .addnum
        

    .a:
        sub     eax, 10
        mov     edi, [nho]
        xor     edi, edi
        inc     edi
        mov     [nho], edi
        jmp     .addchr

    .addmem:
        push    ebx
        push    esi
        mov     ebx, solve
        mov     esi, [count]
        mov     byte [ebx+esi], '1'
        inc     esi
        mov     [count], esi
        pop     esi
        pop     ebx
        xor     esi, esi
        mov     [nho], esi

    .break:
        mov     esi, [nho]
        cmp     esi, 1
        jz      .addmem
        push    ebx
        push    esi
        mov     ebx, solve
        mov     esi, [count]
        mov     byte [ebx+esi], 0Ah
        inc     esi
        pop     esi
        pop     ebx
        pop     ecx
        pop     edx
        mov     esp, ebp
        pop     ebp
        ret     8


strlen:
    push    ebp
    mov     ebp, esp
    push    ebx
    mov     ebx, [ebp+8h]
    xor     ecx, ecx

    nextchar:
        cmp     byte [ebx+ecx], 0h
        jz      .break 
        inc     ecx
        jmp     nextchar
    
    .break:
        pop     ebx
        mov     esp, ebp
        pop     ebp
        ret     4

reversestring:
    push    ebp
    mov     ebp, esp
    push    ecx          
    mov     ecx, [ebp+08h]      ; str
    xor     esi, esi

    .reverse:
        xor     edx, edx
        mov     dl, byte [ecx+esi]
        cmp     dl, 0Ah
        jz      .popstr
        push    edx
        inc     esi
        jmp     .reverse

    .popstr:
        xor     edx, edx
        pop     edx     ; edx=revstr
        mov     byte [ecx], dl
        inc     ecx
        dec     esi
        cmp     esi, 0
        jz      .break
        jmp     .popstr

    .break:
        mov     byte [ecx], 0
        ; inc     ecx
        pop     ecx
        mov     esp, ebp
        pop     ebp
        ret     4  


read:
    push    ebp
    mov     ebp, esp
    push    edx
    push    ecx

    mov     edx, [ebp+0Ch]
    mov     ecx, [ebp+08h]
    mov     ebx, 0
    mov     eax, 3
    int     80h

    pop     ecx
    pop     edx
    mov     esp, ebp
    pop     ebp
    ret     8



write:
    push    ebp
    mov     ebp, esp
    push    edx
    push    ecx
    
    mov     edx, [ebp+0Ch]
    mov     ecx, [ebp+08h]
    mov     ebx, 1
    mov     eax, 4
    int     80h

    pop     ecx
    pop     ebx
    mov     esp, ebp
    pop     ebp
    ret     8


