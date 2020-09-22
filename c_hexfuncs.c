// C implementation of hexdump functions

#include <unistd.h>  // this is the only system header file you may include!
#include "hexfuncs.h"

// Read up to 16 bytes from standard input into data_buf.
// Returns the number of characters read.
long hex_read(char data_buf[]){
    long num_bytes = read(0, data_buf, 16);
    return num_bytes;

}

// Write given nul-terminated string to standard output.
void hex_write_string(const char s[]){
    write(0, s, 16);
}

// Format a long value as an offset string consisting of exactly 8
// hex digits.  The formatted offset is stored in sbuf, which must
// have enough room for a string of length 8.
void hex_format_offset(long offset, char sbuf[]){

}

// Format a byte value (in the range 0-255) as string consisting
// of two hex digits.  The string is stored in sbuf.
void hex_format_byte_as_hex(long byteval, char sbuf[]){

}

// Convert a byte value (in the range 0-255) to a printable character
// value.  If byteval is already a printable character, it is returned
// unmodified.  If byteval is not a printable character, then the
// ASCII code for '.' should be returned.
long hex_to_printable(long byteval){
    long a = 1;
    return a;
}
