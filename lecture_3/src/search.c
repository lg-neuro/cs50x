#include <stdio.h>
#include <cs50.h>

int main(void)
{
    int numbers[] = {20, 500, 10, 5, 100, 1, 50};

    int n = get_int("Number: ");

    for (int i = 0; i < 7; i++)
    {
        if (n == numbers[i])
        {
            printf("Found.\n");
            return 0; // To make the program stop prematurely since I got what I was looking for.
        }
    }
    printf("Not found.\n"); //Not to put it in the
    return 1;
}
