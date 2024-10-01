
section .data
    space        db       20h

section .bss
    minc    resb    10
    maxc    resb    10
    numc1   resb    10
    numc2   resb    10
    solve1  resb    10
    solve2  resb    10
    input   resb    100
    min     resd    1
    max     resd    1
    num     resd    1
    count1  resd    1
    count2  resd    1

section .text
    global _start

_start:
    push    200
    push    input
    call    read


    push    input
    call    findmin

    push    input
    call    findmax

    mov     eax, [min]
    push    eax
    push    solve1
    call    itoa

    mov     ebx, [max]
    push    ebx
    push    solve2
    call    itoa

    push    10
    push    solve1 
    call    write

    push    2
    push    space
    call    write

    push    10
    push    solve2
    call    write

    mov     ebx, 0
    mov     eax, 1
    int     80h    

findmin:
    push    ebp
    mov     ebp, esp
    push    edx
    mov     edx, [ebp+08h]
    xor     esi, esi
    xor     ebx, ebx
    xor     edi, edi

    .min0:
        push    ebx
        push    ecx
        push    esi
        mov     esi, [count1]
        xor     ebx, ebx
        mov     ecx, minc
        mov     bl, byte[edx+esi]
        cmp     bl, 20h
        jz      .split
        cmp     bl, 0Ah
        jz      .split
        mov     byte[ecx+esi], bl
        inc     esi
        mov     [count1], esi
        pop     esi
        pop     ecx
        pop     ebx
        jmp     .min0

    .split:
        push    esi
        mov     esi, [count1]
        push    ebx
        push    ecx
        inc     esi
        xor     ebx, ebx
        xor     ecx, ecx
        mov     ecx, numc1
        mov     bl, byte[edx+esi]
        cmp     bl, 20h
        jz      .find0
        cmp     bl, 0Ah
        jz      .find0
        mov     byte[ecx+edi], bl
        inc     edi
        mov     [count1], esi
        pop     esi
        pop     ecx
        pop     ebx
        jmp     .split

    .find0:
        xor     edi, edi
        push    eax
        mov     eax, [min]
        cmp     eax, 0
        jnz     .find
        pop     eax
        push    minc    
        call    atoi
        mov     [min], eax
     

    .find:
        push    numc1
        call    atoi
        mov     [num], eax
        xor     eax, eax
        xor     ebx, ebx
        mov     eax, [min]
        mov     ebx, [num]
        push    numc1
        call    clear
        cmp     eax, ebx
        jg      .solve
        jmp     .cmptobreak

    .cmptobreak:
        xor     ebx, ebx
        push    esi
        mov     esi, [count1]
        inc     esi
        mov     bl, byte[edx+esi]
        mov     [count1], esi
        pop     esi
        cmp     bl, 0Ah
        jz      .break
        jmp     .split

    .solve:     ; copy num --> min
        xor     edi, edi
        push    esi
        mov     esi, [count1]
        inc     esi
        xor     eax, eax
        mov     eax, [num]
        mov     [min], eax
        xor     ebx, ebx
        mov     bl, byte [edx+esi]
        mov     [count1], esi
        pop     esi
        cmp     bl, 0Ah
        jz      .break
        jmp     .split

    .break:
        pop     edx
        mov     esp, ebp
        pop     ebp
        ret     4

