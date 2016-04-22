#include <stdio.h>

void to_lower_case(char* pstr) {
    for(char *p = pstr;*p;++p) *p=*p>0x40&&*p<0x5b?*p|0x60:*p;
}
