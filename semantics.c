#include <stdio.h>
#include "semantics.h"
#include "util.h"

void semantics(tree_node* root) {
    tree_node* aux = root->luke;
    symbol_tables = init_table();
    c_table = symbol_tables;

    while(aux != NULL) {
        check_node_type(c_table, aux);

        aux = aux->next_brother;
    }
}

// Table symbol functions
void check_node_type(table* c_tab, tree_node* node) {

    if ( strcmp(node->name, "Declaration") == 0 ) {
        is_declaration(c_tab, node);
    } else if ( strcmp(node->name, "ArrayDeclaration") == 0 ) {
        is_array_declaration(c_tab, node);
    } else if ( strcmp(node->name, "FuncDeclaration") == 0 ) {
        is_func_declaration(c_tab, node);
    } else if ( strcmp(node->name, "FuncDefinition") == 0 ) {
        is_func_definition(c_tab, node);
    } else if ( strcmp(node->name, "StatList") == 0 ) {
        is_statlist(c_table, node);
    } else if ( strcmp(node->name, "If") == 0 ) {
        is_if(c_table, node);
    } else if ( strcmp(node->name, "For") == 0 ) {
        is_for(c_table, node);
    } else if ( strcmp(node->name, "Return") == 0 ) {
        is_return(c_table, node);
    } else if ( strcmp(node->name, "Or") == 0 ) {
        is_or(c_table, node);
    } else if ( strcmp(node->name, "And") == 0 ) {
        is_and(c_table, node);
    } else if ( strcmp(node->name, "Eq") == 0 ) {
        is_eq(c_table, node);
    } else if ( strcmp(node->name, "Lt") == 0 ) {
        is_lt(c_table, node);
    } else if ( strcmp(node->name, "Gt") == 0 ) {
        is_gt(c_table, node);
    } else if ( strcmp(node->name, "Le") == 0 ) {
        is_le(c_table, node);
    } else if ( strcmp(node->name, "Ge") == 0 ) {
        is_ge(c_table, node);
    } else if ( strcmp(node->name, "Ne") == 0 ) {
        is_ne(c_table, node);
    } else if ( strcmp(node->name, "Add") == 0 ) {
        is_add(c_table, node);
    } else if ( strcmp(node->name, "Sub") == 0 ) {
        is_sub(c_table, node);
    } else if ( strcmp(node->name, "Mul") == 0 ) {
        is_mul(c_table, node);
    } else if ( strcmp(node->name, "Div") == 0 ) {
        is_div(c_table, node);
    } else if ( strcmp(node->name, "Mod") == 0 ) {
        is_mod(c_table, node);
    } else if ( strcmp(node->name, "Not") == 0 ) {
        is_not(c_table, node);
    } else if ( strcmp(node->name, "Minus") == 0 ) {
        is_minus(c_table, node);
    } else if ( strcmp(node->name, "Plus") == 0 ) {
        is_plus(c_table, node);
    } else if ( strcmp(node->name, "Addr") == 0 ) {
        is_addr(c_table, node);
    } else if ( strcmp(node->name, "Deref") == 0 ) {
        is_deref(c_table, node);
    } else if ( strcmp(node->name, "Store") == 0 ) {
        is_store(c_table, node);
    } else if ( strcmp(node->name, "Comma") == 0 ) {
        is_comma(c_table, node);
    } else if ( strcmp(node->name, "Call") == 0 ) {
        is_call(c_table, node);
    } else if( strcmp(node->name, "Id") == 0 ) {
        is_id(c_table, node);
    }

}

void repeat_check(table* c_table, tree_node* node) {
    tree_node* aux = node->luke;

    while(aux != NULL) {

        check_node_type(c_table, aux);

        aux = aux->next_brother;
    }
}

