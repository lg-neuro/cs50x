#include <cs50.h>
#include <ctype.h>
#include <math.h>
#include <stdio.h>
#include <string.h>

int letter_count(string s);
int word_count(string s);
int sentence_count(string s);
void print_grade(int index);

int main(void)
{
    // Get the text.
    string text = get_string("Text: ");

    // Calculate the index.
    int letters = letter_count(text);
    int words = word_count(text);
    int sentences = sentence_count(text);

    // Calculate the index of readability knowing that L is the average number of letters per 100
    // words and S is the average number of sentences per 100 words.
    float L = letters * 100.0 / words;
    float S = sentences * 100.0 / words;
    float index = 0.0588 * L - 0.295 * S - 15.8;

    // Print the grade.
    print_grade(round(index));
    return 0;
}

int letter_count(string s)
{
    int i = 0;
    int length = 0;

    // Count letters until the input is over.
    while (s[i] != '\0')
    {
        if (isalnum(s[i]))
        {
            length++;
        }
        i++;
    }
    return length;
}

int word_count(string s)
{
    int i = 0;
    int word = 1;

    // Count words until the input is over.
    while (s[i] != '\0')
    {
        if (isspace(s[i]))
        {
            word++;
        }
        i++;
    }
    return word;
}

int sentence_count(string s)
{
    int i = 0;
    int sentence = 0;

    // Count sentences until the input is over.
    while (s[i] != '\0')
    {
        if (s[i] == '.' || s[i] == '?' || s[i] == '!') // || s[i] == ';')
        {
            sentence++;
        }
        i++;
    }
    return sentence;
}

// This function prints the Grade roundend to the nearest integer.
void print_grade(int index)
{
    if (index < 1)
    {
        printf("Before Grade 1\n");
    }
    else if (index >= 1 && index < 16)
    {
        printf("Grade %i\n", index);
    }
    else if (index >= 16)
    {
        printf("Grade 16+\n");
    }
}
