%{
#include <math.h>
#include <stdio.h>
#include <stdlib.h>
#include "tree.h"

#define COLOR_RED "\033[1;31m"
#define COLOR_RESET "\033[0m"

int lineno;

int yystopparser = 0;

FILE *yyin;

char *yyltext;
char *yytext;

char* rule[14] = {
  "R0. S -> A",
  "R1. A -> id := P",
  "R2. P -> prom ( L )",
  "R3. L -> L, E",
  "R4. L -> E",
  "R5. E -> E + T",
  "R6. E -> E - T",
  "R7. E -> T",
  "R8. T -> T * F",
  "R9. T -> T / F",
  "R10. T -> F",
  "R11. F -> id",
  "R12. F -> cte",
  "R13. F -> ( E )"
};

int yylex();
int yyerror(char *);
%}

%union {
  int int_val;
  char *str_val;
}

%token open_parent close_parent

%token prom
%token comma
%token op_sum op_sub op_mult op_div
%token op_assign
%token <str_val> id
%token <int_val> cte

%%
A: id op_assign P {
  puts(rule[1]);
};
P: prom open_parent L close_parent {
  puts(rule[2]);
};
L: L comma E {
  puts(rule[3]);
} | E {
  puts(rule[4]);
};
E: E op_sum T {
  puts(rule[5]);
} | E op_sub T {
  puts(rule[6]);
} | T {
  puts(rule[7]);
};
T: T op_mult F {
  puts(rule[8]);
} | T op_div F {
  puts(rule[9]);
} | F {
  puts(rule[10]);
};
F: id {
  char* id_lex = $1;
  create_leaf((void*)id_lex);

  puts(rule[11]);
} | cte {
  int cte_lex = $1;
  create_leaf(&cte_lex);

  puts(rule[12]);
} | open_parent E close_parent {
  puts(rule[13]);
};
%%

int main(int argc,char *argv[]) {
  const char* filename = argv[1];
  FILE* arg_file = fopen(filename, "rt");

  if (arg_file == NULL ) {
    printf("File cannot be opened: %s\n", filename);
    printf("Using standard input\n\n");
  }
  else {
    yyin = arg_file;
  }

  yyparse();

  fclose(yyin);

  return EXIT_SUCCESS;
}

int yyerror(char *error) {
  fprintf(stderr, COLOR_RED "\nline %d: %s\n" COLOR_RESET, lineno, error);
  fclose(yyin);
  exit(1);
}
