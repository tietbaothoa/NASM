
section .data
    nl      db      0Ah

section .bss
    str1    resb    100
    str2    resb    10
    result  resb    100
    index   resb    100
    len     resd    1
    count   resd    1
    cnt     resd    1

section .text
    global _start

_start:
    push    100
    push    str1
    call    read

    push    10
    push    str2
    call    read

    push    str2
    call    strlen
    mov     [len], ecx    ; eax= len(str2)

    push    str1
    push    str2
    call    findstring

    mov     esi, [count]
    push    esi
    push    index
    call    itoa

    push    100
    push    index
    call    write

    push    2
    push    nl
    call    write

    mov     esi, [cnt]
    push    esi
    push    result
    call    write

    push    2
    push    nl
    call    write

    mov     ebx, 0
    mov     eax, 1
    int     80h

strlen:
    push    ebp
    mov     ebp, esp
    push    ebx
    mov     ebx, [ebp+8h]
    xor     ecx, ecx

    .nextchar:
        cmp     byte [ebx+ecx], 0Ah
        jz      .break 
        inc     ecx
        jmp     .nextchar
    
    .break:
        pop     ebx
        mov     esp, ebp
        pop     ebp
        ret     4

itoa:
    push    ebp
    mov     ebp, esp
    push    eax
    push    ebx
    push    ecx
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
        pop    edx
        pop     ecx
        pop     ebx
        pop     eax
        mov     esp, ebp
        pop     ebp
        ret     8


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

findstring:
    push    ebp
    mov     ebp, esp
    push    ecx
    push    edx
    mov     ecx, [ebp+0Ch]      ; str1
    mov     edx, [ebp+08h]      ; str2
    xor     esi, esi            ; chi so str1
    xor     edi, edi            ; chi so str2

    .find:   ; so sanh ki tu dau tien
        xor     eax, eax
        xor     edi, edi
        mov     al, byte[ecx + esi]
        mov     ah, byte[edx + edi]
        cmp     al, 0Ah     ; str1 == 0Ah --> popstr
        jz      .done
        cmp     al, ah          ; str1[i]==str2[i] --> nextchar
        jz      .nextchar
        inc     esi             ; str1[i]!=str2[i] --> esi++ --> find
        jmp     .find

    .nextchar:
        xor     eax, eax        
        inc     esi
        inc     edi
        mov     al, byte[ecx+esi]
        mov     ah, byte[edx+edi]
        cmp     ah, 0Ah     ; str2[i] == 0Ah --> popstr
        jz      .popstr
        cmp     al, ah      ; str1[i] == str2[i] --> nextchar else --> find
        jz      .nextchar
        jmp     .find

    .popstr:
        push    eax
        xor     eax, eax
        mov     eax, [count]     ; eax == count
        inc     eax             ; count++
        mov     [count], eax    
        pop     eax             
        sub     esi, [len]      ; esi
        push    esi
        mov     [index], esi
        push    esi
        push    index
        call    itoa
        mov     esi, [len]
        push    esi
        push    index
        call    _result
        ; mov     [result], 
        ; mov     [result], 20h
        pop     esi
        inc     esi
        cmp     byte [ecx + esi], 0Ah
        jnz     .find   

    .done:
        pop     edx
        pop     ecx
        mov     esp, ebp
        pop     ebp
        ret     8


_result:
    push    ebp
    mov     ebp, esp
    push    ecx     ; len
    push    edx     ; index
    push    ebx
    push    esi
    mov     ecx, [ebp+0Ch]
    mov     edx, [ebp+08h]
    mov     ebx, result
    mov     esi, [cnt]

    .eachchar:
        xor     eax, eax
        mov     al, byte[edx]
        mov     byte [ebx+esi], al
        inc     edx
        inc     esi
        cmp     byte[edx], 0
        jz      .break
        jmp     .eachchar

    .break:
        mov     byte [ebx+esi], 20h
        inc     esi
        mov     [cnt], esi
        pop     esi
        pop     ebx
        pop     edx
        pop     ecx
        mov     esp, ebp
        pop     ebp
        ret     8



