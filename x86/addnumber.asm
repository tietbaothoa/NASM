section .data
    nl   db  0Ah, 0h

section .bss
    num1    resb    50
    num2    resb    50
    sum     resb    51

section .text
    global _start

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

scanf:
    push    ebp
    mov     ebp, esp
    push    edx
    push    ecx
    mov     edx, [ebp+0Ch]  ; strlen
    mov     ecx, [ebp+08h]  ; str
    mov     ebx, 0
    mov     eax, 3
    int     80h

    pop     ecx
    pop     edx
    mov     esp, ebp
    pop     ebp
    ret     8

printf:
    push    ebp
    mov     ebp, esp
    push    edx
    push    ecx

    mov     edx, [ebp+0Ch]          ;num
    mov     ecx, [ebp+08h]          ;str
    mov     ebx, 1
    mov     eax, 4
    int     80h

    pop     ecx
    pop     edx
    mov     esp, ebp
    pop     ebp
    ret     8

_start:
    push    50
    push    num1
    call    scanf

    push    50
    push    num2
    call    scanf

    push    num1  ; ecx = num1
    call    atoi ; str num1 -->(int)num1    eax = (int) num1
    push    eax

    push    num2    ; ecx = num2
    call    atoi    ; str num2 -->(int)num2   eax = (int) num2
    pop     ecx     
    add     eax, ecx

    push    eax
    push    sum
    call    itoa

    push    eax
    push    sum
    call    printf

    push    2
    push    nl 
    call    printf

    mov     ebx, 0
    mov     eax, 1
    int     80h


; ham div: so du chua trong dx, thuong so trong ax
; ham mul: phan thap luu o ax, phan cao luu o bx
    



    


    









