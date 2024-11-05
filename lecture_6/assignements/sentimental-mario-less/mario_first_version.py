from cs50 import get_int

height = get_int("Height: ")

while height < 1 or height > 8:
    height = get_int("Height: ")

for i in range(height):
    spaces = height - (i + 1)
    for j in range(spaces):
        print(" ", end="")
    print("#" * (i + 1))
