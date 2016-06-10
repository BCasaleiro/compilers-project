%{
    #define YY_USER_ACTION columnNumber += yyleng;

    #include <stdio.h>
    #include <stdlib.h>
    #include <string.h>
    #include <stdbool.h>
    #include "y.tab.h"
    #include "code_gen.h"

    int flag = 0;
    int lineNumber = 1;
    int columnNumber = 1;
    int colComment;
    int lineComment;

    extern int flag_error;
    extern tree_node* root;

    int yyparse();

    bool check_flag();

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
/* unterminated_str    \"([^\"\n]|{valid_stuff})* */
unterminated_str    \"({valid_stuff}*|(\\.|[^"\n\\]))*\\?

ignore              ("\n"|"\t"|" ")
reserved            ("--"|"++"|auto|break|case|const|continue|default|do|double|enum|extern|float|goto|long|register|short|signed|sizeof|static|struct|switch|typedef|union|unsigned|volatile|while)

/* rules */
%%

"/*"                            {
                                    BEGIN (COMMENT);
                                    {
                                        colComment = columnNumber - 1;
                                    }
                                    lineComment = yylineno;
                                }
<COMMENT>"*/"                   { BEGIN (0); }
<COMMENT>"\n"                   { columnNumber = 1; }
<COMMENT>.                      { ; }
<COMMENT><<EOF>>                {
                                    printf("Line %d, col %d: unterminated comment\n", lineComment,  colComment);
                                    yyterminate();
                                }

"\n"                            { columnNumber = 1; }

{reserved}                      {
                                    print_with_content("RESERVED", yytext);
                                    if( check_flag() ) { return RESERVED; }
                                }

"&&"                            {
                                    print_text("AND");
                                    if( check_flag() ) { return AND; }
                                }
"||"                            {
                                    print_text("OR");
                                    if( check_flag() ) { return OR; }
                                }
"&"                             {
                                    print_text("AMP");
                                    if( check_flag() ) { return AMP; }
                                }
"=="                            {
                                    print_text("EQ");
                                    if( check_flag() ) { return EQ; }
                                }
"="                             {
                                    print_text("ASSIGN");
                                    if( check_flag() ) { return ASSIGN; }
                                }
"!"                             {
                                    print_text("NOT");
                                    if( check_flag() ) { return NOT; }
                                }
"!="                            {
                                    print_text("NE");
                                    if( check_flag() ) { return NE; }
                                }
">"                             {
                                    print_text("GT");
                                    if( check_flag() ) { return GT; }
                                }
"<"                             {
                                    print_text("LT");
                                    if( check_flag() ) { return LT; }
                                }
">="                            {
                                    print_text("GE");
                                    if( check_flag() ) { return GE; }
                                }
"<="                            {
                                    print_text("LE");
                                    if( check_flag() ) { return LE; }
                                }
","                             {
                                    print_text("COMMA");
                                    if( check_flag() ) { return COMMA; }
                                }
";"                             {
                                    print_text("SEMI");
                                    if( check_flag() ) { return SEMI; }
                                }
"{"                             {
                                    print_text("LBRACE");
                                    if( check_flag() ) { return LBRACE; }
                                }
"}"                             {
                                    print_text("RBRACE");
                                    if( check_flag() ) { return RBRACE; }
                                }
"("                             {
                                    print_text("LPAR");
                                    if( check_flag() ) { return LPAR; }
                                }
")"                             {
                                    print_text("RPAR");
                                    if( check_flag() ) { return RPAR; }
                                }
"["                             {
                                    print_text("LSQ");
                                    if( check_flag() ) { return LSQ; }
                                }
"]"                             {
                                    print_text("RSQ");
                                    if( check_flag() ) { return RSQ; }
                                }
"+"                             {
                                    print_text("PLUS");
                                    if( check_flag() ) { return PLUS; }
                                }
