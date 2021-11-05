%{
#include <math.h>
#include <stdio.h>
#include <stdlib.h>
#include "tree.h"
#include "rpn.h"

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

// Tree
t_tree tree;
t_tree_node* f_ptr;
t_tree_node* l_ptr;
t_tree_node* e_ptr;
t_tree_node* t_ptr;
t_tree_node* p_ptr;
t_tree_node* a_ptr;

// RPN
rpn_t *rpn;

int counter;

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
S: A {
  tree = a_ptr;
};

A: id op_assign P {
  // tree
  a_ptr = create_node(":=", create_leaf($1), p_ptr);

  // rpn
  add_lexeme_to_rpn(rpn, $1);
  add_lexeme_to_rpn(rpn, ":=");

  puts(rule[1]);
};
P: prom open_parent L close_parent {
  char counter_str[10];
  sprintf(counter_str, "%d", counter);

  // tree
  p_ptr = create_node("/", l_ptr, create_leaf(counter_str));

  // rpn
  add_lexeme_to_rpn(rpn, strdup(counter_str));
  add_lexeme_to_rpn(rpn, "/");

  puts(rule[2]);
};
L: L comma E {
  ++counter;

  // tree
  l_ptr = create_node("+", l_ptr, e_ptr);

  // rpn
  add_lexeme_to_rpn(rpn, "+");

  puts(rule[3]);
} | E {
  counter = 1;
  l_ptr = e_ptr;

  puts(rule[4]);
};
E: E op_sum T {
  // tree
  e_ptr = create_node("+", e_ptr, t_ptr);

  // rpn
  add_lexeme_to_rpn(rpn, "+");

  puts(rule[5]);
} | E op_sub T {
  // tree
  e_ptr = create_node("-", e_ptr, t_ptr);

  // rpn
  add_lexeme_to_rpn(rpn, "-");

  puts(rule[6]);
} | T {
  e_ptr = t_ptr;

  puts(rule[7]);
};
T: T op_mult F {
  // tree
  t_ptr = create_node("*", t_ptr, f_ptr);

  // rpn
  add_lexeme_to_rpn(rpn, "*");

  puts(rule[8]);
} | T op_div F {
  // tree
  t_ptr = create_node("/", t_ptr, f_ptr);

  // rpn
  add_lexeme_to_rpn(rpn, "/");

  puts(rule[9]);
} | F {
  t_ptr = f_ptr;

  puts(rule[10]);
};
F: id {
  char id_lex[100];

  strcpy(id_lex, $1);

  // tree
  f_ptr = create_leaf(id_lex);

  // rpn
  add_lexeme_to_rpn(rpn, strdup(id_lex));

  puts(rule[11]);
} | cte {
  char cte_lex[10];

  sprintf(cte_lex, "%d", $1);

  // tree
  f_ptr = create_leaf(cte_lex);

  // rpn
  add_lexeme_to_rpn(rpn, strdup(cte_lex));

  puts(rule[12]);
} | open_parent E close_parent {
  f_ptr = e_ptr;

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

  rpn = create_rpn();

  yyparse();

  save_postorder_in_file(a_ptr);
  save_rpn_in_file(rpn);

  fclose(yyin);

  return EXIT_SUCCESS;
}

int yyerror(char *error) {
  fprintf(stderr, COLOR_RED "\nline %d: %s\n" COLOR_RESET, lineno, error);
  fclose(yyin);
  exit(1);
}
