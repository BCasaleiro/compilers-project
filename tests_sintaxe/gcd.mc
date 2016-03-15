char buffer[20];
int main(int argc, char **argv) {
    int a, b;
    a = atoi(argv[1]);
    b = atoi(argv[2]);
    if (a == 0) {
        puts(itoa(b, buffer));
    } else {
NOTA: As regras “Declaration → error SEMI” e “Statement → error SEMI” poderão
dar origem a um conflito reduce/reduce no FunctionBody, uma vez que a ocorrência de um erro nas declarações tanto pode ser entendida como uma Declaration ou como o
primeiro Statement. Neste caso deve ser dada preferência à Declaration.
for ( ; b > 0 ; )
            if (a > b)
a = a-b; else
                b = b-a;
        puts(itoa(a, buffer));
}
return 0; }
