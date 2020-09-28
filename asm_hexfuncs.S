/* Assembly language implementation of hexdump functions */
/*
Sam Lipschitz
slipsch3@jhu.edu
*/

	.section .rodata
sHexVals: "0123456789abcdef"

	/* TODO: add read-only data such as strings here */

	.section .text

	/* TODO: add functions here */

	.globl hex_to_printable
hex_to_printable:
    subq $8, %rsp       /*align stack pointer*/
    cmpq $32, %rdi /*is rdi >= 32?*/
    jl .LreturnPeriod /*if not, return a period*/
    cmpq $126, %rdi /*is rdi <= 126?*/
    jg .LreturnPeriod /*if so, return a period*/
    movq %rdi, %rax /*if it got this far, should return val in rdi*/
    addq $8, %rsp /*restore stack pointer*/
    ret

.LreturnPeriod:
    movq $46, %rax /*returning ascii val of period*/
    addq $8, %rsp /*restore stack pointer*/
    ret

    .globl hex_format_byte_as_hex
hex_format_byte_as_hex:


/* vim:ft=gas:
 */
