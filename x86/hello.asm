%include 'strlen.asm'

section .data
msg     db  'Hello world', 0Ah  ; khai bao bien string 

section .text
global  _start

_start:
    mov     ebx, msg
    push    ebx
    call    strlen

    mov     edx, ecx
    mov     ecx, msg
    mov     ebx, 1
    mov     eax, 4
    int     80h

    mov     ebx, 0
    mov     eax, 1
    int     80h

