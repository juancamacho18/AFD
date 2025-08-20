#include <stdio.h>
#include <stdlib.h>
#include <string.h>

typedef struct Node {
    char *str;
    struct Node *next;
} Node;

typedef struct Trans {
    char *origen, *simbolo, *destino;
    struct Trans *next;
} Trans;

extern Node *estados, *alfabeto, *finales;
extern char *estado_inicial;
extern Trans *transiciones;
extern int yyparse();
extern FILE *yyin;

char* transicion(char *st, char sym) {
    char syms[2]={sym, '\0'};
    for (Trans *t=transiciones; t; t=t->next)
        if (!strcmp(t->origen, st) && !strcmp(t->simbolo, syms))
            return t->destino;
    return NULL;
}

int es_final(char *st) {
    for (Node *f=finales; f; f=f->next)
        if (!strcmp(f->str, st)) return 1;
    return 0;
}

int main(int argc, char **argv) {
    if (argc<3) {
        fprintf(stderr, "Uso: %s <conf.txt> <cadenas.txt>\n", argv[0]);
        return 1;
    }

    yyin=fopen(argv[1], "r");
    if (!yyin) { perror("Error conf"); return 1; }
    yyparse();
    fclose(yyin);

    FILE *fc=fopen(argv[2], "r");
    if (!fc) { perror("Error cadenas"); return 1; }

    char buf[1024];
    while (fgets(buf, sizeof(buf), fc)) {
        char *p=strtok(buf, "\r\n");
        if (!p || !*p) continue;

        char *actual=estado_inicial;
        int valido=1;
        for (char *c=p; *c; c++) {
            char *sig=transicion(actual, *c);
            if (!sig) { valido=0; break; }
            actual=sig;
        }

        printf("%s\n", (valido && es_final(actual))? "aceptado" : "No aceptado");

    }

    fclose(fc);
    return 0;
}

