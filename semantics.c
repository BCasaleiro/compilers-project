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
        is_func_definition(c_tab, node);
    } else if ( strcmp(node->name, "ParamDeclaration") == 0 ) {
        is_param_declaration(c_tab, node);
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
        insert_table(symbol_tables, name, false);
    }

}

void is_func_definition(table* c_tab, tree_node* node) {
    table* declared_func;
    tree_node* aux = node->luke;
    tree_node* aux_func_body;
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
            } else if(strcmp(aux->name, "FuncBody") == 0) {
                if((declared_func = search_table(symbol_tables, name)) != NULL) {
                    c_table = declared_func;
                    c_table->is_defined = true;
                } else {
                    insert_function(c_table, name, type, pointer, params);
                    c_table = insert_table(symbol_tables, name, false);
                    c_table->is_defined = true;
                }

                insert_symbol(c_table, "return", type, pointer, false);
                insert_params(c_table, params);

                aux_func_body = aux->luke;

                while(aux_func_body != NULL) {

                    check_node_type(c_table, aux_func_body);

                    aux_func_body = aux_func_body->next_brother;
                }

                c_table = symbol_tables;

            }

            aux = aux->next_brother;
        }



    }
}
