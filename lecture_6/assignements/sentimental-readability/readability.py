from cs50 import get_string


def main():
    # Get the input text
    text = get_string("Text: ")

    # Count each variable
    total_letters = letter_counter(text)
    total_words = word_counter(text)
    total_periods = period_counter(text)

    # Calculate each parameter
    L = total_letters * 100 / total_words
    S = total_periods * 100 / total_words

    # Calculate the readability index
    readability_score = compute_readability_score(L, S)

    # Print readability index
    print_readability_score(readability_score)


# Count the letters in the text
def letter_counter(text):
    counter = 0
    for i in text:
        # Each alphabetic character is a new letter
        if i.isalpha():
            counter += 1
    return counter


# Count the words in the text
def word_counter(text):
    counter = 0
    for i in text:
        # Each space is a new word
        if i.isspace():
            counter += 1
    return counter + 1 # Add 1 to count the last word


# Count the sentences in the text
def period_counter(text):
    counter = 0
    for i in text:
        # Each of this signs means a new sentence
        if i in [".", "!", "?"]:
            counter += 1
    return counter


# Calculate the readability score of the text
def compute_readability_score(L, S):
    # Coleman-Liau formula
    index = 0.0588 * L - 0.296 * S - 15.8
    return index


# Rounds to the nearest integer and print the readability score of the text
def print_readability_score(not_rounded_index):
    index = round(not_rounded_index)

    if index < 1:
        print("Before Grade 1")
    elif 1 <= index < 16:
        print(f"Grade {index}")
    elif index >= 16:
        print("Grade 16+")


main()
