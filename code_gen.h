#include "semantics.h"

void print_code(tree_node * node, table * c_table);
void llvm_is_easy(tree_node * node, table * c_table);
void funcDefenition_code(tree_node * node, table * c_table);
char * return_type(tree_node * node);
void print_function_body(tree_node * node, table * c_table);
void globalDeclaration_code(tree_node * node, table * c_table);