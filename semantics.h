#include "symbol_table.h"

table* symbol_tables;

int semantics(tree_node* root);

int check_node_type(table* c_table, tree_node* node);

void is_array_declaration(table* c_table, tree_node* node);
