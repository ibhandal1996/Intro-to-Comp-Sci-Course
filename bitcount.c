 /*     Name: Iqbal Bhandal
 Lab section time: 04L on Friday at 4:30pm to 7:20pm
 */
#include <stdio.h>
#include <stdlib.h>

int bitCount (unsigned int n);

int main (int argc, char * argv[])
{    
	printf ("# 1-bits in base 2 representation of %u = %d, should be 0\n", 
		0, bitCount (0));

	printf ("# 1-bits in base 2 representation of %u = %d, should be 1\n",
		1, bitCount (1)); 

	printf ("# 1-bits in base 2 representation of %u = %d, should be 16\n",
		2863311530u, bitCount (2863311530u)); 

	printf ("# 1-bits in base 2 representation of %u = %d, should be 1\n",
		536870912, bitCount (536870912));   

	printf ("# 1-bits in base 2 representation of %u = %d, should be 32\n",
		4294967295u, bitCount (4294967295u));  

	printf("%d\n", bitCount(atoi(argv[1])));


	system("pause");
	return 0;   

}   
int bitCount (unsigned int n) 
{
	if (n == 0)
		return 0;
	if (n == 1)
		return 1;
	return bitCount(n % 2) + bitCount(n / 2);
} 