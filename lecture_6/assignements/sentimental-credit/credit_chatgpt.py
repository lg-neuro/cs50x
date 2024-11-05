from cs50 import get_string
from sys import exit

CARD_LENGTH = [13, 15, 16]
CIRCUIT_SIGNATURE = {
    ("34", "37"): "AMEX",
    ("4",): "VISA",
    ("51", "52", "53", "54", "55"): "MASTERCARD",
}


def main():
    card_number = valid_length()
    checksum = calculate_checksum(card_number)
    if card_validation(checksum):
        which_circuit(card_number)
    else:
        print("INVALID")
        exit(2)


def valid_length():
    card_number = get_string("Number: ")
    if len(card_number) in CARD_LENGTH:
        return card_number
    else:
        print("INVALID")
        exit(1)

def calculate_checksum(card): # Way more simple than the one written by me (also quicker since only one loop)
    total = 0
    reversed_digits = card[::-1]

    for i, digit in enumerate(reversed_digits):
        n = int(digit)
        if i % 2 == 1:  # Every other digit, starting from the rightmost
            n *= 2
            if n > 9:
                n -= 9
        total += n

    return total


def card_validation(n): # Simpler than the one written by me, this also influence the `main()` since my function was retuning a boolean this one I don't even knwo what is returning
    return n % 10 == 0


def which_circuit(c):
    for card_type, prefixes in CIRCUIT_SIGNATURE.items():
        if c.startswith(prefixes):
            return card_type
    print("INVALID")
    exit(3)


main()