void is_declaration(table* c_tab, tree_node* node) {
    tree_node* aux = node->luke;
    table_element* aux_repeat;
    char type[MAX_STR];
    char name[MAX_STR];
    int pointer = 0;
    int line = 0, col = 0;

    while(aux != NULL) {
        if(strcmp(aux->name, "Pointer") == 0) {
            pointer++;
        } else if(strcmp(aux->name, "Id") == 0) {
            strcpy(name, aux->value);
            line = aux->line;
            col = aux->col;
        } else {
            strcpy(type, aux->name);
        }

        aux = aux->next_brother;
    }

    to_lower_case(type);

    aux_repeat = search_symbol(symbol_tables, c_table, name, true);
    if(aux_repeat == NULL) {
        insert_symbol(c_tab, name, type, pointer, false);
    } else if(symbol_tables != c_table) {
        printf("Line %d, col %d: Symbol %s already defined\n", line, col, name);
    } else {
        if(strcmp(type, aux_repeat->type) != 0 || (strcmp(type, aux_repeat->type) == 0 &&  aux_repeat->pointer != pointer) ) {
            printf("Line %d, col %d: Symbol %s already defined\n", line, col, name); //TODO: check if it is this error messages
        }
    }
}

void is_array_declaration(table* c_tab, tree_node* node) {
    tree_node* aux = node->luke;
    table_element* aux_repeat;
    char type[MAX_STR];
    char name[MAX_STR];
    char size[MAX_STR];
    int size_dec;
    int pointer =  1;
    int line = 0, col = 0;


    while(aux != NULL) {
        if(strcmp(aux->name, "Pointer") == 0) {
            pointer++;
        } else if(strcmp(aux->name, "Id") == 0) {
            strcpy(name, aux->value);
            line = aux->line; //TODO: fix line and col
            col = aux->col;
        } else if(strcmp(aux->name, "IntLit") == 0) {
            strcpy(size, aux->value);
            size_dec = to_dec_convertion(size);

            aux->size_dec = size_dec;
        } else {
            strcpy(type, aux->name);
        }

        aux = aux->next_brother;
    }

    to_lower_case(type);

    aux_repeat = search_symbol(symbol_tables, c_table, name, true);
    if(aux_repeat == NULL) {
        insert_array_symbol(c_tab, name, type, pointer, size, size_dec, false);
    } else if(symbol_tables != c_table) {
        printf("Line %d, col %d: Symbol %s already defined\n", line, col, name);
    } else {
        if(strcmp(type, aux_repeat->type) != 0 || size_dec != aux_repeat->array_size_dec || (strcmp(type, aux_repeat->type) == 0 &&  aux_repeat->pointer != pointer) ) {
            printf("Line %d, col %d: Symbol %s already defined\n", line, col, name); //TODO: check if it is this error messages
        }
    }
}

void is_func_declaration(table* c_tab, tree_node* node) {
    tree_node* aux = node->luke;
    element_param* params;
    table_element* aux_repeat;
    char name[MAX_STR];
    char type[MAX_STR];
    int pointer = 0;

    while(aux != NULL) {
        if(strcmp(aux->name, "Pointer") == 0) {
            pointer++;
        } else if (strcmp(aux->name, "Id") == 0) {
            strcpy(name, aux->value);
        } else if(strcmp(aux->name, "ParamList") == 0){
            params = get_params(aux);
        } else {
            strcpy(type, aux->name);
        }

        aux = aux->next_brother;
    }

    aux_repeat = search_symbol(symbol_tables, c_table, name, false);
    if(aux_repeat == NULL) {
        to_lower_case(type);
        insert_function(c_table, name, type, pointer, params);
        insert_table(symbol_tables, name, false);
    } else {
        //TODO: add error message
    }
}

