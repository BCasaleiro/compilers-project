%{
    #include <stdio.h>
%}

%%



%%

/* A função main() está do lado do lex */

void yyerror (char *s) {
    printf ("Line %d, col %d: %s: %s\n", <num linha>, <num coluna>, s, yytext);
}
