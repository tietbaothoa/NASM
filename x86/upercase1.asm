section .bss
    input   resb    32

section .text
    global _start

_start:
    mov     edx, 32
    mov     ecx, input
    mov     ebx, 0
    mov     eax, 3
    int     80h

    xor     eax, eax

    uper:
        cmp     byte [ecx+eax], 'a'
        jl      notlowercase
        cmp     byte [ecx+eax], 'z'
        jg      notlowercase
        sub     byte [ecx+eax], 32
        inc     eax
        cmp     byte [ecx+eax], 0
        jz      print
        jmp     uper

        notlowercase:
            inc     eax
            cmp     byte [ecx+eax], 0
            jz      print
            jmp     uper

        print:
            mov     edx, 32
            ; mov     ecx, ecx
            mov     ebx, 1
            mov     eax, 4
            int     80h

            mov     ebx, 0
            mov     eax, 1
            int     80h


        



       



