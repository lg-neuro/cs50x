import csv
import sys


def main():

    # Check for command-line usage
    get_valid_input()

    # Read database file into a variable
    header, database_rows = read_database(sys.argv[1])

    # Read DNA sequence file into a variable
    dna = read_dna(sys.argv[2])

    # Find longest match of each STR in DNA sequence
    longest_matches = []
    for subsequence in header[1:]:
        longest_matches.append(longest_match(dna, subsequence))

    # Check database for matching profiles
    matching_profiles(header, database_rows, longest_matches)


def get_valid_input():
    """Check for command-line usage"""
    if len(sys.argv) != 3:
        print("Usage: python dna.py namefile.cvs namefile.txt")
        sys.exit()


def read_database(filename):
    """Read database file into a variable"""
    header = []
    database_rows = []
    try:
        with open(filename) as file:
            reader = csv.DictReader(file)
            header = reader.fieldnames
            for row in reader:
                database_rows.append(row)
    except FileNotFoundError:
        print(f"Error: {filename} not found.")
        sys.exit()
    except Exception as e:
        print(f"Error: {e}")
        sys.exit()

    return header, database_rows


def read_dna(filename):
    """Read DNA sequence file into a variable"""
    try:
        with open(filename) as dna_seq:
            dna = dna_seq.read()
    except FileNotFoundError:
        print(f"Error: {filename} not found.")
        sys.exit()
    except Exception as e:
        print(f"Error: {e}")
        sys.exit()

    return dna


def matching_profiles(header, database, matches):
    """Check database for matching profiles"""
    not_a_match = True
    for row in database:
        str_count_list = []
        for key in header[1:]:
            str_count = row[key]
            str_count_list.append(int(str_count))
        if str_count_list == matches:
            print(f"{row["name"]}")
            not_a_match = False
    if not_a_match:
        print("No match")


def longest_match(sequence, subsequence):
    """Returns length of longest run of subsequence in sequence."""

    # Initialize variables
    longest_run = 0
    subsequence_length = len(subsequence)
    sequence_length = len(sequence)

    # Check each character in sequence for most consecutive runs of subsequence
    for i in range(sequence_length):

        # Initialize count of consecutive runs
        count = 0

        # Check for a subsequence match in a "substring" (a subset of characters) within sequence
        # If a match, move substring to next potential match in sequence
        # Continue moving substring and checking for matches until out of consecutive matches
        while True:

            # Adjust substring start and end
            start = i + count * subsequence_length
            end = start + subsequence_length

            # If there is a match in the substring
            if sequence[start:end] == subsequence:
                count += 1

            # If there is no match in the substring
            else:
                break

        # Update most consecutive matches found
        longest_run = max(longest_run, count)

    # After checking for runs at each character in seqeuence, return longest run found
    return longest_run


if __name__ == "__main__": # This block ensures that 'main()' is called
    main()                 # only when the script is run directly, not
                           # when it's imported as a module in antother
                           # script. This is a common prractice in Python
                           # to organize code execution.

