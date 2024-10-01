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