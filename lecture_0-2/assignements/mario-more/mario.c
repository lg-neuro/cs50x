#include <cs50.h>
#include <stdio.h>

void print_row(int spaces, int bricks);

int main(void)
{
     // Prompt the user for the pyramid's height
    int height;
    do
    {
        height = get_int("Height: ");
    }
    while (height < 1);

    // Print a pyramid of that height
    for (int i = 0; i < height; i++)
    {
        // Print the first half of a pyramid row
        print_row(height - i + 1, i + 1);

        // Print the middle space
        printf("  ");

        // Print the second half of a pyramid row
        print_row(0, i + 1);

        // Go to the next row
        printf("\n");
    }
}

void print_row(int spaces, int bricks)
{
    // Print spaces (decreasing)
    for (int i = spaces; i > 2; i--)
    {
        printf(" ");
    }

    // Print bricks (increasing)
    for (int j = 0; j < bricks; j++)
    {
        printf("#");
    }
}
