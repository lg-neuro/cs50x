#include <cs50.h>
#include <stdio.h>

int count_coins(int change, int coin_value);

// Define constant values of coins
const int quarter = 25;
const int dime = 10;
const int nickel = 5;
const int penny = 1;

int main(void)
{

    int cents;
    do
    {
        cents = get_int("Change owed: ");
    }
    while (cents < 0);

    int quarters = count_coins(cents, quarter);
    cents = cents - (quarter * quarters);

    int dimes = count_coins(cents, dime);
    cents -= (dime * dimes);

    int nickels = count_coins(cents, nickel);
    cents -= (nickel * nickels);

    int pennies = count_coins(cents, penny);

    int sum = quarters + dimes + nickels + pennies;

    printf("%i\n", sum);

    return 0;
}

int count_coins(int change, int coin_value)
{
    int coin = 0;
    while (change >= coin_value)
    {
        coin++;
        change -= coin_value;
    }
    return coin;
}
