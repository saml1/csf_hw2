// C implementation of hexdump main function

#include "hexfuncs.h"  // this is the only header file which may be included!
#include <stdio.h> //DELETE BEFORE SUBMITTING (just using for print debugging)


int main(void) {
    char buf_string[16]; //string from std in
    char buf_offset[9]; //string of offset
    char byte_in_hex[3]; //string of hex value of char
    long offset_count = 0;
    long chars_read = 0;
    chars_read = hex_read(buf_string);//stores input in buf_string and records #bytes in chars_read;
    while(chars_read == 16 || chars_read = 0){ //while something is getting read in
        hex_format_offset(offset_count, buf_offset); //storing string-rep of offset_count in buf_offset
        hex_write_string(buf_offset); //printing offset
        hex_write_string(": ");
        for(int i = 0; i < 16; i++){
            if( i < chars_read){
                //hex_format_byte_as_hex(hex_to_printable((long) buf_string[i]), byte_in_hex);
                hex_format_byte_as_hex(buf_string[i], byte_in_hex);
                hex_write_string(byte_in_hex);
                hex_write_string(" ");
            } else{
                hex_write_string("   ");
            }
        }
        hex_write_string(" ");
        for(int i = 0; i < chars_read; i++){//***this prob has something to do with the problem of not having the period at the end-look at where you should put it
            buf_string[i] = hex_to_printable(buf_string[i]);
        }
        buf_string[chars_read] = '\0';
        hex_write_string(buf_string);
        chars_read = hex_read(buf_string);
        offset_count+=16;
        hex_write_string("\n");
        //printf("chars_read = %ld\n", chars_read);
    }

}

