#include "ass6_17CS10060_translator.h"
#include "y.tab.h"

extern quad_arr glob_quad;
extern int next_instr;
map<int,int> mp_set;
stack<string> params_stack;
int tester;
stack<int> types_stack;
stack<int> offset_stack;
int tester2;
stack<int> ptrarr_stack;
extern std::vector< string > vs;
extern std::vector<string> cs;
int add_off;
void symtab::mark_labels()
{
	int m=9;
	int count=1;
	//printf("%d-->%d\n",next_instr,glob_quad.arr.size());
	for(int i=0;i<next_instr;i++)
	{
		if(glob_quad.arr[i].op==Q_GOTO || glob_quad.arr[i].op==Q_IF_EQUAL || glob_quad.arr[i].op==Q_IF_NOT_EQUAL 
			|| glob_quad.arr[i].op==Q_IF_EXPRESSION || glob_quad.arr[i].op==Q_IF_NOT_EXPRESSION || glob_quad.arr[i].op== Q_IF_LESS ||
			glob_quad.arr[i].op== Q_IF_GREATER ||glob_quad.arr[i].op== Q_IF_LESS_OR_EQUAL||glob_quad.arr[i].op==Q_IF_GREATER_OR_EQUAL)
		{
			if(glob_quad.arr[i].result!="-1")
			{
				m++;
				if(mp_set.find(atoi(glob_quad.arr[i].result.c_str()))==mp_set.end())
				{
					m++;
					mp_set[atoi(glob_quad.arr[i].result.c_str())]=count;
					m--;
					count++;
				}
				m--;
			}
		}
		/*switch(glob_quad.arr[i].op)
		{
			case Q_GOTO:
			case Q_IF_EQUAL:
			case Q_IF_NOT_EQUAL:
			case Q_IF_EXPRESSION:
			case Q_IF_NOT_EXPRESSION:
			case Q_IF_LESS:
			case Q_IF_GREATER:
			case Q_IF_LESS_OR_EQUAL:
			case Q_IF_GREATER_OR_EQUAL:
			if(glob_quad.arr[i].result=="-2")
			{
				glob_quad.arr[i].result=itoa(next_instr-1);
			}
			if(glob_quad.arr[i].result!="-1")
			{
				if(mp_set.find(atoi(glob_quad.arr[i].result.c_str()))==mp_set.end())
				{
					mp_set[atoi(glob_quad.arr[i].result.c_str())]=count;
					count++;
				}
			}
		}*/
	}
}

void symtab::function_prologue(FILE *fp,int count)
{
	int k=2;
	fprintf(fp,"\n\t.globl\t%s",name.c_str());
	k=k-2;
	fprintf(fp,"\n\t.type\t%s, @function",name.c_str());
	k++;
	fprintf(fp,"\n%s:",name.c_str());
	k=k*8;
	fprintf(fp,"\n.LFB%d:",count);
	int m=0;
	k=k+m;
	fprintf(fp,"\n\tpushq\t%%rbp");
	m=m-k;
	fprintf(fp,"\n\tmovq\t%%rsp, %%rbp");
	m=m+k;
	int t=-offset;
	k=k*m;
	fprintf(fp,"\n\tsubq\t$%d, %%rsp",t);
}

