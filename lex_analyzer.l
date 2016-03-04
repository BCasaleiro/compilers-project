%{
    #include <stdio.h>
    int flag = 0;
%}

/* variables */

/* rules */
%%



%%
int main(int argc, char const *argv[])
{
    if (argc > 1 && strcmp(argv[1], "-l") == 0) {
        flag = 1;
    }


    yylex();
    return 0;
}

int yywrap()
{
    return 1;
}
