#include <stdio.h>
#include <cs50.h>

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
        // Print a pyramid row
        print_row(height - i - 1, i + 1);
    }
}

void print_row(int spaces, int bricks)
{
    // Print spaces (decreasing)
    for (int i = spaces; i > 0; i--)
    {
        printf(" ");
    }

    // Print blocks (increasing)
    for (int i = 0; i < bricks; i++)
    {
        printf("#");
    }
    printf("\n");
}
