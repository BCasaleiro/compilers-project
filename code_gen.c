#include "code_gen.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>


void print_code(tree_node* root, table* c_table){
	tree_node * aux = root->luke;
	while(aux != NULL){
		
		llvm_is_easy(aux, c_table);
		aux = aux->next_brother;
	}
}

void llvm_is_easy(tree_node * node, table * c_table){
	if ( strcmp(node->name, "FuncDefinition") == 0 ) {
        funcDefenition_code(node, c_table);
    }else if(strcmp(node->name, "Declaration")==0){
    	//globalDeclaration_code(node, c_table);
    }
}

void globalDeclaration_code(tree_node * node, table * c_table){
	printf("@");	
}

void funcDefenition_code(tree_node * node, table * c_table){
	printf("define");

	tree_node * aux = node -> luke;
	table * aux_table = c_table;
	while(strcmp(aux->name, "Id") != 0){
		aux = aux->next_brother;
	}

	while(strcmp(aux_table->name, aux->value) != 0){
		aux_table=aux_table->next;
	}

	table_element* aux_element = aux_table->symbols;
	while(strcmp(aux_element->name, "return")!=0){
		aux_element = aux_element->next;
	}

	if (strcmp(aux_element->type, "int") == 0){
		printf(" i32");
	}else if(strcmp(aux_element->type, "void") == 0){
		printf(" void");
	}

	printf(" @");
	printf("%s", aux->value);
	printf("(");

	int param_count = 0;
	aux_element=aux_element->next;
	while(aux_element != NULL && aux_element -> param){
		if(param_count!=0){
			printf(", ");
		}

		if (strcmp(aux_element->type, "int") == 0){
			printf(" i32");
			int i=0;
			while(i<aux_element->pointer){
				printf("*");
				i++;
			}
			printf(" %%%s", aux_element->name);
		}else if(strcmp(aux->type, "void") == 0){
			if(aux_element->pointer >= 1){
				printf(" i8");
				int i=0;
				while(i<aux_element->pointer){
					printf("*");
					i++;
				}
			}
			else{
				printf(" void");
			}

		}else if (strcmp(aux_element->type, "char") == 0){
			printf(" i8");
			int i=0;
			while(i<aux_element->pointer){
				printf("*");
				i++;
			}
			printf(" %%%s", aux_element->name);
		}
		aux_element = aux_element->next;
		param_count++;
	}
	printf(" )\n");
	
	while(aux != NULL && (strcmp(aux->name, "FuncBody") != 0)){
		aux = aux->next_brother;
	}

	if(aux!=NULL){
		printf("{\n");
		print_function_body(aux,c_table);
		printf("}\n");
	}
}

void print_function_body(tree_node * node, table * c_table){
	tree_node * aux_node = node->luke;
	while(aux_node != NULL){
		if(strcmp(aux_node->name, "Declaration")==0){

		}else if(strcmp(aux_node->name, "ArrayDeclaration")==0){

		}else if(strcmp(aux_node->name, "Return")==0){
			tree_node * current = aux_node -> luke;
			if(strcmp(current->name, "Id")==0){
				printf("ret %s %%%s\n",return_type(current),current->name);
			}else if(strcmp(current->name, "IntLit")==0){
				printf("ret %s %s\n", return_type(current), current->value);
			}
			else if(strcmp(current->name, "CharLit")==0){
				printf("ret %s %s\n", return_type(current), current->value);
			}
		}
		aux_node = aux_node->next_brother;
	}
}


char * return_type(tree_node * node){
	char * p = (char*)malloc(sizeof(char*)*10);
	if(strcmp(node->type, "int")==0){
		strcpy(p, "i32");
	}else {
		strcpy(p, "qq");
	}
	return p;
}