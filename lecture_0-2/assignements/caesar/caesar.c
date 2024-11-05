#include <cs50.h>
#include <ctype.h>
#include <math.h>
#include <stdio.h>
#include <string.h>

const int modulo_operator = 26;

int atoi(string s);
char rotate(char c, int n);

int main(int argc, string argv[])
{
    // Get a key from the user. If any of the characters of the command-line argument is not a
    // decimal digit, print the message Usage: ./caesar key and return from main a value of 1.
    if (argc != 2)
    {
        printf("Usage: %s key\n", argv[0]);
        return 1;
    }
    else if (argc == 2)
    {
        for (int i = 0, n = strlen(argv[1]); i < n; i++)
        {
            if (isalpha(argv[1][i]) || ispunct(argv[1][i]))
            {
                printf("Usage: %s key\n", argv[0]);
                return 1;
            }
            else if (isdigit(argv[1][i]))
            {
                int key = atoi(argv[1]);
                if (key < 1)
                {
                    printf("Usage: %s key\n", argv[0]);
                    return 1;
                }
            }
        }
    }

    // Get the "plaintext:  ".
    string plain_text = get_string("plaintext:  ");

    // Transform string key to int
    int key = atoi(argv[1]);

    // Encryption & output "ciphertext: ".
    printf("ciphertext: ");
    for (int i = 0, n = strlen(plain_text); i < n; i++)
    {
        char c = rotate(plain_text[i], key);
        printf("%c", c);
    }
    printf("\n");
    return 0;
}

// This function takes a char and an int as inputs, and rotates that char by that many positions if
// it’s a letter (i.e., alphabetical), wrapping around from Z to A (and from z to a) as needed. If
// the char is not a letter, the function should instead return the same char unchanged.

char rotate(char c, int n)
{
    if (isupper(c))
    {
        return 'A' + (c - 'A' + n) % modulo_operator; // The "%" basically means to go back to 0 once reaching 25.
    }
    else if (islower(c))
    {
        return 'a' + (c - 'a' + n) % modulo_operator;
    }
    else
    {
        return c;
    }
}
