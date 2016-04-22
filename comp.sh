lex mccompiler.l
yacc -d mccompiler.y
cc -o mccompiler y.tab.c lex.yy.c ast.c symbol_table.c semantics.c util.c -ll -ly
zip mccompiler.zip mccompiler.l mccompiler.y ast.h ast.c semantics.h semantics.c symbol_table.h symbol_table.c util.h util.c
