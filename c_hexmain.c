// C implementation of hexdump main function

#include "hexfuncs.h"  // this is the only header file which may be included!
#include <stdio.h> //DELETE BEFORE SUBMITTING (just using for print debugging)


int main(void) {
    char buf_string[17]; //string from std in
    char buf_string_next[16];
    char buf_string_final[17]; //string from std in
    char buf_offset[9]; //string of offset
    char byte_in_hex[3]; //string of hex value of char
    long offset_count = 0;
    long chars_read = 0;
    long chars_read_next = 0;
    long chars_read_total = 0;
    int overflow_element = 0;
    chars_read = hex_read(buf_string_final); //stores input in buf_string and records #bytes in chars_read;
    while(chars_read != 0){
        chars_read_total = chars_read + chars_read_next - overflow_element;//taking into account overflow
        //if(overflow_element != 0){ //not on first loop
            for(int i = overflow_element; i < chars_read_next; i++){//storing prev overflow vals
                buf_string_final[i-overflow_element] = buf_string_next[i];
            }
            for(int i = overflow_element; i < chars_read_next; i++){//storing new chars in buf_string_final
                buf_string_final[i] = buf_string[i-overflow_element];
            }
        //}
        while(chars_read_total < 16){ //keeps reading input until it gets to 16 chars
            chars_read_next = hex_read(buf_string_next); //stores input in buf_string_next
            chars_read_total += chars_read_next;
            for(int i = 0; i < chars_read_next; i++){
                if(i+chars_read > 15){
                    overflow_element = i;
                    break;
                }
                buf_string_final[i+chars_read] = buf_string_next[i]; //copying contents from buf_string_next to buf_string
            }
            //TODO: deal with elements in chars_read_next starting with overflow_element
        }
        hex_format_offset(offset_count, buf_offset); //storing string-rep of offset_count in buf_offset
        hex_write_string(buf_offset); //printing offset
        hex_write_string(": ");
        for(int i = 0; i < 16; i++){ //printing hex vals of buf_string
            if(i < chars_read_total){
                hex_format_byte_as_hex(buf_string_final[i], byte_in_hex);
                hex_write_string(byte_in_hex);
                hex_write_string(" ");
            }else{
                hex_write_string("   ");
            }
        }
        hex_write_string(" ");
        for(int i = 0; i < 16; i++){//making all vals good for printing
            buf_string_final[i] = hex_to_printable(buf_string_final[i]);
        }
        buf_string_final[16] = '\0';
        hex_write_string(buf_string_final);
        offset_count+=16;
        hex_write_string("\n");
        chars_read = hex_read(buf_string);
    }
}

