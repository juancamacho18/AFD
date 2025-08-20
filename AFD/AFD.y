%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int yylex(void);
int yyerror(const char *s);

typedef struct Node {
    char *str;
    struct Node *next;
} Node;

Node *estados = NULL, *alfabeto = NULL, *finales = NULL;
char *estado_inicial = NULL;

typedef struct Trans {
    char *origen, *simbolo, *destino;
    struct Trans *next;
} Trans;

Trans *transiciones = NULL;

void add_node(Node **list, char *s) {
    Node *n = malloc(sizeof(Node));
    n->str = strdup(s);
    n->next = *list;
    *list = n;
}

void add_trans(char *o, char *sym, char *d) {
    Trans *t = malloc(sizeof(Trans));
    t->origen = strdup(o);
    t->simbolo = strdup(sym);
    t->destino = strdup(d);
    t->next = transiciones;
    transiciones = t;
}
%}

%union {
    char *str;
    struct Node *node;
}

%token <str> WORD
%token ESTADOS ALFABETO TRANSICIONES INICIAL FINAL ARROW COLON
%type <node> list

%%

config:
    sections
    ;

sections:
    section
  | section sections
  ;

section:
    ESTADOS list       { for (Node *n = $2; n; n = n->next) add_node(&estados, n->str); }
  | ALFABETO list     { for (Node *n = $2; n; n = n->next) add_node(&alfabeto, n->str); }
  | TRANSICIONES trans_list
  | INICIAL WORD     { estado_inicial = strdup($2); }
  | FINAL list       { for (Node *n = $2; n; n = n->next) add_node(&finales, n->str); }
  ;

list:
    WORD list {
        Node *n = malloc(sizeof(Node));
        n->str = strdup($1);
        n->next = $2;
        $$ = n;
    }
  | WORD {
        Node *n = malloc(sizeof(Node));
        n->str = strdup($1);
        n->next = NULL;
        $$ = n;
    }
  ;

trans_list:
    WORD ARROW WORD COLON WORD { add_trans($1, $5, $3); }
  | WORD ARROW WORD COLON WORD trans_list { add_trans($1, $5, $3); }
  ;

%%

int yyerror(const char *s) {
    fprintf(stderr, "Error: %s\n", s);
    return 0;
}

