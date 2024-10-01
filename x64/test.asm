
section .data
    sNum1   db "Num1 = ", 0h
    sNum2   db "Num2 = ", 0h
    sResult db "Result = ", 0h

section .bss
    Num1    resb 30
    Num2    resb 30
    Num1Fix resb 30
    Num2Fix resb 30
    Result  resb 31

section .text
global _start

_start:
    mov     rbp, rsp
    input1:
        mov     rdi, 1
        mov     rsi, sNum1
        mov     rdx, 7
        mov     rax, 1
        syscall                         ;write text num1

        mov     rdi, 0
        mov     rsi, Num1
        mov     rdx, 30
        mov     rax, 0
        syscall                         ;read num1
        mov     rbx, Num1
        mov     al, byte [rbx]
        cmp     al, '-'                 
        jz      input1                  ;if negative number --> retype

    input2:
        mov     rdi, 1
        mov     rsi, sNum2
        mov     rdx, 7
        mov     rax, 1
        syscall                         ;write text num2
        
        mov     rdi, 0
        mov     rsi, Num2
        mov     rdx, 30
        mov     rax, 0
        syscall                         ;read num2
        mov     rbx, Num2
        mov     al, byte [rbx]
        cmp     al, '-'
        jz      input2                  ;if negative number --> retype

    mov     rsi, Num1                   ;rsi = &num1
    mov     rdi, Num1Fix                ;rdi = &num1fix (fix symbol not number)
    call    _fixnotnumber               
    mov     rsi, Num2                   ;rsi = &num2
    mov     rdi, Num2Fix                ;rdi = &num2fix (fix symbol not number)
    call    _fixnotnumber               ;fixnotnumber(rsi = &num, rdi = &numfix --> return numfix = int(num))

    mov     rsi, Num1Fix                
    mov     rdi, Num2Fix
    mov     rdx, Result
    call    _bigsum                 ;bigsum(rsi = num1, rdi = num2, rdx = result)

    mov     rdi, 1
    mov     rsi, sResult
    mov     rdx, 9
    mov     rax, 1
    syscall                         ;write text result 

    cmp     r14, 0                  ;cmp length with 0 (in case of non-numeric characters)
    jz      resultiszero            ;If right --> jmp --> result = 0 
    printresult:
        mov     rsi, Result
        mov     byte [rsi + r14], 0Ah       ;add \n
        inc     r14
        mov     rdi, 1
        mov     rdx, r14                ;r14 = length
        mov     rax, 1
        syscall                         ;write result
        jmp     exit

    resultiszero:                   ;num1 and num2 not number --> result = 0
        mov     rbx, Result
        mov     byte [rbx + r14], '0'       ;add '0' to result
        inc     r14
        jmp     printresult                 ;jmp --> print result

    exit:
        mov     rdi, 0
        mov     rax, 60
        syscall

_fixnotnumber:
    push    rbp
    mov     rbp, rsp
    push    rdx

    .LoopSym:
        xor     rdx, rdx
        mov     dl, byte [rsi]              ;dl = (char)number 
        cmp     dl, 0Ah                     
        jz      .Exit                       ;dl = \n --> exit
        cmp     dl, '0'         
        jl      .continue                   ;dl < '0' --> not number --> continue
        cmp     dl, '9'
        jg      .continue                   ;dl > '9' --> not number --> continue
        cmp     dl, '9'
        mov     byte [rdi], dl              ;dl = number --> mov dl to numfix
        inc     rsi
        inc     rdi
        jmp     .LoopSym

    .continue:                              
        inc     rsi
        jmp     .LoopSym

    .Exit:
        mov     byte [rdi], 0Ah             ;add \n
        inc     rdi
        pop     rdx
        mov     rsp, rbp
        pop     rbp
        ret

