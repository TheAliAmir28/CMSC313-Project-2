.section .data
message:
    .ascii "The double is: "
message_len = . - message

newline:
    .ascii "\n"
newline_len = . - newline

.section .bss
    .lcomm input_buffer, 32
    .lcomm output_buffer, 32

.section .text
.global _start

_start:
    mov $0, %rax
    mov $0, %rdi
    mov $input_buffer, %rsi
    mov $32, %rdx
    syscall

    mov %rax, %r8

    xor %rbx, %rbx
    mov $input_buffer, %rsi

parse_loop:
    cmp $0, %r8
    je parse_done

    movzbq (%rsi), %rcx

    cmp $10, %rcx
    je parse_done

    cmp $13, %rcx
    je parse_done

    sub $'0', %rcx

    imul $10, %rbx, %rbx
    add %rcx, %rbx

    inc %rsi
    dec %r8
    jmp parse_loop

parse_done:
    add %rbx, %rbx

    mov $1, %rax
    mov $1, %rdi
    mov $message, %rsi
    mov $message_len, %rdx
    syscall

    mov $output_buffer, %r9
    add $31, %r9
    movb $0, (%r9)

    mov %rbx, %rax

    cmp $0, %rax
    jne convert_loop_start

    dec %r9
    movb $'0', (%r9)
    mov $1, %r10
    jmp print_number

convert_loop_start:
    xor %r10, %r10

convert_loop:
    xor %rdx, %rdx
    mov $10, %rcx
    div %rcx

    add $'0', %dl
    dec %r9
    mov %dl, (%r9)
    inc %r10

    cmp $0, %rax
    jne convert_loop

print_number:
    mov $1, %rax
    mov $1, %rdi
    mov %r9, %rsi
    mov %r10, %rdx
    syscall

    mov $1, %rax
    mov $1, %rdi
    mov $newline, %rsi
    mov $newline_len, %rdx
    syscall

    mov $60, %rax
    xor %rdi, %rdi
    syscall
