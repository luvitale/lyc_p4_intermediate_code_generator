#include "rpn.h"
#include <stdio.h>
#include <stdlib.h>
#define INITIAL_CAPACITY 100
#define EXTENSION "rpn.icg"

// create RPN
rpn_t *create_rpn()
{
  rpn_t *rpn = malloc(sizeof(rpn_t));
  rpn->size = 0;
  rpn->capacity = INITIAL_CAPACITY;
  rpn->lexeme = malloc(sizeof(char *) * rpn->capacity);
  return rpn;
}

int rpn_is_full(rpn_t *rpn)
{
  return rpn->size == rpn->capacity;
}

// add a lexeme to RPN
void add_lexeme_to_rpn(rpn_t *rpn, char *lexeme)
{
  if (rpn_is_full(rpn))
  {
    rpn->capacity *= 2;
    rpn->lexeme = realloc(rpn->lexeme, rpn->capacity * sizeof(char *));
  }
  rpn->lexeme[rpn->size++] = lexeme;
}

// set lexeme of RPN
void set_lexeme_of_rpn(rpn_t *rpn, char *lexeme, int cell)
{
  rpn->lexeme[cell - 1] = lexeme;
}

// get lexeme from RPN
char *get_lexeme_from_rpn(rpn_t *rpn, int cell)
{
  return rpn->lexeme[cell - 1];
}

// get size of RPN
int get_size_of_rpn(rpn_t *rpn)
{
  return rpn->size;
}

// get last cell from RPN
int get_last_cell_from_rpn(rpn_t *rpn)
{
  return rpn->size;
}

// free RPN
void free_rpn(rpn_t *rpn)
{
  for (int i = 0; i < rpn->size; i++)
  {
    free(rpn->lexeme[i]);
  }
  free(rpn->lexeme);
  free(rpn);
}

// save RPN in file
void save_rpn_in_file(rpn_t *rpn, char *filename)
{
  FILE *fp;
  char file[100];
  sprintf(file, "%s.%s", filename, EXTENSION);
  fp = fopen(file, "w");
  for (int i = 0; i < rpn->size; i++)
  {
    fprintf(fp, "%s\n", rpn->lexeme[i]);
  }
  fclose(fp);
}

// show RPN
void show_rpn(rpn_t *rpn)
{
  for (int i = 0; i < rpn->size; i++)
  {
    printf("%s ", rpn->lexeme[i]);
  }
}