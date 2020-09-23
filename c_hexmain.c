// C implementation of hexdump main function

#include "hexfuncs.h"  // this is the only header file which may be included!


int main(void) {
    char [16] buf_string; //string from std in
    char [8] buf_offset; //string of offset
    long offset_count = 0;
    while(hex_read(buf_string) > 0){ //while something is getting read in
        hex_format_offset(offset_count, buf_offset);
        hex_write_string(buf_offset);
    }

}

