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

void repeat_check_brother(table* c_table, tree_node* node) {
    tree_node* aux = node->next_brother;

    while(aux != NULL) {

        check_node_type(c_table, aux);

        aux = aux->next_brother;
    }
}

void is_declaration(table* c_tab, tree_node* node) {
    tree_node* aux = node->luke;
    char type[MAX_STR];
    char name[MAX_STR];
    int pointer = 0;

    while(aux != NULL) {
        if(strcmp(aux->name, "Pointer") == 0) {
            pointer++;
        } else if(strcmp(aux->name, "Id") == 0) {
            strcpy(name, aux->value);
            /*
            to_lower_case(type);
            strcpy(aux->type, type);
            */
        } else {
            strcpy(type, aux->name);
        }

        aux = aux->next_brother;
    }

    to_lower_case(type);
    insert_symbol(c_tab, name, type, pointer, false);
}

void is_array_declaration(table* c_tab, tree_node* node) {
    tree_node* aux = node->luke;
    char type[MAX_STR];
    char name[MAX_STR];
    char size[MAX_STR];
    int pointer = 0;

    while(aux != NULL) {
        if(strcmp(aux->name, "Pointer") == 0) {
            pointer++;
        } else if(strcmp(aux->name, "Id") == 0) {
            strcpy(name, aux->value);
            /*
            to_lower_case(type);
            strcpy(aux->type, type);
            */
        } else if(strcmp(aux->name, "IntLit") == 0) {
            strcpy(size, aux->value);
        } else {
            strcpy(type, aux->name);
        }

        aux = aux->next_brother;
    }

    insert_array_symbol(c_tab, name, type, pointer, size, false);
}

void is_func_declaration(table* c_tab, tree_node* node) {
    tree_node* aux = node->luke;
    element_param* params;
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

    to_lower_case(type);
    insert_function(c_table, name, type, pointer, params);
    insert_table(symbol_tables, name, false);
}

void is_func_definition(table* c_tab, tree_node* node) {
    table* declared_func;
    tree_node* aux = node->luke;
    element_param* params;
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
    tree_node* aux = node->luke;
    table_element* aux_t_element;

    if(strcmp("Id", aux->name) == 0) {
        aux_t_element = search_symbol(symbol_tables, c_table, aux->value);
        to_lower_case(aux_t_element->type);
        strcpy(aux->type, aux_t_element->type);
    }
}

void is_or(table* c_table, tree_node* node) {
    tree_node* f_eq = node->luke;
    tree_node* s_eq = f_eq->next_brother;
    table_element* aux;

    if(strcmp(f_eq->name, "Id") == 0) {
        aux = search_symbol(symbol_tables, c_table, f_eq->value);
        to_lower_case(aux->type);
        strcpy(f_eq->type, aux->type);
    }

    if(strcmp(s_eq->name, "Id") == 0) {
        aux = search_symbol(symbol_tables, c_table, s_eq->value);
        to_lower_case(aux->type);
        strcpy(s_eq->type, aux->type);
    }

    if(strcmp(f_eq->type, s_eq->type) == 0) {
        strcpy(node->type, f_eq->type);
    }
}

void is_and(table* c_table, tree_node* node) {
    tree_node* f_eq = node->luke;
    tree_node* s_eq = f_eq->next_brother;
    table_element* aux;

    if(strcmp(f_eq->name, "Id") == 0) {
        aux = search_symbol(symbol_tables, c_table, f_eq->value);
        to_lower_case(aux->type);
        strcpy(f_eq->type, aux->type);
    }

    if(strcmp(s_eq->name, "Id") == 0) {
        aux = search_symbol(symbol_tables, c_table, s_eq->value);
        to_lower_case(aux->type);
        strcpy(s_eq->type, aux->type);
    }

    if(strcmp(f_eq->type, s_eq->type) == 0) {
        strcpy(node->type, f_eq->type);
    }
}

void is_eq(table* c_table, tree_node* node) {
    tree_node* f_eq = node->luke;
    tree_node* s_eq = f_eq->next_brother;
    table_element* aux;

    if(strcmp(f_eq->name, "Id") == 0) {
        aux = search_symbol(symbol_tables, c_table, f_eq->value);
        to_lower_case(aux->type);
        strcpy(f_eq->type, aux->type);
    }

    if(strcmp(s_eq->name, "Id") == 0) {
        aux = search_symbol(symbol_tables, c_table, s_eq->value);
        to_lower_case(aux->type);
        strcpy(s_eq->type, aux->type);
    }

    if(strcmp(f_eq->type, s_eq->type) == 0) {
        strcpy(node->type, f_eq->type);
    }

}

