
// C implementation of hexdump main function

#include "hexfuncs.h"  // this is the only header file which may be included!
#include <stdio.h> //DELETE BEFORE SUBMITTING (just using for print debugging)


    int main(void) {
        char buf_string[17];
        char buf_string_final[17];
        long chars_read = 0;
        long chars_in_final = 0;

        chars_read = hex_read(buf_string); //Read chars into buf_string, store # of chars read in chars_read

        while(chars_read != 0){ //While ! eof:
            for(int i = 0; i < chars_read; i++){ //add chars from buf_string to buf_string_final and keep track of # chars with chars_in_final
                buf_string_final[i] = buf_string[i];
            }
            chars_in_final = chars_read;
            while(chars_in_final < 16){
                chars_read = hex_read(buf_string); //read input to buf_string, store in chars_read
                if(chars_in_final + chars_read >= 16){
                    for(int i = chars_in_final; i < 16; i++){
                        buf_string_final[i] = buf_string[i-chars_in_final];
                    }
                    printf("1buf_string_final: %s\n", buf_string_final);
                    printf("1buf_string: %s\n", buf_string);
                    printf("1chars_read: %ld\n", chars_read);
                    printf("1chars_in_final: %ld\n", chars_in_final);
                    for(int i = 0; i < chars_read+chars_in_final-16; i++){//moving unused chars to front
                        buf_string[i] = buf_string[16-chars_in_final+i];
                    }
                    chars_read = chars_read+chars_in_final-16; //amount of chars "left over"
                    buf_string[chars_read] = '\0';
                    chars_in_final = 16;
                }
            }
            printf("buf_string_final: %s\n", buf_string_final);
            printf("buf_string: %s\n", buf_string);
            printf("chars_read: %ld\n", chars_read);
            printf("chars_in_final: %ld\n", chars_in_final);
        }
    }


