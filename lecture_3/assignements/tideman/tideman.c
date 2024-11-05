#include <cs50.h>
#include <stdio.h>
#include <string.h>

// Max number of candidates
#define MAX 9

// preferences[i][j] is number of voters who prefer i over j
int preferences[MAX][MAX];

// locked[i][j] means i is locked in over j
bool locked[MAX][MAX];

// Each pair has a winner, loser
typedef struct
{
    int winner; // Winner candidate index
    int loser;  // Loser candidate index
} pair;

// Array of candidates
string candidates[MAX];
pair pairs[MAX * (MAX - 1) / 2];

int pair_count;
int candidate_count;

// Function prototypes
bool vote(int rank, string name, int ranks[]);
void record_preferences(int ranks[]);
void add_pairs(void);
void sort_pairs(void);
void lock_pairs(void);
void print_winner(void);
int victory_strength(pair p);
bool cycle_check(int winner, int loser);

int main(int argc, string argv[])
{
    // Check for invalid usage
    if (argc < 2)
    {
        printf("Usage: tideman [candidate ...]\n");
        return 1;
    }

    // Populate array of candidates
    candidate_count = argc - 1; 
    if (candidate_count > MAX)
    {
        printf("Maximum number of candidates is %i\n", MAX);
        return 2;
    }
    for (int i = 0; i < candidate_count; i++)
    {
        candidates[i] = argv[i + 1]; // Why this loop? Does this mean that candidate[0] is argv[1]? Same "issue" in runoff.c. Maybe it is because argv[0] is "tideman"?
    }

    // Clear graph of locked in pairs
    for (int i = 0; i < candidate_count; i++)
    {
        for (int j = 0; j < candidate_count; j++)
        {
            locked[i][j] = false;
        }
    }

    pair_count = 0;
    int voter_count = get_int("Number of voters: ");

    // Query for votes
    for (int i = 0; i < voter_count; i++) // Dov'è la 'i' che si permuta in questo loop?
    {
        // ranks[i] is voter's ith preference
        int ranks[candidate_count];

        // Query for each rank
        for (int j = 0; j < candidate_count; j++)
        {
            string name = get_string("Rank %i: ", j + 1);

            if (!vote(j, name, ranks))
            {
                printf("Invalid vote.\n");
                return 3;
            }
        }

        record_preferences(ranks);

        printf("\n");
    }

    add_pairs();
    sort_pairs();
    lock_pairs();
    print_winner();
    return 0;
}

// Update ranks given a new vote
bool vote(int rank, string name, int ranks[])
{

    // In questo loop 'i' corrisponde al candidato, quindi i = 0 è argv[1], i = 1 è argv[2], etc.
    // 'rank' segnala quale preferenza è data al candidato quindi se rank = 0 vuol dire che stiamo trattando la prima preferenza dell'elettore.
    // Con questa funzione e in questo loop dobbiamo registrare dentro a 'ranks[]' che candidates[i] è la sua 'rank' preferenza.
    // Se scrivo 'ranks[rank] = i' significa che ho memorizzato nell'array 'ranks[]' il 'candidates[i]' come 'rank'-esima scelta. (02/07/2024)

    for (int i = 0; i < candidate_count; i++)
        if (strcmp(candidates[i], name) == 0)
        {
            ranks[rank] = i; // Conserva il nome del candidato indicizzato con candidates[i] come preferenza di un elettore. Se ci sono tre candidati A(0), B(1) e C(2) e l'elettore li vota nell'ordine 1. B, 2. C, 3. A, il ranks[] di questo elettore sarà ranks = {1, 2, 0}. Ci saranno tanti array 'ranks[]' quanti elettori. Non ho capito però come fanno a essere diversi tra di loro. (02/07/2024)
            return true;
        }
    return false;
}

// Update preferences given one voter's ranks
void record_preferences(int ranks[])
{
    for (int i = 0; i < candidate_count; i++)
    {
        for (int j = i + 1; j < candidate_count; j++)
        {
            if (i < j) // Se l'indice di una preferenza è più alto dell'indice di un'altra preferenza per un singolo votante (in sostanza se un candidato viene preferito ad un altro da un elettore), aumenta di 1 le preferenze di questa coppia di candidati (i preferito a j). (02/07/2024)
            {
                preferences[ranks[i]][ranks[j]]++;
            }
        }
    }
}

