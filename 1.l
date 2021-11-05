%{
#include <stdio.h>
#include <stdlib.h>
#include "1.tab.h"
#include "tree.h"

FILE *yyin;

int lineno = 1;

int yyerror(char *);
%}

%option noyywrap
%option yylineno


natural_digit [1-9]
digit (0|{natural_digit})
uppercase_letter [A-Z]
lowercase_letter [a-z]
letter ({uppercase_letter}|{lowercase_letter})

prom ("prom"|"PROM"|"Prom")

comma ","

op_sum "+"
op_sub "-"
op_mult "*"
op_div "/"
op_assign ":="

id {letter}(_?({letter}|{digit}))*

cte ({digit}|{natural_digit}{digit}*)

open_parent "("
close_parent ")"

%%
{open_parent} {
  return open_parent;
}
{close_parent} {
  return close_parent;
}

{prom} {
  return prom;
}

{comma} {
  return comma;
}

{op_sum} {
  return op_sum;
}
{op_sub} {
  return op_sub;
}
{op_mult} {
  return op_mult;
}
{op_div} {
  return op_div;
}
{op_assign} {
  return op_assign;
}

{id} {
  yylval.str_val = strdup(yytext);
  return id;
}

{cte} {
  int value = strtol(yytext,(char **)NULL,10);
  yylval.int_val = value;
  return cte;
}



" "
"\n" {
  ++lineno;
}
"\t"

. {
  char s[] = "invalid character: ";

  strcat(s, yytext);
  strcat(s, "\n");

  yyerror(s);
}
%%
