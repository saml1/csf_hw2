/* Hexdump main function, assembly language version */
    .section .data
sBuf: .zero 17  /*initialize array with room for 17 chars*/
sOffset: .long, 0 /* initialize offset to 0*/

	.section .text

	.globl main
main:
    subq $136, %rsp                 /*align stack pointer*/

.LmainLoop:
    movq $sBuf, %rdi            /*moving sBuf to 1st arg reg*/
    call hex_read               /*calling hex_read*/
    movq $0, (%rdi, %rax)       /*setting null terminator to element of chars read*/
    cmp $0, %rax                /*comparing chars read to 0*/
    je .Lend                   /*jump to end if chars read = 0*/
    jmp .LmainLoop


.Lend:
    addq $136, %rsp                /*restore stack pointer*/
	ret

/* vim:ft=gas:
 */
