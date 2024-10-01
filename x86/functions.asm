slen:
    push    ebx
    mov     ebx,eax
next:
    cmp     key[eax],0
    jz      finished
    inc     eax
    jmp     next
finished:
    sub     eax,ebx
    pop     ebx
    ret

sprint:
    push    ebx
    push    edx
    push    ecx
    push    eax
    
    mov     edx,eax
    call    slen
    pop     eax

    mov     ecx,eax
    mov     ebx,1
    mov     eax,4
    int     80h

    pop     ebx
    pop     edx
    pop     ecx
    ret

quit:
    mov     ebx,0
    mov     eax,1
    int     80h
    ret
