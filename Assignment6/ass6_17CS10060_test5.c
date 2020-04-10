int main()
{
	int n, a[100];
	int err =1;
	printStr("This Program finds length of Longest Increasing Subsequence\nEnter size of array:\n");
	n = readInt(&err);
	printStr("Enter array: (elements on new lines)\n");
	int i, j;
	for(i = 0; i<n; i++)
	{
		a[i] = readInt(&err);
		// printInt(a[i]);
	}
	int l[100];
	l[0]=1;
	int max = -100000;
	for(i=1; i<n; i++)
	{
		l[i] = 1;
		for(j = 0; j<i; j++)
		{
			if(a[j]<a[i] && l[j]+1>l[i])
				l[i] = l[j] +1;
		}
	}
	int ans = -1;
	for(i = 0; i<n; i++)
	{
		if(ans<l[i])
			ans = l[i];
	}
	printStr("Length of LIS is: ");
	printInt(ans);
	printStr("\n");
}
