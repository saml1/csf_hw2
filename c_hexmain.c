
// C implementation of hexdump main function
//Sam Lipschitz
//slipsch3@jhu.edu
#include "hexfuncs.h"  // this is the only header file which may be included!
//#include <stdio.h> //DELETE BEFORE SUBMITTING (just using for print debugging)

int main(void) {
    char buf[17];
    char buf_orig[17];
    char offset_char[9];
    char byte_in_hex[3];
    long chars_read;
    long offset = 0L;

    while(1==1){
        chars_read = hex_read(buf);
        buf[16] = '\0';
        if(chars_read == 0){
            break;
        }

        hex_format_offset(offset, offset_char);
        hex_write_string(offset_char);
        hex_write_string(": ");

        for(int i = 0; i < chars_read; i++){
            buf_orig[i] = hex_to_printable(buf[i]);
            hex_format_byte_as_hex(buf[i], byte_in_hex);
            hex_write_string(byte_in_hex);
            hex_write_string(" ");
        }

        if(chars_read < 16){
            for(int i = 0; i < 16-chars_read; i++){
                hex_write_string("   ");
            }
            buf_orig[chars_read] = '\0';
        }

        buf_orig[16] = '\0';
        hex_write_string(" ");
        hex_write_string(buf_orig);
        offset += 16;
        hex_write_string("\n");
    }

    return 1;
}
