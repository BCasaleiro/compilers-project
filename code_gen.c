#include "code_gen.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>


void print_code(tree_node* root){
	tree_node * aux = root->luke;
	while(aux != NULL){
		llvm_is_easy(aux);
		aux = aux->next_bother;
	}
}

void llvm_is_easy(tree_node * node){
	if ( strcmp(node->name, "FuncDefinition") == 0 ) {
        funcDefenition_code(node);
    }
}



void funcDefenition_code(tree_node * node){
	printf("define");

	char * type;


}