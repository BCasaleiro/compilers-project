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
    char* id;
    int   intlit;
    char*  chrlit;
    char* strlit;
}

%right  ASSIGN NOT AST AMP PLUS MINUS
%left   LPAR RPAR LSQ RSQ GE LE GT LT EQ NE AND OR COMMA

%%
 //Start
Start:  Restart FunctionDefinition
    |   Restart FunctionDeclaration
    |   Restart Declaration
    ;

Restart: Restart Start
    |    Empty
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

Redeclaration: Empty | Redeclaration Declaration;

 //TypeSpec
TypeSpec: CHAR | INT | VOID;

 //Declarator
Declarator: ZMast ID ArraySpecial;

CommaDeclarator: Empty | CommaDeclarator COMMA Declarator;

ArraySpecial: Empty | LSQ INTLIT RSQ;

 //Statement
Statement:  ZUExpr SEMI
        |   LBRACE Restatement RBRACE
        |   IF LPAR Expr RPAR Statement ElseStatement
        |   FOR LPAR ZUExpr SEMI ZUExpr SEMI ZUExpr RPAR Statement
        |   RETURN ZUExpr SEMI
        ;

ElseStatement: Empty | ELSE Statement;

Restatement: Empty | Restatement Statement;

 //Expr
Expr:   Expr Assignment Expr
    |   Expr Options Expr
    |   Expr Comparison Expr
    |   Expr Math Expr
    |   Aggregation Expr
    |   Expr LSQ Expr RSQ
    |   ID LPAR ExprSpecial RPAR
    |   ID | INTLIT | CHRLIT | STRLIT | LPAR Expr RPAR
    ;

ExprSpecial: Empty | Expr CommaExpr;

CommaExpr: Empty | CommaExpr COMMA Expr;

 //Caracteres repetidos

 //Zero ou mais AST
ZMast: Empty | ZMast AST;

 //Zero ou um ID
ZUid: Empty | ID;

ZUExpr: Empty | Expr;

 // Carateres especiais
Assignment: ASSIGN | COMMA;

Options: AND | OR;

Comparison: EQ | NE | LT | GT | LE | GE;

Math: PLUS | MINUS | AST | DIV | MOD;

Aggregation: AMP | AST | PLUS | MINUS | NOT;

Empty:  ;

%%

/* A função main() está do lado do lex */

/*
void yyerror (char *s) {
    printf ("Line %d, col %d: %s: %s\n", <num linha>, <num coluna>, s, yytext);
}
*/
