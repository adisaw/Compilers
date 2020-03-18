#include "ass5_17CS10057_translator.h"
#include "y.tab.h"

int sizeOfInt=4;
int sizeOfFLoat=8;
int sizeOfPointer=4;
int sizeOfChar=1;
int sizeOfBool=1;

Type *glbType;
int glbWidth;
int nextInstr;
int tempCount=0;
SymTab *glbSt =new SymTab();
SymTab *currSt = new SymTab();
QuadArray quads;

Type::Type(types t,int sz,Type *n)
{
	basetp=t;
	size=sz;
	next=n;
}

int Type::getSize()
{
	if(this==NULL)
		return 0;
	//return the size of the Array by calling the recursive function
	//here we are not checking for null as if it will reach the final type it will enter the below conditions
	if((this->basetp) == Tarray)
		return ((this->size)*(this->next->getSize()));
	if((this->basetp) == Tvoid)
		return 0;
	if((this->basetp) == Tint)
		return sizeOfInt;
	if((this->basetp) == Tfloat)
		return sizeOfFLoat;
	if((this->basetp) == Tbool)
		return sizeOfBool;
	if((this->basetp) == Tchar)
		return sizeOfChar;
	if((this->basetp) == Tptr)
		return sizeOfPointer;
}

types Type::getBaseType()
{
	if(this!=NULL)
		return this->basetp;
	else
		return Tvoid;
}

void Type::printSize()
{
	printf("%d\n",size);
}

void Type::print()
{
	switch(basetp){
		case Tvoid:
			printf("Void");
			break;
		case Tbool:
			printf("Bool");
			break;
		case Tint:
			printf("Int");
			break;
		case Tchar:
			printf("Char");
			break;
		case Tfloat:
			printf("Float");
			break;
		case Tptr:
			printf("Ptr(");
			if(this->next!=NULL)
				this->next->print();
			printf(")");
			break;
		case Tarray:
			printf("Array(%d,",size);
			if(this->next!=NULL)
				this->next->print();
			printf(")");
			break;
		case Tfunc:
			printf("Function()");
			break;
		default:
			printf("TYPE NOT FOUND\n");
			exit(-1);
	}

}

Array::Array(string s,int sz,types t)
{
	this->arrBase=s;
	this->tp=t;
	this->bsize=sz;
	this->ndims=1;
}

void Array::addIndex(int i)
{
	this->ndims=this->ndims+1;
	this->dims.push_back(i);
}

void Function::print()
{

	printf("Function(");
	int i;
	for(i=0;i<typelist.size();i++)
	{
		if(i!=0)
			printf(",");
		printf("%d ",typelist[i]);
	}
	printf(")");
}

Function::Function(vector<types> tlist)
{
	typelist=tlist;
}
SymRec::SymRec(string n)
{
	name=n;
	size=0;
	recType=NULL;
	offset=-1;
	vType="";
	isInitialized=false;
	isFunction=false;
	isArray=false;
	arr=NULL;
	funct=NULL;
	nestedTab=NULL;
}

void SymRec::createArray()
{
	arr=new Array(this->name,this->size,Tarray);
}


SymTab::SymTab()
{
	name="";
	offset=0;
}

SymTab::~SymTab()
{
	int i;
	for(i=0;i<records.size();i++)
	{
		Type *p1=records[i]->recType;
		Type *p2;
		while(true)
		{
			if(p1 == NULL)
				break;
			p2=p1;
			p1=p1->next;
			delete p2;
		}
	}
}

Type *CopyType(Type *t)
{
	/*Duplicates the input type and returns the pointer to the newly created type*/
	if(t == NULL) return t;
	Type *ret = new Type(t->basetp);

	ret->size = t->size;
	ret->basetp = t->basetp;

	ret->next = CopyType(t->next);
	return ret;
}

SymRec* SymTab::lookup(string n)
{
	int i;
	for(i=0;i<records.size();i++)
	{
		if(records[i]->name == n)
		{
			return records[i];
		}
	}
	SymRec *temp_o=new SymRec(n);
	temp_o->initVal.int_val=0;
	records.push_back(temp_o);
	return records[records.size()-1];
}

