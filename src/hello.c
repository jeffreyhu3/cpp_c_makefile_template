#include <stdio.h>
#include "hello.h"

int hujunfeng = 85;

void HelloPrint(void)
{
    int i = HELLO+hujunfeng;
    printf("Hello, World! test\n");
    printf("Hujunfeng\n");
    printf("Year = %d \n", i);
}