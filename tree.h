#ifndef TREE_H_INCLUDED
#define TREE_H_INCLUDED

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <math.h>

typedef struct s_tree_node
{
  struct s_tree_node *left;
  struct s_tree_node *right;
  char info[50];
} t_tree_node;

typedef t_tree_node *t_tree;

t_tree_node *create_leaf(void *lexeme);
t_tree_node *create_node(void *lexeme, t_tree_node *left_child, t_tree_node *right_child);
void saveInorderInFile(t_tree *pa, FILE *pIntermedia);
void postorder(t_tree *pa);

#endif // TREE_H_INCLUDED