#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define MAX_STR 250

typedef struct _element_param {
    char type[MAX_STR];
    char name[MAX_STR];
    int pointer;

    struct _element_param* next;
} element_param;

typedef struct _tree_node {
    struct _tree_node* darth_vader;
    struct _tree_node* next_brother;
    struct _tree_node* luke;

    char name[MAX_STR];
    char value[MAX_STR];
    char type[MAX_STR];
    int pointer;
    char size[MAX_STR];
    int size_dec;
    element_param* params;

    int line;
    int col;

} tree_node;

void to_lower_case(char* str);

tree_node* create_simple_node(char* name, int line, int col);
tree_node* create_str_node(char* name, char* value, int line, int col);
tree_node* create_str_node_with_type(char* name, char* value, char* type, int line, int col);
tree_node* create_strlit_node(char* name, char* value, char* type, int line, int col);

void add_child(tree_node * father , tree_node * son);
void add_brother_end(tree_node* father, tree_node* new_son);

tree_node* search_str_node(tree_node* root, char* value);

void print_points(int n);
void print_terminal(tree_node* node);
void print_tree(tree_node* node, int level);

void print_annotated_params(element_param* params);
void print_annotated_terminal(tree_node* node);
void print_annotated_tree(tree_node* node, int level);
