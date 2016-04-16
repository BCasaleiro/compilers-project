lex mccompiler.l
yacc -d mccompiler.y
cc -o mccompiler y.tab.c lex.yy.c ast.c  -ll -ly
zip mccompiler.zip mccompiler.l mccompiler.y ast.h ast.c
