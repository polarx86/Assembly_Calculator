section .data
    title db "<< +- ASM CALCULATOR x/ >>", 10
    len_title equ $ - title

    num1_msg db "Digite o primeiro numero: "
    len_num1_msg equ $ - num1_msg

    op_msg db 10, "Qual operacao voce deseja fazer?", 10, "1 - Adicao(+)", 10, "2 - Subtracao(-)", 10, "3 - multiplicacao(x)", 10, "4 - Divisao(/)", 10, "Insira sua escolha: "
    len_op_msg equ $ - op_msg

    num2_msg db 10, "Digite o segundo numero: "
    len_num2_msg equ $ - num2_msg

    result_msg db 10, "O resultado da sua operacao foi: "
    len_result_msg equ $ - result_msg

    msg_erro db 10, "Caractere invalido, reiniciando...", 10
    len_erro equ $ - msg_erro

    clear_screen db 27, '[2J', 27, '[H'

    tempo:
        segundos  dq 3
        nanosegundos dq 0

    jgr_novamente_msg db 10, "Deseja jogar novamente? [s/n] "
    len_jgr_novamente_msg equ $ - jgr_novamente_msg

section .bss
    num1 resq 1
    num2 resq 1
    operacao resq 1
    escolha resb 1
    result resq 1

section .text
global _start

_start:
    call clear

    mov rax, 1
    mov rdi, 1
    mov rsi, title
    mov rdx, len_title
    syscall

    mov rax, 1
    mov rdi, 1
    mov rsi, num1_msg
    mov rdx, len_num1_msg
    syscall

    mov rax, 0
    mov rdi, 0
    mov rsi, num1
    mov rdx, 8
    syscall

    cmp byte[num1], 0xa
    je _start

    call validar_input

    mov rsi, num1
    call str_to_int
    mov [num1], rax

    mov rax, 1
    mov rdi, 1
    mov rsi, op_msg
    mov rdx, len_op_msg
    syscall

    mov rax, 0
    mov rdi, 0
    mov rsi, operacao
    mov rdx, 8
    syscall

    call validar_operacao

    call str_to_int
    mov [operacao], rax

    mov rax, 1
    mov rdi, 1
    mov rsi, num2_msg
    mov rdx, len_num2_msg
    syscall

    mov rax, 0
    mov rdi, 0
    mov rsi, num2
    mov rdx, 8
    syscall

    call validar_input

    mov rsi, num2
    call str_to_int
    mov [num2], rax

    mov rax, [operacao]
    cmp rax, 1
    je somar

    cmp rax, 2
    je subtrair

    cmp rax, 3
    je multiplicar

    cmp rax, 4
    je dividir

somar:
    mov rax, [num1]
    mov rbx, [num2]
    add rax, rbx
    call int_to_str
    jmp saida

subtrair:
    mov rax, [num1]
    mov rbx, [num2]
    sub rax, rbx
    call int_to_str
    jmp saida

multiplicar:
    mov rax, [num1]
    mov rbx, [num2]
    imul rax, rbx
    call int_to_str
    jmp saida

dividir:
    xor rdx, rdx
    mov rax, [num1]
    mov rbx, [num2]
    div rbx
    call int_to_str
    jmp saida

saida:
    mov [result], rsi
    mov rax, 1
    mov rdi, 1
    mov rsi, result_msg
    mov rdx, len_result_msg
    syscall

    mov rax, 1
    mov rdi, 1
    mov rsi, [result]
    mov rdx, 8
    syscall

    jmp jogar_novamente

validar_input:
    mov al, byte[rsi]
    inc rsi

    cmp al, 0x0a
    je .voltar

    cmp al, 0x30
    jl .erro

    cmp al, 0x39
    jg .erro

    jmp validar_input

.erro:
    mov rax, 1
    mov rdi, 1
    mov rsi, msg_erro
    mov rdx, len_erro
    syscall
    call temporizador
    jmp _start

.voltar:
    ret

validar_operacao:
    mov al, byte[rsi]

    cmp al, 0x31
    jl .erro

    cmp al, 0x34
    jg .erro

    ret

.erro:
    mov rax, 1
    mov rdi, 1
    mov rsi, msg_erro
    mov rdx, len_erro
    syscall
    call temporizador
    jmp _start

str_to_int:
    mov rax, 0

.prox_num:
    mov dl, byte[rsi]
    inc rsi

    cmp dl, 48
    jl .fim
    cmp dl, 57
    jg .fim
    sub dl, 48
    imul rax, 10
    add rax, rdx

    jmp .prox_num

.fim:
    ret

int_to_str:
    mov rbx, 10

.prox_digito:
    mov rdx, 0
    div rbx
    add dl, '0'
    mov byte[rsi], dl
    dec rsi
    cmp rax, 0
    jnz .prox_digito
    ret

clear:
    mov rax, 1
    mov rdi, 1
    mov rsi, clear_screen
    mov rdx, 7
    syscall
    ret

temporizador:
    lea rdi, [tempo]
    mov rax, 35
    mov rsi, rdi
    xor rdx, rdx
    syscall
    ret

jogar_novamente:
    mov rax, 1
    mov rdi, 1
    mov rsi, jgr_novamente_msg
    mov rdx, len_jgr_novamente_msg
    syscall

    mov rax, 0
    mov rdi, 0
    mov rsi, escolha
    mov rdx, 1
    syscall

    mov al, [escolha]
    cmp al, 0x53
    jz _start

    cmp al, 0x73
    jz _start

    cmp al, 0x4E
    jz .fim

    cmp al, 0x6E
    jz .fim

    call clear
    jmp jogar_novamente

.fim:
    mov rax, 60
    xor rdi, rdi
    syscall
