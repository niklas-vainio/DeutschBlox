# This file matches raw words to their constituents, generated with the SECOS program
from fuzzywuzzy import fuzz
import json

with open("raw_compounds.txt", "r") as file:
    word_list = file.read().split("\n")[:-1]

with open("word_list_new.json", "r") as file:
    vocab_data = json.load(file)

with open("split_compounds.txt", "r") as file:
    compound_lines = file.read().split("\n")[:-1]
    # Get third entry in each tab seperated line, which is word with the most compound splits
    compounds_list = [line.split("\t")[3] for line in compound_lines]


# Create a list of lists of word parts
word_parts = [compound.split("-") for compound in compounds_list]

total_words = 0
total_multiple_parts = 0

total_parts = 0
total_in_dict = 0

compound_data = []

def get_best_match(part):
    # Finds the best fuzzy wuzzy match from the word list, which must be over 80%
    best_match = None
    best_ratio = 0

    for test_word in word_list:
        ratio = fuzz.ratio(test_word.lower(), part.lower())

        if ratio > 90 and ratio > best_ratio:
            best_ratio = ratio
            best_match = test_word

    return best_match

for i in range(len(word_list)):
    # Fuzzy wuzzy match to all words in dictionary
    matches = [get_best_match(part) for part in word_parts[i]]
    num_in_list = sum([p is not None for p in matches])

    # Convert list of matching words into list of ids
    part_ids = []
    for part in matches:
        # Add -1 if none
        if part is None:
            part_ids.append(-1)
        else:
            for entry in vocab_data:
                # Add id if part is in germanForms
                if part in entry["germanForms"]:
                    part_ids.append(entry["id"])
                    break

    # Raise exception if lists are not the same length
    if len(part_ids) != len(matches):
        raise Exception("Length mismatch :O")

    # Keep track of count for statistics
    total_words += 1
    if len(word_parts[i]) > 1:
        total_multiple_parts += 1
        total_parts += len(word_parts[i])
        total_in_dict += num_in_list

    # Add a dictionary to compound data with parts and ids in word list if relevant
    word_dict = {"fullWord": word_list[i],
                 "parts": word_parts[i],
                 "ids": part_ids}

    compound_data.append(word_dict)

    print(i, ":", word_list[i], "-", word_parts[i], matches, part_ids, word_dict)

print(f"{total_multiple_parts} have multiple parts out of {total_words} total! ({100 * total_multiple_parts/total_words:.2f})%")
print(f"{total_in_dict} parts in words with multiple are in dictionary out of {total_parts} total! ({100 * total_in_dict/total_parts:.2f})%")

# Write file to json
with open("compound_data.json", "w+") as file:
    json.dump(compound_data, file)

print("DONE!")