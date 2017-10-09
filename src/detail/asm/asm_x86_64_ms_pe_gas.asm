.file	"asm_x86_64_ms_pe_gas.asm"
.text
.p2align 4,,15
.globl	prefetch_asm
.def	prefetch_asm;	.scl	2;	.type	32;	.endef
.seh_proc	prefetch_asm
prefetch_asm:
.seh_endprologue
    prefetcht1 (%rdi)
    ret
.seh_endproc

.section .drectve
.ascii " -export:\"prefetch_asm\""

.text
.p2align 4,,15
.globl	bootstrap_green_task
.def	bootstrap_green_task;	.scl	2;	.type	32;	.endef
.seh_proc	bootstrap_green_task
bootstrap_green_task:
.seh_endprologue
    mov %r12, %rcx     /* setup the function arg */
    mov %r13, %rdx     /* setup the function arg */
    mov %r14, 8(%rsp)  /* this is the new return adrress */
    ret
.seh_endproc

.section .drectve
.ascii " -export:\"bootstrap_green_task\""

.text
.p2align 4,,15
.globl	swap_registers
.def	swap_registers;	.scl	2;	.type	32;	.endef
.seh_proc	swap_registers
swap_registers:
.seh_endprologue
    mov %rbx, (0*8)(%rcx)
    mov %rsp, (1*8)(%rcx)
    mov %rbp, (2*8)(%rcx)
    mov %r12, (4*8)(%rcx)
    mov %r13, (5*8)(%rcx)
    mov %r14, (6*8)(%rcx)
    mov %r15, (7*8)(%rcx)
    mov %rdi, (9*8)(%rcx)
    mov %rsi, (10*8)(%rcx)

    /* align mem */
    mov %rcx, %r10
    and $0xf0, %r10b
    
    /* Save non-volatile XMM registers */
    movapd %xmm6, (18*8)(%r10)
    movapd %xmm7, (20*8)(%r10)
    
    /* load NT_TIB */
    movq %gs:(0x30), %r10
    /* save current stack base */
    movq 0x08(%r10), %rax
    mov %rax, (11*8)(%rcx)
    /* save current stack limit */
    movq 0x10(%r10), %rax
    mov %rax, (12*8)(%rcx)
    /* save current deallocation stack */
    movq 0x1478(%r10), %rax
    mov %rax, (13*8)(%rcx)
    /* save fiber local storage */
    /* movq  0x18(%r10), %rax */
    /* mov  %rax, (14*8)(%rcx) */
    
    mov %rcx, (3*8)(%rcx)
    
    mov (0*8)(%rdx), %rbx
    mov (1*8)(%rdx), %rsp
    mov (2*8)(%rdx), %rbp
    mov (4*8)(%rdx), %r12
    mov (5*8)(%rdx), %r13
    mov (6*8)(%rdx), %r14
    mov (7*8)(%rdx), %r15
    mov (9*8)(%rdx), %rdi
    mov (10*8)(%rdx), %rsi
    
    /* align mem */
    mov %rdx, %r10
    and $0xf0, %r10b
    /* Restore non-volatile XMM registers */
    movapd (18*8)(%r10), %xmm6
    movapd (20*8)(%r10), %xmm7
    
    /* load NT_TIB */
    movq  %gs:(0x30), %r10
    /* restore fiber local storage */
    /* mov (14*8)(%rdx), %rax */
    /* movq  %rax, 0x18(%r10) */
    /* restore deallocation stack */
    mov (13*8)(%rdx), %rax
    movq  %rax, 0x1478(%r10)
    /* restore stack limit */
    mov (12*8)(%rdx), %rax
    movq  %rax, 0x10(%r10)
    /* restore stack base */
    mov  (11*8)(%rdx), %rax
    movq  %rax, 0x8(%r10)
    
    mov (3*8)(%rdx), %rcx
    ret
.seh_endproc

.section .drectve
.ascii " -export:\"swap_registers\""