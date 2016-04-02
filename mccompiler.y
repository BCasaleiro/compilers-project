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
Start:  FunctionDefinition Restart                                              { $$ = create_node("Start");
                                                                                    add_child($$,$1);
                                                                                    add_child($$,$2);
                                                                                    print("start function definition"); 
                                                                                }
    |   FunctionDeclaration Restart                                             { $$ = create_node("Start");
                                                                                    add_child($$,$1);
                                                                                    add_child($$,$2);
                                                                                    print("start function declaration"); 
                                                                                }
    |   Declaration Restart                                                     { $$ = create_node("Start");
                                                                                    add_child($$,$1);
                                                                                    add_child($$,$2); 
                                                                                    print("start declaration"); 
                                                                                }
    ;

Restart:    Empty                                                               { print("restart empty"); } /* o que fazer quando é vazio? $$ = $1? */
    |       FunctionDefinition Restart                                          { $$ = create_node("Restart");
                                                                                    add_child($$,$1);
                                                                                    add_child($$,$2);
                                                                                    print("restart function definition"); 
                                                                                }
    |       FunctionDeclaration Restart                                         { $$ = create_node("Restart");
                                                                                    add_child($$,$1);
                                                                                    add_child($$,$2);
                                                                                    print("restart function declaration"); 
                                                                                }
    |       Declaration Restart                                                 { $$ = create_node("Restart");
                                                                                    add_child($$,$1);
                                                                                    add_child($$,$2);
                                                                                    print("restart declaration"); 
                                                                                }
    ;

 //FunctionDefinition
FunctionDefinition: TypeSpec FunctionDeclarator FunctionBody                    { $$ = create_node("FunctionDefinition");
                                                                                    add_child($$,$1);
                                                                                    add_child($$,$2);
                                                                                    add_child($$,$3);
                                                                                    print("function definition"); 
                                                                                }
                ;

 //FunctionDeclaration
FunctionDeclaration: TypeSpec FunctionDeclarator SEMI                           { $$ = create_node("FunctionDeclaration");
                                                                                    add_child($$,$1);
                                                                                    add_child($$,$2);
                                                                                    print("function declaration"); 
                                                                                }
                ;

 //FunctionDeclarator
FunctionDeclarator: ZMast ID LPAR ParameterList RPAR                            { $$ = create_node("FunctionDeclarator");
                                                                                    add_child($$,$1);
                                                                                    add_child($$,create_node("Id",0,$2));
                                                                                    add_child($$,$4);
                                                                                    print("function declarator"); 
                                                                                }
                ;

 //FunctionBody
FunctionBody: LBRACE Redeclaration ReSpecialStatement  RBRACE                   { $$ = create_node("FunctionBody");
                                                                                    add_child($$,$2);
                                                                                    add_child($$,$3);
                                                                                    print("function body"); }
        |     LBRACE error  RBRACE                                              {}/*o que fazer em caso de erro*/
        ;

 //ParameterList
ParameterList: ParameterDeclaration CommaParameterDeclaration                   { $$ = create_node("ParameterList");
                                                                                    add_child($$,$1);
                                                                                    add_child($$,$2);
                                                                                    print("parameter list"); }
            ;

 //ParameterDeclaration
ParameterDeclaration: TypeSpec ZMast ZUid                                       { $$ = create_node("ParameterDeclaration");
                                                                                    add_child($$,$1);
                                                                                    add_child($$,$2);
                                                                                    add_child($$,$3);
                                                                                    print("parameter declaration"); 
                                                                                }
                ;

CommaParameterDeclaration:COMMA ParameterDeclaration CommaParameterDeclaration  { $$ = create_node("CommaParameterDeclaration",0,NULL);
                                                                                    add_child($$,$2);
                                                                                    add_child($$,$3);
                                                                                    print("comma parameter declaration"); 
                                                                                }
                    |     Empty                                                 { print("comma parameter declaration empty"); } /*o que fazer nos empty? */
                    ;

 //Declaration
