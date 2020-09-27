
// C implementation of hexdump main function

#include "hexfuncs.h"  // this is the only header file which may be included!
#include <stdio.h> //DELETE BEFORE SUBMITTING (just using for print debugging)


    int main(void) {
        char buf_string[17];
        char buf_string_final[17];
        long chars_read = 0;
        long chars_in_final = 0;
        char buf_offset[9]; //string of offset
        char byte_in_hex[3]; //string of hex value of char
        long offset_count = 0;

        chars_read = hex_read(buf_string); //Read chars into buf_string, store # of chars read in chars_read

        while(chars_read != 0){ //While ! eof:
            for(int i = 0; i < chars_read; i++){ //add chars from buf_string to buf_string_final and keep track of # chars with chars_in_final
                buf_string_final[i] = buf_string[i];
            }
            chars_in_final = chars_read;
            while(chars_in_final < 16){
                chars_read = hex_read(buf_string); //read input to buf_string, store in chars_read
                if(chars_in_final + chars_read >= 16){
                    for(int i = chars_in_final; i < 16; i++){//storing chars from buf_string in buf_string_final
                        buf_string_final[i] = buf_string[i-chars_in_final];
                    }
                    for(int i = 0; i < chars_read+chars_in_final-16; i++){//moving unused chars to front
                        buf_string[i] = buf_string[16-chars_in_final+i];
                    }
                    chars_read = chars_read+chars_in_final-16; //amount of chars "left over"
                    buf_string[chars_read] = '\0';
                    chars_in_final = 16;
                }else{ //if still added up won't get to 16
                    for(int i = 0; i < chars_read; i++){
                        buf_string_final[chars_in_final + i] = buf_string[i];
                    }
                    chars_in_final += chars_read;
                }
            }

            hex_format_offset(offset_count, buf_offset); //storing string-rep of offset_count in buf_offset
            hex_write_string(buf_offset); //printing offset
            hex_write_string(": ");

            for(int i = 0; i < 16; i++){ //printing hex vals of buf_string_final
                hex_format_byte_as_hex(buf_string_final[i], byte_in_hex);
                hex_write_string(byte_in_hex);
                hex_write_string(" ");
                buf_string_final[i] = hex_to_printable(buf_string_final[i]);
            }
            buf_string_final[16] = '\0';
            hex_write_string(" ");
            hex_write_string(buf_string_final);
            hex_write_string("\n");
            offset_count+=16;
            chars_read = hex_read(buf_string);
        }
    }


