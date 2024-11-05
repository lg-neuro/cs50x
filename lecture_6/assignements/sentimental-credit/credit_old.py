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


MAX_SINGLE_DIGIT = 9
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
    length = len(card) - 2
    first_digits = []
    while length >= 0:
        first_digits.append(int(card[length]) * 2)
        length -= 2

    for i in range(len(first_digits)):
        if first_digits[i] > MAX_SINGLE_DIGIT:
            first_digits.append(1)
            first_digits[i] -= MODULO_DIVISOR

    length = len(card) - 1
    second_digits = []
    while length >= 0:
        second_digits.append(int(card[length]))
        length -= 2

    Sum = sum(first_digits) + sum(second_digits)
    return Sum


def card_validation(n):
    if n % 10 == 0:
        return True
    else:
        return False


def which_circuit(card):
    signature = card[:2]  # Gets the first two digits
    for key in CIRCUIT_PREFIX:
        if signature in key:
            print(f"{CIRCUIT_SIGNATURE[key]}")
            return

    print("INVALID")
    exit(2)


main()
