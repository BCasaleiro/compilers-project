%{
    #define YY_USER_ACTION columnNumber += yyleng;

    #include <stdio.h>
    #include <stdlib.h>
    #include <string.h>
    #include "y.tab.h"

    int flag = 0;
    int lineNumber = 1;
    int columnNumber = 1;
    int colComment;
    int lineComment;

    void print_text(char* text);
    void print_with_content(char* text, char* content);
    void print_unterminated_error(char* error, int line, int col);
    void print_invalid_error(char* error, int line, int col, char* token);
%}

%option yylineno
%X COMMENT

/* variables */
id                  ([a-z]|[A-Z]|"_")+([a-z]|[A-Z]|"_"|[0-9])*
intlit              [0-9]+

valid_stuff         \\n|\\t|\\\\|\\\'|\\\"|(\\([0-7]{1,3}))
invalid_stuff       \\.|\\[8-9]{1,3}

valid_chr           ([^\n\'\\]|{valid_stuff})
inval_chr           ([^'\n\\]|{invalid_stuff})

chrlit              \'{valid_chr}\'
invalid_chr         \'{inval_chr}*\'
unterminated_chr    \'({valid_stuff}*|(\\.|[^'\n\\]))*\\?

valid_str           ([^\n\"\\]|{valid_stuff})
inval_str           ([^"\n\\]|{invalid_stuff})

strlit              \"{valid_str}*\"
invalid_str         \"{inval_str}*\"
unterminated_str    \"([^\"\n]|{valid_stuff})*

ignore              ("\n"|"\t"|" ")
reserved            ("--"|"++"|auto|break|case|const|continue|default|do|double|enum|extern|float|goto|long|register|short|signed|sizeof|static|struct|switch|typedef|union|unsigned|volatile|while)

/* rules */
%%

"/*"                { BEGIN (COMMENT); { colComment = columnNumber - 2; } lineComment = yylineno; }
<COMMENT>"*/"       { BEGIN (0); }
<COMMENT>"\n"       { columnNumber = 0; }
<COMMENT>.          { ; }
<COMMENT><<EOF>>    { printf("Line %d, col %d: unterminated comment\n", lineComment,  colComment); yyterminate(); }

"\n"                { columnNumber = 1; }

{reserved}          { print_with_content("RESERVED", yytext); }

"&&"                { print_text("AND");    if(flag == 0) {return AND;} }
"||"                { print_text("OR");     if(flag == 0) {return OR;} }
"&"                 { print_text("AMP");    if(flag == 0) {return AMP;} }
"=="                { print_text("EQ");     if(flag == 0) {return EQ;} }
"="                 { print_text("ASSIGN"); if(flag == 0) {return ASSIGN;} }
"!"                 { print_text("NOT");    if(flag == 0) {return NOT;} }
"!="                { print_text("NE");     if(flag == 0) {return NE;} }
">"                 { print_text("GT");     if(flag == 0) {return GT;} }
"<"                 { print_text("LT");     if(flag == 0) {return LT;} }
">="                { print_text("GE");     if(flag == 0) {return GE;} }
"<="                { print_text("LE");     if(flag == 0) {return LE;} }
","                 { print_text("COMMA");  if(flag == 0) {return COMMA;} }
";"                 { print_text("SEMI");   if(flag == 0) {return SEMI;} }
"{"                 { print_text("LBRACE"); if(flag == 0) {return LBRACE;} }
"}"                 { print_text("RBRACE"); if(flag == 0) {return RBRACE;} }
"("                 { print_text("LPAR");   if(flag == 0) {return LPAR;} }
")"                 { print_text("RPAR");   if(flag == 0) {return RPAR;} }
"["                 { print_text("LSQ");    if(flag == 0) {return LSQ;} }
"]"                 { print_text("RSQ");    if(flag == 0) {return RSQ;} }
"+"                 { print_text("PLUS");   if(flag == 0) {return PLUS;} }
"-"                 { print_text("MINUS");  if(flag == 0) {return MINUS;} }
"*"                 { print_text("AST");    if(flag == 0) {return AST;} }
"/"                 { print_text("DIV");    if(flag == 0) {return DIV;} }
"%"                 { print_text("MOD");    if(flag == 0) {return MOD;} }
int                 { print_text("INT");    if(flag == 0) {return INT;} }
char                { print_text("CHAR");   if(flag == 0) {return CHAR;} }
void                { print_text("VOID");   if(flag == 0) {return VOID;} }
if                  { print_text("IF");     if(flag == 0) {return IF;} }
else                { print_text("ELSE");   if(flag == 0) {return ELSE;} }
for                 { print_text("FOR");    if(flag == 0) {return FOR;} }
return              { print_text("RETURN"); if(flag == 0) {return RETURN;} }
{id}                { print_with_content("ID", yytext);         strcpy(yylval.id, yytext);      if(flag == 0) {return ID;} }
{intlit}            { print_with_content("INTLIT", yytext);     yylval.intlit = atoi(yytext);   if(flag == 0) {return INTLIT;} }
{chrlit}            { print_with_content("CHRLIT", yytext);     strcpy(yylval.chrlit, yytext);         if(flag == 0) {return CHRLIT;} }
{unterminated_chr}  { print_unterminated_error("Line %d, col %d: unterminated char constant\n", yylineno, (int)(columnNumber-yyleng)); }
{invalid_chr}       { print_invalid_error("Line %d, col %d: invalid char constant (%s)\n", yylineno, (int)(columnNumber-yyleng), yytext); }
{strlit}            { print_with_content("STRLIT", yytext);     strcpy(yylval.strlit, yytext);  if(flag == 0) {return STRLIT;} }
{unterminated_str}  { print_unterminated_error("Line %d, col %d: unterminated string constant\n", yylineno, (int)(columnNumber-yyleng)); }
{invalid_str}       { print_invalid_error("Line %d, col %d: invalid string constant (%s)\n", yylineno, (int)(columnNumber-yyleng), yytext); }
{ignore}            { ; }
.                   { print_invalid_error("Line %d, col %d: illegal character (%s)\n", yylineno, (int)(columnNumber-yyleng), yytext); }

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

void print_unterminated_error(char* error, int line, int col) {
    printf(error, line, col);
}

void print_invalid_error(char* error, int line, int col, char* token) {
    printf(error, line, col, token);
}

int yywrap()
{
    return 1;
}

int main(int argc, char const *argv[])
{
    if (argc > 1) {
        if (strcmp(argv[1], "-l") == 0) {
            flag = 1;
        } else if(strcmp(argv[1], "-1") == 0) {
            flag = 2;
        }
    }

    yylex();

    if (flag == 0) {
        yyparse();
    }

    return 0;
}