_bigsum:
    push    rbp
    mov     rbp, rsp
    sub     rsp, 18h
    push    rax
    push    rbx
    push    rcx
    mov     [rbp - 08h], rsi                ;[rbp - 08h] = &Num1
    mov     [rbp - 10h], rdi                ;[rbp - 10h] = &Num2
    mov     [rbp - 18h], rdx                ;[rbp - 18h] = Result
    call    _reverse                        ;reverse(Num1)
    mov     rax, rsi                        ;rax = Num1.length
    mov     rsi, [rbp - 10h]
    call    _reverse
    mov     rbx, rsi                        ;rbx = Num2.length

    cmp     rax, rbx
    jz      .Format                         ;Num1.length = Num2.length
    jl      .Num2Max                        ;Num1.length < Num2,length
    ;jg      .Num1Max                        ;Num1 > Num2

    .Num1Max:                               ;num1.length > num2.length
        mov     rsi, [rbp - 10h]            ;rsi = num2
        push    rbx                         ;rbx = Num2.length (min)
        push    rax                         ;rax = Num1.length (max)
        call    _insertzero                 ;num1.length != num2.length --> insert 0
        jmp     .Format

    .Num2Max:                               ;num1.length < num2.length
        mov     rsi, [rbp - 08h]            ;rsi = num1
        push    rax                         ;rax = Num1.length (min)
        push    rbx                         ;rbx = Num2.length (max)
        call    _insertzero                 ;num1.length != num2.length --> insert 0

    .Format:                                ;return data to register
        xor     rbx, rbx
        mov     rsi, [rbp - 08h]            ;[rbp - 08h] = &Num1
        mov     rdi, [rbp - 10h]            ;[rbp - 10h] = &Num2
        mov     rdx, [rbp - 18h]            ;[rbp - 18h] = Result
        xor     r12, r12                    ;r12 = 0

    .Calc:
        xor     rax, rax
        mov     al, byte [rsi + rbx]        ;al = (char)num1
        cmp     al, 0Ah                 
        jz      .InsertMem                  ;al = \n --> insert mem
        mov     ah, byte [rdi + rbx]        ;ah = (char)num2
        sub     al, 30h                     ;al - 48
        sub     ah, 30h                     ;ah - 48
        add     al, ah                      ;al + ah
        xor     ah, ah                      ;ah = 0
        add     rax, r12                    ;rax += mem
        xor     r12, r12                    ;mem = 0
        cmp     al, 10                      
        jnc     .High                           ;al > 10 --> jmp

    .Next:
        add     al, 30h                     ;al + 48
        mov     byte [rdx + rbx], al        ;string += al
        inc     rbx
        jmp     .Calc

    .High:
        mov     r12, 1                          ;mem = 1
        sub     al, 10                          ;al > 10 --> sub al, 10 --> mem = 1
        jmp     .Next

    .InsertMem:                                 ;final: cmp mem, 1 --> insert mem
        xor     rax, rax
        mov     rax, r12                        ;rax = mem
        cmp     rax, 0
        jz      .Exit                           ;rax = 0 --> mem = 0 --> exit
        add     al, 30h
        mov     byte [rdx + rbx], al            ;add mem to result
        inc     rbx

    .Exit:
        mov     byte [rdx + rbx], 0Ah           ;add \n
        inc     rbx 
        mov     rsi, [rbp - 18h]
        call    _reverse                        ;reverse(rsi = &string --> rdi = len)
        mov     r14, rsi                        ;Result.length
        pop     rcx
        pop     rbx
        pop     rax
        mov     rsp, rbp
        pop     rbp
        ret

_insertzero:    
    push    rbp
    mov     rbp, rsp
    push    rcx
    push    rdx
    mov     rcx, [rbp + 18h]                ;rcx = length min
    mov     rdx, [rbp + 10h]                ;rdx = length max

    .Insert:
        cmp     rcx, rdx                    ;cmp len1 with len2
        jz      .Exit                       ;len1 = len2 --> exit
        mov     byte [rsi + rcx], 30h       ;insert '0'
        inc     rcx
        jmp     .Insert

    .Exit:
        mov     byte [rsi + rcx], 0Ah       ;add \n
        inc     rcx
        pop     rdx
        pop     rcx
        mov     rsp, rbp
        pop     rbp
        ret

_reverse:                               ;reverse(rsi = &string --> rdi = len)
    push    rbp
    mov     rbp, rsp
    push    rax
    push    rcx
    push    rdx
    xor     rax, rax
    xor     rcx, rcx
    mov     rdi, rsi                    ;rdi = rsi = &string
    mov     rdx, rsi                    ;rdx = rsi = &string

    .LoopSym:
        lodsb                           ;al = [rsi++]
        cmp     al, 0Ah                 ;al = \n
        jz      .PopSym                 ;--> pop data from stack down
        push    rax                     ;push [rax] to stack
        inc     rcx
        jmp     .LoopSym
    
    .PopSym:
        cmp     rcx, 0                  ;count with 0
        jz      .Exit                   ;count = 0 --> exit
        pop     rax                     ;pop data from stack, mov to rax
        stosb                           ;[rdi++] = al
        dec     rcx
        jmp     .PopSym

    .Exit:
        sub     rdi, rdx                ;rdi = len
        mov     rsi, rdi                ;rsi = len
        pop     rdx
        pop     rcx
        pop     rax
        mov     rsp, rbp
        pop     rbp
        ret
