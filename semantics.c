#include <stdio.h>
#include "semantics.h"

int semantics(tree_node* root) {
    tree_node* aux = root->luke;
    symbol_tables = init_table();
    table* c_table = symbol_tables;
    int error_count = 0;

    while(aux != NULL) {

        check_node_type(c_table, aux);

        aux = aux->next_brother;

    }

    print_tables(symbol_tables);

    return error_count;
}

int check_node_type(table* c_table, tree_node* node) {
    int error_count = 0;

    if ( strcmp(node->name, "Declaration") == 0 ) { // variables

    } else if ( strcmp(node->name, "ArrayDeclaration") == 0 ) {
        is_array_declaration(c_table, node);
    } else if ( strcmp(node->name, "FuncDeclaration") == 0 ) { // functions

    } else if ( strcmp(node->name, "FuncDefinition") == 0 ) {

    } else if ( strcmp(node->name, "ParamList") == 0 ) {

    } else if ( strcmp(node->name, "ParamDeclaration") == 0 ) {

    } else if ( strcmp(node->name, "FuncBody") == 0 ) {

    } else if ( strcmp(node->name, "StatList") == 0 ) { // statements

    } else if ( strcmp(node->name, "If") == 0 ) {

    } else if ( strcmp(node->name, "For") == 0 ) {

    } else if ( strcmp(node->name, "Return") == 0 ) {

    }

    return error_count;
}

void is_array_declaration(table* c_table, tree_node* node) {
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

        insert_array_symbol(c_table, name, type, pointer, size, false); //TODO: check if it is param

    }
}
