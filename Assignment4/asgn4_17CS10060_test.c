//Test Program Aditya Sawant 17CS10060
//bubble sort code
void swap(int *xp, int *yp) 
{ 
    int temp = *xp; 
    *xp = *yp; 
    *yp = temp; 
} 
  
// A function to implement bubble sort 
void bubbleSort(int arr[], int n) 
{ 
   int i, j; 
   for (i = 0; i < n-1; i++)       
  
       // Last i elements are already in place    
       for (j = 0; j < n-i-1; j++)  
           if (arr[j] > arr[j+1]) 
              swap(&arr[j], &arr[j+1]); 
} 
  
/* Function to print an array */
void printArray(int arr[], int size) 
{ 
    int i; 
    for (i=0; i < size; i++) 
        printf("%d ", arr[i]); 
    printf("\n"); 
} 
//Dynamic Fibonacci number calculation
int fib(int n) 
{ 
  /* Declare an array to store Fibonacci numbers. */
  int f[n+2];   // 1 extra to handle case, n = 0 
  int i; 
  
  /* 0th and 1st number of the series are 0 and 1*/
  f[0] = 0; 
  f[1] = 1; 
  
  for (i = 2; i <= n; i++) 
  { 
      /* Add the previous 2 numbers in the series 
         and store it */
      f[i] = f[i-1] + f[i-2]; 
  } 
  
  return f[n]; 
} 
  

 
// A utility function to get the maximum of two integers
int max(int a, int b) { return (a > b)? a : b;}
 

/* Driver program to test above functions */
int main()
{
    int n = 9; 
    printf("%d", fib(n)); 
    getchar(); 
    char* word="hello";
    int arr1[] = {64, 34, 25, 12, 22, 11, 90}; 
    int size = sizeof(arr)/sizeof(arr[0]); 
    bubbleSort(arr1, size); 
    printf("Sorted array: \n"); 
    printArray(arr1, n); 
    return 0;
}
