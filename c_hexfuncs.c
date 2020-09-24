// C implementation of hexdump functions

#include <unistd.h>  // this is the only system header file you may include!
#include "hexfuncs.h"

// Read up to 16 bytes from standard input into data_buf.
// Returns the number of characters read.
long hex_read(char data_buf[]){
    long num_bytes = read(STDIN_FILENO, data_buf, 16);
    return num_bytes;

}

// Write given nul-terminated string to standard output.
void hex_write_string(const char s[]){
    int size = 0;
    while(s[size] != '\0'){
        size++;
    }
    size++;
    write(STDOUT_FILENO, s, size);
}

// Format a long value as an offset string consisting of exactly 8
// hex digits.  The formatted offset is stored in sbuf, which must
// have enough room for a string of length 8.
void hex_format_offset(long offset, char sbuf[]){
    for(int i = 0; i < 8; i++){
        int digit = (offset >> 4*i)&15;
        if(digit >=0 && digit <=9){
            sbuf[7-i] = (char) digit + 48;
        }else{
            sbuf[7-i] = (char) digit + 87;
        }
        //sbuf[8] = '\0';
    }
}

// Format a byte value (in the range 0-255) as string consisting
// of two hex digits.  The string is stored in sbuf.
void hex_format_byte_as_hex(long byteval, char sbuf[]){
    for(int i = 0; i < 2; i++){
        int digit = (byteval >> 4*i)&15;
        if(digit >=0 && digit <=9){
            sbuf[1-i] = (char) digit + 48;
        }else{
            sbuf[1-i] = (char) digit + 87;
        }
        sbuf[2] = '\0';
    }
}

// Convert a byte value (in the range 0-255) to a printable character
// value.  If byteval is already a printable character, it is returned
// unmodified.  If byteval is not a printable character, then the
// ASCII code for '.' should be returned.
long hex_to_printable(long byteval){
    if(byteval >= 32 && byteval <= 126){
        return byteval;
    }else{
        return 46;
    }
}
