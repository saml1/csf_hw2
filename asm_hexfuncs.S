/* Assembly language implementation of hexdump functions */
/*
Sam Lipschitz
slipsch3@jhu.edu
*/

	.section .rodata

sHexVals: .string "0123456789abcdef"

	.section .text

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
    AND $0xF,%r9         /*doing r9 & 15 (this is first hex)*/
    movq $sHexVals, %r10 /*storing sHexvals in r10*/
    movb (%r10, %r9), %r9b /*moves value of string element r9 to r9*/
    movb (%r10, %r8), %r8b /*moves value of string element r8 to r8*/
    movb %r9b, 0(%rsi) /*moving 1st hex val to 2nd arg param*/
    movb %r8b, 1(%rsi) /*moving 2nd hex val to 2nd arg param +1*/
    movb $0, 2(%rsi) /*moving null terminator hex val to 2nd arg param +2*/
    addq $8, %rsp       /*restore stack pointer*/
    ret

    .globl hex_format_offset
hex_format_offset:
    subq $8, %rsp                 /*align stack pointer*/
    movb $0, %r9b                    /*starting at 0, going to 7, r9 is index of sbuf*/
    movq $sHexVals, %r10            /*storing sHexvals in r10*/

.LbeginForLoop:
    movq %rdi, %r8                /*moving offset param to r8*/
    cmp $8, %r9b                  /*comparing 8 to the current index*/
    jl .LaddChar                 /* if r9b < 8, jump to .LaddChar*/
    movb $0, 8(%rsi)            /*moving null terminator hex val to 2nd arg param +8*/
    addq $8, %rsp                /*restore stack pointer*/
    ret

.LaddChar:
    movb %r9b, %al                /*moving i to byte 0 of rax*/
    imul $4, %rax                 /* multiplying i by 4*/
    movb %al, %cl               /* because shr only works with cl as size*/
    shr %cl, %r8                 /*right shifting offset by i*4*/
    and $15, %r8                /*doing offset & 15 (this is now the digit) */
    movb (%r10, %r8), %r8b       /*moving digit val of string to r8b*/
    /*this is lines ive added*/
    movq $7, %r11            /*storing $7 in r11*/
    sub %r9b, %r11b             /* making r11 = 7 - i*/
    /*end newly added lines*/
    movb %r8b, (%rsi, %r11)     /*moving digit val to 2nd param+i */
    inc %r9b                         /*doing i++*/
    jmp .LbeginForLoop          /*go to beginning of for loop */

    .globl hex_read
hex_read:
    subq $24, %rsp                 /*align stack pointer*/
    movq %rdi, %rsi                 /* rdi is data_buf, want it in 2nd param (rsi) when syscall executes*/
    movq $0, %rdi                  /* 0 is STDIN, rdi is first param of read*/
    movq $16, %rdx                  /* rdx is 3rd param (for read is # bytes)*/
    movq $0, %rax                 /* read is system call number 0 */
    syscall                         /* execute system call */
    addq $24, %rsp                /*restore stack pointer*/
    ret

    .globl hex_write_string
hex_write_string:
    subq $8, %rsp                 /*align stack pointer*/
    movq $0, %r8                   /* this will be index*/
.LcompareToZero:
    cmp $0, (%rdi, %r8b)             /* comparing 0 ('\0') to char at index of r8*/
    jne .LincUp                     /* if not null terminator, increment r8*/
    movq %r8, %rdx                  /* r8 is # chars before '\0', this goes in 3rd arg*/
    movq %rdi, %rsi                 /* rdi is char, must be in 2nd arg*/
    movq $1, %rdi                 /* 1st arg to write is file desc */
    movq $1, %rax                 /* write is system call 1 */
    syscall                       /* execute the system call! */
    addq $8, %rsp                /*restore stack pointer*/
    ret

.LincUp:
    inc %r8
    jmp .LcompareToZero



/* vim:ft=gas:
 */
