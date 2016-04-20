#include "symbol_table.h"

table* symbol_tables;
table* c_table;

void semantics(tree_node* root);

void check_node_type(table* c_table, tree_node* node);

void is_declaration(table* c_tab, tree_node* node);
void is_array_declaration(table* c_tab, tree_node* node);
void is_param_declaration(table* c_tab, tree_node* node);
void is_func_declaration(table* c_tab, tree_node* node);
