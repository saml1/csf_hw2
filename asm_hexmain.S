/* Hexdump main function, assembly language version */
    .section .data
sBuf: .zero 17  /*initialize array with room for 17 chars*/

sOffsetChar: .zero 11 /* char for offset*/

	.section .text

	.globl main
main:
    subq $136, %rsp                 /*align stack pointer*/
    pushq %r12
    movq $0, %r12               /* this is long offset */

.LmainLoop:
    movq $sBuf, %rdi            /*moving sBuf to 1st arg reg*/
    call hex_read               /*calling hex_read*/
    movq $0, (%rdi, %rax)       /*setting null terminator to element of chars read*/
    pushq %rdi                  /* storing buf in stack*/
    cmp $0, %rax                /*comparing chars read to 0*/
    je .Lend                   /*jump to end if chars read = 0*/
    pushq %r14                  /* r14 will be chars read*/
    movq %rax, %r14
    movq %r12, %rdi          /* moving offset to rdi, 1st arg*/
    movq $sOffsetChar, %rsi      /* moving offset char to rsi, 2nd arg*/
    call hex_format_offset      /* call hex_format_offset */
    movq %rsi, %rdi             /* moving offsetChar to 1st arg*/
    movq $58, 8(%rsi)           /* moving ':' to OffsetChar*/
    movq $32, 9(%rsi)           /* moving ' ' to OffsetChar*/
    movq $0, 10(%rsi)           /* moving '\0' to OffsetChar*/
    call hex_write_string       /* writing offset*/
    pushq %r13                  /* r13 will start at 0 and go to # chars read */

    popq %r13
    addq $16, %r12      /* adding 16 to offset*/
    popq %rdi
    popq %r14               /* free chars read val*/
    jmp .LmainLoop


.Lend:
    popq %rdi
    popq %r12
    addq $136, %rsp                /*restore stack pointer*/
	ret

/* vim:ft=gas:
 */
