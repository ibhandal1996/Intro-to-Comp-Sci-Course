#include <stdio.h>

int main() {
    int n, a, i, j = 0, k = 1;
    printf("Enter a number: ");
    scanf("%d", &n);
    for(i = 0; i < n; i++) {
        if(i <= 1) {
            a = i;
        }
        else {
            a = j + k;
            j = k;
            k = a;
        }
        printf("%d\n", a);
    }
    return 0;
}


