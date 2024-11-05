c = input("Do you agree? ")

c = c.lower()

if c in ["y", "yes"]:
    print("Agreed.")
elif c in ["n", "no"]:
    print("Not agreed.")
else:
    print("Usage: type 'yes'/'no.")
