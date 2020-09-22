// C implementation of hexdump main function

#include "hexfuncs.h"  // this is the only header file which may be included!
#include <stdlib.h> //REMOVE THIS (ONLY FOR TESTING)


int main(void) {
    char * test = (char *) malloc(4*sizeof(char));
    long a = hex_read(test);
    hex_write_string(test);
   

}

