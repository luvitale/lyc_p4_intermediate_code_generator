#ifndef TAC_H
#define TAC_H

// Three Address Code
typedef struct TAC
{
  int num;
  char *lex;
  struct TAC *op1, *op2;
} tac_t;

tac_t *create_tac(char *lex, tac_t *op1, tac_t *op2);
void initialize_tac();

#endif // TAC_H