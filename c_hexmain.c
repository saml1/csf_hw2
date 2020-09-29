
// C implementation of hexdump main function
//Sam Lipschitz
//slipsch3@jhu.edu
#include "hexfuncs.h"  // this is the only header file which may be included!
#include <stdio.h> //DELETE BEFORE SUBMITTING (just using for print debugging)

    void writeFinalDump(long numChars, char buf[], long offset_count, char buf_offset[], char byte_in_hex[]){
        buf[numChars] = '\0';
        hex_format_offset(offset_count, buf_offset); //storing string-rep of offset_count in buf_offset
        hex_write_string(buf_offset); //printing offset
        hex_write_string(": ");
        for(int i = 0; i < 16; i++){
            if(i < numChars){
                hex_format_byte_as_hex(buf[i], byte_in_hex);
                hex_write_string(byte_in_hex);
                hex_write_string(" ");
                buf[i] = hex_to_printable(buf[i]);
            }else{
                hex_write_string("   ");
            }
        }
        hex_write_string(" ");
        hex_write_string(buf);
        hex_write_string("\n");
    }

    int main(void) {
        char buf_string[17];
        char buf_string_final[17];
        long chars_read = 0;
        long chars_in_final = 0;
        char buf_offset[9]; //string of offset
        char byte_in_hex[3]; //string of hex value of char
        long offset_count = 0;
        int chars_left_over = -1;

        chars_read = hex_read(buf_string); //Read chars into buf_string, store # of chars read in chars_read
        if(chars_read == 0){
            return 1;
        }
        //buf_string[chars_read] = '\0';

        while(chars_read > 0){ //While ! eof:
            for(int i = 0; i < chars_read; i++){ //add chars from buf_string to buf_string_final and keep track of # chars with chars_in_final
                if(chars_in_final != 16){
                    buf_string_final[i+chars_in_final] = buf_string[i];
                }else{
                    buf_string_final[i] = buf_string[i];
                }
            }
            chars_in_final = chars_read;
            while(chars_in_final < 16){
                chars_read = hex_read(buf_string); //read input to buf_string, store in chars_read
                //buf_string[chars_read] = '\0';
                if(chars_read == 0){
                    break;
                }
                if(chars_in_final + chars_read >= 16){
                    for(int i = chars_in_final; i < 16; i++){//storing chars from buf_string in buf_string_final
                        buf_string_final[i] = buf_string[i-chars_in_final];
                    }
                    for(int i = 0; i < chars_read+chars_in_final-16; i++){//moving unused chars to front
                        buf_string[i] = buf_string[16-chars_in_final+i];
                    }
                    if(chars_in_final + chars_read > 16){//must keep track of overflow elements
                        chars_left_over = chars_read+chars_in_final - 16;
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
            if(chars_read == 0){
                break;
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
            if(chars_left_over != -1){ //must save buf_string somehow!
                chars_in_final = chars_left_over;
                for(int i = 0; i < chars_left_over; i++){
                    buf_string_final[i] = buf_string[i];
                }
                chars_left_over = -1;//set up for next loop
            }
            chars_read = hex_read(buf_string);
            if(chars_read == 0 && chars_in_final == 16){
                printf("buf_string_final: %s\n", buf_string_final);
                printf("buf_string: %s\n", buf_string);
                printf("chars_read: %ld\n", chars_read);
                printf("chars_in_final: %ld\n", chars_in_final);
                return 0;
                break;
            }
            /*printf("buf_string_final: %s\n", buf_string_final);
            printf("buf_string: %s\n", buf_string);
            printf("chars_read: %ld\n", chars_read);
            printf("chars_in_final: %ld\n", chars_in_final);*/
        }
        if(chars_in_final != 16 || (chars_in_final == 16 && chars_read == 0)){
            writeFinalDump(chars_in_final, buf_string_final, offset_count, buf_offset,byte_in_hex);
        }else{
            int size = 0;
            while(buf_string[size] != '\0'){
                size++;
            }
            //size++;
            //printf("size: %d\n", size);
            writeFinalDump(size, buf_string, offset_count, buf_offset,byte_in_hex);
        }
        /*printf("buf_string_final: %s\n", buf_string_final);
        printf("buf_string: %s\n", buf_string);
        printf("chars_read: %ld\n", chars_read);
        printf("chars_in_final: %ld\n", chars_in_final);*/

    }


