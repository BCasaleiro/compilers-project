%{
    #include <stdio.h>
    int flag = 0;
    void print_text(char* text);
    void print_with_content(char* text, char* content);
%}

/* variables */
id                  ([a-z]|[A-Z]|"_")+([a-z]|[A-Z]|"_"|[0-9])*
intlit              [0-9]+
valid_stuff         ([^\n\'\\]|\\n|\\t|"\""|"\'"|"\\"|\\([0-7]{1,3}))
chrlit              \'{valid_stuff}\'
unterminated_chr    (\'[^\n\']*)|(\'\\\')
invalid_chr         \'([^\n\'\\]|\\.)*\'
strlit              \"{valid_stuff}*\"
unterminated_str    (\"([^\n\"]|\\n|\\t|\\\\|\\\'|\\\"|\\([0-7]{1,3}))*)|(\"\\\")
invalid_str         (\"([^\n\"]|\\.)*\")
ignore              ("\n"|"\t"|" "|"/*"[^"*/"]*"*/")
reserved            ("-""-"|"+""+"|"|"|"^"|"~"|"<""<"|">"">"|"+""="|"-""="|"*""="|"/""="|"%""="|">"">""="|"<""<""="|"&""="|"^""="|"|""="|auto|break|case|const|continue|default|do|double|enum|extern|float|goto|long|register|short|signed|sizeof|static|struct|switch|typedef|union|unsigned|volatile|while)

/* rules */
%%

"&&"                { print_text("AND"); }
"||"                { print_text("OR"); }
"&"                 { print_text("AMP"); }
"=="                { print_text("EQ"); }
"="                 { print_text("ASSIGN"); }
"!"                 { print_text("NOT"); }
"!="                { print_text("NE"); }
">"                 { print_text("GT"); }
"<"                 { print_text("LT"); }
">="                { print_text("GE"); }
"<="                { print_text("LE"); }
","                 { print_text("COMMA"); }
";"                 { print_text("SEMI"); }
"{"                 { print_text("LBRACE"); }
"}"                 { print_text("RBRACE"); }
"("                 { print_text("LPAR"); }
")"                 { print_text("RPAR"); }
"["                 { print_text("LSQ"); }
"]"                 { print_text("RSQ"); }
"+"                 { print_text("PLUS"); }
"-"                 { print_text("MINUS"); }
"*"                 { print_text("AST"); }
"/"                 { print_text("DIV"); }
"%"                 { print_text("MOD"); }
int                 { print_text("INT"); }
char                { print_text("CHAR"); }
void                { print_text("VOID"); }
if                  { print_text("IF"); }
else                { print_text("ELSE"); }
for                 { print_text("FOR"); }
return              { print_text("RETURN"); }
{id}                { print_with_content("ID", yytext); }
{intlit}            { print_with_content("INTLIT", yytext); }
{chrlit}            { print_with_content("CHRLIT", yytext); }
{strlit}            { print_with_content("STRLIT", yytext); }
{reserved}          { print_with_content("RESERVED", yytext); }
{ignore}            { ; }
.                   { ; }

%%

/* simple printing function that checks for -l flag */
void print_text(char* text) {
    if (flag == 1) {
        printf("%s\n", text);
    }
}

void print_with_content(char* text, char* content) {
    if (flag == 1) {
        printf("%s(%s)\n", text, content);
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