void is_func_definition(table* c_tab, tree_node* node) {
    table* declared_func;
    tree_node* aux = node->luke;
    table_element* aux_repeat;
    element_param* params;
    char name[MAX_STR];
    char type[MAX_STR];
    int pointer = 0;
    int line = 0;
    int col = 0;

    while(aux != NULL) {
        if(strcmp(aux->name, "Pointer") == 0) {
            pointer++;
        } else if (strcmp(aux->name, "Id") == 0) {
            strcpy(name, aux->value);
            line = aux->line;
            col = aux->col;
        } else if(strcmp(aux->name, "ParamList") == 0){
            params = get_params(aux);
        } else if(strcmp(aux->name, "FuncBody") == 0) {
            aux_repeat = search_symbol(symbol_tables, c_tab, name, false);
            declared_func = search_table(symbol_tables, name);

            if(declared_func != NULL) {
                if(!declared_func->is_defined) {
                    c_table = declared_func;
                    c_table->is_defined = true;
                } else {
                    printf("Line %d, col %d: Symbol %s already defined\n", aux->line, aux->col, name);
                }

                insert_symbol(c_table, "return", type, pointer, false);
                insert_params(c_table, params);

            } else {
                insert_function(c_table, name, type, pointer, params);
                c_table = insert_table(symbol_tables, name, true);
                insert_symbol(c_table, "return", type, pointer, false);
                insert_params(c_table, params);
            }

            repeat_check(c_table, aux);

            c_table = symbol_tables;

        } else {
            strcpy(type, aux->name);
            to_lower_case(type);
        }

        aux = aux->next_brother;
    }

}

void is_statlist(table* c_table, tree_node* node) {
    repeat_check(c_table, node);
}

void is_if(table* c_table, tree_node* node) {
    repeat_check(c_table, node);
}

void is_for(table* c_table, tree_node* node) {
    repeat_check(c_table, node);
}

void is_return(table* c_table, tree_node* node) {
    repeat_check(c_table, node);
}

void is_or(table* c_table, tree_node* node) {
    repeat_check(c_table, node);

    strcpy(node->type, "int");
}

void is_and(table* c_table, tree_node* node) {
    repeat_check(c_table, node);

    strcpy(node->type, "int");
}

void is_eq(table* c_table, tree_node* node) {
    repeat_check(c_table, node);

    strcpy(node->type, "int");
}

void is_ne(table* c_table, tree_node* node) {
    repeat_check(c_table, node);

    strcpy(node->type, "int");
}

void is_lt(table* c_table, tree_node* node) {
    repeat_check(c_table, node);

    strcpy(node->type, "int");
}

void is_gt(table* c_table, tree_node* node) {
    repeat_check(c_table, node);

    strcpy(node->type, "int");
}

void is_le(table* c_table, tree_node* node) {
    repeat_check(c_table, node);

    strcpy(node->type, "int");
}

void is_ge(table* c_table, tree_node* node) {
    repeat_check(c_table, node);

    strcpy(node->type, "int");
}

void is_add(table* c_table, tree_node* node) {
    tree_node* f_eq = node->luke;
    tree_node* s_eq = f_eq->next_brother;

    repeat_check(c_table, node);

    if( f_eq->pointer > 0 && s_eq->pointer == 0 && strcmp(s_eq->type, "void") != 0 ) {
        strcpy(node->type, f_eq->type);
        node->pointer = f_eq->pointer;
    } else if( s_eq->pointer > 0 && f_eq->pointer == 0 && strcmp(f_eq->type, "void") != 0) {
        strcpy(node->type, s_eq->type);
        node->pointer = s_eq->pointer;
    } else if( strcmp(f_eq->type, "void") != 0 && strcmp(s_eq->type, "void") != 0  && f_eq->pointer == 0 && s_eq->pointer == 0) {
        strcpy(node->type, "int");
    } else {
        //TODO: add error message
    }
}

void is_sub(table* c_table, tree_node* node) {
    tree_node* f_eq = node->luke;
    tree_node* s_eq = f_eq->next_brother;

    repeat_check(c_table, node);

    if( f_eq->pointer > 0 && s_eq->pointer == 0 && strcmp(s_eq->type, "void") != 0 ) {
        strcpy(node->type, f_eq->type);
        node->pointer = f_eq->pointer;
    } else if( f_eq->pointer > 0 && s_eq->pointer > 0 && strcmp(f_eq->type, s_eq->type) == 0 ) {
        strcpy(node->type, "int");
    } else if( strcmp(f_eq->type, "void") != 0 && strcmp(s_eq->type, "void") != 0  && f_eq->pointer == 0 && s_eq->pointer == 0) {
        strcpy(node->type, "int");
    } else {
        //TODO: add error message
    }
}

