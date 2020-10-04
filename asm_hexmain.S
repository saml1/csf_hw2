/* Hexdump main function, assembly language version */
    .section .data
sBuf: .zero 17  /*initialize array with room for 17 chars*/
sBufPrint: .zero 17 /*array with room for 17 chars, will store printable chars */
sByteChar: .zero 3 /*array with room for 3 chars, this is hex rep of long val */

sOffsetChar: .zero 11 /* char for offset*/

	.section .text

	.globl main
main:
    subq $136, %rsp                 /*align stack pointer*/
    pushq %r12                      /* this is not mentioned in stack comments bc it doesn't get popped til very end */
    movq $0, %r12               /* this is long offset*/

.LmainLoop:
    movq $sBuf, %rdi            /*moving sBuf to 1st arg reg*/
    call hex_read               /*calling hex_read*/
    movq $0, (%rdi, %rax)       /*setting null terminator to element of chars read*/
    pushq %r14                  /* r14 will be chars read*/
    movq %rax, %r14
    pushq %rdi                  /* storing buf in stack*/
    cmp $0, %rax                /*comparing chars read to 0*/
    je .Lend                   /*jump to end if chars read = 0*/
    movq %r12, %rdi          /* moving offset to rdi, 1st arg*/
    movq $sOffsetChar, %rsi      /* moving offset char to rsi, 2nd arg*/
    call hex_format_offset      /* call hex_format_offset */
    movq %rsi, %rdi             /* moving offsetChar to 1st arg*/
    movq $58, 8(%rsi)           /* moving ':' to OffsetChar*/
    movq $32, 9(%rsi)           /* moving ' ' to OffsetChar*/
    movq $0, 10(%rsi)           /* moving '\0' to OffsetChar*/
    call hex_write_string       /* writing offset*/
    popq %rdi                    /* rdi is sBuf, r14 is at top of stack*/
    pushq %r13                  /* r13 will start at 0 and go to # chars read, r13 is on top of stack (above r14) */
    movq $0, %r13
.LprintHexTop:
    cmp %r14,%r13               /* seeing if index < chars read*/
    jl .LprintHex               /* if so, jump to .LprintHex */

    call hex_write_string
    addq $16, %r12      /* adding 16 to offset*/

    popq %r13
    popq %r14

    jmp .LmainLoop

.LprintHex:
    pushq %r15                      /* now r15 is on top of stack, above r13, which is above r14 */
    movq $sBufPrint, %r15       /* sBufPrint is now in r15 */
    movq %rdi, %r8              /* moving sBuf to r8 */
    /*call hex_write_string*/ /* just print debugging - delete */
    /*movq $0, %rdi/ /*testing soething out- delete (changed next line from rdi to dil */
    movb (%r8, %r13), %dil  /* this causes it to segfault so i attempted to replace this line w the following line*/
    /*movb (%r8, %r13), 0(%rdi)*/     /*moving sBuf element r13 to rdi (may be incorrect syntax?)*/
    call hex_to_printable       /*this will put printable val in %rax*/
    movq %rax, (%r15, %r13)     /* putting the printable val in element r13 of sBufPrint */
    movq (%r8, %r13), %rdi      /* moving sBuf element r13 to rdi */
    movq $sByteChar, %rsi       /* moving hex char to rsi */
    pushq %r8                   /* now r8 is on top of stack, above r15, r13, r14 */
    call hex_format_byte_as_hex /* this will put hex rep of sBuf element r13 in %rsi */
    /*popq %r8*/                     /* attempting to move this down now sBuf is in r8 and stack is r15 on top, above r13, then r14 */
    movq %rsi, %rdi             /* putting hex rep in 1st arg */
    call hex_write_string /* TODO: make it write spaces between hexes */
    inc %r13
    popq %r8
    popq %r15                   /* now r13 on top of stack, above r14 */
    movq %r8, %rdi          /*also this is wrong- r8 doesn't have sbuf- trace code push and popsthis was done at night so could be bad, but i think is moving sBuf back to rdi*/
    jmp .LprintHexTop

.Lend:
    popq %rdi
    popq %r14 /* just added this*/
    popq %r12
    addq $136, %rsp                /*restore stack pointer*/
	ret

/* vim:ft=gas:
 */
