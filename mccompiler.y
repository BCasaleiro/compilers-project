%{
    #include <stdio.h>
    #include <stdlib.h>
    #include <string.h>

    #define DEBUG 1
    #define MAX_STR 100

    extern int yylineno;
    extern char * yytext;

    extern int columnNumber;

    void print(char *s);
    void yyerror (char *s);
    extern int yylex();

    typedef struct _tree_node {
        struct _tree_node* darth_vader;
        struct _tree_node* next_brother;
        struct _tree_node* luke;

        char name[MAX_STR];

        int value_int;
        char value_str[MAX_STR];
    } tree_node;

    int flag_error = 0;

    tree_node* root = NULL;
    tree_node* auxId = NULL;
    tree_node* auxIntLit = NULL;
    tree_node* auxChrLit = NULL;
    tree_node* auxStrLit = NULL;

    tree_node* create_simple_node(char* name);
    tree_node* create_int_node(char* name, int value);
    tree_node* create_str_node(char* name, char* value);

    void add_child(tree_node * father , tree_node * son);
    void add_brother_end(tree_node* father, tree_node* new_son);
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

%type <node> Start
%type <node> Restart
%type <node> FunctionDefinition
%type <node> FunctionDeclaration
%type <node> FunctionDeclarator
%type <node> FunctionBody
%type <node> Declaration
%type <node> Redeclaration
%type <node> TypeSpec
%type <node> Declarator
%type <node> CommaDeclarator
%type <node> Statement
%type <node> ParameterList
%type <node> ParameterDeclaration
%type <node> CommaParameterDeclaration
%type <node> StatementSpecial
%type <node> StatList
%type <node> ReSpecialStatement
%type <node> Restatement
%type <node> Expr
%type <node> ExprSpecial
%type <node> ZUExprZMComma
%type <node> ZMComma
%type <node> ZMast
%type <node> ZUid
%type <node> ZUExpr
%type <node> Empty


%union{
    char*   id;
    int     intlit;
    char*   chrlit;
    char*   strlit;
    struct _tree_node* node;
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
Start:  FunctionDefinition Restart                                              {
                                                                                    $$ = create_simple_node("Program");
                                                                                    root = $$;
                                                                                    add_child($$, $1);
                                                                                    $1->next_brother = $2;
                                                                                }
    |   FunctionDeclaration Restart                                             {
                                                                                    $$ = create_simple_node("Program");
                                                                                    root = $$;
                                                                                    add_child($$, $1);
                                                                                    $1->next_brother = $2;
                                                                                }
    |   Declaration Restart                                                     {
                                                                                    $$ = create_simple_node("Program");
                                                                                    root = $$;

                                                                                    add_child($$, $1);
                                                                                    $1->next_brother = $2;
                                                                                }
    ;

Restart:    Empty                                                               {
                                                                                    $$ = $1;
                                                                                }
    |       FunctionDefinition Restart                                          {
                                                                                    $$ = $1;
                                                                                    $$->next_brother = $2;
                                                                                }
    |       FunctionDeclaration Restart                                         {
                                                                                    $$ = $1;
                                                                                    $$->next_brother = $2;
                                                                                }
    |       Declaration Restart                                                 {
                                                                                    $$ = $1;
                                                                                    $$->next_brother = $2;
                                                                                }
    ;

 //FunctionDefinition
FunctionDefinition: TypeSpec FunctionDeclarator FunctionBody                    {

                                                                                }
                ;

 //FunctionDeclaration
FunctionDeclaration: TypeSpec FunctionDeclarator SEMI                           {

                                                                                }
                ;

 //FunctionDeclarator
FunctionDeclarator: ZMast ID LPAR ParameterList RPAR                            {

                                                                                }
                ;

 //FunctionBody
FunctionBody: LBRACE Redeclaration ReSpecialStatement  RBRACE                   {

                                                                                }
        |     LBRACE error  RBRACE                                              { }
        ;

 //ParameterList
ParameterList: ParameterDeclaration CommaParameterDeclaration                   {

                                                                                }
            ;

 //ParameterDeclaration
ParameterDeclaration: TypeSpec ZMast ZUid                                       {

                                                                                }
                ;

CommaParameterDeclaration:COMMA ParameterDeclaration CommaParameterDeclaration  {

                                                                                }
                    |     Empty                                                 {  }
                    ;

 //Declaration
Declaration:    TypeSpec Declarator CommaDeclarator SEMI                        {
                                                                                    $$ = $2;
                                                                                    $$->next_brother = $3;
                                                                                    tree_node* aux = $$;
                                                                                    while(aux != NULL) {
                                                                                        add_child(aux, $1);
                                                                                        aux = aux->next_brother;
                                                                                    }
                                                                                }
        |       error SEMI                                                      { }
        ;

Redeclaration:  Empty                                                           {  }
        |       Declaration Redeclaration                                       {

                                                                                }
        ;

 //TypeSpec
TypeSpec:   INT                                                                 {
                                                                                    $$ = create_simple_node("Int");
                                                                                }
    |       CHAR                                                                {
                                                                                    $$ = create_simple_node("Char");
                                                                                }
    |       VOID                                                                {
                                                                                    $$ = create_simple_node("Void");
                                                                                }
    ;

 //Declarator
Declarator: ZMast ID                                                            {
                                                                                    $$ = create_simple_node("Declaration");
                                                                                    auxId = create_str_node("Id", $2);
                                                                                    if($1 != NULL) {
                                                                                        $$->luke = $1;
                                                                                        add_brother_end($$->luke, auxId);
                                                                                    } else {
                                                                                        add_child($$, auxId);
                                                                                    }
                                                                                }
        |   ZMast ID LSQ INTLIT RSQ                                             {
                                                                                    $$ = create_simple_node("ArrayDeclaration");
                                                                                    auxId = create_str_node("Id", $2);
                                                                                    auxIntLit = create_int_node("IntLit", $4);
                                                                                    if($1 != NULL) {
                                                                                        $$->luke = $1;
                                                                                        add_brother_end($$->luke, auxId);
                                                                                        add_brother_end($$->luke, auxIntLit);
                                                                                    } else {
                                                                                        add_child($$, auxIntLit);
                                                                                        add_child($$, auxId);
                                                                                    }
                                                                                }
        ;

CommaDeclarator:    Empty                                                       { $$ = $1; }
            |       COMMA Declarator CommaDeclarator                            {
                                                                                    $$ = $2;
                                                                                    $$->next_brother = $3;
                                                                                }
            ;

 //Statement
Statement:      error SEMI                                                      { }
        |       StatementSpecial                                                {  }
        ;

StatementSpecial:   ZUExpr SEMI                                                 {

                                                                                }
        |           LBRACE StatList RBRACE                                      {

                                                                                }
        |           LBRACE RBRACE                                               {  }
        |           LBRACE error RBRACE                                         {  }
        |           IF LPAR Expr RPAR Statement %prec "then"                    {

                                                                                }
        |           IF LPAR Expr RPAR Statement ELSE Statement                  {

                                                                                }
        |           FOR LPAR ZUExpr SEMI ZUExpr SEMI ZUExpr RPAR Statement      {

                                                                                }
        |           RETURN ZUExpr SEMI                                          {

                                                                                }
        ;


StatList:       Statement Restatement                                           {

                                                                                }
    ;

ReSpecialStatement: Empty                                                       {  }

                |   StatementSpecial ReSpecialStatement                         {

                                                                                }
                ;

Restatement:    Empty                                                           {  }

        |       Statement Restatement                                           {

                                                                                }
        ;

 //Expr
Expr:    ExprSpecial                                                            {

                                                                                }
    |    Expr COMMA ExprSpecial                                                 {

                                                                                }
    ;

ExprSpecial:    ExprSpecial ASSIGN ExprSpecial                                  {

                                                                                }

        |       ExprSpecial AND ExprSpecial                                     {

                                                                                }


        |       ExprSpecial OR ExprSpecial                                      {

                                                                                }

        |       ExprSpecial EQ ExprSpecial                                      {

                                                                                }

        |       ExprSpecial NE ExprSpecial                                      {

                                                                                }

        |       ExprSpecial LT ExprSpecial                                      {

                                                                                }
        |       ExprSpecial GT ExprSpecial                                      {

                                                                                }
        |       ExprSpecial LE ExprSpecial                                      {

                                                                                }
        |       ExprSpecial GE ExprSpecial                                      {

                                                                                }
        |       ExprSpecial PLUS ExprSpecial                                    {

                                                                                }
        |       ExprSpecial MINUS ExprSpecial                                   {

                                                                                }
        |       ExprSpecial AST ExprSpecial                                     {

                                                                                }
        |       ExprSpecial DIV ExprSpecial                                     {

                                                                                }
        |       ExprSpecial MOD ExprSpecial                                     {

                                                                                }
        |       NOT ExprSpecial                                                 {

                                                                                }
        |       MINUS ExprSpecial                                               {

                                                                                }
        |       PLUS ExprSpecial                                                {

                                                                                }
        |       AST ExprSpecial                                                 {

                                                                                }
        |       AMP ExprSpecial                                                 {

                                                                                }
        |       ID                                                              {

                                                                                }
        |       INTLIT                                                          {

                                                                                }
        |       CHRLIT                                                          {

                                                                                }
        |       STRLIT                                                          {

                                                                                }
        |       LPAR Expr RPAR                                                  {

                                                                                }
        |       LPAR error RPAR                                                 { }
        |       ID LPAR ZUExprZMComma RPAR                                      {

                                                                                }
        |       ID LPAR error RPAR                                              { }
        |       ExprSpecial LSQ Expr RSQ                                        {

                                                                                }
        ;

ZUExprZMComma:  Empty                                                           { $$ = $1; }
            |   ExprSpecial ZMComma                                             {

                                                                                }
            ;

ZMComma:    Empty                                                               { $$ = $1; }
    |       ZMComma COMMA ExprSpecial                                           {

                                                                                }
    ;

 //Caracteres repetidos

 //Zero ou mais AST
ZMast:  Empty                                                                   { $$ = $1; }
    |   ZMast AST                                                               {
                                                                                    $$ = create_simple_node("Pointer");
                                                                                    $$->next_brother = $1;
                                                                                }
    ;

 //Zero ou um ID
ZUid:   Empty                                                                   {  }
    |   ID                                                                      {

                                                                                }
    ;

ZUExpr: Empty                                                                   {  }
    |   Expr                                                                    {

                                                                                }
    ;

 // Carateres especiais

Empty:                                                                          { $$ = NULL; }
    ;

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

tree_node* create_simple_node(char* name) {
    tree_node* new_node = (tree_node*) malloc( sizeof(tree_node) );

    if (new_node != NULL) {
        strcpy(new_node->name, name);
        new_node->next_brother = NULL;
        new_node->luke = NULL;
        new_node->darth_vader = NULL;
    } else {
        printf("ERROR SIMPLE NODE\n");
    }

    return new_node;
}

tree_node* create_int_node(char* name, int value) {
    tree_node* new_node = (tree_node*)malloc(sizeof(tree_node));

    if(new_node != NULL) {
        strcpy(new_node->name, name);
        new_node->next_brother = NULL;
        new_node->luke = NULL;
        new_node->darth_vader = NULL;

        new_node->value_int = value;
    } else {
        printf("ERROR INT NODE\n");
    }

    return new_node;
}

tree_node* create_str_node(char* name, char* value) {
    tree_node* new_node = (tree_node*)malloc(sizeof(tree_node));

    if(new_node != NULL) {
        strcpy(new_node->name, name);
        new_node->next_brother = NULL;
        new_node->luke = NULL;
        new_node->darth_vader = NULL;

        strcpy(new_node->value_str, value);
    } else {
        printf("ERROR STR NODE\n");
    }

    return new_node;
}

/*Adicionar o filho son ao fim da lista de filhos de father*/
void add_child(tree_node * father , tree_node * son){
    tree_node * aux = father;
    if(aux->luke != NULL) {
        son->next_brother = father->luke;
        son->darth_vader = father;
        father->luke = son;
    } else {
        father->luke = son;
        father->luke->darth_vader = father;
    }
}

void add_brother_end(tree_node* brother, tree_node* new_son) {
    tree_node* aux = brother;
    if(aux!= NULL && new_son != NULL) {
        while(aux->next_brother != NULL) {
            aux = aux->next_brother;
        }
        aux->next_brother = new_son;
        new_son->darth_vader = brother->darth_vader;
    }
}

void print(char* s) {
    if (DEBUG) {
        printf("%s\n", s);
    }
}

void yyerror (char *s) {

    flag_error = 1;

    printf ("Line %d, col %d: %s: %s\n", yylineno, (int)(columnNumber - strlen(yytext)), s, yytext);
}
