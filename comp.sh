lex mccompiler.l
yacc -d mccompiler.y
gcc -g -c util.c -o util
gcc -g -c ast.c -o ast
gcc -g -c symbol_table.c -o symbol_table
gcc -g -c semantics.c -o semantics
gcc -o mccompiler y.tab.c lex.yy.c ast symbol_table semantics util -ll -ly
zip mccompiler.zip mccompiler.l mccompiler.y ast.h ast.c semantics.h semantics.c symbol_table.h symbol_table.c util.h util.c
