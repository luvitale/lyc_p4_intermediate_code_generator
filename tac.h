#ifndef TAC_H
#define TAC_H

// Three Address Code
typedef struct TAC
{
  int num;
  char *lex;
  struct TAC *op1, *op2;
} tac_t;

tac_t *create_tac(char *, tac_t *, tac_t *);
void initialize_tac(char *);

#endif // TAC_H