SymRec* SymTab::search(string n)
{
	int i;
	for(i=0;i<records.size();i++)
	{
		if(records[i]->name==n)
		{
			return (records[i]);
		}
	}
	return NULL;
}

SymRec* SymTab::gentemp(Type *type)
{
	char c[10];
	sprintf(c,"t%03d",tempCount);
	tempCount++;
	SymRec *temp=lookup(c);
	int temp_sz;
	if(type==NULL)
		temp_sz=0;
	else if((type->basetp) == Tvoid)
		temp_sz=0;
	else if((type->basetp) == Tint)
		temp_sz=sizeOfInt;
	else if((type->basetp) == Tfloat)
		temp_sz=sizeOfFLoat;
	else if((type->basetp) == Tbool)
		temp_sz=sizeOfBool;
	else if((type->basetp) == Tchar)
		temp_sz=sizeOfChar;
	else if((type->basetp) == Tptr)
		temp_sz=sizeOfPointer;
	else
		temp_sz=type->getSize();
	temp->size=temp_sz;
	temp->vType="temp";
	temp->recType=type;
	this->offset=this->offset+(temp->size);
	return temp;
}

void SymTab::update(SymRec *sm,Type *type,BasicVal initval,SymTab *next)
{
	sm->recType=CopyType(type);
	sm->initVal=initval;
	sm->nestedTab=next;
	int temp_sz;
	if(sm->recType==NULL)
		temp_sz=0;
	else if(((sm->recType)->basetp) == Tvoid)
		temp_sz=0;
	else if(((sm->recType)->basetp) == Tint)
		temp_sz=sizeOfInt;
	else if(((sm->recType)->basetp) == Tfloat)
		temp_sz=sizeOfFLoat;
	else if(((sm->recType)->basetp) == Tbool)
		temp_sz=sizeOfBool;
	else if(((sm->recType)->basetp) == Tchar)
		temp_sz=sizeOfChar;
	else if(((sm->recType)->basetp) == Tptr)
		temp_sz=sizeOfPointer;
	else
		temp_sz=sm->recType->getSize();
	sm->size=temp_sz;
	sm->offset=this->offset+(sm->size);
	sm->isInitialized=false;
}

void SymTab::print()
{
	printf("\n+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++\n");
	printf("\nSymbol Table : %s\n",name.c_str());
	printf("\n-------------------------------------------------------------------------------------\n");
	printf("Name\tValue\t\tvType\tSize\tOffset\tType");
	printf("\n-------------------------------------------------------------------------------------\n");
    for(int i = 0; i<(records).size(); i++)
    {
        SymRec * t = records[i];
        printf("%s\t",records[i]->name.c_str());
        if(t->isInitialized)
        {
        	if((t->recType)->basetp == Tchar) printf("%c\t\t",(t->initVal).char_val);
        	else if((t->recType)->basetp == Tint) printf("%d\t\t",(t->initVal).int_val);
        	else if((t->recType)->basetp == Tfloat) printf("%lf\t",(t->initVal).float_val);
       	 	else printf("----\t\t");
      	}
      	else
      		printf("null\t\t");
        printf("%s\t",t->vType.c_str());
        printf("\t%d\t%d\t",t->size,t->offset);
		if(t->vType == "func")
			printf("ptr-to-St( %s )",t->nestedTab->name.c_str());

		if(t->recType != NULL)
			(t->recType)->print();
		printf("\n");
	}
	printf("\n+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++\n");

}
List* makelist(int i)
{
	List *temp = (List*)malloc(sizeof(List));
	temp->index=i;
	temp->next=NULL;
	return temp;
}
List* merge(List *lt1,List *lt2)
{
	List *temp = (List*)malloc(sizeof(List));
	List *p1=temp;
	int flag=0;
	List *l1=lt1;
	List *l2=lt2;
	while(l1!=NULL)
	{
		flag=1;
		p1->index=l1->index;
		if(l1->next!=NULL)
		{
			p1->next=(List*)malloc(sizeof(List));
			p1=p1->next;
		}
		l1=l1->next;
	}
	while(l2!=NULL)
	{
		if(flag==1)
		{
			p1->next=(List*)malloc(sizeof(List));
			p1=p1->next;
			flag=0;
		}
		p1->index=l2->index;
		if(l2->next!=NULL)
		{
			p1->next=(List*)malloc(sizeof(List));
			p1=p1->next;
		}
		l2=l2->next;
	}
	p1->next=NULL;
	return temp;
}