void is_ne(table* c_table, tree_node* node) {
    tree_node* f_eq = node->luke;
    tree_node* s_eq = f_eq->next_brother;
    table_element* aux;

    if(strcmp(f_eq->name, "Id") == 0) {
        aux = search_symbol(symbol_tables, c_table, f_eq->value);
        to_lower_case(aux->type);
        strcpy(f_eq->type, aux->type);
    }

    if(strcmp(s_eq->name, "Id") == 0) {
        aux = search_symbol(symbol_tables, c_table, s_eq->value);
        to_lower_case(aux->type);
        strcpy(s_eq->type, aux->type);
    }

    if(strcmp(f_eq->type, s_eq->type) == 0) {
        strcpy(node->type, f_eq->type);
    }

}

void is_lt(table* c_table, tree_node* node) {
    tree_node* f_eq = node->luke;
    tree_node* s_eq = f_eq->next_brother;
    table_element* aux;

    if(strcmp(f_eq->name, "Id") == 0) {
        aux = search_symbol(symbol_tables, c_table, f_eq->value);
        to_lower_case(aux->type);
        strcpy(f_eq->type, aux->type);
    }

    if(strcmp(s_eq->name, "Id") == 0) {
        aux = search_symbol(symbol_tables, c_table, s_eq->value);
        to_lower_case(aux->type);
        strcpy(s_eq->type, aux->type);
    }

    if(strcmp(f_eq->type, s_eq->type) == 0) {
        strcpy(node->type, f_eq->type);
    }

}

void is_gt(table* c_table, tree_node* node) {
    tree_node* f_eq = node->luke;
    tree_node* s_eq = f_eq->next_brother;
    table_element* aux;

    if(strcmp(f_eq->name, "Id") == 0) {
        aux = search_symbol(symbol_tables, c_table, f_eq->value);
        to_lower_case(aux->type);
        strcpy(f_eq->type, aux->type);
    }

    if(strcmp(s_eq->name, "Id") == 0) {
        aux = search_symbol(symbol_tables, c_table, s_eq->value);
        to_lower_case(aux->type);
        strcpy(s_eq->type, aux->type);
    }

    if(strcmp(f_eq->type, s_eq->type) == 0) {
        strcpy(node->type, f_eq->type);
    }

}

void is_le(table* c_table, tree_node* node) {
    tree_node* f_eq = node->luke;
    tree_node* s_eq = f_eq->next_brother;
    table_element* aux;

    if(strcmp(f_eq->name, "Id") == 0) {
        aux = search_symbol(symbol_tables, c_table, f_eq->value);
        to_lower_case(aux->type);
        strcpy(f_eq->type, aux->type);
    }

    if(strcmp(s_eq->name, "Id") == 0) {
        aux = search_symbol(symbol_tables, c_table, s_eq->value);
        to_lower_case(aux->type);
        strcpy(s_eq->type, aux->type);
    }

    if(strcmp(f_eq->type, s_eq->type) == 0) {
        strcpy(node->type, f_eq->type);
    }

}

void is_ge(table* c_table, tree_node* node) {
    tree_node* f_eq = node->luke;
    tree_node* s_eq = f_eq->next_brother;
    table_element* aux;

    if(strcmp(f_eq->name, "Id") == 0) {
        aux = search_symbol(symbol_tables, c_table, f_eq->value);
        to_lower_case(aux->type);
        strcpy(f_eq->type, aux->type);
    }

    if(strcmp(s_eq->name, "Id") == 0) {
        aux = search_symbol(symbol_tables, c_table, s_eq->value);
        to_lower_case(aux->type);
        strcpy(s_eq->type, aux->type);
    }

    if(strcmp(f_eq->type, s_eq->type) == 0) {
        strcpy(node->type, f_eq->type);
    }

}

