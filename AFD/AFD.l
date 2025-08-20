%{
#include "AFD.tab.h"
%}

%%
"estados: "                  return ESTADOS;
"alfabeto de entrada: "      return ALFABETO;
"funciones de transicion: "  return TRANSICIONES;
"estado inicial: "           return INICIAL;
"estado final: "             return FINAL;

"->"                        return ARROW;
":"                         return COLON;
[a-zA-Z0-9]+                { yylval.str=strdup(yytext); return WORD; }
[ \t\r\n]+                  /* Ignorar espacios en blanco */
.                           /* Ignorar otros caracteres */

%%

int yywrap(void) { return 1; }

