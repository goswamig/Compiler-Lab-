#include "codegen.h"

		
int CodeGen(NODPTR ptr)
{
	int t1, t2, t;	
	switch(ptr->NodeType)
	{
		case CONST:
					t = regcount++;
					fprintf(fp, "MOV R%d %d\n", t, ptr->value);
					regcount--;
					return t;
					break;
		case VARIABLE:
					t = regcount++;
					fprintf(fp, "MOV R%d [%d]\n", t, ptr->stptr->binding);
					return t;
					break;
		case RD:
					t = regcount++;
					fprintf(fp,"IN R%d\n", t);
					fprintf(fp, "MOV [%d] R%d\n", ptr->Lptr->stptr->binding, t);
					regcount--;
					return 0;
					break;
		//Recursive cases.
		case WE:
					t2 = CodeGen(ptr->Lptr);
					t1 = regcount++;
					fprintf(fp, "MOV R%d R%d \n", t1, t2);
					fprintf(fp,"OUT R%d\n", t1);
					regcount-=2;
					return 0;
					break;
		case PLUS:
					t1 = CodeGen(ptr->Lptr);
					t2 = CodeGen(ptr->Rptr);
					fprintf(fp, "ADD R%d R%d\n", t1, t2);
					regcount--;
					return t1;
					break;
		case MINUS:
					t1 = CodeGen(ptr->Lptr);
					t2 = CodeGen(ptr->Rptr);
					fprintf(fp, "SUB R%d R%d\n", t1, t2);
					regcount--;
					return t1;
					break;
		case MUL:
					t1 = CodeGen(ptr->Lptr);
					t2 = CodeGen(ptr->Rptr);
					fprintf(fp, "MUL R%d R%d\n", t1, t2);
					regcount--;
					return t1;
					break;
		case DIV:
					t1 = CodeGen(ptr->Lptr);
					t2 = CodeGen(ptr->Rptr);
					fprintf(fp, "DIV R%d R%d\n", t1, t2);
					regcount--;
					return t1;
					break;
		case SEQ:
					CodeGen(ptr->Lptr);
					if(ptr->Rptr)
						CodeGen(ptr->Rptr);
					return 0;
					break;
		case EQUAL:
					t1 = CodeGen(ptr->Rptr);
					fprintf(fp, "MOV [%d] R%d\n", ptr->Lptr->stptr->binding, t1);
					return 0;
					break;

		case GT:		t1 = CodeGen(ptr->Lptr);
					t2 = CodeGen(ptr->Rptr);
					fprintf(fp, "GT R%d R%d\n", t1, t2);
					regcount--;
					return t1;
					break;

		case LT:		t1 = CodeGen(ptr->Lptr);
					t2 = CodeGen(ptr->Rptr);
					fprintf(fp, "LT R%d R%d\n", t1, t2);
					regcount--;
					return t1;
					break;
	}
}
