; Name: Narcissus
; Author: K4YT3X
; Date: January 15, 2024
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
    call guard

answerWrong:
    mov rsi, wrong
    mov rdx, 14
    jmp exit

guard:
    mov dword [rsp], main
    xor rax, rax
    mov rdi, rax
    ret
    db 0xEB exit

exit:
    syscall

    ; sys_exit(0)
    mov rax, 60
    xor rdi, rdi
    syscall

finishReading:
    xor rbx, rbx
    mov rcx, rbx
    mov rdi, buffer
    add rcx, 29
    jmp convert

main:
    cmp rsi, rdi
    jz readInput
    db 0xE8

readInput:
    inc rax
    inc rdi
    mov rsi, prompt
    mov rdx, 19
    syscall

    jmp $+2

    ; read user input
    mov rax, 0
    mov rdi, 0
    mov rsi, buffer
    mov rdx, 8
    syscall

    cmp rax, 1
    jle answerWrong

    cmp rax, rdx
    jb finishReading

    cmp byte[rsi+rdx-1], 10
    je finishReading
    jmp readOverflow

convert:
    ; atoi
    movzx rax, byte [rdi]
    sub rax, '0'
    imul rbx, rbx, 10
    add rbx, rax

    ; jmp -1
    ; inc rdi
    db 0xEB, 0xFF, 0xC7

    ; check if the character is '\n'
    cmp byte [rdi], 10
    je conversionFinished

    ; check if the character is '\0'
    cmp byte [rdi], 0
    jne convert
    je conversionFinished

    db 0x48, 0xFF, 0xCF

dummyExit:
    mov rax, 60
    xor rdi, rdi
    inc rdi
    syscall

answerCorrect:
    mov rsi, correct
    mov rdx, 17
    jmp exit

conversionFinished:
    ; getpid
    add rcx, [rdi]
    add rcx, 10
    mov rax, rcx
    syscall

    call guard2

compareAnswer:
    cmp rax, rbx
    mov rax, 1
    mov rdi, 1
    jne answerWrong
    je answerCorrect

    db 0x0F

readOverflow:
    mov rax, 0
    mov rdi, 0
    mov rsi, dummy
    mov rdx, 8
    syscall

    cmp rax, rdx
    jb finishReading

    cmp byte [rsi+rdx-1], 10
    jne readOverflow
    je finishReading

    db 0xE8

guard2:
    mov dword [rsp], compareAnswer
    ret