findmax:
    push    ebp
    mov     ebp, esp
    push    edx
    mov     edx, [ebp+08h]
    xor     esi, esi
    xor     ebx, ebx
    xor     edi, edi

    .max0:
        push    ebx
        push    ecx
        push    esi
        mov     esi, [count2]
        xor     ebx, ebx
        mov     ecx, maxc
        mov     bl, byte[edx+esi]
        cmp     bl, 20h
        jz      .split
        cmp     bl, 0Ah
        jz      .split
        mov     byte[ecx+esi], bl
        inc     esi
        mov     [count2], esi
        pop     esi
        pop     ecx
        pop     ebx
        jmp     .max0

    .split:
        push    esi
        mov     esi, [count2]
        push    ebx
        push    ecx
        inc     esi
        xor     ebx, ebx
        xor     ecx, ecx
        mov     ecx, numc2
        mov     bl, byte[edx+esi]
        cmp     bl, 20h
        jz      .find0
        cmp     bl, 0Ah
        jz      .find0
        mov     byte[ecx+edi], bl
        inc     edi
        mov     [count2], esi
        pop     esi
        pop     ecx
        pop     ebx
        jmp     .split

    .find0:
        xor     edi, edi
        push    eax
        mov     eax, [max]
        cmp     eax, 0
        jnz     .find
        pop     eax
        push    maxc    
        call    atoi
        mov     [max], eax
     

    .find:
        push    numc2
        call    atoi
        mov     [num], eax
        xor     eax, eax
        xor     ebx, ebx
        mov     eax, [max]
        mov     ebx, [num]
        push    numc2
        call    clear
        cmp     eax, ebx
        jl      .solve
        jmp     .cmptobreak

    .cmptobreak:
        xor     ebx, ebx
        push    esi
        mov     esi, [count2]
        inc     esi
        mov     bl, byte[edx+esi]
        mov     [count2], esi
        pop     esi
        cmp     bl, 0Ah
        jz      .break
        jmp     .split

    .solve:     ; copy num --> min
        xor     edi, edi
        push    esi
        mov     esi, [count2]
        inc     esi
        xor     eax, eax
        mov     eax, [num]
        mov     [max], eax
        xor     ebx, ebx
        mov     bl, byte [edx+esi]
        mov     [count2], esi
        pop     esi
        cmp     bl, 0Ah
        jz      .break
        jmp     .split

    .break:
        pop     edx
        mov     esp, ebp
        pop     ebp
        ret     4
clear:
    push    ebp
    mov     ebp, esp
    push    edx
    mov     edx, [ebp+08h]
    push    ebx
    push    esi
    xor     esi, esi

    .clear:
        xor     ebx, ebx
        mov     bl, byte [edx+esi]
        cmp     bl, 20h
        jz     .break
        cmp     bl, 0h
        jz     .break
        mov     bl, 0
        mov     byte [edx+esi], bl
        inc     esi
        jmp     .clear

    .break:
        pop     esi
        pop     ebx
        pop     edx
        mov     esp, ebp
        pop     ebp
        ret     4

itoa:       ; int --> str
    push    ebp
    mov     ebp, esp
    push    eax
    push    ebx
    mov     eax, [ebp+0Ch]      ;num
    mov     ebx, [ebp+08h]      ;str
    mov     ecx, 10
    push    69h

    divide: 
        xor     edx, edx
        div     ecx     ; eax chia cho ecx, thuong so luu o eax, so du luu o edx
        add     dl, '0'
        push    edx
        cmp     eax, 0
        jz      .popstr
        jmp     divide

    .popstr:
        xor     edx, edx
        pop     edx
        cmp     dl, 69h
        jz      .break
        mov     [ebx], dl
        inc     ebx
        jmp     .popstr

    .break:
        mov     byte [ebx], 0h
        pop     ebx
        pop     eax
        mov     esp, ebp
        pop     ebp
        ret     8


atoi:       ; (str --> num)  atoi(ecx=str(num) --> eax=int(num))
    push    ebp
    mov     ebp, esp
    push    ecx
    push    edx
    mov     ecx, [ebp+08h]
    xor     eax, eax    ; eax=0
    mov     ebx, 10     ; ebx=10

    multi:
        xor     edx, edx    ; edx=0
        mov     dl, [ecx]
        cmp     dl, 0h     ; \n --> break
        jz      .break
        sub     dl, '0'     
        add     eax, edx ; eax+=edx 
        mul     ebx     ; eax = eax*ebx = eax*10
        inc     ecx
        jmp     multi

    .break:
        xor     edx, edx    ; edx = 0
        div     ebx         ; phan du cua phep chia de o edx
        pop     edx
        pop     ecx
        mov     esp, ebp
        pop     ebp
        ret     4
    
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