Declaration:    TypeSpec Declarator CommaDeclarator SEMI                        {
                                                                                    $$ = create_node("Declaration");
                                                                                    add_child($$,$1);
                                                                                    add_child($$,$2);
                                                                                    add_child($$,$3);
                                                                                }
        |       error SEMI                                                      {} /* o que fazer em caso de erro? */
        ;

Redeclaration:  Empty                                                           { print("redeclaration empty"); }
        |       Declaration Redeclaration                                       { $$ = create_node("Redeclaration",0,NULL);
                                                                                    add_child($$,$1);
                                                                                    add_child($$,$2);
                                                                                    print("redeclaration"); 
                                                                                }
        ;

 //TypeSpec
TypeSpec:   INT                                                                 {
                                                                                    $$ = create_node("TypeSpec",0,NULL);
                                                                                    add_child($$, create_node("Int",0,NULL);
                                                                                }
    |       CHAR                                                                {
                                                                                    $$ = create_node("TypeSpec",0,NULL);
                                                                                    add_child($$, create_node("Char",0,NULL);
                                                                                }
    |       VOID                                                                {
                                                                                    $$ = create_node("TypeSpec",0,NULL);
                                                                                    add_child($$, create_node("Char",0,NULL);
                                                                                }
    ;

 //Declarator
Declarator: ZMast ID                                                            {
                                                                                    $$ = create_node("Declarator");
                                                                                    add_child($$,$1);
                                                                                    add_child($$,create_node("Id"),$2); //Nao sei se isto esta bem

                                                                                }
        |   ZMast ID LSQ INTLIT RSQ                                             {
                                                                                    $$ = create_node("Declarator");
                                                                                    add_child($$,$1);
                                                                                    add_child($$,create_node("Id"),0,$2); //Nao sei se isto esta bem
                                                                                    add_child($$,create_node("IntLit",$4,NULL));
                                                                                }
        ;

CommaDeclarator:    Empty                                                       {}
            |       COMMA Declarator CommaDeclarator                            {
                                                                                    $$ = create_node("CommaDeclarator",0,NULL);
                                                                                    add_child($$,$2); /*adicionar a virgula? (antes)*/
                                                                                    add_child($$,$3);
                                                                                    // temp_aux = current->luke->name;
                                                                                    // current = current->darth_vader;
                                                                                    // current = add_child("PreDeclaration", -1, NULL);

                                                                                }
            ;

 //Statement
Statement:      error SEMI                                                      {} /* o que fazer em caso de erro?*/
        |       StatementSpecial                                                { print("statement"); }
        ;

StatementSpecial:   ZUExpr SEMI                                                 { $$ = create_node("StatementSpecial",0,NULL);
                                                                                    add_child($$,$1);
                                                                                    add_child($$,$2);
                                                                                    print("statement special 1"); }
        |           LBRACE StatList RBRACE                                      { $$ = create_node("StatementSpecial",0,NULL);
                                                                                    add_child($$,$2);
                                                                                    print("statement special 2"); }
        |           LBRACE RBRACE                                               { print("statement special 3"); } /*o que fazer aqui*/
        |           LBRACE error RBRACE                                         {} /*e aqui*/
        |           IF LPAR Expr RPAR Statement %prec "then"                    {   $$ = create_node("StatementSpecial",0,NULL);
                                                                                    /*add_child($$, create_node("If",0,NULL)); é preciso este nó?*/
                                                                                    add_child($$, $3);
                                                                                    add_child($$, $5);
                                                                                     print("statement special 4"); }
        |           IF LPAR Expr RPAR Statement ELSE Statement                  { $$ = create_node("StatementSpecial",0,NULL);
                                                                                    add_child($$,$3);
                                                                                    add_child($$,$5);
                                                                                    add_child($$,$7);
                                                                                    print("statement special 5"); 
                                                                                }
        |           FOR LPAR ZUExpr SEMI ZUExpr SEMI ZUExpr RPAR Statement      { $$ = create_node("StatementSpecial",0,NULL);
                                                                                    add_child($$, $3);
                                                                                    add_child($$, $5);
                                                                                    add_child($$, $7);
                                                                                    add_child($$, $9);
                                                                                    print("statement special 6"); 
                                                                                }
        |           RETURN ZUExpr SEMI                                          { $$ = create_node("StatementSpecial",0,NULL);
                                                                                    add_child($$, $2);
                                                                                    print("statement special 7"); 
                                                                                }
        ;


StatList:       Statement Restatement                                           { $$ = create_node("StatList",0,NULL);
                                                                                    add_child($$,$1);
                                                                                    add_child($$,$2);
                                                                                    print("stat list"); }
    ;

ReSpecialStatement: Empty                                                       { print("respecial statement empty"); }

                |   StatementSpecial ReSpecialStatement                         { $$ = create_node("ReSpecialStatement",0,NULL);
                                                                                    add_child($$,$1);
                                                                                    add_child($$,$2);
                                                                                    print("respecial statement"); }
                ;

Restatement:    Empty                                                           { print("estatement empty"); }

        |       Statement Restatement                                           { $$ = create_node("Restatement",0,NULL);
                                                                                    add_child($$,$1);
                                                                                    add_child($$,$2);
                                                                                    print("restatement"); }
        ;

 //Expr
Expr:    ExprSpecial                                                            { $$ = create_node("Expr",0,NULL);
                                                                                    add_child($$,$1);
                                                                                    print("expr special"); 
                                                                                }
    |    Expr COMMA ExprSpecial                                                 { $$ = create_node("Expr",0,NULL);
                                                                                    add_child($$,$1);
                                                                                    add_child($$, create_node("Comma",0,NULL)); /*eliminar este no?*/
                                                                                    add_child($$,$3);
                                                                                    print("expr comma special"); 
                                                                                }
    ;

ExprSpecial:    ExprSpecial ASSIGN ExprSpecial                                  {   $$ = create_node("ExprSpecial",0,NULL);
                                                                                    add_child($$,$1);
                                                                                    add_child($$,create_node("Assign",0,NULL));
                                                                                    add_child($$,$3);
                                                                                 print("expr special assign"); 
                                                                                }

        |       ExprSpecial AND ExprSpecial                                     { $$ = create_node("ExprSpecial",0,NULL);
                                                                                    add_child($$,$1);
                                                                                    add_child($$,create_node("And",0,NULL));
                                                                                    add_child($$,$3);
                                                                                print("expr special and"); 
                                                                                }


        |       ExprSpecial OR ExprSpecial                                      { $$ = create_node("ExprSpecial",0,NULL);
                                                                                    add_child($$,$1);
                                                                                    add_child($$,create_node("Or",0,NULL));
                                                                                    add_child($$,$3);
                                                                                 print("expr special or"); 
                                                                                }

        |       ExprSpecial EQ ExprSpecial                                      { $$ = create_node("ExprSpecial",0,NULL);
                                                                                    add_child($$,$1);
                                                                                    add_child($$,create_node("Eq",0,NULL));
                                                                                    add_child($$,$3);
                                                                                    print("expr special eq"); 
                                                                                }

        |       ExprSpecial NE ExprSpecial                                      { $$ = create_node("ExprSpecial",0,NULL);
                                                                                    add_child($$,$1);
                                                                                    add_child($$,create_node("Ne",0,NULL));
                                                                                    add_child($$,$3);
                                                                                    print("expr special ne"); 
                                                                                }

        |       ExprSpecial LT ExprSpecial                                      { $$ = create_node("ExprSpecial",0,NULL);
                                                                                    add_child($$,$1);
                                                                                    add_child($$,create_node("Lt",0,NULL));
                                                                                    add_child($$,$3);
                                                                                    print("expr special lt"); 
                                                                                }
        |       ExprSpecial GT ExprSpecial                                      { $$ = create_node("ExprSpecial",0,NULL);
                                                                                    add_child($$,$1);
                                                                                    add_child($$,create_node("Gt",0,NULL));
                                                                                    add_child($$,$3);
                                                                                    print("expr special gt"); 
                                                                                }
        |       ExprSpecial LE ExprSpecial                                      { $$ = create_node("ExprSpecial",0,NULL);
                                                                                    add_child($$,$1);
                                                                                    add_child($$,create_node("Le",0,NULL));
                                                                                    add_child($$,$3);
                                                                                    print("expr special le");
                                                                                }
        |       ExprSpecial GE ExprSpecial                                      { $$ = create_node("ExprSpecial",0,NULL);
                                                                                    add_child($$,$1);
                                                                                    add_child($$,create_node("Ge",0,NULL));
                                                                                    add_child($$,$3);
                                                                                    print("expr special ge"); 
                                                                                }
        |       ExprSpecial PLUS ExprSpecial                                    { $$ = create_node("ExprSpecial",0,NULL);
                                                                                    add_child($$,$1);
                                                                                    add_child($$,create_node("Plus",0,NULL));
                                                                                    add_child($$,$3);
                                                                                    print("expr special plus"); 
                                                                                }
        |       ExprSpecial MINUS ExprSpecial                                   { $$ = create_node("ExprSpecial",0,NULL);
                                                                                    add_child($$,$1);
                                                                                    add_child($$,create_node("Minus",0,NULL));
                                                                                    add_child($$,$3);
                                                                                    print("expr special minus"); 
                                                                                }
        |       ExprSpecial AST ExprSpecial                                     { $$ = create_node("ExprSpecial",0,NULL);
                                                                                    add_child($$,$1);
                                                                                    add_child($$,create_node("Ast",0,NULL));
                                                                                    add_child($$,$3);
                                                                                    print("expr special ast"); 
                                                                                }
        |       ExprSpecial DIV ExprSpecial                                     { $$ = create_node("ExprSpecial",0,NULL);
                                                                                    add_child($$,$1);
                                                                                    add_child($$,create_node("Div",0,NULL));
                                                                                    add_child($$,$3);
                                                                                    print("expr special div"); 
                                                                                }
        |       ExprSpecial MOD ExprSpecial                                     { $$ = create_node("ExprSpecial",0,NULL);
                                                                                    add_child($$,$1);
                                                                                    add_child($$,create_node("Mod",0,NULL));
                                                                                    add_child($$,$3);
                                                                                    print("expr special mod"); 
                                                                                }
        |       NOT ExprSpecial                                                 {   $$ = create_node("ExprSpecial",0,NULL);
                                                                                    add_child($$,create_node("Not",0,NULL));
                                                                                    add_child($$,$2);
                                                                                    print("expr special not a"); 
                                                                                }
        |       MINUS ExprSpecial                                               { $$ = create_node("ExprSpecial",0,NULL);
                                                                                    add_child($$,create_node("Minus",0,NULL));
                                                                                    add_child($$,$2);
                                                                                    print("expr special minus a"); 
                                                                                }
        |       PLUS ExprSpecial                                                { $$ = create_node("ExprSpecial",0,NULL);
                                                                                    add_child($$,create_node("Plus",0,NULL));
                                                                                    add_child($$,$2);
                                                                                    print("expr special plus a"); 
                                                                                }
        |       AST ExprSpecial                                                 { $$ = create_node("ExprSpecial",0,NULL);
                                                                                    add_child($$,create_node("Ast",0,NULL));
                                                                                    add_child($$,$2);
                                                                                    print("expr special ast a"); 
                                                                                }
        |       AMP ExprSpecial                                                 { $$ = create_node("ExprSpecial",0,NULL);
                                                                                    add_child($$,create_node("Amp",0,NULL));
                                                                                    add_child($$,$2);
                                                                                    print("expr special amp a"); 
                                                                                }
        |       ID                                                              { $$ = create_node("ExprSpecial",0,NULL);
                                                                                    add_child($$,create_node("Id",0,$1));
                                                                                    print("expr special id"); 
                                                                                }
        |       INTLIT                                                          { $$ = create_node("ExprSpecial",0,NULL);
                                                                                    add_child($$,create_node("IntLit",$1,NULL));
                                                                                    print("expr special intlit"); 
                                                                                }
        |       CHRLIT                                                          { $$ = create_node("ExprSpecial",0,NULL);
                                                                                    add_child($$, create_node("ChrLit",0,NULL));
                                                                                    print("expr special chrlit"); 
                                                                                }
        |       STRLIT                                                          { $$ = create_node("ExprSpecial",0,NULL);
                                                                                    add_child($$ , create_node("StrLit",0,NULL));
                                                                                    print("expr special strlit"); 
                                                                                }
        |       LPAR Expr RPAR                                                  {  $$ = $2;
                                                                                     print("expr special ()"); 
                                                                                }
        |       LPAR error RPAR                                                 {}/*O que fazer em caso de erro?*/
        |       ID LPAR ZUExprZMComma RPAR                                      {   $$ = create_node("ExprSpecial",0,NULL);
                                                                                    add_child($$, create_node(ID,0,$1));
                                                                                    add_child($$, $3);
                                                                                    print("expr special id()"); }
        |       ID LPAR error RPAR                                              {}/*O que fazer em caso de erro?*/
        |       ExprSpecial LSQ Expr RSQ                                        { $$ = create_node("ExprSpecial",0,NULL);
                                                                                    add_child($$,$1);
                                                                                    add_child($$,$3);
                                                                                    print("expr special []"); 
                                                                                }
        ;

ZUExprZMComma:  Empty                                                           { print("zero um expr special zero mais comma empty"); }
            |   ExprSpecial ZMComma                                             { $$ = create_node("ZUExprZMComma",0,NULL);
                                                                                    add_child($$,$1);
                                                                                    add_child($$,$2);
                                                                                    print("zero um expr special zero mais comma"); 
                                                                                }
            ;

ZMComma:    Empty                                                               { print("zero mais comma empty"); }
    |       ZMComma COMMA ExprSpecial                                           { 
                                                                                    $$ = create_node("ZMComma",0,NULL);
                                                                                    add_child($$,$1);
                                                                                    add_child($$, create_node("Comma",0,NULL));/*eliminar este no?*/
                                                                                    add_child($$,$3);
                                                                                    print("zero mais comma");
                                                                                }
    ;

 //Caracteres repetidos

 //Zero ou mais AST
ZMast:  Empty                                                                   { print("zero um ast empty"); }
    |   ZMast AST                                                               { $$ = create_node("ZMast",0,NULL);
                                                                                    add_child($$,create_node("Ast",0,NULL);
                                                                                    print("zero um ast"); 
                                                                                }
    ;

 //Zero ou um ID
ZUid:   Empty                                                                   { print("zero um id empty"); }
    |   ID                                                                      { $$ = create_node("ZUid",0,NULL);
                                                                                    add_child("Id",0,$1);
                                                                                    print("zero um id"); 
                                                                                }
    ;

ZUExpr: Empty                                                                   { print("zero um expr empty"); }
    |   Expr                                                                    { $$ = create_node("ZUExpr",0,NULL);
                                                                                    add_child($$,$1);
                                                                                    print("zero um expr"); 
                                                                                }
    ;

 // Carateres especiais

Empty:                                                                          { $$ = create_node("Null",0,NULL); } 
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

tree_node* create_node(char* node_name, int int_value, char* char_value) {
    tree_node* new_node = (tree_node*)malloc(sizeof(tree_node));

    strcpy(new_node->name, node_name);
    new_node->next_brother = NULL;
    new_node->luke = NULL;
    new_node->father = NULL;
    new_node->value_int = int_value;
    new_node->value_str = char_value;

    return new_node;
}


/*Adicionar o filho son ao fim da lista de filhos de father*/
void add_child(tree_node * father , tree_node * son){
    tree_node * aux;

    /*se houver mais que um filho, ir ate ao ultimo*/
    if(father->luke != NULL){
        aux = father->luke;

        while(aux->next_brother != NULL){
            aux = aux->next_brother;
        }
        /*adicionar o filho ao fim*/
        aux->next_brother = son;
        son->darth_vader = father;
    }
    else{
        /*Se ainda nao existir nenhum filho, adicionar diretamente*/
        father -> luke = son;
        son -> darth_vader = father;
    }
}

void print(char* s) {
    if (DEBUG) {
        printf("%s\n", s);
    }
}

void yyerror (char *s) {
    printf ("Line %d, col %d: %s: %s\n", yylineno, (int)(columnNumber - strlen(yytext)), s, yytext);
}
