#include <cs50.h>
#include <ctype.h>
#include <stdio.h>
#include <string.h>

char substitute(char c, string s);

int main(int argc, string argv[])
{
    // Get a valid key.
    if (argc != 2)
    {
        printf("Usage: %s key\n", argv[0]);
        return 1;
    }
    else if (strlen(argv[1]) != 26)
    {
        printf("Key must contain 26 characters.\n");
        return 1;
    }
    else
    {
        for (int i = 0; i < 26; i++)
        {
            if (!isalpha(argv[1][i]))
            {
                printf("Key must contain only alphabetic characters.\n");
                return 1;
            }
            for (int j = i + 1; j < 26; j++)
            {
                if (argv[1][i] == argv[1][j])
                {
                    printf("Key must not contain repeated characters.\n");
                    return 1;
                }
            }
        }
    }

    // Get an input.
    string plain_text = get_string("plaintext:  ");

    // Output "ciphertext: ".
    printf("ciphertext: ");
    for (int i = 0, n = strlen(plain_text); i < n; i++)
    {
        char c = substitute(plain_text[i], argv[1]);
        printf("%c", c);
    }
    printf("\n");
    return 0;
}

char substitute(char c, string s)
{
    if (isupper(c))
    {
        // Map A-Z to corresponding letter in key
        int i = c - 'A';
        return toupper(s[i]);
    }
    else if (islower(c))
    {
        // Map a-z to corresponding letter in key
        int i = c - 'a';
        return tolower(s[i]);
    }

    // Non-alphabetic characters are unchanged
    else
        return c;
}
