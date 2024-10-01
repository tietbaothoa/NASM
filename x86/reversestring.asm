section .data
    nl      db       0Ah

section .bss
    string      resb    30

section .text
    global  _start

reversestring:      
    push    ebp
    mov     ebp, esp
    push    ecx
    mov     ecx, [ebp+08h] ; str
    xor     esi, esi

    rev:       
        xor     edx, edx    ; edx = 0
        mov     dl, byte [ecx+esi]
        cmp     dl, 0Ah
        jz      .popstr
        push    edx     ; edx=str
        inc     esi
        jmp     rev

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
        pop     ecx
        mov     esp, ebp
        pop     ebp
        ret     4

scanf:
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

printf:
    push    ebp
    mov     ebp, esp
    push    edx
    push    ecx

    mov     edx, [ebp+0Ch]  ; strlen
    mov     ecx, [ebp+08h]  ; str
    mov     ebx, 1
    mov     eax, 4
    int     80h

    pop     ecx
    pop     edx
    mov     esp, ebp
    pop     ebp
    ret     8

_start:
    push    30
    push    string
    call    scanf

    push    string
    call    reversestring

    push    30
    push    string
    call    printf

    mov     ebx, 0
    mov     eax, 1
    int     80h


