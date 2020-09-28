/* Assembly language implementation of hexdump functions */
/*
Sam Lipschitz
slipsch3@jhu.edu
*/

	.section .rodata
sHexVals: .string "0123456789abcdef"

	/* TODO: add read-only data such as strings here */

	.section .text

	/* TODO: add functions here */

	.globl hex_to_printable
hex_to_printable:
    subq $8, %rsp       /*align stack pointer*/
    cmpq $32, %rdi      /*is rdi >= 32?*/
    jl .LreturnPeriod   /*if not, return a period*/
    cmpq $126, %rdi     /*is rdi <= 126?*/
    jg .LreturnPeriod   /*if so, return a period*/
    movq %rdi, %rax     /*if it got this far, should return val in rdi*/
    addq $8, %rsp       /*restore stack pointer*/
    ret

.LreturnPeriod:
    movq $46, %rax /*returning ascii val of period*/
    addq $8, %rsp /*restore stack pointer*/
    ret

    .globl hex_format_byte_as_hex
hex_format_byte_as_hex:
    subq $8, %rsp       /*align stack pointer*/
    movq %rdi, %r8      /*moving byteval param to r8*/
    and $15,%r8         /*doing r8 & 15 (this is 2nd hex)*/
    movq %rdi, %r9      /*moving byteval param to r9*/
    shr $4, %r9          /*right shifting byteval by 4*/
    and $15,%r9         /*doing r9 & 15 (this is first hex)*/
    movq $sHexvals, %r10 /*storing sHexvals in r10*/
    movq (%r10, %r9), %r9 /*moves value of string element r9 to r9*/
    movq (%r10, %r8), %r8 /*moves value of string element r8 to r8*/
    addq $8, %rsp       /*restore stack pointer*/

    .globl hex_format_offset
hex_format_offset:


/* vim:ft=gas:
 */
