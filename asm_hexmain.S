/* Hexdump main function, assembly language version */

	.section .text

	.globl main
main:
    subq $24, %rsp                 /*align stack pointer*/

.LmainLoop:
    call hex_read               /*calling hex_read*/
    movq %rax, %rdi             /*moving return string from hex_read to 1st arg for next call*/
    call hex_write_string
    addq $24, %rsp                /*restore stack pointer*/

	ret

/* vim:ft=gas:
 */
