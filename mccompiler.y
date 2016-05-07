%{
    #include <stdio.h>
    #include <stdlib.h>
    #include <string.h>
    #include "ast.h"

    extern int yylineno;
    extern char * yytext;

    extern int columnNumber;

    void print(char *s);
    void yyerror (char *s);
    extern int yylex();

    int flag_error = 0;
    int stat_list = 0;

    tree_node* root = NULL;

    tree_node* auxId = NULL;
    tree_node* auxNull = NULL;
    tree_node* auxIntLit = NULL;
    tree_node* auxChrLit = NULL;
    tree_node* auxStrLit = NULL;
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
    char*   intlit;
    char*   chrlit;
    char*   strlit;
    struct _tree_node* node;
}

%nonassoc "then"


%left COMMA
%right ASSIGN
%left OR
%left AND
%left EQ NE
%left GE LE GT LT
%left PLUS MINUS
%left AST DIV MOD
%nonassoc "pos" "neg" "pointer"
%right NOT AMP
%left LPAR RPAR LSQ RSQ LBRACE RBRACE
%nonassoc ELSE

%%
 //Start
Start:  FunctionDefinition Restart                                              {
                                                                                    $$ = create_simple_node("Program", yylineno, (int)(columnNumber));
                                                                                    root = $$;
                                                                                    if($1 != NULL) {
                                                                                        add_child($$, $1);
                                                                                        add_brother_end($1, $2);
                                                                                    }
                                                                                }
    |   FunctionDeclaration Restart                                             {
                                                                                    $$ = create_simple_node("Program", yylineno, (int)(columnNumber));
                                                                                    root = $$;
                                                                                    if($1 != NULL) {
                                                                                        add_child($$, $1);
                                                                                        add_brother_end($1, $2);
                                                                                    }
                                                                                }
    |   Declaration Restart                                                     {
                                                                                    $$ = create_simple_node("Program", yylineno, (int)(columnNumber));
                                                                                    root = $$;

                                                                                    if($1 != NULL) {
                                                                                        add_child($$, $1);
                                                                                        add_brother_end($1, $2);
                                                                                    }
                                                                                }
    ;

Restart:    Empty                                                               { $$ = $1; }
    |       FunctionDefinition Restart                                          {
                                                                                    $$ = $1;
                                                                                    if($1 != NULL) {
                                                                                        add_brother_end($1, $2);
                                                                                    }
                                                                                }
    |       FunctionDeclaration Restart                                         {
                                                                                    $$ = $1;
                                                                                    if($1 != NULL) {
                                                                                        add_brother_end($1, $2);
                                                                                    }
                                                                                }
    |       Declaration Restart                                                 {
                                                                                    $$ = $1;
                                                                                    if($1 != NULL) {
                                                                                        add_brother_end($1, $2);
                                                                                    }
                                                                                }
    ;

 //FunctionDefinition
FunctionDefinition: TypeSpec FunctionDeclarator FunctionBody                    {
                                                                                    $$ = create_simple_node("FuncDefinition", yylineno, (int)(columnNumber));
                                                                                    add_child($$, $1);
                                                                                    add_brother_end($1,$2);
                                                                                    add_brother_end($1,$3);
                                                                                }
                ;

 //FunctionDeclaration
FunctionDeclaration: TypeSpec FunctionDeclarator SEMI                           {
                                                                                    $$ = create_simple_node("FuncDeclaration", yylineno, (int)(columnNumber));
                                                                                    add_child($$, $1);
                                                                                    add_brother_end($$->luke,$2);
                                                                                }
                ;

 //FunctionDeclarator
FunctionDeclarator: ZMast ID LPAR ParameterList RPAR                            {
                                                                                    auxId = create_str_node("Id", $2, yylineno, (int)($4->col - strlen($2)));
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
                                                                                    $$ = create_simple_node("FuncBody", yylineno, (int)(columnNumber));
                                                                                    if($2 != NULL || $3 != NULL) {
                                                                                        if($2 != NULL){
                                                                                            add_child($$, $2);
                                                                                            add_brother_end($2,$3);
                                                                                        }
                                                                                        else{
                                                                                            add_child($$, $3);
                                                                                        }
                                                                                    }
                                                                                }
        |     LBRACE error  RBRACE                                              { $$ = NULL; }
        ;

 //ParameterList
