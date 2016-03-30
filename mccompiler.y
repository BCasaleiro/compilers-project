%{
    #include <stdio.h>
    #include <stdlib.h>
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



%right  ASSIGN
%right  NOT
%right  AST
%right  AMP
%right  PLUS
%right  MINUS
%left   LPAR
%left   RPAR
%left   LSQ
%left   RSQ
%left   GE
%left   LE
%left   GT
%left   LT
%left   EQ
%left   NE
%left   AND
%left   OR
%left   COMMA

%%
 //Start
Start:  Restart FunctionDefinition
    |   Restart FunctionDeclaration
    |   Restart Declaration
    ;

Restart:    Empty
    |       Restart FunctionDefinition
    |       Restart FunctionDeclaration
    |       Restart Declaration
    ;

 //FunctionDefinition
FunctionDefinition: TypeSpec FunctionDeclarator FunctionBody;

 //FunctionDeclaration
FunctionDeclaration: TypeSpec FunctionDeclarator SEMI;

 //FunctionDeclarator
FunctionDeclarator: ZMast ID LPAR ParameterList RPAR;

 //FunctionBody
FunctionBody: LBRACE Redeclaration Restatement  RBRACE;

 //ParameterList
ParameterList: ParameterDeclaration CommaParameterDeclaration;

 //ParameterDeclaration
ParameterDeclaration: TypeSpec ZMast ZUid;

CommaParameterDeclaration:  COMMA ParameterDeclaration CommaParameterDeclaration;
                        |   Empty
                        ;

 //Declaration
Declaration: TypeSpec Declarator CommaDeclarator SEMI;

Redeclaration:  Empty
        |       Redeclaration Declaration
        ;

 //TypeSpec
TypeSpec:   INT
   |       CHAR
   |       VOID
   ;

 //Declarator
Declarator: ZMast ID ArraySpecial;

CommaDeclarator: Empty | CommaDeclarator COMMA Declarator;

ArraySpecial: Empty | LSQ INTLIT RSQ;

 //Statement
Statement:  ZUExpr SEMI
        |   LBRACE Restatement RBRACE
        |   IF LPAR Expr RPAR Statement %prec "then"
        |   IF LPAR Expr RPAR Statement ELSE Statement
        |   FOR LPAR ZUExpr SEMI ZUExpr SEMI ZUExpr RPAR Statement
        |   RETURN ZUExpr SEMI
        ;

/*ElseStatement:  Empty
            |   ELSE Statement
            ;*/



Restatement:    Empty
        |       Restatement Statement
        ;

 //Expr

Expr:   /*Expr Symbol Expr    %prec "then"
    |*/   Expr ASSIGN Expr
    |   Expr COMMA Expr
    |   Expr AND Expr
    |   Expr OR Expr
    |   Expr EQ Expr
    |   Expr NE Expr
    |   Expr LT Expr
    |   Expr GT Expr
    |   Expr LE Expr
    |   Expr GE Expr
    |   Expr PLUS Expr
    |   Expr MINUS Expr
    |   Expr AST Expr
    |   Expr DIV Expr
    |   Expr MOD Expr
    |   NOT Expr
    |   MINUS Expr
    |   PLUS Expr
    |   AST Expr
    |   AMP Expr
    // |   ID LPAR ExprSpecial RPAR
    // |   ID
    // |   INTLIT
    // |   CHRLIT
    // |   STRLIT
    |   LPAR Expr RPAR
    ;


Symbol: ASSIGN
    |   COMMA
    |   AND
    |   OR
    |   EQ
    |   NE
    |   LT
    |   GT
    |   LE
    |   GE
    |   PLUS
    |   MINUS
    |   AST
    |   DIV
    |   MOD
    ;

ExprSpecial:    Empty
        |       Expr CommaExpr
        ;

CommaExpr:  Empty
        |   CommaExpr COMMA Expr
        ;

 //Caracteres repetidos

 //Zero ou mais AST
ZMast: Empty | ZMast AST;

 //Zero ou um ID
ZUid: Empty | ID;

ZUExpr: Empty | Expr;

 // Carateres especiais

Empty:  ;

%%

/* A função main() está do lado do lex */

/*
void yyerror (char *s) {
    printf ("Line %d, col %d: %s: %s\n", <num linha>, <num coluna>, s, yytext);
}
*/
