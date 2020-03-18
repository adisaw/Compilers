//Common expressions test

int main()
{
	int a = 19;
	int b = a + 3;
	a = a % b;

	int *p1 = &a;
	if(&p1 == a)
		b = a*4;
	else
		b = a*2;

	int f = b << 21;

	double c, d = 1.8;
	c = a*d;
	c = 21.3;
	d = d/c;
	c = c*10.21;

	char g, h;
	g = 'a';
	h = 'b';
	g++;
	h--;
}