void is_add(table* c_table, tree_node* node) {
    tree_node* f_eq = node->luke;
    tree_node* s_eq = f_eq->next_brother;
    table_element* aux;

    if(strcmp(f_eq->name, "Id") == 0) {
        aux = search_symbol(symbol_tables, c_table, f_eq->value);
        to_lower_case(aux->type);
        strcpy(f_eq->type, aux->type);
    }

    if(strcmp(s_eq->name, "Id") == 0) {
        aux = search_symbol(symbol_tables, c_table, s_eq->value);
        to_lower_case(aux->type);
        strcpy(s_eq->type, aux->type);
    }

    if(strcmp(f_eq->type, s_eq->type) == 0) {
        strcpy(node->type, f_eq->type);
    }

}

void is_sub(table* c_table, tree_node* node) {
    tree_node* f_eq = node->luke;
    tree_node* s_eq = f_eq->next_brother;
    table_element* aux;

    if(strcmp(f_eq->name, "Id") == 0) {
        aux = search_symbol(symbol_tables, c_table, f_eq->value);
        to_lower_case(aux->type);
        strcpy(f_eq->type, aux->type);
    }

    if(strcmp(s_eq->name, "Id") == 0) {
        aux = search_symbol(symbol_tables, c_table, s_eq->value);
        to_lower_case(aux->type);
        strcpy(s_eq->type, aux->type);
    }

    if(strcmp(f_eq->type, s_eq->type) == 0) {
        strcpy(node->type, f_eq->type);
    }

}

void is_mul(table* c_table, tree_node* node) {
    tree_node* f_eq = node->luke;
    tree_node* s_eq = f_eq->next_brother;
    table_element* aux;

    if(strcmp(f_eq->name, "Id") == 0) {
        aux = search_symbol(symbol_tables, c_table, f_eq->value);
        to_lower_case(aux->type);
        strcpy(f_eq->type, aux->type);
    }

    if(strcmp(s_eq->name, "Id") == 0) {
        aux = search_symbol(symbol_tables, c_table, s_eq->value);
        to_lower_case(aux->type);
        strcpy(s_eq->type, aux->type);
    }

    if(strcmp(f_eq->type, s_eq->type) == 0) {
        strcpy(node->type, f_eq->type);
    }

}

void is_div(table* c_table, tree_node* node) {
    tree_node* f_eq = node->luke;
    tree_node* s_eq = f_eq->next_brother;
    table_element* aux;

    if(strcmp(f_eq->name, "Id") == 0) {
        aux = search_symbol(symbol_tables, c_table, f_eq->value);
        to_lower_case(aux->type);
        strcpy(f_eq->type, aux->type);
    }

    if(strcmp(s_eq->name, "Id") == 0) {
        aux = search_symbol(symbol_tables, c_table, s_eq->value);
        to_lower_case(aux->type);
        strcpy(s_eq->type, aux->type);
    }

    if(strcmp(f_eq->type, s_eq->type) == 0) {
        strcpy(node->type, f_eq->type);
    }

}

void is_mod(table* c_table, tree_node* node) {
    tree_node* f_eq = node->luke;
    tree_node* s_eq = f_eq->next_brother;
    table_element* aux;

    if(strcmp(f_eq->name, "Id") == 0) {
        aux = search_symbol(symbol_tables, c_table, f_eq->value);
        to_lower_case(aux->type);
        strcpy(f_eq->type, aux->type);
    }

    if(strcmp(s_eq->name, "Id") == 0) {
        aux = search_symbol(symbol_tables, c_table, s_eq->value);
        to_lower_case(aux->type);
        strcpy(s_eq->type, aux->type);
    }

    if(strcmp(f_eq->type, s_eq->type) == 0) {
        strcpy(node->type, f_eq->type);
    }

}

void is_not(table* c_table, tree_node* node) {
    tree_node* not = node->luke;
    table_element* aux;

    if(strcmp(not->name, "Id") == 0) {
        aux = search_symbol(symbol_tables, c_table, not->value);
        to_lower_case(aux->type);
        strcpy(not->type, aux->type);
    }

    strcpy(node->type, not->type); //TODO: check if not gets the int
}

void is_minus(table* c_table, tree_node* node) {
    tree_node* minus = node->luke;
    table_element* aux;

    if(strcmp(minus->name, "Id") == 0) {
        aux = search_symbol(symbol_tables, c_table, minus->value);
        to_lower_case(aux->type);
        strcpy(minus->type, aux->type);
    }

    strcpy(node->type, minus->type); //TODO: check if not gets the int
}