// Record pairs of candidates where one is preferred over the other
void add_pairs(void)
{
    for (int i = 0; i < candidate_count; i++)
    {
        for (int j = 0; j < candidate_count; j++)
        {
            if (preferences[i][j] > preferences[j][i]) // Se le preferenze [i > j] sono maggiori delle preferenze [j > i] (se le persone in generale preferisocno i a j), aggiorna l'array 'pairs' (che è una variabile di tipo pair - vedi header - con due integers) con l'indice del candidato vincente nell'integer 'winner' e l'indice del candidato perdente nell'integer 'loser'. Anche qui non capisco bene come succeda, nel senso, solo per coincidenza il candidato A anche per questo loop ha 0 come indice. (02/07/2024)
            {
                pairs[pair_count].winner = i;
                pairs[pair_count].loser = j;
                pair_count++;
            }
        }
    }
    return;
}

// Establish which is the victory strength of a pair
int victory_strength(pair p) // Questa funzione ha il solo scopo di ritornare la differenza tra una coppia di 'pairs'. In sostanza se il candidato A è preferito al candidato B 7 volte e l'inverso 3 vlte questa funzione ritornerà 4. (02/07/2024)
{
    int difference = preferences[p.winner][p.loser] - preferences[p.loser][p.winner];
    return difference;
}

// Sort pairs in decreasing order by strength of victory
void sort_pairs(void)
{
    if (pair_count == 1)
    {
        return;
    }
    bool swap = true;
    while (swap) // Qesto è un "do-while loop" in cui la funzione continua ad essere implementata finché non si verifica la condizione 'false'. È un modo smart di tenere conto se una cosa si verifica o meno. Infatti, osservando meglio il codice si può notare che: inizialmente il valore di 'swap' è settato su 'true', appena il loop inizia 'swap' viene settato su 'false' e unicamente se l' 'if' si verifica ritorna fissato su 'true'. La volta che la condizione 'if' non verrà più soddisfatta (in questo caso quando tutte le 'pairs[]' saranno ordinate in modo decrescente in base alla 'victory_strength'), si uscirà dal loop.
    {
        swap = false;
        for (int i = 0; i < pair_count; i++)
        {
            for (int j = i + 1; j < pair_count; j++)
            {
                if (victory_strength(pairs[i]) < victory_strength(pairs[j]))
                {
                    pair x = pairs[i];
                    pairs[i] = pairs[j];
                    pairs[j] = x;
                    swap = true;
                }
            }
        }
    }
    return;
}

bool cycle_check(int winner, int loser)
{
    if (winner == loser)
    {
        return true;
    }
    for (int i = 0; i < candidate_count; i++)
    {
        if (locked[loser][i] && cycle_check(winner, i)) // Non ho capito perché è così. (03/07/2024)
        {
            return true;
        }
    }
    return false;
}

// Lock pairs into the candidate graph in order, without creating cycles
void lock_pairs(void)
{
    for (int i = 0; i < pair_count; i++)
    {
        if (!cycle_check(pairs[i].winner, pairs[i].loser)) // Non ho capito perché è così. In generale il significato è implementa cioè chhe segue solo se non si forma un ciclo (il ciclo impedirebbe di determinare un vincitore dell'elezione). (03/07/2024)
        {
            locked[pairs[i].winner][pairs[i].loser] = true; // Qui stai dicendo di aggiornare l'array boolean 'locker[][]' (rappresentante il grafico a frecce) con 'true' (quidni una frecca da i a j) ma solo nella condizione che si verifichi l' 'if'. (03/07/2024)
        }
    }
    return;
}

// Print the winner of the election
void print_winner(void)
{
    for (int i = 0; i < candidate_count; i++)
    {

        bool has_incoming_edges = false;
        for (int j = 0; j < candidate_count; j++)
        {
            if (locked[j][i] == true)
            {
                has_incoming_edges = true;
                break;
            }
        }
        if (has_incoming_edges == false)
        {
            printf("The winner is %s.\n", candidates[i]);
            return;
        }
    }
}
