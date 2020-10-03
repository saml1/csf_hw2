/* Hexdump main function, assembly language version */
    .section .data
sBuf: .zero 17  /*initialize array with room for 17 chars*/

	.section .text

	.globl main
main:
    subq $136, %rsp                 /*align stack pointer*/

.LmainLoop:
    movq $sBuf, %rdi            /*moving sBuf to 1st arg reg*/
    call hex_read               /*calling hex_read*/

    movq $0, (%rdi, %rax)       /*setting null terminator to element of chars read*/
    call hex_write_string
    addq $136, %rsp                /*restore stack pointer*/

	ret

/* vim:ft=gas:
 */
