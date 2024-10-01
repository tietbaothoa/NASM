section .data
    output      db      "1.Cong", 0Ah, "2.Tru", 0Ah, "3.Nhan", 0Ah, "4.Chia", 0Ah, "5.Thoat", 0Ah, 0h
    output1     db      "Num1: ", 0Ah, 0h
    output2     db      "Num2: ", 0Ah, 0h
    output3     db      "So du: ", 0Ah, 0h
    dau         db      "-"
    nl          db      0Ah, 0h

section .bss
    result  resb    100
    choice  resb    2
    num1    resb    10
    num2    resb    10
    du      resb    10
    len1    resd    1
    len2    resd    1
    len3    resd    1
    n1      resd    1
    n2      resd    1

section .text
    global _start

_start:

    push    36
    push    output
    call    write

    push    2
    push    choice
    call    read
    mov     edx, [choice]
    cmp     dl, '5'
    jz      exit

    push    8
    push    output1
    call    write

    push    10
    push    num1
    call    read

    push    8
    push    output2
    call    write

    push    10
    push    num2
    call    read

    push    num1
    push    num2
    call    calc

    push    num1
    call    clear
    push    num2
    call    clear

    push    100
    push    result
    call    write
    push    result
    call    clear
    push    2
    push    nl
    call    write
    mov     edx, [choice]
    cmp     dl, '4'
    jz      sodu

    jmp     _start
    ; jmp     .exit

sodu:
    push    9
    push    output3
    call    write
    push    10
    push    du
    call    write
    push    2
    push    nl
    call    write
    push    du
    call    clear
    jmp     _start

exit:
    mov     ebx, 0
    mov     eax, 1
    int     80h


calc:
    push    ebp
    mov     ebp, esp
    push    edx         ;num1
    push    ecx         ;num2
    mov     edx, [ebp+0Ch]
    mov     ecx, [ebp+08h]
    
    .compare:
        xor     ebx, ebx
        mov     bl, [choice]
        cmp     bl, '1'
        jz      .Cong
        cmp     bl, '2'
        jz      .Tru
        cmp     bl, '3'
        jz      .Nhan
        cmp     bl, '4'
        jz      .Chia
    
    .Cong:
        push    eax
        push    ebx
        push    num2
        call    atoi    ; eax=(int)num1
        push    eax
        push    num1
        call    atoi    ; eax=(int)num2
        pop     ebx
        add     eax, ebx ; eax=(int)result
        push    eax
        push    result
        call    itoa
        pop     ebx
        pop     eax
        jmp     .break

    .Tru:
        push    eax
        push    ebx
        push    num2
        call    atoi    ; eax=(int)num1
        push    eax
        push    num1
        call    atoi    ; eax=(int)num2
        pop     ebx
        push    eax
        push    ebx
        call    fixsub
        mov     eax, [n1]
        mov     ebx, [n2]
        ; cmp     eax, ebx
        ; jl      .fixsub
        sub     eax, ebx ; eax=(int)result
        push    eax
        push    result
        call    itoa
        pop     ebx
        pop     eax
        jmp     .break

    .Nhan:
        push    eax
        push    ebx
        push    edx
        push    num2
        call    atoi
        push    eax
        push    num1
        call    atoi
        pop     ebx
        mul     ebx
        push    eax
        push    result
        call    itoa
        pop     edx
        pop     ebx
        pop     eax
        jmp     .break

    .Chia:
        push    eax
        push    ebx
        xor     edx, edx
        push    num2
        call    atoi
        push    eax
        push    num1
        call    atoi
        pop     ebx
        div     ebx
        push    eax
        push    result
        call    itoa
        push    edx
        push    du
        call    itoa
        pop     ebx
        pop     eax
        jmp     .break

    .break:
        pop     ecx
        pop     edx
        mov     esp, ebp
        pop     ebp
        ret     8

fixsub:
    push    ebp
    mov     ebp, esp
    push    eax
    push    ebx
    mov     eax, [ebp+0Ch]
    mov     ebx, [ebp+08h]


    .fix:
        cmp     eax, ebx
        jnl     .notfix
        mov     [n1], ebx
        mov     [n2], eax
        push    1
        push    dau
        call    write
        jmp     .break

    .notfix:
        mov     [n1], eax
        mov     [n2], ebx

    .break:
        pop     ebx
        pop     eax
        mov     esp, ebp
        pop     ebp
        ret     8


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

    