void is_mul(table* c_table, tree_node* node) {
    tree_node* f_eq = node->luke;
    tree_node* s_eq = f_eq->next_brother;

    repeat_check(c_table, node);

    if( strcmp(f_eq->type, "void") != 0 && strcmp(s_eq->type, "void") != 0  && f_eq->pointer == 0 && s_eq->pointer == 0) {
        strcpy(node->type, "int");
    } else {
        //TODO: add error message
    }
}

void is_div(table* c_table, tree_node* node) {
    tree_node* f_eq = node->luke;
    tree_node* s_eq = f_eq->next_brother;

    repeat_check(c_table, node);

    if( strcmp(f_eq->type, "void") != 0 && strcmp(s_eq->type, "void") != 0  && f_eq->pointer == 0 && s_eq->pointer == 0) {
        strcpy(node->type, "int");
    } else {
        //TODO: add error message
    }
}

void is_mod(table* c_table, tree_node* node) {
    tree_node* f_eq = node->luke;
    tree_node* s_eq = f_eq->next_brother;

    repeat_check(c_table, node);

    if( strcmp(f_eq->type, "void") != 0 && strcmp(s_eq->type, "void") != 0  && f_eq->pointer == 0 && s_eq->pointer == 0) {
        strcpy(node->type, "int");
    } else {
        //TODO: add error message
    }
}

void is_not(table* c_table, tree_node* node) {
    repeat_check(c_table, node);

    strcpy(node->type, "int");
}

void is_minus(table* c_table, tree_node* node) {
    tree_node* minus = node->luke;

    repeat_check(c_table, node);

    if(minus->pointer == 0) {
        strcpy(node->type, "int");
    }
}

void is_plus(table* c_table, tree_node* node) {
    tree_node* plus = node->luke;

    repeat_check(c_table, node);

    if(plus->pointer == 0) {
        strcpy(node->type, "int");
    }
}

void is_addr(table* c_table, tree_node* node) {
    tree_node* son = node->luke;

    repeat_check(c_table, node);

    strcpy(node->type, son->type);
    node->pointer = son->pointer + 1;
}

void is_deref(table* c_table, tree_node* node) {
    tree_node* son = node->luke;

    repeat_check(c_table, node);

    strcpy(node->type, son->type);
    node->pointer = son->pointer - 1; //TODO: error handling
}

void is_store(table* c_table, tree_node* node) {
    tree_node* target = node->luke;

    repeat_check(c_table, node);

    strcpy(node->type, target->type);
    node->pointer = target->pointer;
}

void is_comma(table* c_table, tree_node* node) {
    tree_node* son = node->luke;

    repeat_check(c_table, node);

    while(son->next_brother != NULL) {
        son = son->next_brother;
    }

    strcpy(node->type, son->type);
    node->pointer = son->pointer;
}

void is_call(table* c_table, tree_node* node) {
    tree_node* function = node->luke;

    repeat_check(c_table, node);

    strcpy(node->type, function->type);
    node->pointer = function->pointer;
}

void is_id(table* c_table, tree_node* node) {
    table_element* aux = search_symbol(symbol_tables, c_table, node->value, false);

    if(aux != NULL) {
        to_lower_case(aux->type);
        if(aux->is_func) {
            strcpy(node->type, aux->type);
            node->pointer = aux->pointer;
            node->params = aux->func_param;
        } else if(aux->is_array) {
            strcpy(node->type, aux->type);
            node->pointer = aux->pointer;
            strcpy(node->size, aux->array_size);
        } else {
            strcpy(node->type, aux->type);
            node->pointer = aux->pointer;
        }
    } else {
        printf("Line %d, col %d: Unkown symbol %s\n", node->line, node->col, node->value);
        strcpy(node->type, "undef");
    }
}