void is_plus(table* c_table, tree_node* node) {
    tree_node* plus = node->luke;
    table_element* aux;

    if(strcmp(plus->name, "Id") == 0) {
        aux = search_symbol(symbol_tables, c_table, plus->value);
        to_lower_case(aux->type);
        strcpy(plus->type, aux->type);
    }

    strcpy(node->type, plus->type); //TODO: check if not gets the int
}

tree_node* is_addr(table* c_table, tree_node* node) {
    tree_node* son = node->luke;
    tree_node* ret;
    table_element* aux;

    if(strcmp(son->name, "Id") == 0) {
        aux = search_symbol(symbol_tables, c_table, son->value);
        to_lower_case(aux->type);
        strcpy(son->type, aux->type);
        son->pointer = aux->pointer;

        strcpy(node->type, aux->type);
        node->pointer = aux->pointer + 1;

        return node;
    } else if(strcmp(son->name, "Call") == 0) {
        is_deref_call(c_table, son);

        strcpy(node->type, son->type);
        node->pointer = son->pointer + 1;

        return node;
    } else {
        ret = is_addr(c_table, son);
        strcpy(node->type, ret->type);
        node->pointer = ret->pointer + 1;
        return node;
    }
}

tree_node* is_deref(table* c_table, tree_node* node) {
    tree_node* son = node->luke;
    tree_node* ret;
    table_element* aux;

    if(strcmp(son->name, "Id") == 0) {
        aux = search_symbol(symbol_tables, c_table, son->value);
        to_lower_case(aux->type);
        strcpy(son->type, aux->type);
        son->pointer = aux->pointer;

        strcpy(node->type, aux->type);
        node->pointer = aux->pointer - 1;

        return node;
    } else if(strcmp(son->name, "Add") == 0) {
        is_deref_add(c_table, son);

        strcpy(node->type, son->type);
        node->pointer = son->pointer - 1;

        return node;
    } else if(strcmp(son->name, "Call") == 0) {
        is_deref_call(c_table, son);

        strcpy(node->type, son->type);
        node->pointer = son->pointer - 1;

        return node;
    } else {
        ret = is_deref(c_table, son);
        strcpy(node->type, ret->type);
        node->pointer = ret->pointer - 1;
        return node;
    }
}

void is_deref_call(table* c_table, tree_node* node) {
    tree_node* function = node->luke;
    table_element* aux;

    if(strcmp(function->name, "Id") == 0) {
        aux = search_symbol(symbol_tables, c_table, function->value);

        to_lower_case(aux->type);
        strcpy(node->type, aux->type);
        node->pointer = aux->pointer;

        strcpy(function->type, aux->type);
        function->pointer = aux->pointer;
        function->params = aux->func_param;
    }

    repeat_check_brother(c_table, function);
}

void is_deref_add(table* c_table, tree_node* node) {
    tree_node* f_node = node->luke;
    table_element* aux;

    if(strcmp(f_node->name, "Id") == 0) {
        aux = search_symbol(symbol_tables, c_table, f_node->value);
        to_lower_case(aux->type);
        strcpy(f_node->type, aux->type);
        f_node->pointer = aux->pointer;

        strcpy(node->type, aux->type);
        node->pointer = aux->pointer;
    }
}

void is_store(table* c_table, tree_node* node) {
    tree_node* target = node->luke;
    table_element* aux;

    if(strcmp(target->name, "Id") == 0) {
        aux = search_symbol(symbol_tables, c_table, target->value);
        to_lower_case(aux->type);
        strcpy(target->type, aux->type);
    }

    strcpy(node->type, target->type);

    repeat_check(c_table, node);
}

void is_comma(table* c_table, tree_node* node) {

}

void is_call(table* c_table, tree_node* node) {
    tree_node* function = node->luke;
    table_element* aux;

    if(strcmp(function->name, "Id") == 0) {
        aux = search_symbol(symbol_tables, c_table, function->value);

        to_lower_case(aux->type);
        strcpy(node->type, aux->type);
        node->pointer = aux->pointer;

        strcpy(function->type, aux->type);
        function->pointer = aux->pointer;
        function->params = aux->func_param;
    }

    repeat_check_brother(c_table, function);

}

void is_id(table* c_table, tree_node* node) {
    table_element* aux = search_symbol(symbol_tables, c_table, node->value);

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
}
