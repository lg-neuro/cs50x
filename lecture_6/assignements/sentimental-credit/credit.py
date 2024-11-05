from cs50 import get_string
from sys import exit


# List of all possible card number lengths
CARD_LENGTH = [13, 15, 16]

# Dictionary with all card prefixes
CIRCUIT_PREFIX = {
    ("34", "37",): "AMEX",
    ("40", "41", "42", "43", "44", "45", "46", "47", "48", "49",): "VISA",
    ("51", "52", "53", "54", "55",): "MASTERCARD",
}


MAX_DIGIT = 9
MODULO_DIVISOR = 10


def main():
    # Get a valid card number
    card_number = valid_length()

    # Calculate the checksum
    checksum = calculate_checksum(card_number)

    # Output the circuit, if the card number is valid
    if card_validation(checksum) == True:
        which_circuit(card_number)
    else:
        print("INVALID")

# This function return the card number to main() only if it respects length parameters


def valid_length():
    while True:
        card_number = get_string("Number: ")

        if len(card_number) in CARD_LENGTH:
            return card_number
        else:
            print("INVALID")
            exit(1)

            # For better debugging `raise ValueError("INVALID")`
            # could be used. Doing so, every time a non-valid
            # card number is input, an error pops out: I don't
            # know if it's better this way or the `exit()` way)


# This function calculates the checksum
def calculate_checksum(card):
    total = 0
    length = len(card) - 1

    # Flag to keep track which digits to double
    to_double = False

    # Multiply every other digit by 2, starting with the number’s second-to-last digit and add those products’ digits together
    for i in range(length, -1, -1):

        # If odd index (starting from the end of the card)
        if not to_double:
            # Add digit to the total
            total += int(card[i])

            # Change flag for next number
            to_double = True

        # If even index
        elif to_double:
            # Double the digit
            digit = int(card[i]) * 2

            # If double-digit number, subtract 9 to have the sum of the digits of that number
            if digit > MAX_DIGIT:
                digit -= MAX_DIGIT

            # Add digit to the total
            total += digit

            # Change flag for next number
            to_double = False

    return total


# This function returns true if the last digit of a number is 0
def card_validation(n):
    if n % 10 == 0:
        return True
    else:
        return False


# This function returns the card circuit based on the prefix
def which_circuit(card):
    signature = card[:2]  # Gets the first two digits
    for key in CIRCUIT_PREFIX:
        if signature in key:
            print(f"{CIRCUIT_PREFIX[key]}")
            return

    print("INVALID")
    exit(2)


main()
