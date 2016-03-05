%{
    #include <stdio.h>
    int flag = 0;
    void print_text(char* text);
%}

/* variables */
id                  [a-z]+([a-z]*|[A-Z]*|"_"*|[0-9]*)*
intlit              [0-9]+
chrlit
strlit
ignore              ("\n"|"\t"|" ")

/* rules */
/* TODO chrlit */
/* TODO strlit */
/* TODO reserved */
%%

"&""&"              { print_text("AND"); }
"|""|"              { print_text("OR"); }
"&"                 { print_text("AMP"); }
"=""="              { print_text("EQ"); }
"="                 { print_text("ASSIGN"); }
"!"                 { print_text("NOT"); }
"!""="              { print_text("NE"); }
">"                 { print_text("GT"); }
"<"                 { print_text("LT"); }
">""="              { print_text("GE"); }
"<""="              { print_text("LE"); }
"*"                 { print_text("AST"); }
","                 { print_text("COMMA"); }
";"                 { print_text("SEMI"); }
"/"                 { print_text("DIV"); }
"{"                 { print_text("LBRACE"); }
"}"                 { print_text("RBRACE"); }
"("                 { print_text("LPAR"); }
")"                 { print_text("RPAR"); }
"["                 { print_text("LSC"); }
"]"                 { print_text("RSC"); }
"-"                 { print_text("MINUS"); }
"+"                 { print_text("PLUS"); }
"%"                 { print_text("MOD"); }
int                 { print_text("INT"); }
char                { print_text("CHAR"); }
void                { print_text("VOID"); }
if                  { print_text("IF"); }
else                { print_text("ELSE"); }
for                 { print_text("FOR"); }
return              { print_text("RETURN"); }
{id}                { print_text("ID"); }
{intlit}            { print_text("INTLIT"); }
{chrlit}            { print_text("CHRLIT"); }
{strlit}            { print_text("STRLIT"); }
{ignore}            { ; }

%%

/* simple printing function that checks for -l flag */
void print_text(char* text) {
    if (flag == 1) {
        printf("%s", text);
    }
}

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
