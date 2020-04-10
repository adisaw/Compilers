//following program implements bubble sort
int bubblesort(int arr[], int n)
{
   int i, key, j;
   for (i = 0; i < n; i++)
   {
       
	for(j=0;j<n-1;j++)
	{
		if(arr[j+1]<arr[j])
		{
			key=arr[j+1];
			arr[j+1]=arr[j];
			arr[j]=key;
		}
	}
   }
   return 0;
}

int main()
{
    printStr("This Program implements bubble sort\n");
    int arr[100];
    int n, err = 1;
    printStr("Enter the size of the array: \n");
    n = readInt(&err);
    printStr("Enter the elements of the array to be sorted: \n");
    for(i=0;i<n;i++)
    {
         arr[i] = readInt(&err);
    }

    bubblesort(arr, n);
    printStr("The sorted array is: \n");
    for (i=0; i < n-1; i++)
    {
        printInt(arr[i]);
        printStr(", ");
    }
    printInt(arr[n-1]);
    printStr("\n");

    return 0;
}
