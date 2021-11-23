%{
#include <math.h>
#include <stdio.h>
#include <stdlib.h>
#include "tree.h"
#include "rpn.h"
#include "tac.h"

#define COLOR_RED "\033[1;31m"
#define COLOR_RESET "\033[0m"

#define FILENAME "2"

int lineno;

int yystopparser = 0;

FILE *yyin;

char *yyltext;
char *yytext;

char* rule[20] = {
  "R0. T -> S",
  "R1. S -> S R",
  "R2. S -> R",
  "R3. R -> A",
  "R4. R -> A semicolon",
  "R5. A -> id := P",
  "R6. A -> id := E",
  "R7. A -> id := A",
  "R8. P -> prom ( L )",
  "R9. L -> L, E",
  "R10. L -> E",
  "R11. E -> E + T",
  "R12. E -> E - T",
  "R13. E -> T",
  "R14. T -> T * F",
  "R15. T -> T / F",
  "R16. T -> F",
  "R17. F -> id",
  "R18. F -> cte",
  "R19. F -> ( E )"
};

// Tree
t_tree tree;
t_tree_node* s_ptr;
t_tree_node* f_ptr;
t_tree_node* l_ptr;
t_tree_node* e_ptr;
t_tree_node* t_ptr;
t_tree_node* p_ptr;
t_tree_node* a_ptr;

// RPN
rpn_t *rpn;

// TAC
tac_t* f_ind;
tac_t* l_ind;
tac_t* e_ind;
tac_t* t_ind;
tac_t* p_ind;
tac_t* a_ind;

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
%token semicolon
%token op_sum op_sub op_mult op_div
%token op_assign
%token <str_val> id
%token <int_val> cte

%%
S: S R {
  s_ptr = create_node(";", s_ptr, a_ptr);

  tree = s_ptr;
  
  puts(rule[1]);
} | R {
  s_ptr = a_ptr;

  tree = s_ptr;

  puts(rule[2]);
};

R: A {
  puts(rule[3]);
} | A semicolon {
  puts(rule[4]);
};

A: id op_assign P {
  // tree
  a_ptr = create_node(":=", create_leaf($1), p_ptr);

  // rpn
  add_lexeme_to_rpn(rpn, $1);
  add_lexeme_to_rpn(rpn, ":=");

  // tac
  a_ind = create_tac(":=", create_tac($1, NULL, NULL), p_ind);

  puts(rule[5]);
} | id op_assign E {
  // tree
  a_ptr = create_node(":=", create_leaf($1), e_ptr);

  // rpn
  add_lexeme_to_rpn(rpn, $1);
  add_lexeme_to_rpn(rpn, ":=");

  // tac
  a_ind = create_tac(":=", create_tac($1, NULL, NULL), e_ind);

  puts(rule[6]);
} | id op_assign A {
  // tree
  a_ptr = create_node(":=", create_leaf($1), a_ptr);

  // rpn
  add_lexeme_to_rpn(rpn, $1);
  add_lexeme_to_rpn(rpn, ":=");

  // tac
  a_ind = create_tac(":=", create_tac($1, NULL, NULL), a_ind);

  puts(rule[7]);
};

P: prom open_parent L close_parent {
  char counter_str[10];
  sprintf(counter_str, "%d", counter);

  // tree
  p_ptr = create_node("/", l_ptr, create_leaf(counter_str));

  // rpn
  add_lexeme_to_rpn(rpn, strdup(counter_str));
  add_lexeme_to_rpn(rpn, "/");

  // tac
  p_ind = create_tac("/", l_ind, create_tac(counter_str, NULL, NULL));

  puts(rule[8]);
};

L: L comma E {
  ++counter;

  // tree
  l_ptr = create_node("+", l_ptr, e_ptr);

  // rpn
  add_lexeme_to_rpn(rpn, "+");

  // tac
  l_ind = create_tac("+", l_ind, e_ind);

  puts(rule[9]);
} | E {
  counter = 1;

  l_ptr = e_ptr;

  l_ind = e_ind;

  puts(rule[10]);
};

E: E op_sum T {
  // tree
  e_ptr = create_node("+", e_ptr, t_ptr);

  // rpn
  add_lexeme_to_rpn(rpn, "+");

  // tac
  e_ind = create_tac("+", e_ind, t_ind);

  puts(rule[11]);
} | E op_sub T {
  // tree
  e_ptr = create_node("-", e_ptr, t_ptr);

  // rpn
  add_lexeme_to_rpn(rpn, "-");

  // tac
  e_ind = create_tac("-", e_ind, t_ind);

  puts(rule[12]);
} | T {
  e_ptr = t_ptr;

  e_ind = t_ind;

  puts(rule[13]);
};

T: T op_mult F {
  // tree
  t_ptr = create_node("*", t_ptr, f_ptr);

  // rpn
  add_lexeme_to_rpn(rpn, "*");

  // tac
  t_ind = create_tac("*", t_ind, f_ind);

  puts(rule[14]);
} | T op_div F {
  // tree
  t_ptr = create_node("/", t_ptr, f_ptr);

  // rpn
  add_lexeme_to_rpn(rpn, "/");

  // tac
  t_ind = create_tac("/", t_ind, f_ind);

  puts(rule[15]);
} | F {
  t_ptr = f_ptr;

  t_ind = f_ind;

  puts(rule[16]);
};

F: id {
  char id_lex[100];

  strcpy(id_lex, $1);

  // tree
  f_ptr = create_leaf(id_lex);

  // rpn
  add_lexeme_to_rpn(rpn, strdup(id_lex));

  // tac
  f_ind = create_tac(strdup(id_lex), NULL, NULL);

  puts(rule[17]);
} | cte {
  char cte_lex[10];

  sprintf(cte_lex, "%d", $1);

  // tree
  f_ptr = create_leaf(cte_lex);

  // rpn
  add_lexeme_to_rpn(rpn, strdup(cte_lex));

  // tac
  f_ind = create_tac(strdup(cte_lex), NULL, NULL);

  puts(rule[18]);
} | open_parent E close_parent {
  f_ptr = e_ptr;

  puts(rule[19]);
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
  initialize_tac(FILENAME);

  yyparse();

  save_postorder_in_file(a_ptr, FILENAME);
  save_rpn_in_file(rpn, FILENAME);

  fclose(yyin);

  return EXIT_SUCCESS;
}

int yyerror(char *error) {
  fprintf(stderr, COLOR_RED "\nline %d: %s\n" COLOR_RESET, lineno, error);
  fclose(yyin);
  exit(1);
}
