#include "tac.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#define EXTENSION "tac.icg"

int num = 0;

char file[100];

// Add TAC to file
void add_tac_to_file(tac_t *tac)
{
  FILE *fp = fopen(file, "a");
  if (file == NULL)
  {
    printf("Error opening file %s\n", file);
    exit(1);
  }

  char t1[100];
  char t2[100];
  char t3[100];

  strcpy(t1, tac->lex);

  if (tac->op1)
  {
    sprintf(t2, "[%d]", tac->op1->num);
  }
  else
  {
    strcpy(t2, "_");
  }

  if (tac->op2)
  {
    sprintf(t3, "[%d]", tac->op2->num);
  }
  else
  {
    strcpy(t3, "_");
  }

  fprintf(fp, "(%s, %s, %s)\n", t1, t2, t3);
  fclose(fp);
}

// Create Three Address Code
tac_t *create_tac(char *lex, tac_t *op1, tac_t *op2)
{
  ++num;
  tac_t *new = (tac_t *)malloc(sizeof(tac_t));
  new->num = num;
  new->lex = lex;
  new->op1 = op1;
  new->op2 = op2;
  add_tac_to_file(new);

  return new;
}

// Initialize TAC
void initialize_tac(char *filename)
{
  sprintf(file, "%s.%s", filename, EXTENSION);

  // Delete file
  remove(file);

  num = 0;
}