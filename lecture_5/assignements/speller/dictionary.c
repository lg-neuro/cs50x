// Implements a dictionary's functionality

#include <ctype.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <strings.h>

#include "dictionary.h"

// Represents a node in a hash table
typedef struct node
{
    char word[LENGTH + 1];
    struct node *next;
} node;

// TODO: Choose number of buckets in hash table
const unsigned int N = 107323; // Prime nuber close to 107,000 would be an ideal
                               // load factor (~0.75, 'number_of_elements / N') for
                               // approximately 143,091 words in the dictionary.
                               // Until 50,000 I did not notice a significant drop
                               // in the `check` time performance. Below 10,000 the
                               // performance is decreasing significanlty.

// Represent the number of nodes
unsigned int nodes_count = 0;

// Hash table
node *table[N];

// Returns true if word is in dictionary, else false
bool check(const char *word)
{
    // Hash word
    int n = hash(word);

    for (node *ptr = table[n]; ptr != NULL; ptr = ptr->next)
    {
        if (strcasecmp(word, ptr->word) == 0)
        {
            return true;
        }
    }

    return false;
}

// Hashes word to a number
unsigned int hash(const char *word)
{
    // Calculate hash index for each word
    unsigned int hash = 0;

    for (int i = 0; word[i] != '\0'; i++) // The `word[i] != '\0'` idea comes from cs50 duck,
                                          // before I was calculating the length of the word
                                          // using `strlen()` and it was much slower
    {
        hash += (toupper(word[i]) - 'A'); // With `hash = (hash << 2) ^ toupper(word[i]);`
                                          // the performance increases a lot getting as good
                                          // as the one in `speller50` developed by cs50 staff.
    }

    return hash % N;
}

// Loads dictionary into memory, returning true if successful, else false
bool load(const char *dictionary)
{
    // Open the dictionary file
    FILE *source = fopen(dictionary, "r");
    if (source == NULL)
    {
        return false;
    }

    char word[LENGTH + 1];

    // Read each word in the dictionary
    while (fscanf(source, "%s", word) != EOF) // EOF is the end of the file
    {
        // Create a new node for each word
        node *n = malloc(sizeof(node));
        if (n == NULL)
        {
            fclose(source);
            return false;
        }
        nodes_count++;

        // Copy the word into the function
        strcpy(n->word, word);

        // Set the new node pointer to NULL
        n->next = NULL;

        // Hash the word
        int index = hash(word);

        // Insert the node in the table
        n->next = table[index];
        table[index] = n;
    }
    fclose(source);
    return true;
}

// Returns number of words in dictionary if loaded, else 0 if not yet loaded
unsigned int size(void)
{
    if (nodes_count > 0)
    {
        return nodes_count;
    }
    else
    {
        return 0;
    }
}

// Unloads dictionary from memory, returning true if successful, else false
bool unload(void)
{
    for (int i = 0; i < N; i++)
    {
        node *tmp;
        for (node *ptr = table[i]; ptr != NULL; ptr = tmp)
        {
            tmp = ptr->next; // If I directly freed ptr I would have a dangling pointer.
            free(ptr);
        }
    }
    return true;
}
