// C implementation of hexdump main function

#include "hexfuncs.h"  // this is the only header file which may be included!
#include <stdio.h> //DELETE BEFORE SUBMITTING (just using for print debugging)


int main(void) {
    char buf_string[16]; //string from std in
    char buf_offset[8]; //string of offset
    char byte_in_hex[2]; //string of hex value of char
    long offset_count = 0;
    long chars_read = 0;
    chars_read = hex_read(buf_string);
    while(chars_read > 0){ //while something is getting read in
        hex_format_offset(offset_count, buf_offset); //storing string-rep of offset_count in buf_offset
        hex_write_string(buf_offset); //printing offset
        hex_write_string(": ");
        for(int i = 0; i < 16; i++){
            if( i < chars_read){
                hex_format_byte_as_hex(buf_string[i], byte_in_hex);
                hex_write_string(byte_in_hex);
                printf("byte_in_hex: %s\n", byte_in_hex);
                hex_write_string(" ");
            } else{
                hex_write_string("   ");
            }
        }
        chars_read = hex_read(buf_string);
        offset_count+=16;
        hex_write_string("\n");
    }

}

