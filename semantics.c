#include <stdio.h>
#include "semantics.h"

void semantics(tree_node* root) {
    tree_node* aux = root->luke;
    symbol_tables = init_table();
    c_table = symbol_tables;

    while(aux != NULL) {

        check_node_type(c_table, aux);

        aux = aux->next_brother;

    }

    print_tables(symbol_tables);
}

void check_node_type(table* c_tab, tree_node* node) {

    if ( strcmp(node->name, "Declaration") == 0 ) { // variables
        is_declaration(c_tab, node);
    } else if ( strcmp(node->name, "ArrayDeclaration") == 0 ) {
        is_array_declaration(c_tab, node);
    } else if ( strcmp(node->name, "FuncDeclaration") == 0 ) { // functions
        is_func_declaration(c_tab, node);
    } else if ( strcmp(node->name, "FuncDefinition") == 0 ) {

    } else if ( strcmp(node->name, "ParamList") == 0 ) {

    } else if ( strcmp(node->name, "ParamDeclaration") == 0 ) {
        is_param_declaration(c_tab, node);
    } else if ( strcmp(node->name, "FuncBody") == 0 ) {

    } else if ( strcmp(node->name, "StatList") == 0 ) { // statements

    } else if ( strcmp(node->name, "If") == 0 ) {

    } else if ( strcmp(node->name, "For") == 0 ) {

    } else if ( strcmp(node->name, "Return") == 0 ) {

    }
}

void is_declaration(table* c_tab, tree_node* node) {
    tree_node* aux = node->luke;
    char type[MAX_STR];
    char name[MAX_STR];
    int pointer = 0;

    if(aux != NULL) {

        strcpy(type, aux->name);

        while(aux != NULL) {
            if(strcmp(aux->name, "Pointer") == 0) {
                pointer++;
            } else {
                strcpy(name, aux->value);
            }

            aux = aux->next_brother;
        }

        insert_symbol(c_tab, name, type, pointer, false);

    }
}

void is_array_declaration(table* c_tab, tree_node* node) {
    tree_node* aux = node->luke;
    char type[MAX_STR];
    char name[MAX_STR];
    char size[MAX_STR];
    int pointer = 0;

    if(aux != NULL) {

        strcpy(type, aux->name);

        while(aux != NULL) {
            if(strcmp(aux->name, "Pointer") == 0) {
                pointer++;
            } else if(strcmp(aux->name, "Id") == 0) {
                strcpy(name, aux->value);
            } else {
                strcpy(size, aux->value);
            }

            aux = aux->next_brother;
        }

        insert_array_symbol(c_tab, name, type, pointer, size, false);

    }
}

void is_param_declaration(table* c_tab, tree_node* node) {
    tree_node* aux = node->luke;
    char type[MAX_STR];
    char name[MAX_STR];
    int pointer = 0;

    if(aux != NULL) {

        strcpy(type, aux->name);

        while(aux != NULL) {
            if(strcmp(aux->name, "Pointer") == 0) {
                pointer++;
            } else {
                strcpy(name, aux->value);
            }

            aux = aux->next_brother;
        }

        insert_symbol(c_tab, name, type, pointer, true);

    }
}

void is_func_declaration(table* c_tab, tree_node* node) {
    tree_node* aux = node->luke;
    element_param* params;
    char name[MAX_STR];
    char type[MAX_STR];
    int pointer = 0;

    if(aux != NULL) {

        strcpy(type, aux->name);

        while(aux != NULL) {
            if(strcmp(aux->name, "Pointer") == 0) {
                pointer++;
            } else if (strcmp(aux->name, "Id") == 0) {
                strcpy(name, aux->value);
            } else if(strcmp(aux->name, "ParamList") == 0){
                params = get_params(aux);
            }

            aux = aux->next_brother;
        }

        insert_function(c_table, name, type, pointer, params);
    }

}

void is_func_definition(table* c_tab, tree_node* node) {
    
}
