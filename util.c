#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <ctype.h>

int to_dec_convertion(char* value) {
    int out = 0;

    if(value[0] == '0') {
        sscanf(value, "%o", &out);
    } else {
        out = atoi(value);
    }

    return out;
}

int get_str_size(char* str) {
    int size = 0;
    int flag = 0;

    for(int i = 0; i < strlen(str); i++) {

        if(flag == 0) {
            size++;

            if(str[i] == '\\') {
                flag++;
            }
        } else {
            if( flag == 1 && (str[i] == 'n' || str[i] == 't' || str[i] == '\\' || str[i] == '\'' || str[i] == '\"') ) {
                flag = 0;
            } else if(flag == 4) {
                if(str[i] == '\\') {
                    flag = 1;
                } else {
                    flag = 0;
                }

                size++;
            } else if(str[i] >= '0' && str[i] <= '7') {
                flag++;
            } else {
                if(str[i] == '\\') {
                    flag = 1;
                } else {
                    flag = 0;
                }

                size++;
            }
        }

    }

    return size - 1;
}

void to_lower_case(char* pstr) {
    for(char *p = pstr;*p;++p) *p=*p>0x40&&*p<0x5b?*p|0x60:*p;
}
