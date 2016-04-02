%{
    #include <stdio.h>
    #include <stdlib.h>
    #include <string.h>

    #define DEBUG 1

    extern int yylineno;
    extern int yyleng;
    extern char * yytext;

    extern int flag;
    extern int columnNumber;

    void print(char *s);
    void yyerror (char *s);
    extern int yylex();

    typedef struct _tree_node {
        struct _tree_node* darth_vader;
        struct _tree_node* next_brother;
        struct _tree_node* luke;

        char* name;

        int value_int;
        char* value_str;
    } tree_node;

    tree_node* root = NULL;
    tree_node* current = NULL;
    char* temp_aux;

    void create_tree();
    tree_node* add_child(char* child_name, int child_int, char* child_str);
%}

%token AND
%token OR
%token AMP
%token EQ
%token ASSIGN
%token NOT
%token NE
%token GT
%token LT
%token GE
%token LE
%token COMMA
%token SEMI
%token LBRACE
%token RBRACE
%token LPAR
%token RPAR
%token LSQ
%token RSQ
%token PLUS
%token MINUS
%token AST
%token DIV
%token MOD
%token INT
%token CHAR
%token VOID
%token IF
%token ELSE
%token FOR
%token RETURN
%token RESERVED

%token <id> ID
%token <intlit> INTLIT
%token <chrlit> CHRLIT
%token <strlit> STRLIT

%union{
    char*   id;
    int     intlit;
    char*   chrlit;
    char*   strlit;
}

%nonassoc "then"
%nonassoc ELSE

%left LPAR
%left RPAR
%left LSQ
%left RSQ
%left MOD
%left AST
%left DIV
%left MINUS
%left PLUS
%left GE
%left LE
%left GT
%left LT
%left EQ
%left NE
%left NOT
%left OR
%left AND
%left AMP
%right ASSIGN
%left COMMA

%%
 //Start
Start:  FunctionDefinition Restart                                              { /*create_tree();*/ print("start function definition"); }
    |   FunctionDeclaration Restart                                             { /*create_tree();*/ print("start function declaration"); }
    |   Declaration Restart                                                     { /*create_tree();*/ print("start declaration"); }
    ;

Restart:    Empty                                                               { print("restart empty"); }
    |       FunctionDefinition Restart                                          { print("restart function definition"); }
    |       FunctionDeclaration Restart                                         { print("restart function declaration"); }
    |       Declaration Restart                                                 { print("restart declaration"); }
    ;

 //FunctionDefinition
FunctionDefinition: TypeSpec FunctionDeclarator FunctionBody                    { print("function definition"); }
                ;

 //FunctionDeclaration
FunctionDeclaration: TypeSpec FunctionDeclarator SEMI                           { print("function declaration"); }
                ;

 //FunctionDeclarator
FunctionDeclarator: ZMast ID LPAR ParameterList RPAR                            { print("function declarator"); }
                ;

 //FunctionBody
FunctionBody: LBRACE Redeclaration ReSpecialStatement  RBRACE                   { print("function body"); }
        |     LBRACE error  RBRACE
        ;

 //ParameterList
ParameterList: ParameterDeclaration CommaParameterDeclaration                   { print("parameter list"); }
            ;

 //ParameterDeclaration
ParameterDeclaration: TypeSpec ZMast ZUid                                       { print("parameter declaration"); }
                ;

CommaParameterDeclaration:COMMA ParameterDeclaration CommaParameterDeclaration  { print("comma parameter declaration"); }
                    |     Empty                                                 { print("comma parameter declaration empty"); }
                    ;

 //Declaration
Declaration:    TypeSpec Declarator CommaDeclarator SEMI                        {
                                                                                    //current = add_child("PreDeclaration", -1, NULL);
                                                                                }
        |       error SEMI
        ;

Redeclaration:  Empty                                                           { print("redeclaration empty"); }
        |       Declaration Redeclaration                                       { print("redeclaration"); }
        ;

 //TypeSpec
TypeSpec:   INT                                                                 {
                                                                                    // add_child("Int", -1, NULL);
                                                                                }
    |       CHAR                                                                {
                                                                                    // add_child("Char", -1, NULL);
                                                                                }
    |       VOID                                                                {
                                                                                    // add_child("Void", -1, NULL);
                                                                                }
    ;

 //Declarator
Declarator: ZMast ID                                                            {
                                                                                    // current->name="Declaration";
                                                                                    // add_child("Id", -1, NULL); //TODO add this shitty id
                                                                                }
        |   ZMast ID LSQ INTLIT RSQ                                             {
                                                                                    // current->name="ArrayDeclaration";
                                                                                    // add_child("Id", -1, NULL); //TODO add this shitty id
                                                                                    // add_child("IntLit", -1, NULL); //TODO add this shitty intlit
                                                                                }
        ;

CommaDeclarator:    Empty                                                       {
                                                                                    // current = current->darth_vader;
                                                                                }
            |       COMMA Declarator CommaDeclarator                            {
                                                                                    // temp_aux = current->luke->name;
                                                                                    // current = current->darth_vader;
                                                                                    // current = add_child("PreDeclaration", -1, NULL);

                                                                                }
            ;

 //Statement
Statement:      error SEMI
        |       StatementSpecial                                                { print("statement"); }
        ;

