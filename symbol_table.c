#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "symbol_table.h"


table* init_table() {
    table* aux = (table*) malloc( sizeof(table) );

    if(aux != NULL) {
        strcpy(aux->name, "Global");
        aux->is_defined = true;
        insert_pre_defined_functions(aux);
    } else {
        printf("ERROR SYMBOL TABLE");
    }

    return aux;
}

void insert_pre_defined_functions(table* c_table) {
    element_param* char_atoi = (element_param*) malloc( sizeof(element_param) );
    element_param* char_itoa = (element_param*) malloc( sizeof(element_param) );
    element_param* int_itoa = (element_param*) malloc( sizeof(element_param) );
    element_param* char_puts = (element_param*) malloc( sizeof(element_param) );

    strcpy(char_atoi->type, "char");
    char_atoi->pointer = 1;
    char_atoi->next = NULL;

    strcpy(char_itoa->type, "char");
    char_itoa->pointer = 1;
    char_itoa->next = NULL;

    strcpy(int_itoa->type, "int");
    int_itoa->pointer = 0;
    int_itoa->next = char_itoa;

    strcpy(char_puts->type, "char");
    char_puts->pointer = 1;
    char_puts->next = NULL;

    insert_function(c_table, "atoi", "int", 0, char_atoi);
    insert_function(c_table, "itoa", "char", 1, int_itoa);
    insert_function(c_table, "puts", "int", 0, char_puts);
}

table* insert_table(table* c_table, char* name, bool defined) {
    table* new_table = (table*) malloc( sizeof(table) );
    table* aux;

    if(new_table != NULL) {
        aux = c_table;

        strcpy(new_table->name, name);
        new_table->is_defined = defined;

        while(aux->next != NULL) {
            aux = aux->next;
        }

        aux->next = new_table;

    } else {
        printf("ERROR SYMBOL TABLE");
    }

    return new_table;
}

void insert_function(table* function_table, char* function_name, char* r_type, int r_pointer, element_param* function_params) {
    table_element* aux = function_table->symbols;
    table_element* new_element = (table_element*) malloc( sizeof(table_element) );

    // printf("[insert_function]\n");

    if(new_element != NULL) {
        strcpy(new_element->name, function_name);
        strcpy(new_element->type, r_type);
        new_element->pointer = r_pointer;
        new_element->is_func = true;
        new_element->is_array = false;
        new_element->func_param = function_params;

        if(aux != NULL) {
            while(aux->next != NULL) {
                aux = aux->next;
            }

            aux->next = new_element;
        } else {
            function_table->symbols = new_element;
        }

    } else {
        printf("ERROR TABLE ELEMENT\n");
    }

}

void insert_array_symbol(table* symbol_table, char* symbol_name, char* symbol_type, int symbol_pointer, char* symbol_size, int symbol_size_dec, bool symbol_param) {
    table_element* aux = symbol_table->symbols;
    table_element* new_element = (table_element*) malloc( sizeof(table_element) );

    if(new_element != NULL) {
        strcpy(new_element->name, symbol_name);
        strcpy(new_element->type, symbol_type);
        strcpy(new_element->array_size, symbol_size);
        new_element->pointer = symbol_pointer;
        new_element->is_func = false;
        new_element->is_array = true;
        new_element->array_size_dec = symbol_size_dec;
        new_element->param = symbol_param;

        if(aux != NULL) {
            while(aux->next != NULL) {
                aux = aux->next;
            }

            aux->next = new_element;
        } else {
            symbol_table->symbols = new_element;
        }

    } else {
        printf("ERROR TABLE ELEMENT\n");
    }
}

void insert_symbol(table* symbol_table, char* symbol_name, char* symbol_type, int symbol_pointer, bool symbol_param) {
    table_element* aux = symbol_table->symbols;
    table_element* new_element = (table_element*) malloc( sizeof(table_element) );

    if(new_element != NULL) {
        strcpy(new_element->name, symbol_name);
        strcpy(new_element->type, symbol_type);
        new_element->pointer = symbol_pointer;
        new_element->is_func = false;
        new_element->is_array = false;
        new_element->param = symbol_param;

        if(aux != NULL) {
            while(aux->next != NULL) {
                aux = aux->next;
            }

            aux->next = new_element;
        } else {
            symbol_table->symbols = new_element;
        }

    } else {
        printf("ERROR TABLE ELEMENT\n");
    }
}

