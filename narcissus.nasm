; Name: Narcissus
; Author: K4YT3X
; Date: January 18, 2024
; Description: A simple reverse engineering challenge.

section .data

prompt:
    db "Enter your answer: "

correct:
    db 10, "Correct answer!", 10

wrong:
    db "Wrong answer.", 10

buffer:
    db 8 dup(0)

dummy:
    db 8 dup(0)

section .text
global _start

_start:
    ; the call behaves like jmp
    call guard

    ; will never be reached
    ; makes the disassembler recognize the fake functions as subroutines

    ; make the first 0xFF bytes functions
    %assign i 1
    %rep 0xFF
        call _start + i
        %assign i i+1
    %endrep

    ; make the INT3 bytes functions
    %assign i 0
    %rep 1024
        call fakeFunction + i
        %assign i i+1
    %endrep

    ; make the last 0xFF bytes functions
    %assign i 1
    %rep 0xFF
        call end - i
        %assign i i+1
    %endrep

answerWrong:
    mov rax, 1
    mov rdi, 1
    mov rsi, wrong
    mov rdx, 14
    jmp exit

guard:
    ; overwrite the return address to the address of main
    mov dword [rsp], main

    xor rax, rax
    mov rdi, rax

    ; ret to main
    ret

    ; junk code, will never be reached
    db 0xEB exit

exit:
    ; sys_write
    syscall

    ; sys_exit(0)
    mov rax, 60
    xor rdi, rdi
    syscall

finishReading:
    ; rbx = 0
    xor rbx, rbx

    ; rcx = 0
    mov rcx, rbx

    mov rdi, buffer

    ; rcx = (0 + 29)
    add rcx, 29
    jmp convert

main:
    ; jump will always happen
    cmp rsi, rdi
    jz readInput

    ; junk code, will never be reached
    db 0xE8

continueReading:
    ; if the user pressed enter
    cmp rax, 1
    jle answerWrong

    cmp rax, rdx
    jb finishReading

    ; determine if there is more data to read
    ; check if the last byte is '\n'
    cmp byte [rsi+rdx-1], 10
    je finishReading

    ; check if the last byte is '\0'
    cmp byte [rsi+rdx-1], 0
    je finishReading
    jmp readOverflow

; convert's effect is similar to atoi
; it converts the user input ASCII into an integer
convert:
    movzx rax, byte [rdi]
    sub rax, '0'
    imul rbx, rbx, 10
    add rbx, rax

    ; these three bytes are two multi-byte instructions
    ; jmp -1 (0xEB 0xFF)
    ; inc rdi (0xFF 0xC7)
    db 0xEB, 0xFF, 0xC7

    ; check if the character is '\n'
    cmp byte [rdi], 10
    je conversionFinished

    ; check if the character is '\0'
    cmp byte [rdi], 0
    jne convert
    je conversionFinished

    ; junk code, will never be reached
    db 0x48, 0xFF, 0xCF

readInput:
    ; rax += 1 (rax == 1)
    inc rax

    ; rdi += 1 (rdi == 1)
    inc rdi

    mov rsi, prompt
    mov rdx, 19

    ; sys_read
    syscall

    ; clear the signed flag (SF)
    and rdx, rdx

    ; junk code
    clc
    clc
    clc

    ; read user input
    mov rax, 0
    mov rdi, 0
    mov rsi, buffer
    mov rdx, 8
    syscall

    ; since the SF flag is cleared, the jump will always be taken
    jns continueReading

    ; junk code, will never be reached
    jmp $-10

answerCorrect:
    mov rsi, correct
    mov rdx, 17

    ; rax = 1
    ; rdi = 1
    mov rbx, rdx
    xor rdx, rbx
    mov rax, rbx
    div rbx
    mov rdx, rbx
    mov rdi, rax

    jmp exit

conversionFinished:
    ; junk code
    jmp $+3
    ret

    ; rcx (29) += [rdi]
    ; add the value of the input's last byte to rcx
    add rcx, [rdi]

    ; rcx += 10
    ; if [rdi] in the last statement is not 0, the value of rcx will be incorrect here
    ; therefore, the user must ensure that the last byte of the input is '\0', not '\n'
    add rcx, 10
    mov rax, rcx

    ; getpid
    syscall

    ; save PID on stack
    push rax

    ; ptrace(PTRACE_TRACEME, 0, NULL, NULL);
    ; used to check if a debugger is present
    ; if a debugger is present, it will return -1
    mov rax, 101
    xor rdi, rdi
    xor rsi, rsi
    xor rdx, rdx
    xor r10, r10
    syscall

    ; if no debugger is present, jump
    cmp rax, -1
    jne fakeFunction+1

    ; debugger will be forced to break here
    ; if the user single steps in debugger, the debugger will not be able to find
    ;   the bounds of the current function
    ; if the user continues running in the debugger, SIGSEGV will be thrown
    int3

fakeFunction:
    ; this ret will never be executed
    ; the jne above jumps past it
    ret

    ; jump to the address of the `pop rax` below
    mov rcx, $+1036
    jmp rcx

    ; 1024x INT3
    db 1024 dup(0xCC)

    ; restore PID from stack
    pop rax

    ; this jump will never happen
    cmp rax, rdi
    jz finishReading

    mov rcx, rax

    ; loop implicitly decreases rcx by 1
    ; i.e., PID -= 1
    loop callGuard2

    ; junk code, will never be reached
    outsw

callGuard2:
    push rcx
    call guard2

compareAnswer:
    pop rax

    ; rax: getpid - 1
    ; rbx: atoi(read())
    cmp rax, rbx
    jne answerWrong
    je answerCorrect

    ; junk code
    db 0x0F

readOverflow:
    mov rax, 0
    mov rdi, 0
    mov rsi, dummy
    mov rdx, 8
    syscall

    cmp rax, rdx
    jb finishReading

    ; check if the last byte is '\n'
    cmp byte [rsi+rdx-1], 10
    je finishReading

    ; check if the last byte is '\0'
    cmp byte [rsi+rdx-1], 0
    jne readOverflow
    je finishReading

    ; junk code, will never be reached
    db 0xE8

guard2:
    ; junk code
    loop $+2

    ; modify the return address on the stack
    mov dword [rsp], compareAnswer

    ; junk code
    fnop

    ; ret to compareAnswer
    ret

end:
