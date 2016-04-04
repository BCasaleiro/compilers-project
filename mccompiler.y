%{
    #include <stdio.h>
    #include <stdlib.h>
    #include <string.h>

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
%right ASSIGN
%left COMMA
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


%%
 //Start
Start:  FunctionDefinition Restart                                              {
                                                                                    $$ = create_simple_node("Program");
                                                                                    root = $$;
                                                                                    add_child($$, $1);
                                                                                    add_brother_end($1, $2);
                                                                                }
    |   FunctionDeclaration Restart                                             {
                                                                                    $$ = create_simple_node("Program");
                                                                                    root = $$;
                                                                                    add_child($$, $1);
                                                                                    add_brother_end($1, $2);
                                                                                }
    |   Declaration Restart                                                     {
                                                                                    $$ = create_simple_node("Program");
                                                                                    root = $$;

                                                                                    add_child($$, $1);
                                                                                    add_brother_end($1, $2);
                                                                                }
    ;

Restart:    Empty                                                               { $$ = $1; }
    |       FunctionDefinition Restart                                          {
                                                                                    $$ = $1;
                                                                                    add_brother_end($$, $2);
                                                                                }
    |       FunctionDeclaration Restart                                         {
                                                                                    $$ = $1;
                                                                                    add_brother_end($$, $2);
                                                                                }
    |       Declaration Restart                                                 {
                                                                                    $$ = $1;
                                                                                    add_brother_end($$, $2);
                                                                                }
    ;

 //FunctionDefinition
FunctionDefinition: TypeSpec FunctionDeclarator FunctionBody                    {
                                                                                    $$ = create_simple_node("FuncDefinition");
                                                                                    add_child($$, $1);
                                                                                    add_brother_end($1,$2);
                                                                                    add_brother_end($1,$3);
                                                                                }
                ;

 //FunctionDeclaration
FunctionDeclaration: TypeSpec FunctionDeclarator SEMI                           {
                                                                                    $$ = create_simple_node("FuncDeclaration");
                                                                                    add_child($$, $2);
                                                                                    add_child($$, $1);
                                                                                }
                ;

 //FunctionDeclarator
FunctionDeclarator: ZMast ID LPAR ParameterList RPAR                            {
                                                                                    auxId = create_str_node("Id", $2);
                                                                                    if($1 != NULL) {
                                                                                        $$ = $1;
                                                                                        add_brother_end($$, auxId);
                                                                                        add_brother_end($$, $4);
                                                                                    } else {
                                                                                        $$ = auxId;
                                                                                        add_brother_end($$, $4);
                                                                                    }
                                                                                }
                ;

 //FunctionBody
FunctionBody: LBRACE Redeclaration ReSpecialStatement  RBRACE                   {
                                                                                    $$ = create_simple_node("FuncBody");
                                                                                    if($2 != NULL){
                                                                                        add_child($$, $2);
                                                                                        add_brother_end($2,$3);
                                                                                    }
                                                                                    else{
                                                                                        add_child($$, $3);
                                                                                    }


                                                                                }
        |     LBRACE error  RBRACE                                              { }
        ;

 //ParameterList
ParameterList: ParameterDeclaration CommaParameterDeclaration                   {
                                                                                    $$ = create_simple_node("ParamList");
                                                                                    add_child($$,$1);
                                                                                    add_brother_end($1,$2);
                                                                                }
            ;

 //ParameterDeclaration
ParameterDeclaration: TypeSpec ZMast ZUid                                       {
                                                                                    $$ = create_simple_node("ParamDeclaration");
                                                                                    add_child($$,$1);
                                                                                    add_brother_end($1,$2);
                                                                                    add_brother_end($1,$3);
                                                                                }
                ;

CommaParameterDeclaration:COMMA ParameterDeclaration CommaParameterDeclaration  {
                                                                                    $$ = $2;
                                                                                    add_brother_end($2,$3);
                                                                                }
                    |     Empty                                                 { $$ = $1; }
                    ;

 //Declaration
Declaration:    TypeSpec Declarator CommaDeclarator SEMI                        {
                                                                                    $$ = $2;

                                                                                    if($3 != NULL) {
                                                                                        add_brother_end($$, $3);
                                                                                    }

                                                                                    tree_node* aux = $$;
                                                                                    tree_node aux2 = *$1;
                                                                                    while(aux != NULL) {
                                                                                        aux2.next_brother = aux->luke;
                                                                                        aux2.darth_vader = aux;
                                                                                        aux->luke = (tree_node*) malloc(sizeof(tree_node));
                                                                                        *(aux->luke) = aux2;

                                                                                        aux = aux->next_brother;
                                                                                    }
                                                                                }
        |       error SEMI                                                      { }
        ;

Redeclaration:  Empty                                                           { $$ = $1; }
        |       Declaration Redeclaration                                       {
                                                                                    add_brother_end($$,$2);
                                                                                    $$ = $1;
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
                                                                                        add_brother_end(auxIntLit, auxId);
                                                                                    }
                                                                                }
        ;

CommaDeclarator:    Empty                                                       { $$ = $1; }
            |       COMMA Declarator CommaDeclarator                            {
                                                                                    $$ = $2;
                                                                                    add_brother_end($2, $3);

                                                                                }
            ;

 //Statement
Statement:      error SEMI                                                      { }
        |       StatementSpecial                                                { $$ = $1; }
        ;

StatementSpecial:   ZUExpr SEMI                                                 {
                                                                                    $$ = $1;
                                                                                }
        |           LBRACE StatList RBRACE                                      {
                                                                                    $$ = $2;
                                                                                }
        |           LBRACE Statement RBRACE                                     {
                                                                                    $$ = $2;
                                                                                }
        |           LBRACE RBRACE                                               { $$ = NULL; }
        |           LBRACE error RBRACE                                         {  }
        |           IF LPAR Expr RPAR Statement %prec "then"                    {
                                                                                    $$ = create_simple_node("If");
                                                                                    add_child($$,$3);
                                                                                    add_brother_end($$->luke,$5);
                                                                                    add_brother_end($$->luke, create_simple_node("Null")); /* porque if tem de ter 3 filhos*/
                                                                                }
        |           IF LPAR Expr RPAR Statement ELSE Statement                  {
                                                                                    $$ = create_simple_node("If");
                                                                                    add_child($$,$3);
                                                                                    add_brother_end($$->luke,$5);
                                                                                    add_brother_end($$->luke,$7);
                                                                                }
        |           FOR LPAR ZUExpr SEMI ZUExpr SEMI ZUExpr RPAR Statement      {
                                                                                    $$ = create_simple_node("For");
                                                                                    add_child($$,$3);
                                                                                    add_brother_end($$->luke,$5);
                                                                                    add_brother_end($$->luke,$7);
                                                                                    add_brother_end($$->luke,$9);
                                                                                }
        |           RETURN ZUExpr SEMI                                          {
                                                                                    $$ = create_simple_node("Return");
                                                                                    add_child($$,$2);
                                                                                }
        ;


StatList:       Statement Statement Restatement                                 {
                                                                                    $$ = create_simple_node("StatList");
                                                                                    add_child($$,$1);
                                                                                    add_brother_end($$->luke,$2);
                                                                                    add_brother_end($$->luke,$3);
                                                                                }
    ;

ReSpecialStatement: Empty                                                       { $$ = $1; }

                |   StatementSpecial ReSpecialStatement                         {
                                                                                    $$ = $1;
                                                                                    add_brother_end($$,$2);
                                                                                }
                ;

Restatement:    Empty                                                           { $$ = $1; }

        |       Statement Restatement                                           {
                                                                                    $$ = $1;
                                                                                    add_brother_end($$,$2);
                                                                                }
        ;

 //Expr
Expr:    ExprSpecial                                                            {
                                                                                    $$ = $1;
                                                                                }
    |    Expr COMMA ExprSpecial                                                 {
                                                                                    $$ = $3;
                                                                                }
    ;