ParameterList: ParameterDeclaration CommaParameterDeclaration                   {
                                                                                    $$ = create_simple_node("ParamList", yylineno, (int)($1->col - 1));
                                                                                    add_child($$,$1);
                                                                                    add_brother_end($1,$2);
                                                                                }
            ;

 //ParameterDeclaration
ParameterDeclaration: TypeSpec ZMast ZUid                                       {
                                                                                    $$ = create_simple_node("ParamDeclaration", yylineno, (int)(columnNumber - (columnNumber - $1->col)));
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
        |       error SEMI                                                      { $$ = NULL; }
        ;

Redeclaration:  Empty                                                           { $$ = $1; }
        |       Declaration Redeclaration                                       {
                                                                                    add_brother_end($$,$2);
                                                                                    $$ = $1;
                                                                                }
        ;

 //TypeSpec
TypeSpec:   INT                                                                 {
                                                                                    $$ = create_simple_node("Int", yylineno, (int)(columnNumber - 3));
                                                                                }
    |       CHAR                                                                {
                                                                                    $$ = create_simple_node("Char", yylineno, (int)(columnNumber - 4));
                                                                                }
    |       VOID                                                                {
                                                                                    $$ = create_simple_node("Void", yylineno, (int)(columnNumber - 4));
                                                                                }
    ;

 //Declarator
Declarator: ZMast ID                                                            {
                                                                                    $$ = create_simple_node("Declaration", yylineno, (int)(columnNumber));
                                                                                    auxId = create_str_node("Id", $2, yylineno, (int)(columnNumber - strlen($2) - 1));
                                                                                    if($1 != NULL) {
                                                                                        $$->luke = $1;
                                                                                        add_brother_end($$->luke, auxId);
                                                                                    } else {
                                                                                        add_child($$, auxId);
                                                                                    }
                                                                                }
        |   ZMast ID LSQ INTLIT RSQ                                             {
                                                                                    $$ = create_simple_node("ArrayDeclaration", yylineno, (int)(columnNumber));
                                                                                    auxId = create_str_node("Id", $2, yylineno, (int)(columnNumber - strlen($2) - strlen($4) - 2));
                                                                                    auxIntLit = create_str_node("IntLit", $4, yylineno, (int)(columnNumber - strlen($4)));
                                                                                    if($1 != NULL) {
                                                                                        $$->luke = $1;
                                                                                        add_brother_end($$->luke, auxId);
                                                                                        add_brother_end($$->luke, auxIntLit);
                                                                                    } else {

                                                                                        add_child($$, auxId);
                                                                                        add_brother_end(auxId, auxIntLit);
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
Statement:      error SEMI                                                      { $$ = NULL; }
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
        |           LBRACE error RBRACE                                         { $$ = NULL; }
        |           IF LPAR Expr RPAR Statement %prec "then"                    {
                                                                                    if($3 != NULL) {
                                                                                        $$ = create_simple_node("If", yylineno, (int)(columnNumber));

                                                                                        add_child($$,$3);
                                                                                        if($5 != NULL) {
                                                                                            add_brother_end($3,$5);
                                                                                        } else {
                                                                                            add_brother_end($3,create_simple_node("Null", yylineno, (int)(columnNumber)));
                                                                                        }
                                                                                        add_brother_end($3,create_simple_node("Null", yylineno, (int)(columnNumber)));
                                                                                    } else {
                                                                                        $$ = NULL;
                                                                                    }
                                                                                    // add_brother_end($$->luke, create_simple_node("Null")); /* porque if tem de ter 3 filhos*/
                                                                                }
        |           IF LPAR Expr RPAR Statement ELSE Statement                  {
                                                                                    if( $3 != NULL ) {
                                                                                        $$ = create_simple_node("If", yylineno, (int)(columnNumber));
                                                                                        add_child($$, $3);
                                                                                        if($5 != NULL) {
                                                                                            add_brother_end($3,$5);
                                                                                        } else {
                                                                                            add_brother_end($3,create_simple_node("Null", yylineno, (int)(columnNumber)));
                                                                                        }

                                                                                        if($7 != NULL) {
                                                                                            add_brother_end($3,$7);
                                                                                        } else {
                                                                                            add_brother_end($3,create_simple_node("Null", yylineno, (int)(columnNumber)));
                                                                                        }
                                                                                    } else {
                                                                                        $$ = NULL;
                                                                                    }
                                                                                }
        |           FOR LPAR ZUExpr SEMI ZUExpr SEMI ZUExpr RPAR Statement      {
                                                                                    $$ = create_simple_node("For", yylineno, (int)(columnNumber));
                                                                                    if($3 != NULL) {
                                                                                        add_child($$,$3);
                                                                                    } else {
                                                                                        auxNull = create_simple_node("Null", yylineno, (int)(columnNumber));
                                                                                        add_child($$,auxNull);
                                                                                    }
                                                                                    if ($5 != NULL) {
                                                                                        add_brother_end($$->luke,$5);
                                                                                    } else {
                                                                                        auxNull = create_simple_node("Null", yylineno, (int)(columnNumber));
                                                                                        add_brother_end($$->luke,auxNull);
                                                                                    }
                                                                                    if ($7 != NULL) {
                                                                                        add_brother_end($$->luke,$7);
                                                                                    } else {
                                                                                        auxNull = create_simple_node("Null", yylineno, (int)(columnNumber));
                                                                                        add_brother_end($$->luke,auxNull);
                                                                                    }
                                                                                    if($9 != NULL) {
                                                                                        add_brother_end($$->luke,$9);
                                                                                    } else {
                                                                                        auxNull = create_simple_node("Null", yylineno, (int)(columnNumber));
                                                                                        add_brother_end($$->luke,auxNull);
                                                                                    }
                                                                                }
        |           RETURN ZUExpr SEMI                                          {
                                                                                    $$ = create_simple_node("Return", yylineno, (int)(columnNumber));
                                                                                    if($2 == NULL){
                                                                                        add_child($$, create_simple_node("Null", yylineno, (int)(columnNumber)));
                                                                                    }
                                                                                    else{
                                                                                        add_child($$,$2);
                                                                                    }

                                                                                }
        ;


StatList:       Statement Statement Restatement                                 {
                                                                                    int stat_num = 0;
                                                                                    tree_node * stat_aux = $3;
                                                                                    while (stat_aux != NULL) {
                                                                                        stat_num +=1;
                                                                                        stat_aux = stat_aux -> next_brother;
                                                                                    }
                                                                                    if($1 != NULL && $2 != NULL) {
                                                                                        $$ = create_simple_node("StatList", yylineno, (int)(columnNumber));
                                                                                        add_child($$,$1);
                                                                                        add_brother_end($$->luke,$2);
                                                                                        add_brother_end($$->luke,$3);
                                                                                    } else {
                                                                                        if($1 != NULL && $2 == NULL && stat_num >=1) {
                                                                                            $$ = create_simple_node("StatList", yylineno, (int)(columnNumber));
                                                                                            add_child($$,$1);
                                                                                            add_brother_end($$->luke, $3);
                                                                                        }else if($2 != NULL && $1 == NULL && stat_num >=1){
                                                                                            $$ = create_simple_node("StatList", yylineno, (int)(columnNumber));
                                                                                            add_child($$,$2);
                                                                                            add_brother_end($$->luke, $3);
                                                                                        }else if($2 != NULL && $1 == NULL) {
                                                                                            $$ = $2;
                                                                                            add_brother_end($$, $3);
                                                                                        }else if($1 != NULL && $2 == NULL){
                                                                                            $$ = $1;
                                                                                            add_brother_end($$, $3);
                                                                                        }else if($2 == NULL && $1 == NULL && stat_num >=2) {
                                                                                            $$ = create_simple_node("StatList", yylineno, (int)(columnNumber));
                                                                                            add_child($$,$3);
                                                                                        }
                                                                                    }
                                                                                }
    ;

ReSpecialStatement: Empty                                                       { $$ = $1; }

                |   StatementSpecial ReSpecialStatement                         {
                                                                                    if($1 != NULL){
                                                                                        $$ = $1;
                                                                                        add_brother_end($$,$2);
                                                                                    }
                                                                                    else{
                                                                                        $$ = $2;
                                                                                    }
                                                                                }
                ;

Restatement:    Empty                                                           { $$ = $1; }

        |       Statement Restatement                                           {
                                                                                    if($1 != NULL){
                                                                                        $$ = $1;
                                                                                        add_brother_end($$,$2);
                                                                                    }
                                                                                    else{
                                                                                        $$ = $2;
                                                                                    }
                                                                                }
        ;

 //Expr
Expr:    ExprSpecial                                                            {
                                                                                    $$ = $1;
                                                                                }
    |    Expr COMMA ExprSpecial                                                 {
                                                                                    $$ = create_simple_node("Comma", yylineno, (int)(columnNumber));
                                                                                    add_child($$,$1);
                                                                                    add_brother_end($$->luke,$3);
                                                                                }
    ;

ExprSpecial:    ExprSpecial ASSIGN ExprSpecial                                  {
                                                                                    $$ = create_simple_node("Store", yylineno, (int)(columnNumber));
                                                                                    add_child($$,$1);
                                                                                    add_brother_end($1,$3);
                                                                                }

        |       ExprSpecial AND ExprSpecial                                     {
                                                                                    $$ = create_simple_node("And", yylineno, (int)(columnNumber));
                                                                                    add_child($$,$1);
                                                                                    add_brother_end($1,$3);
                                                                                }


        |       ExprSpecial OR ExprSpecial                                      {
                                                                                    $$ = create_simple_node("Or", yylineno, (int)(columnNumber));
                                                                                    add_child($$,$1);
                                                                                    add_brother_end($1,$3);
                                                                                }

        |       ExprSpecial EQ ExprSpecial                                      {
                                                                                    $$ = create_simple_node("Eq", yylineno, (int)(columnNumber));
                                                                                    add_child($$,$1);
                                                                                    add_brother_end($1,$3);
                                                                                }

        |       ExprSpecial NE ExprSpecial                                      {
                                                                                    $$ = create_simple_node("Ne", yylineno, (int)(columnNumber));
                                                                                    add_child($$,$1);
                                                                                    add_brother_end($1,$3);
                                                                                }

        |       ExprSpecial LT ExprSpecial                                      {
                                                                                    $$ = create_simple_node("Lt", yylineno, (int)(columnNumber));
                                                                                    add_child($$,$1);
                                                                                    add_brother_end($1,$3);
                                                                                }
        |       ExprSpecial GT ExprSpecial                                      {
                                                                                    $$ = create_simple_node("Gt", yylineno, (int)(columnNumber));
                                                                                    add_child($$,$1);
                                                                                    add_brother_end($1,$3);
                                                                                }
        |       ExprSpecial LE ExprSpecial                                      {
                                                                                    $$ = create_simple_node("Le", yylineno, (int)(columnNumber));
                                                                                    add_child($$,$1);
                                                                                    add_brother_end($1,$3);
                                                                                }
        |       ExprSpecial GE ExprSpecial                                      {
                                                                                    $$ = create_simple_node("Ge", yylineno, (int)(columnNumber));
                                                                                    add_child($$,$1);
                                                                                    add_brother_end($1,$3);
                                                                                }
        |       ExprSpecial PLUS ExprSpecial                                    {
                                                                                    $$ = create_simple_node("Add", yylineno, (int)(columnNumber));
                                                                                    add_child($$,$1);
                                                                                    add_brother_end($1,$3);
                                                                                }
        |       ExprSpecial MINUS ExprSpecial                                   {
                                                                                    $$ = create_simple_node("Sub", yylineno, (int)(columnNumber));
                                                                                    add_child($$,$1);
                                                                                    add_brother_end($1,$3);
                                                                                }
        |       ExprSpecial AST ExprSpecial                                     {
                                                                                    $$ = create_simple_node("Mul", yylineno, (int)(columnNumber));
                                                                                    add_child($$,$1);
                                                                                    add_brother_end($1,$3);
                                                                                }
        |       ExprSpecial DIV ExprSpecial                                     {
                                                                                    $$ = create_simple_node("Div", yylineno, (int)(columnNumber));
                                                                                    add_child($$,$1);
                                                                                    add_brother_end($1,$3);
                                                                                }
        |       ExprSpecial MOD ExprSpecial                                     {
                                                                                    $$ = create_simple_node("Mod", yylineno, (int)(columnNumber));
                                                                                    add_child($$,$1);
                                                                                    add_brother_end($1,$3);
                                                                                }
        |       NOT ExprSpecial                                                 {
                                                                                    $$ = create_simple_node("Not", yylineno, (int)(columnNumber));
                                                                                    add_child($$,$2);
                                                                                }
        |       MINUS ExprSpecial %prec "neg"                                   {
                                                                                    $$ = create_simple_node("Minus", yylineno, (int)(columnNumber));
                                                                                    add_child($$,$2);
                                                                                }
        |       PLUS ExprSpecial %prec "pos"                                    {
                                                                                    printf("%d %d\n", columnNumber, $2->col - 1);
                                                                                    $$ = create_simple_node("Plus", yylineno, (int)(columnNumber));
                                                                                    add_child($$,$2);
                                                                                }
        |       AST ExprSpecial %prec "pointer"                                 {

                                                                                    $$ = create_simple_node("Deref", yylineno, (int)(columnNumber));
                                                                                    add_child($$,$2);
                                                                                }
        |       AMP ExprSpecial                                                 {
                                                                                    $$ = create_simple_node("Addr", yylineno, (int)(columnNumber));
                                                                                    add_child($$,$2);
                                                                                }
        |       ID                                                              {
                                                                                    $$ = create_str_node("Id",$1, yylineno, (int)(columnNumber - strlen($1)));
                                                                                }
        |       INTLIT                                                          {
                                                                                    $$ = create_str_node_with_type("IntLit",$1, "int", yylineno, (int)(columnNumber - strlen($1)));
                                                                                }
        |       CHRLIT                                                          {
                                                                                    $$ = create_str_node_with_type("ChrLit",$1, "int", yylineno, (int)(columnNumber - strlen($1)));
                                                                                }
        |       STRLIT                                                          {
                                                                                    $$ = create_strlit_node("StrLit",$1, "char", yylineno, (int)(columnNumber - strlen($1)));
                                                                                }
        |       LPAR Expr RPAR                                                  {
                                                                                    $$ = $2;
                                                                                }
        |       LPAR error RPAR                                                 { $$ = NULL; }
        |       ID LPAR ZUExprZMComma RPAR                                      {
                                                                                    $$ = create_simple_node("Call", yylineno, (int)(columnNumber));
                                                                                    if($3 != NULL) {
                                                                                        add_child($$, create_str_node( "Id",$1, yylineno, (int)($3->col - strlen($1) - 2) ));
                                                                                    } else {
                                                                                        add_child($$, create_str_node( "Id",$1, yylineno, (int)(columnNumber - strlen($1) - 2) ));
                                                                                    }

                                                                                    add_brother_end($$->luke,$3);
                                                                                }
        |       ID LPAR error RPAR                                              { $$ = NULL; }
        |       ExprSpecial LSQ Expr RSQ                                        {
                                                                                    $$ = create_simple_node("Deref", yylineno, (int)(columnNumber));
                                                                                    add_child($$, create_simple_node("Add", yylineno, (int)(columnNumber)));
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
                                                                                    $$ = create_simple_node("Pointer", yylineno, (int)(columnNumber - 1));
                                                                                    $$->next_brother = $1;
                                                                                }
    ;

 //Zero ou um ID
ZUid:   Empty                                                                   { $$ = $1; }
    |   ID                                                                      {
                                                                                    $$ = create_str_node("Id",$1, yylineno, (int)(columnNumber - strlen($1)));
                                                                                }
    ;

ZUExpr: Empty                                                                   { $$ = NULL; }
    |   Expr                                                                    {
                                                                                    $$ = $1;
                                                                                }
    ;

 // Carateres especiais

Empty:                                                                          { $$ = NULL; }
    ;

%%

/* A função main() está do lado do lex */

void yyerror (char *s) {

    flag_error = 1;

    printf ("Line %d, col %d: %s: %s\n", yylineno, (int)(columnNumber - strlen(yytext)), s, yytext);
}
