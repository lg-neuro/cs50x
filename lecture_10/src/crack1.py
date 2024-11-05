from string import ascii_letters
from itertools import product

# Pythonic way to combnine all 10 digits 4 times
for passcode in product(ascii_letters, repeat=4):
    print(passcode) # Just for us to visualize it, not for sure for the hacker to hack into out phone