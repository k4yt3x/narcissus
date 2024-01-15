; Name: Narcissus
; Author: K4YT3X
; Date: January 15, 2024
; Description: A simple reverse engineering challenge.

section .data

prompt:
    db "Enter your answer: "

correct:
    db "Correct answer!", 10

wrong:
    db "Wrong answer.", 10

buffer:
    db 8 dup(0)

dummy:
    db 8 dup(0)

section .text
global _start

_start:
    mov rax, 1
    mov rdi, 1
    mov rsi, prompt
    mov rdx, 19
    syscall

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

finishReading:
    xor rbx, rbx
    mov rdi, buffer

convert:
    ; atoi
    movzx rax, byte[rdi]
    sub rax, '0'
    imul rbx, rbx, 10
    add rbx, rax
    inc rdi

    ; check if the character is '\n'
    cmp byte [rdi], 10
    je conversionFinished

    ; check if the character is '\0'
    cmp byte [rdi], 0
    jne convert

conversionFinished:
    mov rax, 39
    syscall

    cmp rax, rbx
    jne answerWrong

answerCorrect:
    mov rax, 1
    mov rdi, 1
    mov rsi, correct
    mov rdx, 16
    syscall
    jmp exit

answerWrong:
    mov rax, 1
    mov rdi, 1
    mov rsi, wrong
    mov rdx, 14
    syscall
    jmp exit

exit:
    ; sys_exit(0)
    mov rax, 60
    xor rdi, rdi
    syscall

