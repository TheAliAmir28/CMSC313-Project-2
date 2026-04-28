.section .data
message:
    .ascii "The double is: "
message_len = . - message

newline:
    .ascii "\n"
newline_len = . - newline

.section .bss
    .lcomm output_buffer, 32    #space to build the output number as a string

.section .text
.global _start

_start:
    mov (%rsp), %rax
    cmp $2, %rax     #Check that we have at least one argument
    jl exit_program  # if we don't, then just exit

    mov 16(%rsp), %rsi  #rsi points to to argv[1], the input string

    xor %rbx, %rbx   #Will store the final integer (Currently 0)

# We walk through each character and build the number manually.
convert_input:
    movzbq (%rsi), %rcx

    cmp $0, %rcx     #Check if reached end of string
    je double_number  #If so, then done parsing

    sub $'0', %rcx    #Convert the ascii to digit

    imul $10, %rbx, %rbx
    add %rcx, %rbx

    inc %rsi
    jmp convert_input

double_number:
    add %rbx, %rbx       # rbx = rbx * 2 (doubling)

# Print: The double is:
print_message:
    mov $1, %rax
    mov $1, %rdi
    mov $message, %rsi        #Pointer to message
    mov $message_len, %rdx    #Message length
    syscall

#Integer to string. We convert the number back to string to print it
prepare_output:
    mov $output_buffer, %r9
    add $31, %r9     #Start from end as we build backwards
    movb $0, (%r9)

    mov %rbx, %rax    #rax = number to convert

    cmp $0, %rax
    jne convert_output
        #Special case if number is 0
    dec %r9
    movb $'0', (%r9)
    mov $1, %r10
    jmp print_number

convert_output:
    xor %r10, %r10

convert_digits:
    xor %rdx, %rdx
    mov $10, %rcx
    div %rcx

    add $'0', %dl
    dec %r9
    mov %dl, (%r9)
    inc %r10     #Increase length

    cmp $0, %rax
    jne convert_digits

print_number:
    mov $1, %rax
    mov $1, %rdi
    mov %r9, %rsi
    mov %r10, %rdx    #Number of characters
    syscall

print_newline:
    mov $1, %rax
    mov $1, %rdi
    mov $newline, %rsi
    mov $newline_len, %rdx
    syscall

exit_program:
    mov $60, %rax
    xor %rdi, %rdi    #exit code 0
    syscall