Quad::Quad(opcode opc,string a1,string a2,string rs)
{
	this->op=opc;
	this->arg1=a1;
	this->result=rs;
	this->arg2=a2;
}

void Quad::printArg()
{
	printf("\t%s\t=\t%s\top\t%s\t",result.c_str(),arg1.c_str(),arg2.c_str());
}

QuadArray::QuadArray()
{
	nextInstr=0;
}

void QuadArray::emit(opcode opc, string arg1, string arg2, string result)
{
	if(result.size()!=0)
	{
		Quad new_elem(opc,arg1,arg2,result);
		arr.push_back(new_elem);
	}
	else if(arg2.size()!=0)
	{
		Quad new_elem(opc,arg1,"",arg2);
		arr.push_back(new_elem);
	}
	else if(arg1.size()!=0)
	{
		Quad new_elem(opc,"","",arg1);
		arr.push_back(new_elem);
	}
	else
	{
		Quad new_elem(opc,"","","");
		arr.push_back(new_elem);
	}
	nextInstr=nextInstr+1;
}

void QuadArray::emit(opcode opc, int val, string operand)
{
	char str[20];
	sprintf(str, "%d", val);
	if(operand.size()==0)
	{
		Quad new_quad(opc,"","",str);
		arr.push_back(new_quad);
	}
	else
	{
		Quad new_quad(opc,str,"",operand);
		arr.push_back(new_quad);
	}
	nextInstr=nextInstr+1;
}

void QuadArray::emit(opcode opc, float val, string operand)
{
	char str[20];
	sprintf(str, "%lf", val);
	if(operand.size()==0)
	{
		Quad new_quad(opc,"","",str);
		arr.push_back(new_quad);
	}
	else
	{
		Quad new_quad(opc,str,"",operand);
		arr.push_back(new_quad);
	}
	nextInstr=nextInstr+1;
}

void QuadArray::emit(opcode opc, char val, string operand)
{
	char str[20];
	sprintf(str, "'%c'", val);
	if(operand.size()==0)
	{
		Quad new_quad(opc,"","",str);
		arr.push_back(new_quad);
	}
	else
	{
		Quad new_quad(opc,str,"",operand);
		arr.push_back(new_quad);
	}
	nextInstr=nextInstr+1;
}

