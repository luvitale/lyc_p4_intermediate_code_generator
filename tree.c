#include "tree.h"

t_tree_node *create_leaf(void *lexeme)
{
  t_tree_node *leaf = (t_tree_node *)malloc(sizeof(t_tree_node));
  if (!leaf)
  {
    printf("No memory to create leaf.\n");
    return NULL;
  }

  leaf->left = NULL;
  leaf->right = NULL;
  strcpy(leaf->info, lexeme);
  return leaf;
}

t_tree_node *create_node(void *lexeme, t_tree_node *left_child, t_tree_node *right_child)
{
  t_tree_node *parent = (t_tree_node *)malloc(sizeof(t_tree_node));

  if (!parent)
  {
    printf("No memory to create node.\n");
    return NULL;
  }

  parent->left = left_child;
  parent->right = right_child;
  strcpy(parent->info, lexeme);

  return parent;
}

void saveInorderInFile(t_tree *ptree, FILE *pf)
{
  if (!*ptree)
    return;

  saveInorderInFile(&(*ptree)->left, pf);
  fwrite(&(*ptree)->info, sizeof(char[50]), 1, pf);
  saveInorderInFile(&(*ptree)->right, pf);
}

void postorder(t_tree *ptree)
{
  if (!(*ptree))
    return;
  postorder(&(*ptree)->left);
  postorder(&(*ptree)->right);
  printf("%s  ", (*ptree)->info);
}