StatementSpecial:   ZUExpr SEMI                                                 { print("statement special 1"); }
        |           LBRACE StatList RBRACE                                      { print("statement special 2"); }
        |           LBRACE RBRACE                                               { print("statement special 3"); }
        |           LBRACE error RBRACE
        |           IF LPAR Expr RPAR Statement %prec "then"                    { print("statement special 4"); }
        |           IF LPAR Expr RPAR Statement ELSE Statement                  { print("statement special 5"); }
        |           FOR LPAR ZUExpr SEMI ZUExpr SEMI ZUExpr RPAR Statement      { print("statement special 6"); }
        |           RETURN ZUExpr SEMI                                          { print("statement special 7"); }
        ;


StatList:       Statement Restatement                                           { print("stat list"); }
    ;

ReSpecialStatement: Empty                                                       { print("respecial statement empty"); }
                |   StatementSpecial ReSpecialStatement                         { print("respecial statement"); }
                ;

Restatement:    Empty                                                           { print("restatement empty"); }
        |       Statement Restatement                                           { print("restatement"); }
        ;

 //Expr
Expr:    ExprSpecial                                                            { print("expr special"); }
    |    Expr COMMA ExprSpecial                                                 { print("expr comma special"); }
    ;

ExprSpecial:    ExprSpecial ASSIGN ExprSpecial                                  { print("expr special assign"); }
        |       ExprSpecial AND ExprSpecial                                     { print("expr special and"); }
        |       ExprSpecial OR ExprSpecial                                      { print("expr special or"); }
        |       ExprSpecial EQ ExprSpecial                                      { print("expr special eq"); }
        |       ExprSpecial NE ExprSpecial                                      { print("expr special ne"); }
        |       ExprSpecial LT ExprSpecial                                      { print("expr special lt"); }
        |       ExprSpecial GT ExprSpecial                                      { print("expr special gt"); }
        |       ExprSpecial LE ExprSpecial                                      { print("expr special le"); }
        |       ExprSpecial GE ExprSpecial                                      { print("expr special ge"); }
        |       ExprSpecial PLUS ExprSpecial                                    { print("expr special plus"); }
        |       ExprSpecial MINUS ExprSpecial                                   { print("expr special minus"); }
        |       ExprSpecial AST ExprSpecial                                     { print("expr special ast"); }
        |       ExprSpecial DIV ExprSpecial                                     { print("expr special div"); }
        |       ExprSpecial MOD ExprSpecial                                     { print("expr special mod"); }
        |       NOT ExprSpecial                                                 { print("expr special not a"); }
        |       MINUS ExprSpecial                                               { print("expr special minus a"); }
        |       PLUS ExprSpecial                                                { print("expr special plus a"); }
        |       AST ExprSpecial                                                 { print("expr special ast a"); }
        |       AMP ExprSpecial                                                 { print("expr special amp a"); }
        |       ID                                                              { print("expr special id"); }
        |       INTLIT                                                          { print("expr special intlit"); }
        |       CHRLIT                                                          { print("expr special chrlit"); }
        |       STRLIT                                                          { print("expr special strlit"); }
        |       LPAR Expr RPAR                                                  { print("expr special ()"); }
        |       LPAR error RPAR
        |       ID LPAR ZUExprZMComma RPAR                                      { print("expr special id()"); }
        |       ID LPAR error RPAR
        |       ExprSpecial LSQ Expr RSQ                                        { print("expr special []"); }
        ;

ZUExprZMComma:  Empty                                                           { print("zero um expr special zero mais comma empty"); }
            |   ExprSpecial ZMComma                                             { print("zero um expr special zero mais comma"); }
            ;

ZMComma:    Empty                                                               { print("zero mais comma empty"); }
    |       ZMComma COMMA ExprSpecial                                           { print("zero mais comma"); }
    ;

 //Caracteres repetidos

 //Zero ou mais AST
ZMast:  Empty                                                                   { print("zero um ast empty"); }
    |   ZMast AST                                                               { print("zero um ast"); }
    ;

 //Zero ou um ID
ZUid:   Empty                                                                   { print("zero um id empty"); }
    |   ID                                                                      { print("zero um id"); }
    ;

ZUExpr: Empty                                                                   { print("zero um expr empty"); }
    |   Expr                                                                    { print("zero um expr"); }
    ;

 // Carateres especiais

Empty:  ;

%%

/* A função main() está do lado do lex */

/*
typedef struct _tree_node {
    struct _tree_node* darth_vader;
    struct _tree_node* next_brother;
    struct _tree_node* luke;
    char* name;

    int value_int;
    char* value_str;
} tree_node;
*/

void create_tree() {
    root = (tree_node*)malloc( sizeof(tree_node) );
    if (root != NULL) {
        root->darth_vader = NULL;
        root->next_brother = NULL;
        root->name = "Program";
        root->luke = NULL;

        current = root;
    } else {
        printf("ERROR MALLOC\n");
    }
}

tree_node* add_child(char* child_name, int child_int, char* child_str) {
    tree_node* new_node = NULL;


    return new_node;
}

void print(char* s) {
    if (DEBUG) {
        printf("%s\n", s);
    }
}

void yyerror (char *s) {
    printf ("Line %d, col %d: %s: %s\n", yylineno, (int)(columnNumber - strlen(yytext)), s, yytext);
}
