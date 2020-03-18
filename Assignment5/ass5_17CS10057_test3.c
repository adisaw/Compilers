//If else statement test

int main()
{
	int a = 13, b = 3;
	char c = 'i';
	char d = 'k';
	float addition = 2.1;
	if(b > a)
	{
		if(c > d)
		{
			addition = addition + c;
			addition = addition + b;
		}
		else
		{
			addition = addition + d;
			addition = addition + b;
		}
	}
	else
	{
		if(c > d)
		{
			addition = addition + c;
			addition = addition + a;
		}
		else
		{
			addition = addition + d;
			addition = addition + a;
		}
	}
}
