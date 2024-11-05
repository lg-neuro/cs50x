from cs50 import get_float


COINS = [25, 10, 5, 1]


def main():
    change = get_valid_change()
    print(coin_counter(change))


def get_valid_change():
    while True:
        change = get_float("Change: ")

        if change > 0:
            return (change * 100)


def coin_counter(n):
    coins = 0

    for m in COINS:
        while n > (m - 1):
            n -= m
            coins += 1

    return coins


main()
