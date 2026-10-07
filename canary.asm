section .data
    msg_ok       db "Buffer integrity verified. Stack Canary is safe.", 10
    len_ok       equ \$ - msg_ok

    msg_corrupt  db "CRITICAL ALERT: Stack buffer corruption detected! Purging...", 10
    len_corrupt  equ \$ - msg_corrupt

    SECRET_CANARY equ 0xDEADBEEFCAFEF00D 

section .text
    global _start

_start:
    push rbp
    mov rbp, rsp
    sub rsp, 16             
    
    mov rax, SECRET_CANARY  
    mov [rbp - 8], rax      

    mov rdx, [rbp - 8]      
    mov rax, SECRET_CANARY  
    cmp rdx, rax            
    jne .stack_corrupted    

    mov rax, 1              
    mov rdi, 1             
    mov rsi, msg_ok
    mov rdx, len_ok
    syscall

    mov rsp, rbp
    pop rbp
    mov rax, 60             
    xor rdi, rdi
    syscall

.stack_corrupted:
    mov rax, 1              
    mov rdi, 1             
    mov rsi, msg_corrupt
    mov rdx, len_corrupt
    syscall

    mov rax, 60          
    mov rdi, 139            
    syscall
