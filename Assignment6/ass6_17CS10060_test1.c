//program to handle global variables
int cat = 6;
int man=3;
int main()
{
	printStr("Program to handles global variables\n");
	int value;
	value = man + 2; //3+2
	printStr("value = ");
	printInt(value);
	printStr("\n");
	cat = 11;
	value = cat;   //11
	printStr("value = ");
	printInt(value);
	printStr("\n");
	return 0;
}
