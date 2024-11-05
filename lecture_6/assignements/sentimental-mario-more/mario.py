from cs50 import get_int


def main():
    height = get_valid_height()
    print_pyramid(height)


def get_valid_height():
    while True:
        height = get_int("Height: ")

        if 1 <= height <= 8:
            return height


def print_pyramid(n):
    for i in range(n):
        print(" " * (n - (i + 1)), end="")
        print("#" * (i + 1), end="")
        print("  ", end="")
        print("#" * (i + 1))


main()
