section .data
    space   db 20h, 0h 
    a1      db  '0', 20h
    a2      db  '1', 20h
    a3      db  '0', ' ', '1', ' '

section .bss
    cnt1    resb    4
    str1    resb    100
    str2    resb    100
    solve   resb    101
    f0      resb    100
    f1      resb    100
    cnt2    resd    1
    len1    resd    1
    len2    resd    1
    nho     resd    1
    count   resd    1    
    x       resd    1 
    
section .text
    global _start

_start:
    push    4
    push    cnt1
    call    read


    push    cnt1
    call    atoi  
    mov     [cnt2], eax  

    push    cnt2 
    call    findfibo

    mov     ebx, 0
    mov     eax, 1
    int     80h


findfibo:
    push    ebp
    mov     ebp, esp
    push    edx
    push    ebx
    push    eax
    mov     edx, [ebp+08h]
    mov     esi, 2
    xor     edi, edi
    mov     eax, f0
    mov     byte [eax], '0'
    mov     ebx, f1
    mov     byte[ebx], '1'
    mov     edi, [cnt2]

    .print0:
        cmp     edi, 1
        jg      .print1
        push    a1
        push    3
        call    write

    .print1:
        cmp     edi, 2
        jg      .print2
        push    a2
        push    3
        call    write

    .print2:
        push    5
        push    a3
        call    write

    .calc:
        cmp     esi, [cnt2]
        jz      .break
        push    f0
        call    reversestring     
        push    f1
        call    reversestring
        push    f0
        call    strlen
        mov     [len1], ecx
        push    f1
        call    strlen
        mov     [len2], ecx
        push    f0
        push    f1
        call    addnum
        push    solve
        call    reversestring
        inc     esi
        push    100
        push    solve
        call    write
        push    2
        push    space
        call    write
        push    f1
        call    reversestring
        push    f1
        push    f0
        call    copy
        push    solve
        push    f1
        call    copy
        push    ecx
        xor     ecx, ecx
        mov     [count], ecx
        pop     ecx
        jmp     .calc

    .break:
        pop     eax
        pop     ebx
        pop     edx
        mov     esp, ebp
        pop     ebp
        ret     4



copy:
    push    ebp
    mov     ebp, esp
    push    eax     
    push    ebx     ; copy eax vao ebx
    mov     eax, [ebp+0Ch]
    mov     ebx, [ebp+08h]
    push    esi
    xor     esi, esi

    .copy:
        xor     edx, edx
        mov     dl, byte [eax+esi]
        cmp     dl, 0
        jz      .break
        mov     byte[ebx+esi], dl
        inc     esi
        jmp     .copy
    
    .break:
        pop     esi
        pop     ebx
        pop     eax
        mov     esp, ebp
        pop     ebp
        ret     8


write:
    push    ebp
    mov     ebp, esp
    push    edx
    push    ecx
    push    ebx
    push    eax
    mov     edx, [ebp+0Ch]
    mov     ecx, [ebp+08h]
    mov     ebx, 1
    mov     eax, 4
    int     80h

    pop     eax
    pop     ebx
    pop     ecx
    pop     edx
    mov     esp, ebp
    pop     ebp
    ret     8


reversestring:
    push    ebp
    mov     ebp, esp
    push    ecx       
    push    esi
    push    edx
    mov     ecx, [ebp+08h]      ; str
    xor     esi, esi

    .reverse:
        xor     edx, edx
        mov     dl, byte [ecx+esi] ; bug
        cmp     dl, 0h
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
        pop     edx
        pop     esi
        pop     ecx
        mov     esp, ebp
        pop     ebp
        ret     4  

addnum:
    push    ebp
    mov     ebp, esp
    push    edx     ;str1
    push    ecx     ;str2
    push    esi
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
        ; push    ebx
        ; mov     ebx, solve
        ; mov     esi, [count]
        ; mov     byte [ebx+esi], 0Ah
        ; inc     esi
        ; pop     esi
        ; pop     ebx
        pop     esi
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




atoi:
    push    ebp
    mov     ebp, esp
    push    ecx
    mov     ecx, [ebp+08h]  ; ecx = cnt
    xor     eax, eax
    mov     ebx, 10

    .multi:
        xor     edx, edx
        mov     dl, byte [ecx]
        cmp     dl, 0Ah
        jz      .break
        sub     dl, '0'
        add     eax, edx
        mul     ebx         ; eax = eax*ebx = eax*10
        inc     ecx
        jmp     .multi


    .break:
        xor     edx, edx    ; edx = 0
        div     ebx         ; phan du cua phep chia de o edx
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