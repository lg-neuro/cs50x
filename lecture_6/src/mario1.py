from cs50 import get_int

while True:
    x = get_int("Length: ")
    if x > 0:
        break

for i in range(x):
    print("#", end="")

print()
