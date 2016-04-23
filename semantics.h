#include "symbol_table.h"

table* symbol_tables;
table* c_table;

void semantics(tree_node* root);

void note_tree(tree_node* root);
void check_note(tree_node* node);

void check_node_type(table* c_table, tree_node* node);
void repeat_check(table* c_table, tree_node* node);
void repeat_check_brother(table* c_table, tree_node* node);

void is_declaration(table* c_tab, tree_node* node);
void is_array_declaration(table* c_tab, tree_node* node);
void is_func_declaration(table* c_tab, tree_node* node);
void is_func_definition(table* c_tab, tree_node* node);
void is_statlist(table* c_table, tree_node* node);
void is_if(table* c_table, tree_node* node);
void is_for(table* c_table, tree_node* node);
void is_return(table* c_table, tree_node* node);
void is_or(table* c_table, tree_node* node);
void is_and(table* c_table, tree_node* node);
void is_eq(table* c_table, tree_node* node);
void is_ne(table* c_table, tree_node* node);
void is_lt(table* c_table, tree_node* node);
void is_gt(table* c_table, tree_node* node);
void is_le(table* c_table, tree_node* node);
void is_ge(table* c_table, tree_node* node);
void is_add(table* c_table, tree_node* node);
void is_sub(table* c_table, tree_node* node);
void is_mul(table* c_table, tree_node* node);
void is_div(table* c_table, tree_node* node);
void is_mod(table* c_table, tree_node* node);
void is_not(table* c_table, tree_node* node);
void is_minus(table* c_table, tree_node* node);
void is_plus(table* c_table, tree_node* node);
tree_node* is_addr(table* c_table, tree_node* node);
tree_node* is_deref(table* c_table, tree_node* node);
void is_deref_call(table* c_table, tree_node* node);
void is_deref_add(table* c_table, tree_node* node);
void is_store(table* c_table, tree_node* node);
void is_comma(table* c_table, tree_node* node);
void is_call(table* c_table, tree_node* node);
void is_id(table* c_table, tree_node* node);
