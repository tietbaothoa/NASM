section .data
    f0      db '0'
    f1      db '1'
    nl      db 0Ah, 0h
section .bss
    result  resb    100
    cnt     resb    10
    solve   resb    26
    num1    resb    10
    num2    resb    10
    count   resd    1
    len1    resd    1
    len2    resd    1
    nho     resd    1
    
section .text
    global _start

_start:
    push    10
    push    cnt
    call    read

    push    10
    push    cnt   ; str --> int
    call    atoi

    push    cnt
    call    findfibo

    push    10
    push    cnt
    call    write

    mov     ebx, 0
    mov     eax, 1
    int     80h

findfibo:
    push    ebp
    mov     ebp, esp
    push    edx
    mov     edx, [ebp+08h]
    mov     eax, f0    ; eax = 0 =f0
    mov     ebx, f1       ; ebx =f1

    .calc:
        mov     esi, [cnt]
        cmp     esi, [count]
        jz      .break
 
        push    eax
        push    ebx
        call    addnum    
        mov     eax, ebx
        mov     ebx, solve
        jmp     .popstr

    .popstr:
        mov     edi, [count]
        inc     edi
        ; mov     [count], edi
        mov     ecx, result
        mov     ecx, ebx
        mov     cl, ' '
        jmp     .calc

    .break:
        pop     edx
        mov     esp, ebp
        pop     ebp
        ret     4


addnum:
    push    ebp
    mov     ebp, esp
    push    edx     ;str1
    push    ecx     ;str2
    mov     edx, [ebp+0Ch]
    mov     ecx, [ebp+08h]
    push    edx
    call    reversestring  ; bug
    push    ecx
    call    reversestring

    .addzero:
        xor     eax, eax
        xor     ebx, ebx
        push    edx
        call    strlen
        mov     [len2], ecx
        push    ecx
        call    strlen
        mov     [len2], ecx
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


atoi:                       ; str(cnt) --> int(cnt)
    push    ebp
    mov     ebp, esp
    push    ecx
    mov     ecx, [ebp+08h]  ; ecx = cnt
    xor     eax, eax
    mov     ebx, 10

    .multi:
        xor     edx, edx
        mov     dl, [ecx]
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

strlen:
    ;khoi tao stackframe 
    push    ebp
    mov     ebp, esp
    push    ebx
    ; truy cap tham so thong qua dia chi tuong doi cua ebp
    mov     ebx, [ebp+8h]
    ; gan gia tri 0 cho ecx bang cach xor ecx voi chinh no
    xor     ecx, ecx

    nextchar:
        cmp     byte [ebx+ecx], 0
        jz      .break 
        inc     ecx
        jmp     nextchar
    
    .break:
        pop     ebx
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
    pop     edx
    mov     esp, ebp
    pop     ebp
    ret     8



    