ExprSpecial:    ExprSpecial ASSIGN ExprSpecial                                  {
                                                                                    $$ = create_simple_node("Store");
                                                                                    add_child($$,$1);
                                                                                    add_brother_end($1,$3);
                                                                                }

        |       ExprSpecial AND ExprSpecial                                     {
                                                                                    $$ = create_simple_node("And");
                                                                                    add_child($$,$1);
                                                                                    add_brother_end($1,$3);
                                                                                }


        |       ExprSpecial OR ExprSpecial                                      {
                                                                                    $$ = create_simple_node("Or");
                                                                                    add_child($$,$1);
                                                                                    add_brother_end($1,$3);
                                                                                }

        |       ExprSpecial EQ ExprSpecial                                      {
                                                                                    $$ = create_simple_node("Eq");
                                                                                    add_child($$,$1);
                                                                                    add_brother_end($1,$3);
                                                                                }

        |       ExprSpecial NE ExprSpecial                                      {
                                                                                    $$ = create_simple_node("Ne");
                                                                                    add_child($$,$1);
                                                                                    add_brother_end($1,$3);
                                                                                }

        |       ExprSpecial LT ExprSpecial                                      {
                                                                                    $$ = create_simple_node("Lt");
                                                                                    add_child($$,$1);
                                                                                    add_brother_end($1,$3);
                                                                                }
        |       ExprSpecial GT ExprSpecial                                      {
                                                                                    $$ = create_simple_node("Gt");
                                                                                    add_child($$,$1);
                                                                                    add_brother_end($1,$3);
                                                                                }
        |       ExprSpecial LE ExprSpecial                                      {
                                                                                    $$ = create_simple_node("Le");
                                                                                    add_child($$,$1);
                                                                                    add_brother_end($1,$3);
                                                                                }
        |       ExprSpecial GE ExprSpecial                                      {
                                                                                    $$ = create_simple_node("Ge");
                                                                                    add_child($$,$1);
                                                                                    add_brother_end($1,$3);
                                                                                }
        |       ExprSpecial PLUS ExprSpecial                                    {
                                                                                    $$ = create_simple_node("Add");
                                                                                    add_child($$,$1);
                                                                                    add_brother_end($1,$3);
                                                                                }
        |       ExprSpecial MINUS ExprSpecial                                   {
                                                                                    $$ = create_simple_node("Sub");
                                                                                    add_child($$,$1);
                                                                                    add_brother_end($1,$3);
                                                                                }
        |       ExprSpecial AST ExprSpecial                                     {
                                                                                    $$ = create_simple_node("Mul");
                                                                                    add_child($$,$1);
                                                                                    add_brother_end($1,$3);
                                                                                }
        |       ExprSpecial DIV ExprSpecial                                     {
                                                                                    $$ = create_simple_node("Div");
                                                                                    add_child($$,$1);
                                                                                    add_brother_end($1,$3);
                                                                                }
        |       ExprSpecial MOD ExprSpecial                                     {
                                                                                    $$ = create_simple_node("Mod");
                                                                                    add_child($$,$1);
                                                                                    add_brother_end($1,$3);
                                                                                }
        |       NOT ExprSpecial                                                 {
                                                                                    $$ = create_simple_node("Not");
                                                                                    add_child($$,$2);
                                                                                }
        |       MINUS ExprSpecial                                               {
                                                                                    $$ = create_simple_node("Minus");
                                                                                    add_child($$,$2);
                                                                                }
        |       PLUS ExprSpecial                                                {
                                                                                    $$ = create_simple_node("Plus");
                                                                                    add_child($$,$2);
                                                                                }
        |       AST ExprSpecial                                                 {
                                                                                    $$ = create_simple_node("Deref"); /* PODE ESTAR TROCADO COM O DE BAIXO*/
                                                                                    add_child($$,$2);
                                                                                }
        |       AMP ExprSpecial                                                 {
                                                                                    $$ = create_simple_node("Addr"); /* PODE ESTAR TROCADO COM O DE CIMA*/
                                                                                    add_child($$,$2);
                                                                                }
        |       ID                                                              {
                                                                                    $$ = create_str_node("Id",$1);
                                                                                }
        |       INTLIT                                                          {
                                                                                    $$ = create_int_node("IntLit",$1);
                                                                                }
        |       CHRLIT                                                          {
                                                                                    $$ = create_str_node("ChrLit",$1);
                                                                                }
        |       STRLIT                                                          {
                                                                                    $$ = create_str_node("StrLit",$1);
                                                                                }
        |       LPAR Expr RPAR                                                  {
                                                                                    $$ = $2;
                                                                                }
        |       LPAR error RPAR                                                 { }
        |       ID LPAR ZUExprZMComma RPAR                                      {
                                                                                    $$ = create_simple_node("Call");
                                                                                    add_child($$, create_str_node("Id",$1));
                                                                                    add_brother_end($$->luke,$3);
                                                                                }
        |       ID LPAR error RPAR                                              { }
        |       ExprSpecial LSQ Expr RSQ                                        {
                                                                                    $$ = create_simple_node("Deref");
                                                                                    add_child($$, create_simple_node("Add"));
                                                                                    add_child($$->luke,$1);
                                                                                    add_brother_end($$->luke->luke,$3);
                                                                                }
        ;

ZUExprZMComma:  Empty                                                           { $$ = $1; }
            |   ExprSpecial ZMComma                                             {
                                                                                    $$ = $1;
                                                                                    add_brother_end($$,$2);
                                                                                }
            ;

ZMComma:    Empty                                                               { $$ = $1; }
    |       COMMA ExprSpecial ZMComma                                           {
                                                                                    $$ = $2;
                                                                                    add_brother_end($$,$3);
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
ZUid:   Empty                                                                   { $$ = $1; }
    |   ID                                                                      {
                                                                                    $$ = create_str_node("Id",$1);
                                                                                }
    ;

ZUExpr: Empty                                                                   { $$ = create_simple_node("Null"); }
    |   Expr                                                                    {
                                                                                    $$ = $1;
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
    if(father->luke != NULL) {
        son->next_brother = father->luke;
        son->darth_vader = father;
        father->luke = son;
    } else {
        son->darth_vader = father;
        father->luke = son;
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

void add_brother_begining(tree_node* brother, tree_node* new_son) {
    tree_node* aux = brother;
    if(aux!= NULL && new_son != NULL) {
        brother = new_son;
        brother->next_brother = aux;
    }
}

void yyerror (char *s) {

    flag_error = 1;

    printf ("Line %d, col %d: %s: %s\n", yylineno, (int)(columnNumber - strlen(yytext)), s, yytext);
}
