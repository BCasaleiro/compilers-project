%{
    #include <stdio.h>
    #include <stdlib.h>

    extern int yylineno;
    extern int yyleng;
    extern int columnNumber;
    extern char * yytext;

    void yyerror (char *s);
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

%start Start
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
FunctionBody: LBRACE Redeclaration ReSpecialStatement  RBRACE
        |     LBRACE error  RBRACE
        ;

 //ParameterList
ParameterList: ParameterDeclaration CommaParameterDeclaration;

 //ParameterDeclaration
ParameterDeclaration: TypeSpec ZMast ZUid;

CommaParameterDeclaration:  COMMA ParameterDeclaration CommaParameterDeclaration;
                        |   Empty
                        ;

 //Declaration
Declaration:    TypeSpec Declarator CommaDeclarator SEMI
        |       error SEMI
        ;

Redeclaration:  Empty
        |       Declaration Redeclaration
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
Statement:      error SEMI
        |       StatementSpecial
        ;

StatementSpecial:   ZUExpr SEMI
        |           LBRACE error RBRACE
        |           LBRACE Restatement RBRACE
        |           IF LPAR Expr RPAR Statement %prec "then"
        |           IF LPAR Expr RPAR Statement ELSE Statement
        |           FOR LPAR ZUExpr SEMI ZUExpr SEMI ZUExpr RPAR Statement
        |           RETURN ZUExpr SEMI
        ;

// UMStatement: Statement | Statement UMStatement;

ReSpecialStatement: Empty
                |   StatementSpecial ReSpecialStatement;
                ;

Restatement:    Empty
        |       Statement Restatement
        ;

 //Expr
Expr:    ExprSpecial
    |    Expr COMMA ExprSpecial
    ;

ExprSpecial:    ExprSpecial ASSIGN ExprSpecial
        |       ExprSpecial AND ExprSpecial
        |       ExprSpecial OR ExprSpecial
        |       ExprSpecial EQ ExprSpecial
        |       ExprSpecial NE ExprSpecial
        |       ExprSpecial LT ExprSpecial
        |       ExprSpecial GT ExprSpecial
        |       ExprSpecial LE ExprSpecial
        |       ExprSpecial GE ExprSpecial
        |       ExprSpecial PLUS ExprSpecial
        |       ExprSpecial MINUS ExprSpecial
        |       ExprSpecial AST ExprSpecial
        |       ExprSpecial DIV ExprSpecial
        |       ExprSpecial MOD ExprSpecial
        |       NOT ExprSpecial
        |       MINUS ExprSpecial
        |       PLUS ExprSpecial
        |       AST ExprSpecial
        |       AMP ExprSpecial
        |       ID
        |       INTLIT
        |       CHRLIT
        |       STRLIT
        |       LPAR Expr RPAR
        |       LPAR error RPAR
        |       ID LPAR ZUExprZMComma RPAR
        |       ID LPAR error RPAR
        |       ExprSpecial LSQ Expr RSQ
        ;

ZUExprZMComma:  Empty
            |   ExprSpecial ZMComma
            ;

ZMComma:    Empty
    |       ZMComma COMMA ExprSpecial
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


void yyerror (char *s) {
    printf ("Line %d, col %d: %s: %s\n", yylineno, columnNumber-yyleng, s, yytext);
}
