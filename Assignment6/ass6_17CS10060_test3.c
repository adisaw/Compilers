// Binary Search
int binary(int a[],int n,int m,int l,int u)
{

    int mid,c=0;
	if(l>u)
	{
		return -1;
	}
    	mid=(l+u)/2;
	int t=a[mid];
	if (m<t)
	{
    	return binary(a,n,m,l,mid-1);
	}
	else if(m>t)
	{
		return binary(a,n,m,mid+1,u);
	}
	else
	{
         return mid;
    }
}
int main()
{
	int a[10],i,n,m,c,l,u;
    int err=1;
    printStr("This Program implements Binary search\n");
    printStr("Enter the size of an array: \n");
    n=readInt(&err);
    printStr("Enter the elements of the array in sorted order one by one i.e. single element in a line: \n");
    for(i=0;i<n;i++){
         a[i]=readInt(&err);
    }

    printStr("Enter the number to be search: \n");
    m=readInt(&err);
	l=0,u=n-1;
	c=0;
    c=binary(a,n,m,l,u);
    if(c==-1)
    {
		printStr("Number is not found.\n");
	}
    else
    {
		printStr("Number is found at index(1-based)-:\n");
		c=c+1;
		printInt(c);
		printStr("\n");
	}
	return 0;
}
