#include <stdio.h>
#include <stdlib.h>

int to_dec_convertion(char* value) {
    int out = 0;

    if(value[0] == '0') {
        sscanf(value, "%o", &out);
    } else {
        out = atoi(value);
    }

    return out;
}

void to_lower_case(char* pstr) {
    for(char *p = pstr;*p;++p) *p=*p>0x40&&*p<0x5b?*p|0x60:*p;
}
