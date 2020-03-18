//Loops test

int main()
{
	int i, j = 0,k = 0;
	char c[41][1];
	int x = 2, y = 5;
	int sum = 5;
	float a[10];

	for(i = k; i < sum; i++)
	{
		a[i] = i;
		x++;
		y--;
	}

	while(sum > 1)
	{
		a[i] = a[i-1] + 1.2*a[i];
		sum = sum - 1;
	}

	sum=0;

	do {
		x = x + y;
		sum++;
	} while(x<23 && sum<7);

	int iter=1233;
	while(iter)
	{
		iter /= 10;
		j += iter;
	}
}
