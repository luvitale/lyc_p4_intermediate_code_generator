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

t_tree_node *create_leaf(char *);
t_tree_node *create_node(char *, t_tree_node *, t_tree_node *);
void save_inorder_in_file(t_tree_node *);
void save_postorder_in_file(t_tree_node *);
void postorder(t_tree_node *);

#endif // TREE_H_INCLUDED