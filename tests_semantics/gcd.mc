char buffer[20];

int gdc(int a, int b);
void ola(void);

int main(int argc, char **argv) {
    int a, b;
    if (argc > 2) {
        a = atoi(argv[1]);
        b = atoi(argv[2]);
        puts(itoa(gdc(a, b), buffer));
    } else
        puts("Error: two parameters required.");
    return 0;
}

int gdc(int a, int b) {
    if(a == 0) {
        return b;
    } else {
        for ( ; b > 0 ; )
            if ( a > b )
                a = a - b;
            else
                b = b - a;
        return a;
    }
}

void ola(void) {

}
