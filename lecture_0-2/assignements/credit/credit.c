#include <cs50.h>
#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

const int amex = 15;
const int m_card = 16;
const int visa_1 = 13;
const int visa_2 = 16;

const int invalid_card_length = 14;

const int max_digit = 9;
const int modulo_divisor = 10;

int check_sum(string number, int length);
bool card_validation(int sum);
void which_circuit(string number, int length);

int main(void)
{
    // Get the user credit card number
    long credit_card;
    do
    {
        credit_card = get_long("Number: ");
    }
    while (credit_card < 0);

    // Convert the `card_number` long to a string to have access to all its digits, remembering that
    // no credit card number exceeds 16 digits.
    char card_number[m_card + 1];
    sprintf(card_number, "%li", credit_card);

    // Check if the credic card length is valid (at least among the ones we consider)
    int card_length = strlen(card_number);

    // Calculate the checksum
    int checksum = check_sum(card_number, card_length);

    // Validate the card with checksum
    if (card_validation(checksum))
    {
        // Find the card cicuit
        which_circuit(card_number, card_length);
    }
    else
    {
        printf("INVALID\n");
    }
}

// This function will calculate the checksum
int check_sum(string number, int length)
{
    // Multiply every other digit by 2, starting with the number’s second-to-last digit and add
    // those products’ digits together
    int sum = 0;

    for (int i = length - 2; i >= 0; i -= 2)
    {
        // Double each number
        int digit = (number[i] - '0') * 2;

        // If digit is a double-digit number, e.g. 12, that I will consider the sum of the two
        // digits, 1 and 2 (which is equal to 12 - 10 + 1)
        if (digit > max_digit)
        {
            digit -= digit - modulo_divisor + 1;
        }

        // Sum digits
        sum += digit;
    }

    // Sum to the total also the previously not considered digits
    for (int i = length - 1; i >= 0; i -= 2)
    {
        sum += (number[i] - '0');
    }

    return sum;
}

// This function will return true if the last digit of the checksum is 0
bool card_validation(int checksum)
{
    return (checksum % modulo_divisor == 0);
}

// This function will print the circuit of the card after checking its length and its prefix
void which_circuit(string number, int length)
{
    if (length == amex && (strncmp(number, "34", 2) == 0 || strncmp(number, "37", 2) == 0))
    {
        printf("AMEX\n");
    }
    else if (length == m_card && number[0] == '5' && (number[1] >= '1' && number[1] <= '5'))
    {
        printf("MASTERCARD\n");
    }
    else if ((length == visa_1 || length == visa_2) && number[0] == '4')
    {
        printf("VISA\n");
    }
    else
    {
        printf("INVALID\n");
    }
}