void QuadArray::print()
{
		opcode op;
		string arg1;
		string arg2;
		string result;
	for(int i=0;i<nextInstr;i++)
	{
		op=arr[i].op;
		arg1=arr[i].arg1;
		arg2=arr[i].arg2;
		result=arr[i].result;
		printf("%3d :\t",i);
		if(OP_ADD<=op && op<=OP_NEQ)
	    {
	        printf("%s",result.c_str());
	        printf("\t=\t");
	        printf("%s",arg1.c_str());
	        printf(" ");
	        switch(op)
	        {
	            case OP_ADD:
	            	printf("+");
	            	break;
	            case OP_SUB:
	            	printf("-");
	            	break;
	            case OP_MULT:
	            	printf("*");
	            	break;
	            case OP_DIV:
	            	printf("/");
	            	break;
	            case OP_MOD:
	            	printf("%%");
	            	break;
	            case OP_LST:
	            	printf("<<");
	            	break;
	            case OP_RST:
	            	printf(">>");
	            	break;
	            case OP_XOR:
	            	printf("^");
	            	break;
	            case OP_AND:
	            	printf("&");
	            	break;
	            case OP_OR:
	            	printf("|");
	            	break;
	            case OP_LOGIC_AND:
	            	printf("&&");
	            	break;
	            case OP_LOGIC_OR:
	            	printf("||");
	            	break;
	            case OP_LTH:
	            	printf("<");
	            	break;
	            case OP_LEQ:
	            	printf("<=");
	            	break;
	            case OP_GEQ:
	            	printf(">=");
	            	break;
	            case OP_GTH:
	            	printf(">");
	            	break;
	            case OP_EQ:
	            	printf("==");
	            	break;
	            case OP_NEQ:
	            	printf("!=");
	            	break;
	        }
	        printf(" ");
	       	printf("%s\n",arg2.c_str());
	    }
	    else if(OP_UMINUS<=op && op<=OP_ASSIGN)
	    {
	        printf("%s",result.c_str());
	        printf("\t=\t");
	        switch(op)
	        {

	            //Unary Assignment Instruction
	            case OP_UMINUS :
	            	printf("-");
	            	break;
	            case OP_UPLUS :
	            	printf("+");
	            	break;
	            case OP_NOT :
	            	printf("~");
	            	break;
	            case OP_LOGIC_NOT :
	            	printf("!");
	            	break;
	            //Copy Assignment Instruction
	            case OP_ASSIGN :
	            	break;
	        }
	        printf("%s\n",arg1.c_str());
	    }
	    else if(op == OP_GOTO) {printf("goto ");printf("%s\n",result.c_str());}
	    else if(OP_IF_EQ<=op && op<=OP_IF_GEQ)
	    {
	        printf("if  ");printf("%s",arg1.c_str());printf(" ");
	        switch(op)
	        {
	            //Conditional Jump
	            case   OP_IF_LTH :
	            	printf("<");
	            	break;
	            case   OP_IF_GTH :
	            	printf(">");
	            	break;
	            case   OP_IF_LEQ :
	            	printf("<=");
	            	break;
	            case   OP_IF_GEQ :
	            	printf(">=");
	            	break;
	            case   OP_IF_EQ :
	            	printf("==");
	            	break;
	            case   OP_IF_NEQ :
	            	printf("!=");
	            	break;
	            case   OP_IF_EXPR :
	            	printf("!= 0");
	            	break;
	            case   OP_IF_NEXPR :
	            	printf("== 0");
	            	break;
	        }
	        printf("%s",arg2.c_str());printf("\tgoto ");
	        printf("%s\n",result.c_str());
	    }
	    else if(OP_CHAR2INT<=op && op<=OP_FLT2INT)
	    {
	        printf("%s",result.c_str());printf("\t=\t");
	        switch(op)
	        {
	            case OP_CHAR2INT :
	            	printf(" Char2Int(");printf("%s",arg1.c_str());printf(")\n");
	            	break;
	            case OP_CHAR2FLT :
	            	printf(" Char2float(");printf("%s",arg1.c_str());printf(")\n");
	            	break;
	            case OP_INT2CHAR :
	            	printf(" Int2Char(");printf("%s",arg1.c_str());printf(")\n");
	            	break;
	            case OP_FLT2CHAR :
	            	printf(" float2Char(");printf("%s",arg1.c_str());printf(")\n");
	            	break;
	            case OP_INT2FLT :
	            	printf(" Int2float(");printf("%s",arg1.c_str());printf(")\n");
	            	break;
	            case OP_FLT2INT :
	            	printf(" float2Int(");printf("%s",arg1.c_str());printf(")\n");
	            	break;
	        }
	    }
	    else if(op == OP_PARAM)
	    {
	        printf("param\t");printf("%s\n",result.c_str());
	    }
	    else if(op == OP_CALL)
	    {
	        if(!result.c_str())
					printf("call %s, %s\n", arg1.c_str(), arg2.c_str());
				else
					printf("%s\t=\tcall %s, %s\n", result.c_str(), arg1.c_str(), arg2.c_str());
	    }
	    else if(op == OP_RETURN)
	    {
	        printf("return\t");printf("%s\n",result.c_str());
	    }
	    else if( op == OP_RINDEX)
	    {
	        printf("%s\t=\t%s[%s]\n", result.c_str(), arg1.c_str(), arg2.c_str());
	    }
	    else if(op == OP_LINDEX)
	    {
	        printf("%s[%s]\t=\t%s\n", result.c_str(), arg1.c_str(), arg2.c_str());
	    }
	    else if(op == OP_LDEREF)
	    {
	        printf("*%s\t=\t%s\n", result.c_str(), arg1.c_str());
	    }
	    else if(op == OP_RDEREF)
	    {
	    	printf("%s\t=\t* %s\n", result.c_str(), arg1.c_str());
	    }
	    else if(op == OP_ADDREF)
	    {
	    	printf("%s\t=\t& %s\n", result.c_str(), arg1.c_str());
	    }
	}
}

