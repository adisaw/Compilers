//Type declaration test

float function_1(float a,int b)
{
	float ans;
	ans=a * b;
	return ans;
}

char function_2(int a,float b, char c)
{
	float kt=b;
	char *p=&c;
	int i=a+b;
	return c;
}

int main()
{
	char a='a',b='b',c='c';
	float dp[20][15];
	char *d=&a;
	int k=9;
	int l=k+10;
	int  i = 50, *p = &i;
	function_1(dp[1][1],dp[1][2]);
	function_2(k, dp[1][1], a);
}
