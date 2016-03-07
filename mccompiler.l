%{
    #define YY_USER_ACTION columnNumber += yyleng;

    #include <stdio.h>

    int flag = 0;
    int lineNumber = 1;
    int columnNumber = 1;
    int colComment;
    int lineComment;

    void print_text(char* text);
    void print_with_content(char* text, char* content);
%}

%option yylineno
%X COMMENT

/* variables */
id                  ([a-z]|[A-Z]|"_")+([a-z]|[A-Z]|"_"|[0-9])*
intlit              [0-9]+
valid_stuff         ([^\n\'\\]|\\n|\\t|"\""|"\'"|"\\"|\\([0-7]{1,3}))
chrlit              \'{valid_stuff}\'
unterminated_chr    (\'[^\n\']*)|(\'\\\')
invalid_chr         \'([^\n\'\\]|\\.)*\'
strlit              \"{valid_stuff}*\"
unterminated_str    (\"([^\n\"]|\\n|\\t|\\\\|\\\'|\\\"|\\([0-7]{1,3}))*)|(\"\\\")
invalid_str         \"([^\n\"]|\\.)*\"
ignore              ("\n"|"\t"|" ")
reserved            ("--"|"++"|auto|break|case|const|continue|default|do|double|enum|extern|float|goto|long|register|short|signed|sizeof|static|struct|switch|typedef|union|unsigned|volatile|while)

/* rules */
%%

"/*"                                { BEGIN (COMMENT); { colComment = columnNumber - 2; } lineComment = yylineno; }
<COMMENT>"*/"                       { BEGIN (0); }
<COMMENT>"\n"                       { columnNumber = 0; }
<COMMENT>.                          { ; }
<COMMENT><<EOF>>                    { printf("Line %d, col %d: unterminated comment\n", lineComment,  colComment); yyterminate(); }

"\n"                { columnNumber = 1; }

{reserved}          { print_with_content("RESERVED", yytext); }

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
{unterminated_chr}  { printf("Line %d, col %d: unterminated char constant\n", yylineno, (int)(columnNumber-yyleng)); }
{invalid_chr}       { printf("Line %d, col %d: invalid char constant (%s)\n", yylineno, (int)(columnNumber-yyleng), yytext); }
{strlit}            { print_with_content("STRLIT", yytext); }
{unterminated_str}  { printf("Line %d, col %d: unterminated string constant\n", yylineno, (int)(columnNumber-yyleng)); }
{invalid_str}       { printf("Line %d, col %d: invalid string constant (%s)\n", yylineno, (int)(columnNumber-yyleng), yytext); }
{ignore}            { ; }
.                   { printf("Line %d, col %d: illegal character (%s)\n", yylineno, (int)(columnNumber-yyleng), yytext); }

%%

/* simple printing function that checks for -l flag */
void print_text(char* text) {
    if (flag == 1) {
        printf("%s\n", text);
    }
}

/* printing function that checks for -l flag */
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
