#include <stdio.h>
#include <cs50.h>
#include <string.h>

int main(void)
{
    string strings[] = {"battleship", "boot", "cannon", "iron", "thimble", "top hat"};

    string s = get_string("String: ");

    for (int i = 0; i < 6; i++)
    {
        if (strcmp(strings[i], s) == 0) // This function compares the ASCII-betical order of two strings. The return value could be negative, positive, or neutral (0), meaning that the second string comes before, after, or is the same word, respectively.
        {
            printf("Found :)\n");
            return 0;
        }
    }
    printf("Not found :(\n");
    return 1;
}