void symtab::global_variables(FILE *fp)
{
	for(int i=0;i<symbol_tab.size();i++)
	{
		for(int z=0;z<-1;z++)
		{
			printf("test");
		}
		if(symbol_tab[i]->name[0]!='t' &&symbol_tab[i]->tp_n!=NULL&&symbol_tab[i]->var_type!="func")
		{
			int z=0;
			if(symbol_tab[i]->tp_n->basetp==tp_int)
			{
				z++;
				vs.push_back(symbol_tab[i]->name);
				z--;
				if(symbol_tab[i]->isInitialized==false)
				{
					z=z-6;
					fprintf(fp,"\n\t.comm\t%s,4,4",symbol_tab[i]->name.c_str());
				}
				else
				{
					fprintf(fp,"\n\t.globl\t%s",symbol_tab[i]->name.c_str());
					z++;
					fprintf(fp,"\n\t.data");
					z+=1;
					fprintf(fp,"\n\t.align 4");
					z=z+1;
					fprintf(fp,"\n\t.type\t%s, @object",symbol_tab[i]->name.c_str());
					z=z+1*1;
					fprintf(fp,"\n\t.size\t%s ,4",symbol_tab[i]->name.c_str());
					z--;
					fprintf(fp,"\n%s:",symbol_tab[i]->name.c_str());
					z=z-1;
					fprintf(fp,"\n\t.long %d",symbol_tab[i]->i_val.int_val);
				}
		    }
		    if(symbol_tab[i]->tp_n->basetp==tp_char)
			{
				z-=1;
				cs.push_back(symbol_tab[i]->name);
				if(symbol_tab[i]->isInitialized==false)
				{
					z++;
					fprintf(fp,"\n\t.comm\t%s,1,1",symbol_tab[i]->name.c_str());
				}
				else
				{
					fprintf(fp,"\n\t.globl\t%s",symbol_tab[i]->name.c_str());
					for(int mx=0;mx<-1;mx++)
					{
						printf("test");
					}
					fprintf(fp,"\n\t.data");
					fprintf(fp,"\n\t.type\t%s, @object",symbol_tab[i]->name.c_str());
					z=z+3;
					fprintf(fp,"\n\t.size\t%s ,1",symbol_tab[i]->name.c_str());
					fprintf(fp,"\n%s:",symbol_tab[i]->name.c_str());
					z--;
					fprintf(fp,"\n\t.byte %c",symbol_tab[i]->i_val.char_val);
				}
		    }
		}

	}
	fprintf(fp,"\n\t.text");
}
void symtab::assign_offset()
{
	int curr_offset=0;
	int temp=0;
	int param_offset=16;
	float ans;
	no_params=0;
	for(int i = (symbol_tab).size()-1; i>=0; i--)
    {
        if(symbol_tab[i]->ispresent==false)
        {
        	temp++;
        	continue;
        }
        if(symbol_tab[i]->var_type=="param" && symbol_tab[i]->isdone==false)
        {
        	temp--;
        	no_params++;
        	if(symbol_tab[i]->tp_n && symbol_tab[i]->tp_n->basetp==tp_arr)
        	{
        		temp=9;
        		if(symbol_tab[i]->tp_n->size==-1)
        		{
        			ans=1;
        			symbol_tab[i]->isptrarr=true;
        		}
        		ans++;
        		symbol_tab[i]->size=8;
        	}
        	symbol_tab[i]->offset=curr_offset-symbol_tab[i]->size;
        	temp=0;
        	curr_offset=curr_offset-symbol_tab[i]->size;
        	symbol_tab[i]->isdone=true;
        }
        if(no_params==6)
        {
        	temp=8;
        	ans=0;
        	break;
        }
    }
    for(int i = 0; i<(symbol_tab).size(); i++)
    {
        temp=0;
        if(symbol_tab[i]->ispresent==false)
        {
        	temp++;
        	continue;
        }
        if(symbol_tab[i]->var_type!="return"&&symbol_tab[i]->var_type!="param" && symbol_tab[i]->isdone==false)
        {
        	symbol_tab[i]->offset=curr_offset-symbol_tab[i]->size;
        	temp=temp+3;
        	curr_offset=curr_offset-symbol_tab[i]->size;
        	symbol_tab[i]->isdone=true;
        	ans*=3;
        }
        else if(symbol_tab[i]->var_type=="param" && symbol_tab[i]->isdone==false)
        {
        	ans=0;
        	if(symbol_tab[i]->tp_n && symbol_tab[i]->tp_n->basetp==tp_arr)
        	{
        		if(symbol_tab[i]->tp_n->size==-1)
        		{
        			ans++;
        			symbol_tab[i]->isptrarr=true;
        		}
        		symbol_tab[i]->size=8;
        	}
        	temp++;
        	symbol_tab[i]->isdone=true;
        	no_params++; ans++;
        	symbol_tab[i]->offset=param_offset;
        	param_offset=param_offset+symbol_tab[i]->size;
        }
    }
    temp=0; ans=0;
    offset=curr_offset;
}
string symtab::assign_reg(int type_of,int no)
{
	string s="NULL";
	if(type_of==tp_char){

		if(no==0)
		{
			s="dil";
		}
		else if(no==1)
		{
			s="sil";
		}
		else if(no==2)
		{
			s="dl";
		}
		else if(no==3)
		{
			s="cl";
		}
		else if(no==4)
		{
			s="r8b";
		}
		else if(no==5)
		{
			s="r9b";
		}
        /*switch(no){
            case 0: s = "dil";
                    break;
            case 1: s = "sil";
                    break;
            case 2: s = "dl";
                    break;
            case 3: s = "cl";
                    break;
            case 4: s = "r8b";
                    break;
            case 5: s = "r9b";
                    break;
        }*/
    }
    else if(type_of == tp_int){
    	if(no==0)
		{
			s="edi";
		}
		else if(no==1)
		{
			s="esi";
		}
		else if(no==2)
		{
			s="edx";
		}
		else if(no==3)
		{
			s="ecx";
		}
		else if(no==4)
		{
			s="r8d";
		}
		else if(no==5)
		{
			s="r9d";
		}		

        /*switch(no){
            case 0: s = "edi";
                    break;
            case 1: s = "esi";
                    break;
            case 2: s = "edx";
                    break;
            case 3: s = "ecx";
                    break;
            case 4: s = "r8d";
                    break;
            case 5: s = "r9d";
                    break;
        }*/
    }
    else
    {
        if(no==0)
		{
			s="rdi";
		}
		else if(no==1)
		{
			s="rsi";
		}
		else if(no==2)
		{
			s="rdx";
		}
		else if(no==3)
		{
			s="rcx";
		}
		else if(no==4)
		{
			s="r8";
		}
		else if(no==5)
		{
			s="r9";
		}
        /*switch(no){
            case 0: s = "rdi";
                    break;
            case 1: s = "rsi";
                    break;
            case 2: s = "rdx";
                    break;
            case 3: s = "rcx";
                    break;
            case 4: s = "r8";
                    break;
            case 5: s = "r9";
                    break;
        }*/

    }
    return s;
}
int symtab::function_call(FILE *fp)
{

	int c=0; int temp=0;
	fprintf(fp,"\n\tpushq %%rbp");
	int counter=0;
	int count=0;
	while(count<6 && params_stack.size())
	{
		string p=params_stack.top();
		counter++;
		int btp=types_stack.top();
		int off=offset_stack.top();
		temp=temp+counter;
		int parr=ptrarr_stack.top();
		params_stack.pop();
		types_stack.pop();
		temp--;
		offset_stack.pop();
		ptrarr_stack.pop();
		counter++;
		string temp_str=assign_reg(btp,count);
		if(temp_str!="NULL")
		{
			//printf("%s Basetype--> %d--> %d\n",p.c_str(),btp,tp_int);
			if(btp==tp_int)
			{
				temp++;
				fprintf(fp,"\n\tmovl\t%d(%%rbp) , %%%s",off,temp_str.c_str());
			}
			else if(btp==tp_char)
			{
				counter++;
				fprintf(fp,"\n\tmovb\t%d(%%rbp), %%%s",off,temp_str.c_str());
			}
			else if(btp==tp_arr && parr==1)
			{
				counter++;
				fprintf(fp,"\n\tmovq\t%d(%%rbp), %%%s",off,temp_str.c_str());
			}
			else if(btp==tp_arr)
			{
				temp--;
				fprintf(fp,"\n\tleaq\t%d(%%rbp), %%%s",off,temp_str.c_str());
			}
			else
			{
				temp--;
				fprintf(fp,"\n\tmovq\t%d(%%rbp), %%%s",off,temp_str.c_str());
			}
			count++;
		}
	}
	while(params_stack.size())
	{

		string p=params_stack.top();
		counter=counter+temp;
		int btp=types_stack.top();
		int off=offset_stack.top();
		temp=temp+counter;
		int parr=ptrarr_stack.top();
		params_stack.pop();
		types_stack.pop();
		counter--;
		offset_stack.pop();
		ptrarr_stack.pop();
		if(btp==tp_int)
		{
			temp++;
			fprintf(fp,"\n\tsubq $4, %%rsp");
			fprintf(fp,"\n\tmovl\t%d(%%rbp), %%eax",off);
			temp--;
			fprintf(fp,"\n\tmovl\t%%eax, (%%rsp)");
			c+=4;
		}
		else if(btp==tp_arr && parr==1)
		{
			temp=8;
			fprintf(fp,"\n\tsubq $8, %%rsp");
			fprintf(fp,"\n\tmovq\t%d(%%rbp), %%rax",off);
			temp=temp-4;
			fprintf(fp,"\n\tmovq\t%%rax, (%%rsp)");
			c+=8;
		}
		else if(btp==tp_arr)
		{
			fprintf(fp,"\n\tsubq $8, %%rsp");
			counter++;
			fprintf(fp,"\n\tleaq\t%d(%%rbp), %%rax",off);
			fprintf(fp,"\n\tmovq\t%%rax, (%%rsp)");
			counter=8;
			c+=8;
		}
		else if(btp==tp_char)
		{
			fprintf(fp,"\n\tsubq $4, %%rsp");
			temp++;
			fprintf(fp,"\n\tmovsbl\t%d(%%rbp), %%eax",off);
			fprintf(fp,"\n\tmovl\t%%eax, (%%rsp)");
			temp=8;
			c+=4;
		}
		else
		{
			fprintf(fp,"\n\tsubq $8, %%rsp");
			temp=counter++;
			fprintf(fp,"\n\tmovq\t%d(%%rbp), %%rax",off);
			fprintf(fp,"\n\tmovq\t%%rax, (%%rsp)");
			counter=8;
			c+=8;
		}
	}
	return c;

}
void symtab::function_restore(FILE *fp)
{
	int count=0;
	int temp=0;
	string regname;
	for(int i=symbol_tab.size()-1;i>=0;i--)
	{
	    if(symbol_tab[i]->ispresent==false)
	    {
	    	temp=1;
	    	continue;
	    }
	    if(symbol_tab[i]->var_type=="param" && symbol_tab[i]->offset<0)
	    {
		    temp=0;
		    if(symbol_tab[i]->tp_n->basetp == tp_char){
	            regname = assign_reg(tp_char,count);
	            temp=temp+1;
	            fprintf(fp,"\n\tmovb\t%%%s, %d(%%rbp)",regname.c_str(),symbol_tab[i]->offset);
	        }
	        else if(symbol_tab[i]->tp_n->basetp == tp_int){
	            regname = assign_reg(tp_int,count);
	            temp=temp+1;
	            fprintf(fp,"\n\tmovl\t%%%s, %d(%%rbp)",regname.c_str(),symbol_tab[i]->offset);
	        }
	        else {
	            regname = assign_reg(10,count);
	            temp=temp+1;
	            fprintf(fp,"\n\tmovq\t%%%s, %d(%%rbp)",regname.c_str(),symbol_tab[i]->offset);
	        }
	    	count++;
	    	temp=0;
	    }
	    if(count==6)
	    {
	    	temp=0;
	    	break;
	    }
    }
}
void symtab::gen_internal_code(FILE *fp,int ret_count)
{
	int i; int temp=0;
	int counter;
	for(i = start_quad; i <=end_quad; i++)
	{
		opcode &opx =glob_quad.arr[i].op;
		counter++;
		string &arg1x =glob_quad.arr[i].arg1;
		string &arg2x =glob_quad.arr[i].arg2;
		temp=temp+counter;
		string &resx =glob_quad.arr[i].result;
		int offr,off1,off2;
		int temp2=1;
		int flag1=1;
		int flag2=1;
		counter++;
		int flag3=1;
		int j;
		fprintf(fp,"\n# %d:",i);
		//printf("dsda %s\n",resx.c_str());
		if(search(resx))
		{
			temp=0;
			offr = search(resx)->offset;
			temp++;
			fprintf(fp,"res = %s ",search(resx)->name.c_str());
		}
		else if(glob_quad.arr[i].result!=""&& findg(glob_quad.arr[i].result))
		{
			temp++;
			flag3=0;
		}
		if(search(arg1x))
		{

			temp++;
			off1 = search(arg1x)->offset;
			fprintf(fp,"arg1 = %s ",search(arg1x)->name.c_str());
		}
		else if(glob_quad.arr[i].arg1!="" && findg(glob_quad.arr[i].arg1))
		{
				temp=0;
				flag1=0;

		}
		if(search(arg2x))
		{
			temp++;
			off2 = search(arg2x)->offset;
			fprintf(fp,"arg2 = %s ",search(arg2x)->name.c_str());
		}
		else if(glob_quad.arr[i].arg2!="" && findg(glob_quad.arr[i].arg2))
		{
				temp2=0;
				flag2=0;


		}
		if(flag1==0)
		{
			if(findg(arg1x)==2)
			{
					temp++;
					fprintf(fp,"\n\tmovzbl\t%s(%%rip), %%eax",arg1x.c_str());
			}
			else{

					temp=8;
					fprintf(fp,"\n\tmovl\t%s(%%rip), %%eax",arg1x.c_str());
				}
		}
		if(flag2==0)
		{
			if(findg(arg1x)==2)
			{
					temp++;
					fprintf(fp,"\n\tmovzbl\t%s(%%rip), %%edx",arg2x.c_str());
			}
				else
				{
					counter=temp+temp;
					fprintf(fp,"\n\tmovl\t%s(%%rip), %%edx",arg2x.c_str());
				}
		}
		if(mp_set.find(i)!=mp_set.end())
		{
			//Generate Label here
			temp++;
			fprintf(fp,"\n.L%d:",mp_set[i]);
		}
		switch(opx)
		{
			case Q_PLUS:
				// Copy values in eax and edx, add both of them to eax then move it to destination

				// 	if(search(arg1x)!=NULL && search(arg2x)!=NULL && ((search(arg1x)!=NULL && search(arg1x)->tp_n!=NULL && search(arg1x)->tp_n->basetp == tp_ptr) || (search(arg2x)!=NULL && search(arg2x)->tp_n!=NULL && search(arg2x)->tp_n->basetp == tp_ptr ) ))
				// 	{
				// 	if((search(arg1x)!=NULL && search(arg1x)->tp_n!=NULL && search(arg1x)->tp_n->basetp == tp_ptr))
				// 	{
				// 		fprintf(fp,"\n\tmovq\t%d(%%rbp), %%rax",off1);
				// 		fprintf(fp,"\n\tmovslq\t%d(%%rbp), %%rdx",off2);
				// 		fprintf(fp,"\n\taddq\t%%rax, %%rdx");
				// 		if(search(resx)!=NULL && search(resx)->tp_n!=NULL && search(resx)->tp_n->basetp==tp_int)
				// 		{
				// 			fprintf(fp,"\n\tmovl\t(%%rdx), %%eax");
				// 			fprintf(fp,"\n\tmovl\t%%eax, %d(%%rbp)",offr);
				// 		}
				// 		else if(search(resx)!=NULL && search(resx)->tp_n!=NULL && search(resx)->tp_n->basetp==tp_char)
				// 		{
				// 			fprintf(fp,"\n\tmovb\t(%%rdx), %%al");
				// 			fprintf(fp,"\n\tmovb\t%%al, %d(%%rbp)",offr);
				// 		}
				// 		else
				// 		{
				// 			fprintf(fp,"\n\tmovq\t(%%rdx), %%rax");
				// 			fprintf(fp,"\n\tmovq\t%%rax, %d(%%rbp)",offr);
				// 		}
				// 	}

				// 	else
				// 	{
				// 		fprintf(fp,"\n\tmovq\t%d(%%rbp), %%rax",off2);
				// 		fprintf(fp,"\n\tmovslq\t%d(%%rbp), %%rdx",off1);
				// 		fprintf(fp,"\n\taddq\t%%rax, %%rdx");
				// 		if(search(resx)!=NULL && search(resx)->tp_n!=NULL && search(resx)->tp_n->basetp==tp_int)
				// 		{
				// 			fprintf(fp,"\n\tmovl\t(%%rax), %%edx");
				// 			fprintf(fp,"\n\tmovl\t%%edx, %d(%%rbp)",offr);
				// 		}
				// 		else if(search(resx)!=NULL && search(resx)->tp_n!=NULL && search(resx)->tp_n->basetp==tp_char)
				// 		{
				// 			fprintf(fp,"\n\tmovb\t(%%rax), %%dl");
				// 			fprintf(fp,"\n\tmovb\t%%dl, %d(%%rbp)",offr);
				// 		}
				// 		else
				// 		{
				// 			fprintf(fp,"\n\tmovq\t(%%rax), %%rdx");
				// 			fprintf(fp,"\n\tmovq\t%%rdx, %d(%%rbp)",offr);
				// 		}
				// 	}
				// }
				if(search(resx)!=NULL && search(resx)->tp_n!=NULL&&search(resx)->tp_n->basetp == tp_char)
				{
					counter++;
					if(flag1!=0)
					{
						fprintf(fp,"\n\tmovzbl\t%d(%%rbp), %%eax",off1);
					}
					temp++;
					if(flag2!=0)
					{
						fprintf(fp,"\n\tmovzbl\t%d(%%rbp), %%edx",off2);
					}
					temp=temp+counter;
					fprintf(fp,"\n\taddl\t%%edx, %%eax");
					if(flag3!=0)
					{
						fprintf(fp,"\n\tmovb\t%%al, %d(%%rbp)",offr);
					}
					else
					{
						temp++;
						fprintf(fp,"\n\tmovb\t%%al, %s(%%rip)",resx.c_str());
					}
				}
				else
				{
					counter++;
					if(flag1!=0)
					{
						fprintf(fp,"\n\tmovl\t%d(%%rbp), %%eax",off1);
					}
					if(flag2!=0)
					{
						temp++;
						if(arg2x[0]>='0' && arg2x[0]<='9')
						fprintf(fp,"\n\tmovl\t$%s, %%edx",arg2x.c_str());
					else
						fprintf(fp,"\n\tmovl\t%d(%%rbp), %%edx",off2);
					}
					temp=temp+counter;
					fprintf(fp,"\n\taddl\t%%edx, %%eax");
					if(flag3!=0)
					{
						fprintf(fp,"\n\tmovl\t%%eax, %d(%%rbp)",offr);
					}
					else
					{
						temp=0;
						fprintf(fp,"\n\tmovl\t%%eax, %s(%%rip)",resx.c_str());
					}
				}
				break;
			case Q_MINUS:
				if(search(resx)!=NULL && search(resx)->tp_n!=NULL&&search(resx)->tp_n->basetp == tp_char)
				{
					counter++;
					if(flag1!=0)
					{
						fprintf(fp,"\n\tmovzbl\t%d(%%rbp), %%eax",off1);
					}
					temp=counter;
					if(flag2!=0)
					{
						fprintf(fp,"\n\tmovzbl\t%d(%%rbp), %%edx",off2);
					}
					counter++;
					fprintf(fp,"\n\tsubl\t%%edx, %%eax");
					if(flag3!=0)
					fprintf(fp,"\n\tmovb\t%%al, %d(%%rbp)",offr);
					else
					{
						temp=0;
						fprintf(fp,"\n\tmovb\t%%al, %s(%%rip)",resx.c_str());
					}
				}
				else
				{
					counter++;
					if(flag1!=0)
					fprintf(fp,"\n\tmovl\t%d(%%rbp), %%eax",off1);
					// Direct Number access
					if(flag2!=0)
					{
						temp=0;
						if(arg2x[0]>='0' && arg2x[0]<='9')
						fprintf(fp,"\n\tmovl\t$%s, %%edx",arg2x.c_str());
						else
						{
							fprintf(fp,"\n\tmovl\t%d(%%rbp), %%edx",off2);}
							counter++;
						}	
						
					fprintf(fp,"\n\tsubl\t%%edx, %%eax");
					temp=counter;
					if(flag3!=0)
					fprintf(fp,"\n\tmovl\t%%eax, %d(%%rbp)",offr);
					else
					{
						temp=0;counter=0;
						fprintf(fp,"\n\tmovl\t%%eax, %s(%%rip)",resx.c_str());
					}

				}
				break;

			case Q_MULT:
				if(search(resx)!=NULL && search(resx)->tp_n!=NULL&&search(resx)->tp_n->basetp == tp_char)
				{
					temp=0;
					if(flag1!=0)
					fprintf(fp,"\n\tmovzbl\t%d(%%rbp), %%eax",off1);
					temp++;
					if(flag2!=0)
					fprintf(fp,"\n\tmovzbl\t%d(%%rbp), %%edx",off2);
					temp++;
					fprintf(fp,"\n\timull\t%%edx, %%eax");
					if(flag3!=0)
					{
						temp=0;
						fprintf(fp,"\n\tmovb\t%%al, %d(%%rbp)",offr);
					}
					else
					{
						temp++;
						fprintf(fp,"\n\tmovb\t%%al, %s(%%rip)",resx.c_str());
					}
				}
				else
				{
				temp=0;
				if(flag1!=0)
				fprintf(fp,"\n\tmovl\t%d(%%rbp), %%eax",off1);
				if(flag2!=0)
				{
					counter=0;
					if(arg2x[0]>='0' && arg2x[0]<='9')
				{
					fprintf(fp,"\n\tmovl\t$%s, %%ecx",arg2x.c_str());
					counter++;
					fprintf(fp,"\n\timull\t%%ecx, %%eax");
				}
				else
				{
					counter=0;
					fprintf(fp,"\n\timull\t%d(%%rbp), %%eax",off2);}
				}
				if(flag3!=0)
				fprintf(fp,"\n\tmovl\t%%eax, %d(%%rbp)",offr);
				else
				{
					temp=0;
					fprintf(fp,"\n\tmovl\t%%eax, %s(%%rip)",resx.c_str());
				}
				temp=0;counter=0;
				}
				break;
			case Q_DIVIDE:
				temp=0;
				if(search(resx)!=NULL && search(resx)->tp_n!=NULL&&search(resx)->tp_n->basetp == tp_char)
				{
					temp++;
					if(flag1!=0)
					fprintf(fp,"\n\tmovzbl\t%d(%%rbp), %%eax",off1);
					temp++;
					fprintf(fp,"\n\tcltd");
					if(flag2!=0)
					fprintf(fp,"\n\tidivl\t%d(%%rbp), %%eax",off2);
					else
					{
						temp++;
						fprintf(fp,"\n\tidivl\t%%edx, %%eax");
					}
					if(flag3!=0)
					fprintf(fp,"\n\tmovb\t%%al, %d(%%rbp)",offr);
					else
					{
						temp++;
						fprintf(fp,"\n\tmovb\t%%al, %s(%%rip)",resx.c_str());
					}
				}
				else{
				temp=0;	
				if(flag1!=0)
				fprintf(fp,"\n\tmovl\t%d(%%rbp), %%eax",off1);
				temp++;
				fprintf(fp,"\n\tcltd");
				if(flag2!=0)
				fprintf(fp,"\n\tidivl\t%d(%%rbp), %%eax",off2);
				else
				{
					temp++;
					fprintf(fp,"\n\tidivl\t%%edx, %%eax");
				}
				if(flag3!=0)
				fprintf(fp,"\n\tmovl\t%%eax, %d(%%rbp)",offr);
				else
				{
					temp++;
					fprintf(fp,"\n\tmovl\t%%eax, %s(%%rip)",resx.c_str());
				}
				}
				break;

			case Q_UNARY_MINUS:
				temp=0;counter=0;
				if(search(resx)!=NULL && search(resx)->tp_n!=NULL&&search(resx)->tp_n->basetp == tp_char)
				{
					fprintf(fp,"\n\tmovzbl\t%d(%%rbp), %%eax",off1);
					counter++;
					fprintf(fp,"\n\tnegl\t%%eax");
					fprintf(fp,"\n\tmovb\t%%al, %d(%%rbp)",offr);
					temp=0;
				}
				else{
				fprintf(fp,"\n\tmovl\t%d(%%rbp), %%eax",off1);
				temp++;
				fprintf(fp,"\n\tnegl\t%%eax");
				fprintf(fp,"\n\tmovl\t%%eax, %d(%%rbp)",offr);
				}
				break;
			case Q_ASSIGN:
				temp=0;
				//Check if the second argument is a constant
				if(arg1x[0]>='0' && arg1x[0]<='9')	//first character is number
				{
					temp=-1;
					if(flag1!=0)
					fprintf(fp,"\n\tmovl\t$%s, %d(%%rbp)",arg1x.c_str(),offr);
				}
				else if(arg1x[0] == '\'')
				{
					temp=2;
					//Character
					fprintf(fp,"\n\tmovb\t$%d, %d(%%rbp)",(int)arg1x[1],offr);
				}
				else if(flag1 && search(resx)!=NULL && search(resx)->tp_n!=NULL&&search(resx)->tp_n->basetp == tp_char)
				{
					temp=3;
					fprintf(fp,"\n\tmovzbl\t%d(%%rbp), %%eax",off1);
					fprintf(fp,"\n\tmovb\t%%al, %d(%%rbp)",offr);
					temp++;
				}
				else if(flag1&&search(resx)!=NULL && search(resx)->tp_n!=NULL&&search(resx)->tp_n->basetp == tp_int)
				{
					temp++;
					if(flag1!=0)
					fprintf(fp,"\n\tmovl\t%d(%%rbp), %%eax",off1);
					counter++;
					fprintf(fp,"\n\tmovl\t%%eax, %d(%%rbp)",offr);
				}
				else if(search(resx)!=NULL && search(resx)->tp_n!=NULL)
				{
					fprintf(fp,"\n\tmovq\t%d(%%rbp), %%rax",off1);temp=0;
					fprintf(fp,"\n\tmovq\t%%rax, %d(%%rbp)",offr);temp++;
				}
				else
				{
					if(flag3!=0)
					{fprintf(fp,"\n\tmovl\t%d(%%rbp), %%eax",off1);temp++;
					fprintf(fp,"\n\tmovl\t%%eax, %d(%%rbp)",offr);}
					else
					{
						counter=0;
						fprintf(fp,"\n\tmovl\t%%eax, %s(%%rip)",resx.c_str());
					}
				}
				break;
			case Q_PARAM:
				temp=0;
				if(resx[0] == '_')
				{
					//string
					char* temporary = (char*)resx.c_str();
					temp++;
					fprintf(fp,"\n\tmovq\t$.STR%d,\t%%rdi",atoi(temporary+1));
				}
				else
				{
					counter=0;
					params_stack.push(resx);
					//printf("resx--> %s\n",resx.c_str());
					types_stack.push(search(resx)->tp_n->basetp);
					counter++;
					offset_stack.push(offr);
					if(search(resx)->isptrarr==true)
					{
						counter++;
						ptrarr_stack.push(1);
					}
					else
					{
						counter--;
						ptrarr_stack.push(0);
					}
				}
				break;

			case Q_GOTO:
				temp=0;
				if(resx!="-1"&& atoi(resx.c_str())<=end_quad)
				{
					temp=1;
					fprintf(fp,"\n\tjmp .L%d",mp_set[atoi(resx.c_str())]);
				}
				else
				{
					temp=0;
					fprintf(fp,"\n\tjmp\t.LRT%d",ret_count);
				}
				break;
			case Q_CALL:
				counter=0; temp=0;
				add_off=function_call(fp);
				fprintf(fp,"\n\tcall\t%s",arg1x.c_str());
				if(resx=="")
				{
					counter++;
				}
				else if(search(resx)!=NULL && search(resx)->tp_n!=NULL&&search(resx)->tp_n->basetp == tp_int)
				{
					fprintf(fp,"\n\tmovl\t%%eax, %d(%%rbp)",offr);temp++;
				}
				else if(search(resx)!=NULL && search(resx)->tp_n!=NULL&&search(resx)->tp_n->basetp == tp_char)
				{
					temp++; fprintf(fp,"\n\tmovb\t%%al, %d(%%rbp)",offr);
				}
				else if(search(resx)!=NULL && search(resx)->tp_n!=NULL)
				{
					temp++;fprintf(fp,"\n\tmovq\t%%rax, %d(%%rbp)",offr);
				}
				else
				{
					temp++;
					fprintf(fp,"\n\tmovl\t%%eax, %d(%%rbp)",offr);
				}
				if(arg1x=="printStr")
				{
					counter++;
					fprintf(fp,"\n\taddq $8 , %%rsp");
				}
				else
				{
					counter++;fprintf(fp,"\n\taddq $%d , %%rsp",add_off);
				}
				break;
			case Q_IF_LESS:
				temp=0; counter=0;
				if(search(arg1x)!=NULL && search(arg1x)->tp_n!=NULL&&search(arg1x)->tp_n->basetp == tp_char)
				{
					fprintf(fp,"\n\tmovzbl\t%d(%%rbp), %%eax",off1);
					temp++;
					fprintf(fp,"\n\tcmpb\t%d(%%rbp), %%al",off2);
					fprintf(fp,"\n\tjl .L%d",mp_set[atoi(resx.c_str())]);temp++;
				}
				else
				{
					counter=0;
					fprintf(fp,"\n\tmovl\t%d(%%rbp), %%eax",off1);
					fprintf(fp,"\n\tmovl\t%d(%%rbp), %%edx",off2);
					counter++;
					fprintf(fp,"\n\tcmpl\t%%edx, %%eax");
					fprintf(fp,"\n\tjl .L%d",mp_set[atoi(resx.c_str())]);temp=0;
				}
				break;
			case Q_IF_LESS_OR_EQUAL:
				temp=0;
				if(search(arg1x)!=NULL && search(arg1x)->tp_n!=NULL&&search(arg1x)->tp_n->basetp == tp_char)
				{
					fprintf(fp,"\n\tmovzbl\t%d(%%rbp), %%eax",off1);
					temp++;
					fprintf(fp,"\n\tcmpb\t%d(%%rbp), %%al",off2);
					fprintf(fp,"\n\tjle .L%d",mp_set[atoi(resx.c_str())]);
					counter++;
				}
				else
				{
					fprintf(fp,"\n\tmovl\t%d(%%rbp), %%eax",off1);
					temp++;
					fprintf(fp,"\n\tmovl\t%d(%%rbp), %%edx",off2);
					fprintf(fp,"\n\tcmpl\t%%edx, %%eax");
					counter++;
					fprintf(fp,"\n\tjle .L%d",mp_set[atoi(resx.c_str())]);
				}
				break;
			case Q_IF_GREATER:
				counter=0;
				if(search(arg1x)!=NULL && search(arg1x)->tp_n!=NULL&&search(arg1x)->tp_n->basetp == tp_char)
				{
					fprintf(fp,"\n\tmovzbl\t%d(%%rbp), %%eax",off1);counter++;
					fprintf(fp,"\n\tcmpb\t%d(%%rbp), %%al",off2);counter=counter+1;
					fprintf(fp,"\n\tjg .L%d",mp_set[atoi(resx.c_str())]);
				}
				else
				{
					fprintf(fp,"\n\tmovl\t%d(%%rbp), %%eax",off1);temp++;
					fprintf(fp,"\n\tmovl\t%d(%%rbp), %%edx",off2);
					fprintf(fp,"\n\tcmpl\t%%edx, %%eax");temp++;
					fprintf(fp,"\n\tjg .L%d",mp_set[atoi(resx.c_str())]);
				}
				break;
			case Q_IF_GREATER_OR_EQUAL:
				if(search(arg1x)!=NULL && search(arg1x)->tp_n!=NULL&&search(arg1x)->tp_n->basetp == tp_char)
				{
					fprintf(fp,"\n\tmovzbl\t%d(%%rbp), %%eax",off1);temp++;
					fprintf(fp,"\n\tcmpb\t%d(%%rbp), %%al",off2);
					fprintf(fp,"\n\tjge .L%d",mp_set[atoi(resx.c_str())]);temp=temp+1;
				}
				else
				{
					fprintf(fp,"\n\tmovl\t%d(%%rbp), %%eax",off1);
					fprintf(fp,"\n\tmovl\t%d(%%rbp), %%edx",off2);counter++;
					fprintf(fp,"\n\tcmpl\t%%edx, %%eax");
					fprintf(fp,"\n\tjge .L%d",mp_set[atoi(resx.c_str())]);counter=counter+1;
				}
				break;
			case Q_IF_EQUAL:
				temp=0; counter=0;
				if(search(arg1x)!=NULL && search(arg1x)->tp_n!=NULL&&search(arg1x)->tp_n->basetp == tp_char)
				{
					fprintf(fp,"\n\tmovzbl\t%d(%%rbp), %%eax",off1);
					temp++;
					fprintf(fp,"\n\tcmpb\t%d(%%rbp), %%al",off2);
					fprintf(fp,"\n\tje .L%d",mp_set[atoi(resx.c_str())]);temp++;
				}
				else
				{
					fprintf(fp,"\n\tmovl\t%d(%%rbp), %%eax",off1);
					counter++;
					fprintf(fp,"\n\tmovl\t%d(%%rbp), %%edx",off2);
					fprintf(fp,"\n\tcmpl\t%%edx, %%eax");
					counter=counter+1;
					fprintf(fp,"\n\tje .L%d",mp_set[atoi(resx.c_str())]);
				}
				break;
			case Q_IF_NOT_EQUAL:
				temp=0; counter=0;
				if(search(arg1x)!=NULL && search(arg1x)->tp_n!=NULL&&search(arg1x)->tp_n->basetp == tp_char)
				{
					fprintf(fp,"\n\tmovzbl\t%d(%%rbp), %%eax",off1); temp++;
					fprintf(fp,"\n\tcmpb\t%d(%%rbp), %%al",off2);
					fprintf(fp,"\n\tjne .L%d",mp_set[atoi(resx.c_str())]);temp++;
				}
				else
				{
					fprintf(fp,"\n\tmovl\t%d(%%rbp), %%eax",off1);counter++;
					fprintf(fp,"\n\tmovl\t%d(%%rbp), %%edx",off2);
					fprintf(fp,"\n\tcmpl\t%%edx, %%eax");counter--;
					fprintf(fp,"\n\tjne .L%d",mp_set[atoi(resx.c_str())]);
				}
				break;
			case Q_ADDR:
				temp=0;
				fprintf(fp,"\n\tleaq\t%d(%%rbp), %%rax",off1);temp++;
				fprintf(fp,"\n\tmovq\t%%rax, %d(%%rbp)",offr);
				break;
			case Q_LDEREF:
				counter=0;
				fprintf(fp,"\n\tmovq\t%d(%%rbp), %%rax",offr);
				fprintf(fp,"\n\tmovl\t%d(%%rbp), %%edx",off1);counter++;
				fprintf(fp,"\n\tmovl\t%%edx, (%%rax)");
				break;
			case Q_RDEREF:
				temp=0;
				fprintf(fp,"\n\tmovq\t%d(%%rbp), %%rax",off1);
				fprintf(fp,"\n\tmovl\t(%%rax), %%eax");temp++;
				fprintf(fp,"\n\tmovl\t%%eax, %d(%%rbp)",offr);
				break;
			case Q_RINDEX:
				temp=0;
				counter=0;
				// Get Address, subtract offset, get memory
				if(search(arg1x)&&search(arg1x)->isptrarr==true)
				{
					fprintf(fp,"\n\tmovq\t%d(%%rbp), %%rdx",off1);
					temp++;
					fprintf(fp,"\n\tmovslq\t%d(%%rbp), %%rax",off2);
					fprintf(fp,"\n\taddq\t%%rax, %%rdx");
				}
				else
				{
					fprintf(fp,"\n\tleaq\t%d(%%rbp), %%rdx",off1);
					counter++;
					fprintf(fp,"\n\tmovslq\t%d(%%rbp), %%rax",off2);
					fprintf(fp,"\n\taddq\t%%rax, %%rdx");
					temp=0;
				}
				if(search(resx)!=NULL && search(resx)->tp_n!=NULL&&search(resx)->tp_n->next&&search(resx)->tp_n->next->basetp == tp_char)
				{
					fprintf(fp,"\n\tmovzbl\t(%%rdx), %%eax");counter++;
					fprintf(fp,"\n\tmovb\t%%al, %d(%%rbp)",offr);
				}
				else
				{
					temp=0;
					fprintf(fp,"\n\tmovl\t(%%rdx), %%eax");
					fprintf(fp,"\n\tmovl\t%%eax, %d(%%rbp)",offr);temp++;
				}
				break;
			case Q_LINDEX:
				temp=0;counter=0;
				// Get Address, subtract offset, get memory
				if(search(resx)&&search(resx)->isptrarr==true)
				{
					fprintf(fp,"\n\tmovq\t%d(%%rbp), %%rdx",offr);temp++;
					fprintf(fp,"\n\tmovslq\t%d(%%rbp), %%rax",off1);counter=temp;
					fprintf(fp,"\n\taddq\t%%rax, %%rdx");
				}
				else
				{
					temp++;
					fprintf(fp,"\n\tleaq\t%d(%%rbp), %%rdx",offr);
					fprintf(fp,"\n\tmovslq\t%d(%%rbp), %%rax",off1);temp--;
					fprintf(fp,"\n\taddq\t%%rax, %%rdx");
				}
				if(search(resx)!=NULL && search(resx)->tp_n!=NULL&&search(resx)->tp_n->next && search(resx)->tp_n->next->basetp == tp_char)
				{
					fprintf(fp,"\n\tmovzbl\t%d(%%rbp), %%eax",off2);counter++;
					fprintf(fp,"\n\tmovb\t%%al, (%%rdx)");temp=counter;
				}
				else
				{
					fprintf(fp,"\n\tmovl\t%d(%%rbp), %%eax",off2);temp++;
					fprintf(fp,"\n\tmovl\t%%eax, (%%rdx)");
				}
				break;
			case Q_RETURN:
				temp=0; counter=0;
				//printf("return %s\n",resx.c_str());
				if(resx!="")
				{
					temp++;
					if(search(resx)!=NULL && search(resx)->tp_n!=NULL&&search(resx)->tp_n->basetp == tp_char)
				{
					counter++;
					fprintf(fp,"\n\tmovzbl\t%d(%%rbp), %%eax",offr);
				}
				else
				{
					temp++;fprintf(fp,"\n\tmovl\t%d(%%rbp), %%eax",offr);
				}}
				else
				{
					temp++;fprintf(fp,"\n\tmovl\t$0, %%eax");
				}
				//printf("Happy\n");
				fprintf(fp,"\n\tjmp\t.LRT%d",ret_count);
				break;
			default:
			temp=0;
			break;
		}
	}
}

void symtab::function_epilogue(FILE *fp,int count,int ret_count)
{
	int test=0,temp=1;
	fprintf(fp,"\n.LRT%d:",ret_count);
	fprintf(fp,"\n\taddq\t$%d, %%rsp",offset);temp=temp+test;
	fprintf(fp,"\n\tmovq\t%%rbp, %%rsp");
	fprintf(fp,"\n\tpopq\t%%rbp");test++;
	fprintf(fp,"\n\tret");
	fprintf(fp,"\n.LFE%d:",count);temp=temp+test;
	fprintf(fp,"\n\t.size\t%s, .-%s",name.c_str(),name.c_str());
}