void backpatch(List *l,int i)
{
	List *temp =l;
	List *temp2;
	char str[10];
	sprintf(str,"%d",i);
	while(temp!=NULL)
	{
		quads.arr[temp->index].result = str;
		temp2=temp;
		temp=temp->next;
		free(temp2);
	}
}

void typeCheck(Expression *e1,Expression *e2,bool isAssign)
{
	types type1,type2;
	type1=(e1->type)->basetp;
	type2=(e2->type)->basetp;
	if(type1==type2)
	{
		return;
	}
	if(!isAssign)
	{
		if(type1>type2)
		{
			SymRec *temp = currSt->gentemp(e1->type);
			if(type1 == Tint && type2 == Tchar)
				quads.emit(OP_CHAR2INT, e2->loc->name, temp->name);
			else if(type1 == Tfloat && type2 == Tint)
				quads.emit(OP_INT2FLT, e2->loc->name, temp->name);
			e2->loc = temp;
			e2->type = temp->recType;
		}
		else
		{
			SymRec *temp = currSt->gentemp(e2->type);
			if(type2 == Tint && type1 == Tchar)
				quads.emit(OP_CHAR2INT, e1->loc->name, temp->name);
			else if(type2 == Tfloat && type1 == Tint)
				quads.emit(OP_INT2FLT, e1->loc->name, temp->name);
			e1->loc = temp;
			e1->type = temp->recType;
		}
	}
	else
	{
		SymRec *temp = currSt->gentemp(e1->type);
		if(type1 == Tint && type2 == Tfloat)
			quads.emit(OP_FLT2INT, e2->loc->name, temp->name);
		else if(type1 == Tfloat && type2 == Tint)
			quads.emit(OP_INT2FLT, e2->loc->name, temp->name);
		else if(type1 == Tchar && type2 == Tint)
			quads.emit(OP_INT2CHAR, e2->loc->name, temp->name);
		else if(type1 == Tint && type2 == Tchar)
			quads.emit(OP_CHAR2INT, e2->loc->name, temp->name);
		else
		{
			printf("%s %s Types compatibility not defined\n",e1->loc->name.c_str(),e2->loc->name.c_str());
			exit(-1);
		}
		e2->loc = temp;
		e2->type = temp->recType;
	}
}

void printList(List *root)
{
	int flag=0;
	while(root!=NULL)
	{
		printf("%d ",root->index);
		flag=1;
		root=root->next;
	}
	if(flag==0)
	{
		printf("Empty List\n");
	}
	else
	{
		printf("\n");
	}
}
void conv2bool(Expression *e)
{
	if((e->type)->basetp!=Tbool)
	{
		(e->type) = new Type(Tbool);
		e->falselist=makelist(nextInstr);
		quads.emit(OP_IF_EQ,e->loc->name,"0","-1");
		e->truelist = makelist(nextInstr);
		quads.emit(OP_GOTO,-1);
	}
}

int main()
{
	yyparse();
	glbSt->name="Global";
	printf("=====================================================================================");
	printf("\n\nGenerated Quads for the program\n\n");
	quads.print();
	printf("=====================================================================================");
	printf("\n\nSymbol table Maintained For the Given Program\n");
	glbSt->print();
	for(int i=0; i<glbSt->records.size();i++)
	{
		((glbSt->records[i])->nestedTab)->print();
	}
	printf("=====================================================================================\n");
	return 0;
}
