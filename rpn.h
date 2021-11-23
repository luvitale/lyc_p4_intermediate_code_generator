#ifndef RPN_H
#define RPN_H

// Reverse Polish Notation structure
typedef struct RPN
{
  char **lexeme;
  int capacity;
  int size;
} rpn_t;

rpn_t *create_rpn();
int rpn_is_full(rpn_t *rpn);
void add_lexeme_to_rpn(rpn_t *, char *);
void set_lexeme_of_rpn(rpn_t *, char *, int);
char *get_lexeme_from_rpn(rpn_t *, int);
int get_size_of_rpn(rpn_t *);
int get_last_cell_of_rpn(rpn_t *);
void free_rpn(rpn_t *);
void save_rpn_in_file(rpn_t *, char *);
void show_rpn(rpn_t *);

#endif // RPN_H