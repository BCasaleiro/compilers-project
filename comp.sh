lex mccompiler.l
yacc -d mccompiler.y
gcc -g -c util.c -o  util -std=gnu99
gcc -g -c ast.c -o ast -std=gnu99
gcc -g -c symbol_table.c -o symbol_table -std=gnu99
gcc -g -c semantics.c -o semantics -std=gnu99
gcc -g -c code_gen.c -o code_gen -std=gnu99
gcc -o mccompiler y.tab.c lex.yy.c ast symbol_table semantics util code_gen -ll -ly
zip mccompiler.zip mccompiler.l mccompiler.y ast.h ast.c semantics.h semantics.c symbol_table.h symbol_table.c util.h util.c
zip mpacompiler.zip mccompiler.l mccompiler.y ast.h ast.c semantics.h semantics.c symbol_table.h symbol_table.c util.h util.c
