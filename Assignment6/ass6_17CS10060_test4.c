int gen(int *a)
{
	*a = 78;
	return 0;
}
int main()
{
	printStr("This Program handles pointers\n");
	int *p;
	int i = 5;
	p = &i;
	*p = 6;
	printInt(i);
	printStr("\n");
	int *q = p;
	*q = 9;
	printInt(i);
	printStr("\n");
	char c = 'A';
	char *d;
	d = &c;
	*d = 'k';
	if(c == 'k')
	{
		printStr("YES\n");
	}
	else
	{
		printStr("NO\n");
	}
	gen(p);
	printInt(i);
	printStr("\n");

	return 0;
}
