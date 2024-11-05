#include <ctype.h>
#include <cs50.h>
#include <stdio.h>
#include <string.h>

// Points assigned to each letter of the alphabet
int POINTS[] = {1, 3, 3, 2, 1, 4, 2, 4, 1, 8, 5, 1, 3, 1, 1, 3, 10, 1, 1, 1, 1, 4, 4, 8, 4, 10};

int word_points(string s);

int main(void)
{
    // Prompt the user for two words
    string word1 = get_string("Player 1: ");
    string word2 = get_string("Player 2: ");

    // Compute the score of each word
    int sum1 = word_points(word1);
    int sum2 = word_points(word2);

    printf("Sum 1: %i; Sum 2: %i\n", sum1, sum2);

    // Print the winner
    if (sum1 > sum2)
    {
        printf("Player 1 wins!\n");
    }
    else if (sum1 < sum2)
    {
        printf("Player 2 wins!\n");
    }
    else
    {
        printf("Tie!\n");
    }
}

int word_points(string word)
{
    int sum = 0;

    for (int i = 0, n = strlen(word); i < n; i++)
    {
        if (isalnum(word[i]))
        {
            word[i] = toupper(word[i]);
            sum += POINTS[word[i] - 'A'];
        }
    }
    return sum;
}
