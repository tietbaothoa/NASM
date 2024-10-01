section .data
    nl      db      20h
section .bss
    input   resb    100
    sum1    resb    10
    sum2    resb    10
    num     resb    10
    count   resd    1

section .text
    global _start

_start:
    push    100
    push    input
    call    read

    push    input
    call    tongchan

    push    input
    call    tongle

    push    10
    push    sum1
    call    write

    push    2
    push    nl
    call    write

    push    100
    push    sum2
    call    write

    push    2
    push    nl
    call    write

    mov     ebx, 0
    mov     eax, 1
    int     80h

tongle:
    push    ebp
    mov     ebp, esp
    push    edx
    push    ecx
    mov     edx, [ebp+08h]
    xor     esi, esi
    xor     edi, edi

    .split:
        mov     ecx, num
        mov     bl, byte[edx+esi]
        cmp     bl, 20h
        jz      .oddnumber
        cmp     bl, 0Ah
        jz      .oddnumber
        cmp     bl, 0h
        jz      .break
        mov     byte[ecx+edi], bl
        inc     esi
        inc     edi
        jmp     .split

    .oddnumber:
        push    eax
        push    edx
        xor     edx, edx
        mov     ecx, 2
        push    num
        call    atoi    ; eax = (int) num
        div     ecx
        mov     ecx, edx
        pop     edx
        pop     eax
        cmp     ecx, 0
        jnz     .calc
        push    num
        call    clear
        xor     edi, edi
        inc     esi
        jmp     .split

    .calc:
        push    eax
        push    ebx

        push    num
        call    atoi        ; eax = (int) num
        push    eax

        push    sum2
        call    atoi
        pop     ebx
        add     eax, ebx   ; eax = (int) sum1

        push    eax
        push    sum2    
        call    itoa        ; sum1 = (str) sum1

        push    num
        call    clear

        cmp     byte[edx+esi], 0Ah
        jz      .break

        xor     edi, edi
        inc     esi
        jmp     .split

    .break:
        pop     ecx
        pop     edx
        mov     esp, ebp
        pop     ebp
        ret     4

tongchan:
    push    ebp
    mov     ebp, esp
    push    edx
    push    ecx
    mov     edx, [ebp+08h]
    xor     esi, esi
    xor     edi, edi

    .split:
        mov     ecx, num
        mov     bl, byte[edx+esi]
        cmp     bl, 20h
        jz      .evennumber
        cmp     bl, 0Ah
        jz      .evennumber
        cmp     bl, 0h
        jz      .break
        mov     byte[ecx+edi], bl
        inc     esi
        inc     edi
        jmp     .split

    .evennumber:
        push    eax
        push    edx
        xor     edx, edx
        mov     ecx, 2
        push    num
        call    atoi    ; eax = (int) num
        div     ecx
        mov     ecx, edx
        pop     edx
        pop     eax
        cmp     ecx, 0
        jz     .calc
        push    num
        call    clear
        xor     edi, edi
        inc     esi
        jmp     .split

        

    .calc:
        push    eax
        push    ebx

        push    num
        call    atoi        ; eax = (int) num
        push    eax

        push    sum1
        call    atoi
        pop     ebx
        add     eax, ebx   ; eax = (int) sum1

        push    eax
        push    sum1    
        call    itoa        ; sum1 = (str) sum1

        push    num
        call    clear

        cmp     byte[edx+esi], 0Ah
        jz      .break

        xor     edi, edi
        inc     esi
        jmp     .split

    .break:
        pop     ecx
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
        xor     ebx, ebx
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
    push    edx
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
        pop     edx
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
        cmp     dl, 0Ah
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



; ham div: so du chua trong dx, thuong so trong ax
; ham mul: phan thap luu o ax, phan cao luu o bx