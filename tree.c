#include "tree.h"
#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#define FILENAME "tree.icg"

// create leaf
t_tree_node *create_leaf(char *lexeme)
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

// create node
t_tree_node *create_node(char *lexeme, t_tree_node *left_child, t_tree_node *right_child)
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

// save inorder
void save_inorder(t_tree_node *root, FILE *fp)
{
  if (root)
  {
    save_inorder(root->left, fp);
    fprintf(fp, "%s ", root->info);
    save_inorder(root->right, fp);
  }
}

// save inorder in file
void save_inorder_in_file(t_tree_node *root)
{
  FILE *fp;
  fp = fopen(FILENAME, "w+");
  if (!fp)
  {
    printf("Cannot open file.\n");
    return;
  }

  save_inorder(root, fp);
  fclose(fp);
}

// save postorder
void save_postorder(t_tree_node *root, FILE *fp)
{
  if (root)
  {
    save_postorder(root->left, fp);
    save_postorder(root->right, fp);
    fprintf(fp, "%s ", root->info);
  }
}

// save postorder in file
void save_postorder_in_file(t_tree_node *root)
{
  FILE *fp;
  fp = fopen(FILENAME, "w+");
  if (!fp)
  {
    printf("Cannot open file.\n");
    return;
  }

  save_postorder(root, fp);
  fclose(fp);
}

// show postorder
void postorder(t_tree_node *root)
{
  if (root)
  {
    postorder(root->left);
    postorder(root->right);
    printf("%s ", root->info);
  }
}
