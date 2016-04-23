char buffer[20];

void test(void) {

}

int gdc(int a, int b) {

    int c, d;

    a = 1, b = 2, c = 3;

    &c;

    &(&d);

    &gdc();

    *a;

    **b;

    ***c;

    *gdc();

    if(!a) {

    }

    if(!1) {

    }

    if(-a) {

    }

    if(-1) {

    }

    if(+a) {

    }

    if(+1) {

    }

    if(a == 0 || a == 2) {
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