"-"                             {
                                    print_text("MINUS");
                                     if( check_flag() ) { return MINUS; }
                                }
"*"                             {
                                    print_text("AST");
                                    if( check_flag() ) { return AST; }
                                }
"/"                             {
                                    print_text("DIV");
                                    if( check_flag() ) { return DIV; }
                                }
"%"                             {
                                    print_text("MOD");
                                    if( check_flag() ) { return MOD; }
                                }
int                             {
                                    print_text("INT");
                                    if( check_flag() ) { return INT; }
                                }
char                            {
                                    print_text("CHAR");
                                    if( check_flag() ) { return CHAR; }
                                }
void                            {
                                    print_text("VOID");
                                    if( check_flag() ) { return VOID; }
                                }
if                              {
                                    print_text("IF");
                                    if( check_flag() ) { return IF; }
                                }
else                            {
                                    print_text("ELSE");
                                    if( check_flag() ) { return ELSE; }
                                }
for                             {
                                    print_text("FOR");
                                    if( check_flag() ) { return FOR; }
                                }
return                          {
                                    print_text("RETURN");
                                    if( check_flag() ) { return RETURN; }
                                }
{id}                            {
                                    print_with_content("ID", yytext);
                                    yylval.id = strdup(yytext);
                                    if( check_flag() ) { return ID; }
                                }
{intlit}                        {
                                    print_with_content("INTLIT", yytext);
                                    yylval.intlit = strdup(yytext);
                                    if( check_flag() ) { return INTLIT; }
                                }
{chrlit}                        {
                                    print_with_content("CHRLIT", yytext);
                                    yylval.chrlit = strdup(yytext);
                                    if( check_flag() ) { return CHRLIT; }
                                }
{unterminated_chr}              {
                                    print_unterminated_error("Line %d, col %d: unterminated char constant\n", yylineno, (int)(columnNumber-yyleng));
                                }
{invalid_chr}                   {
                                    print_invalid_error("Line %d, col %d: invalid char constant (%s)\n", yylineno, (int)(columnNumber-yyleng), yytext);
                                }
{strlit}                        {
                                    print_with_content("STRLIT", yytext);
                                    yylval.strlit = strdup(yytext);
                                    if( check_flag() ) { return STRLIT; }
                                }
{unterminated_str}              {
                                    print_unterminated_error("Line %d, col %d: unterminated string constant\n", yylineno, (int)(columnNumber-yyleng));
                                }
{invalid_str}                   {
                                    print_invalid_error("Line %d, col %d: invalid string constant (%s)\n", yylineno, (int)(columnNumber-yyleng), yytext);
                                }
{ignore}                        { ; }
.                               {
                                    print_invalid_error("Line %d, col %d: illegal character (%s)\n", yylineno, (int)(columnNumber-yyleng), yytext);
                                }

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

int yywrap() {
    return 1;
}

bool check_flag() {
    return (flag == 0 || flag >= 3);
}

int main(int argc, char const *argv[])
{
    if (argc > 1) {
        if (strcmp(argv[1], "-l") == 0) {
            flag = 1;
        } else if(strcmp(argv[1], "-1") == 0) {
            flag = 2;
        } else if(strcmp(argv[1], "-t") == 0) {
            flag = 3;
        } else if(strcmp(argv[1], "-2") == 0) {
            flag = 4;
        } else if(strcmp(argv[1], "-s") == 0) {
            flag = 5;
        }
    }

    if (check_flag()) {
        yyparse();

        if(flag == 3 && flag_error == 0) {
            print_tree(root, 0);
        }

        if( (flag == 0 || flag == 5) && flag_error == 0 ) {
            semantics(root);
        }

        if(flag == 5 && flag_error == 0) {
            print_tables(symbol_tables);
            print_annotated_tree(root, 0);
        }
        if(flag == 0 && flag_error==0){
            print_code(root, symbol_tables);
        }

    } else {
        yylex();
    }

    return 0;
}
