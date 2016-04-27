#include <stdlib.h>
#include "ast.h"

tree_node* create_simple_node(char* name) {
    tree_node* new_node = (tree_node*) malloc( sizeof(tree_node) );

    if (new_node != NULL) {
        strcpy(new_node->name, name);
        new_node->next_brother = NULL;
        new_node->luke = NULL;
        new_node->darth_vader = NULL;
        new_node->pointer = 0;
        new_node->size_dec = -1;
        strcpy(new_node->size, "-1");
    } else {
        printf("ERROR SIMPLE NODE\n");
    }

    return new_node;
}

tree_node* create_str_node(char* name, char* value) {
    tree_node* new_node = (tree_node*)malloc(sizeof(tree_node));

    if(new_node != NULL) {
        strcpy(new_node->name, name);
        new_node->next_brother = NULL;
        new_node->luke = NULL;
        new_node->darth_vader = NULL;
        new_node->pointer = 0;
        new_node->size_dec = -1;
        strcpy(new_node->size, "-1");

        strcpy(new_node->value, value);
    } else {
        printf("ERROR STR NODE\n");
    }

    return new_node;
}

tree_node* create_str_node_with_type(char* name, char* value, char* type) {
    tree_node* new_node = (tree_node*)malloc(sizeof(tree_node));

    if(new_node != NULL) {
        strcpy(new_node->name, name);
        new_node->next_brother = NULL;
        new_node->luke = NULL;
        new_node->darth_vader = NULL;
        new_node->pointer = 0;
        new_node->size_dec = -1;
        strcpy(new_node->size, "-1");

        strcpy(new_node->value, value);
        strcpy(new_node->type, type);
    } else {
        printf("ERROR STR NODE\n");
    }

    return new_node;
}

tree_node* create_strlit_node(char* name, char* value, char* type) {
    tree_node* new_node = (tree_node*)malloc(sizeof(tree_node));
    char size[MAX_STR];

    sprintf(size, "%ld", strlen(value) - 1);

    if(new_node != NULL) {
        strcpy(new_node->name, name);
        new_node->next_brother = NULL;
        new_node->luke = NULL;
        new_node->darth_vader = NULL;
        new_node->pointer = 0;
        new_node->size_dec = -1;
        strcpy(new_node->size, "-1");

        strcpy(new_node->value, value);
        strcpy(new_node->type, type);
        strcpy(new_node->size, size );
    } else {
        printf("ERROR STR NODE\n");
    }

    return new_node;
}

void add_child(tree_node * father , tree_node * son){
    if(father->luke != NULL) {
        son->next_brother = father->luke;
        son->darth_vader = father;
        father->luke = son;
    } else {
        son->darth_vader = father;
        father->luke = son;
    }
}

void add_brother_end(tree_node* brother, tree_node* new_son) {
    tree_node* aux = brother;
    if(aux!= NULL && new_son != NULL) {
        while(aux->next_brother != NULL) {
            aux = aux->next_brother;
        }
        aux->next_brother = new_son;
        new_son->darth_vader = brother->darth_vader;
    }
}

/* PRINTING */
void print_terminal(tree_node* node){
    printf("%s(%s)\n", node->name, node->value);
}

void print_points(int n){
    while(n > 0){
        printf("..");
        n--;
    }
}

void print_tree(tree_node* node, int level){
    if(node != NULL) {
        print_points(level);

        if(strcmp(node->name, "Id") == 0 || strcmp(node->name, "ChrLit") == 0 || strcmp(node->name, "StrLit") == 0 || strcmp(node->name, "IntLit") == 0){
            print_terminal(node);
        } else {
            printf("%s\n", node->name);
        }

        tree_node* child = node->luke;

        if(child != NULL){
            print_tree(child, level + 1);

            while(child->next_brother != NULL){
                child = child->next_brother;
                print_tree(child, level + 1);
            }

        }
    }
}

/* PRINTING ANNOTATED */
void print_annotated_params(element_param* params) {
    printf("(");
    while(params != NULL) {
        printf("%s", params->type);

        for (int i = 0; i < params->pointer; i++) {
            printf("*");
        }

        if(params->next != NULL) {
            printf(",");
        }

        params = params->next;
    }
    printf(")");
}

void print_annotated_terminal(tree_node* node) {
    if(strcmp(node->type, "") != 0) {
        printf("%s(%s) - %s", node->name, node->value, node->type);

        for(int i = 0; i < node->pointer; i++) {
            printf("*");
        }

        if(strcmp(node->size, "-1") != 0) {
            printf("[%d]", node->size_dec);
        }

        if (node->params != NULL) {
            print_annotated_params(node->params);
        }

        printf("\n");
    } else {
        if(node->size_dec != -1) {
            printf("%s(%d)\n", node->name, node->size_dec);
        } else {
            printf("%s(%s)\n", node->name, node->value);
        }
    }

}

void print_annotated_tree(tree_node* node, int level) {
    if(node != NULL) {
        print_points(level);

        if(strcmp(node->name, "Id") == 0 || strcmp(node->name, "ChrLit") == 0 || strcmp(node->name, "StrLit") == 0 || strcmp(node->name, "IntLit") == 0){
            print_annotated_terminal(node);
        } else {
            if(strcmp(node->type, "") != 0) {
                printf("%s - %s", node->name, node->type);

                for(int i = 0; i < node->pointer; i++) {
                    printf("*");
                }

                printf("\n");
            } else {
                printf("%s\n", node->name);
            }
        }

        tree_node* child = node->luke;

        if(child != NULL){
            print_annotated_tree(child, level + 1);

            while(child->next_brother != NULL){
                child = child->next_brother;
                print_annotated_tree(child, level + 1);
            }

        }
    }
}
