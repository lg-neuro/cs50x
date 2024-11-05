def get_int(prompt):
    while True:
        try:
            return int(input(prompt))
        except ValueError:
            pass                      # you can also insert `print("Not an integer")` instead of `pass`


def main():
    x = get_int("  x: ")
    y = get_int("  y: ")

    print("Sum:", x + y)


main()
