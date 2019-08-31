#include "myl.h"

int main()
{
	float floatvalue=0; 
	int opt;
	int intval=0;
	while(1)
	{
		printStr("\n Functions :");
		printStr("\n1. read integer");
		printStr("\n2. print integer");
		printStr("\n3. read float");
		printStr("\n4. print float");
		printStr("\n5. Exit");
		printStr("\nChoose an option:");	
		if(readInt(&opt)==ERR)
		{
			printStr("Invalid choice\n, re-enter :");
			continue;
		}
		if(opt==5)
		{
			break;
		}
		switch(opt)
		{
			case 1: printStr("\nEnter integer value: ");
					if(readInt(&intval)==ERR)
					{
						printStr("ERR Invalid integer\n");
					}
					break;
			case 2: printInt(intval);
					break;
			case 3: printStr("\n Enter float value: ");
					if(readFlt(&floatvalue)==ERR)
					{
						printStr("ERR Invalid float value\n");
					}
					break;
			case 4: printFlt(floatvalue);
					break;
			default:
					break;
		}
	}
	return 0;

}
