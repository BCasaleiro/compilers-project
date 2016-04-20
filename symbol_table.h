#include <stdbool.h>
#include "ast.h"

#define MAX_STR 100

typedef struct _element_param {
    char type[MAX_STR];
    char name[MAX_STR];
    int pointer;

    struct _element_param* next;
} element_param;

typedef struct _table_element{
	char name[MAX_STR];
    char type[MAX_STR];
    int pointer;
    bool param;

    bool is_array;
    char array_size[MAX_STR];

    bool is_func;
    element_param* func_param;

	struct _table_element* next;
} table_element;

typedef struct _table {
    char name[MAX_STR];
    bool is_defined;

    struct _table_element* symbols;
    struct _table* next;
} table;

table* init_table();
table* insert_table(table* c_table, char* name, bool defined);

void insert_pre_defined_functions(table* c_table);
void insert_symbol(table* symbol_table, char* symbol_name, char* symbol_type, int symbol_pointer, bool symbol_param);
void insert_array_symbol(table* symbol_table, char* symbol_name, char* symbol_type, int symbol_pointer, char* symbol_size, bool symbol_param);
void insert_function(table* function_table, char* function_name, char* r_type, int r_pointer, element_param* function_params);

element_param* get_params(tree_node* node);
element_param* get_param_info(tree_node* node);

table_element *search_symbol(char *name);

void print_tables(table* c_table);
void print_elements(table* table);
void print_params(element_param* param);
