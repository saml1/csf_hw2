/*
Sam Lipschitz
slipsch3@jhu.edu
*/

/* Hexdump main function, assembly language version */
    .section .data
sBuf: .zero 17  /*initialize array with room for 17 chars*/
sBufPrint: .zero 17 /*array with room for 17 chars, will store printable chars */
sByteChar: .zero 3 /*array with room for 3 chars, this is hex rep of long val */
sSpace: .zero 2 /* char array with space (or newline) then null ter*/

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
    pushq %r11
    cmp $16, %r14           /* comparing chars read to 16*/
    jl .LprintExtraSpaces       /* jump if chars read < 16 */
.LprintsBufPrint:
    /*pushq %r11*/                  /* preserving sBufPrint*/
    movq $sSpace, %rdi
    movb $32, 0(%rdi)         /* putting space char in rdi*/
    movb $0, 1(%rdi)         /* putting null ter in rdi+1*/
    call hex_write_string /* printing space */
    /*movq $0, %rdi*/
    popq %r11           /* sBufprint is now back in r11 */
    movq %r11, %rdi         /* moving sBufPrint to rdi*/
    call hex_write_string /* printing sBufPrint*/
    addq $16, %r12      /* adding 16 to offset*/
    movq $sSpace, %rdi
    movb $10, 0(%rdi)         /* putting newline in rdi*/
    movb $0, 1(%rdi)         /* putting null ter in rdi+1*/
    call hex_write_string /* printing newline */
    popq %r13
    popq %r14

    jmp .LmainLoop

.LprintHex:
    pushq %r15                      /* now r15 is on top of stack, above r13, which is above r14 */
    movq $sBufPrint, %r15       /* sBufPrint is now in r15 */
    movq %rdi, %r8              /* moving sBuf to r8 */
    movq $0, %rdi
    movb (%r8, %r13), %dil  /* moving sbuf element r13 to rdi*/
    call hex_to_printable       /*this will put printable val in %rax*/
    movq %rax, (%r15, %r13)     /* putting the printable val in element r13 of sBufPrint */
    movq (%r8, %r13), %rdi      /* moving sBuf element r13 to rdi */
    movq $sByteChar, %rsi       /* moving hex char to rsi */
    pushq %r8                   /* now r8 is on top of stack, above r15, r13, r14 */
    call hex_format_byte_as_hex /* this will put hex rep of sBuf element r13 in %rsi */
    movq %rsi, %rdi             /* putting hex rep in 1st arg */
    call hex_write_string /* printing individual hex rep*/
    movq $sSpace, %rdi
    movb $32, 0(%rdi)         /* putting space char in rdi*/
    movb $0, 1(%rdi)         /* putting null ter in rdi+1*/
    call hex_write_string /* printing space */
    inc %r13                /*increasing r8 (element) for next iteration*/
    popq %r8                /* r8 is now sBuf */
    movq %r15, %r11         /* storing sBufPrint in r11*/
    popq %r15                   /* now r13 on top of stack, above r14 */
    movq %r8, %rdi          /*moving sBuf back to rdi for next iteration*/

    jmp .LprintHexTop

.LprintExtraSpaces:
    pushq %r12 /* this will be total # jumps to .Lprint3Spaces*/
    movq $16, %r12
    subq %r14, %r12
.LprintExtraSpacesLoop:
    cmp $0, %r12 /* comparing 0 to r12 (#jumps)*/
    jne .Lprint3Spaces  /* jump if r12!=$0 */
    popq %r12 /* restoring r12 */
    jmp .LprintsBufPrint /* going back to top to print sBufPrint, finishing off the line */


.Lprint3Spaces:
    pushq %rdi              /* preserving rdi*/
    movq $sSpace, %rdi
    movb $32, 0(%rdi)         /* putting space char in rdi*/
    movb $0, 1(%rdi)         /* putting null ter in rdi+1*/
    call hex_write_string   /* printing space */
    movq $sSpace, %rdi
    movb $32, 0(%rdi)         /* putting space char in rdi*/
    movb $0, 1(%rdi)         /* putting null ter in rdi+1*/
    call hex_write_string   /* printing space */
    movq $sSpace, %rdi
    movb $32, 0(%rdi)         /* putting space char in rdi*/
    movb $0, 1(%rdi)         /* putting null ter in rdi+1*/
    call hex_write_string   /* printing space */
    popq %rdi               /* restoring rdi */
    dec %r12
    jmp .LprintExtraSpacesLoop

.Lend:
    popq %rdi
    popq %r14 /* just added this*/
    popq %r12
    addq $136, %rsp                /*restore stack pointer*/
	ret

/* vim:ft=gas:
 */
