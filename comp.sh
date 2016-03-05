lex mccompiler.l
cc -o mccompiler lex.yy.c -ll
zip mccompiler.zip mccompiler.l