void insert_params(table* c_table, element_param* params) {
    element_param* aux = params;

    while(aux != NULL) {
        if(strcmp(aux->type, "void") != 0) {
            to_lower_case(aux->type);
            insert_symbol(c_table, aux->name, aux->type, aux->pointer, true);
        } else if(strcmp(aux->type, "void") == 0 && aux->pointer > 0) {
            to_lower_case(aux->type);
            insert_symbol(c_table, aux->name, aux->type, aux->pointer, true);
        }

        aux = aux->next;
    }
}

element_param* get_param_info(tree_node* node) {
    element_param* param = (element_param*) malloc( sizeof(element_param) );
    tree_node* aux = node->luke;

    param->pointer = 0;

    while(aux != NULL) {
        if(strcmp(aux->name, "Id") == 0) {
            strcpy(param->name, aux->value);
        } else if(strcmp(aux->name, "Pointer") == 0) {
            (param->pointer)++;
        } else {
            strcpy(param->type, aux->name);
            to_lower_case(param->type);
        }

        aux = aux->next_brother;
    }

    return param;
}

element_param* get_params(tree_node* node) {
    element_param* params = NULL;
    element_param* aux_param;
    element_param* aux_params;
    tree_node* aux = node->luke;

    while(aux != NULL) {
        if(params == NULL) {
            params = get_param_info(aux);
        } else {
            aux_param = get_param_info(aux);
            aux_params = params;
            while(aux_params->next != NULL) {
                aux_params = aux_params->next;
            }
            aux_params->next = aux_param;
        }

        aux = aux->next_brother;
    }

    return params;
}

table* search_table(table* tables, char *name) { //TODO: maybe add params to the search
    table* target = NULL;
    table* aux = tables;

    while(aux != NULL) {
        if(strcmp(aux->name, name) == 0) {
            return aux;
        }

        aux = aux->next;
    }

    return target;
}

table_element* search_symbol(table* g_table, table* c_table, char *name) { //TODO: maybe add params to the search
    table_element* table_symbols = c_table->symbols;
    table_element* global_symbols = g_table->symbols;

    while(table_symbols != NULL) {
        if(strcmp(table_symbols->name, name) == 0) {
            return table_symbols;
        }

        table_symbols = table_symbols->next;
    }

    while (global_symbols != NULL) {
        if(strcmp(global_symbols->name, name) == 0) {
            return global_symbols;
        }

        global_symbols = global_symbols->next;
    }

    return NULL;
}

void print_params(element_param* param) {
    element_param* aux = param;

    while(aux != NULL) {

        printf("%s", aux->type);

        for(int i = 0; i < aux->pointer; i++){
            printf("*");
        }

        if(aux->next != NULL) {
            printf(",");
        }

        aux = aux->next;
    }
}

void print_elements(table* table) {
    table_element* aux = table->symbols;

    while(aux != NULL) {
        if(aux->is_func) {
            printf("%s\t%s", aux->name, aux->type);

            for(int i = 0; i < aux->pointer; i++){
                printf("*");
            }

            printf("(");

            print_params(aux->func_param);

            printf(")");

        } else if(aux->is_array) {
            printf("%s\t%s", aux->name, aux->type);

            for(int i = 0; i < aux->pointer; i++){
                printf("*");
            }

            printf("[%d]", aux->array_size_dec);

            if(aux->param) {
                printf("\tparam");
            }
        } else {
            printf("%s\t%s", aux->name, aux->type);

            for(int i = 0; i < aux->pointer; i++){
                printf("*");
            }

            if(aux->param) {
                printf("\tparam");
            }


        }

        printf("\n");

        aux = aux->next;
    }
}

void print_tables(table* c_table) {
    table* aux = c_table;

    while(aux != NULL) {
        if(aux == c_table) {
            printf("===== %s Symbol Table =====\n", aux->name);

            print_elements(aux);
            printf("\n");
        } else if(aux->is_defined) {
            printf("===== Function %s Symbol Table =====\n", aux->name);

            print_elements(aux);
            printf("\n");
        }

        aux = aux->next;
    }

}
