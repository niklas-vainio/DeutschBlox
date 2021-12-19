# This file is my attempt at word decompounding
# Outputs a file called compound_data.json, which is read by final_formatter.py
# Formatted as a list of dicts:
#   fullWord - String
#   parts - list of dicts [{
#       text - String, english - String (possibly empty)
#   }]

import json
from fuzzywuzzy import fuzz

# Function to decompound a word
def decompound(word_in):
    word = word_in.lower()

    # Special cases
    if word in ["abend", "eher"]:
        return [word]

    if word == "wohnung":
        return ["wohn", "ung"]

    # Find infixes, ungs, heits, keist as well as special cases
    infixes = ["sich ", "... ", " + dat", "ungs", "heits", "keits", "ung", "heit", "igkeit", "keit"]
    for infix in infixes:
        if infix in word:
            start_idx = word.index(infix)
            end_idx = start_idx + len(infix)

            # Return start and end after decompounding
            return decompound(word[:start_idx]) + [infix] + decompound(word[end_idx:])


    # print(f"Sarting with {word}")

    start = []
    end = []

    # Go through all prefixes and suffixes
    # Avoid splitting if remaining word would only have one letter
    # Don't split off a preposition which is the same length as the input word, if in word list
    for prefix in prefixes:
        if len(prefix) < len(word_in):
            if word.startswith(prefix) and len(word) - len(prefix) != 1:

                word = word[len(prefix):]
                # print(f"Found prefix {prefix} - word is now {word}")
                start.append(prefix)
                break


    for suffix in suffixes:
        # Suffix -> remove from end
        if len(suffix) < len(word_in):
            if word.endswith(suffix) and len(word) - len(suffix) != 1:
                word = word[:-len(suffix)]
                # print(f"Found suffix {suffix} - word is now {word}")
                end.append(suffix)
                break

    word_parts = start + [word] + end

    # Remove any empty strings
    word_parts_clean = []
    for part in word_parts:
        if part != '':
            word_parts_clean.append(part)

    return word_parts_clean

# Returns the translations of all the compound words
def translate_compounds(parts, full_word):
    # Return an empty string if length one

    if len(parts) == 1:
        return ['']
    translations = []

    for part in parts:
        # Don't translate "ei" as egg or "eh" as anyway
        if part.lower() in ["ei", "eh"]:
            translations.append('')
            continue

        # Check if part is a preposition
        if part in prepositions:
            translations.append(prepositions[part])
            continue

        # Finds the best fuzzy wuzzy match from the word list, which must be over 80%
        best_match = None
        best_ratio = 0

        for test_word in word_list:
            raw_ratio = fuzz.ratio(test_word.lower(), part.lower())
            verbal_ratio = fuzz.ratio(test_word.lower(), part.lower() + "en")

            ratio = max(raw_ratio, verbal_ratio - 5)

            if ratio > 90 and ratio > best_ratio:
                best_ratio = ratio
                best_match = test_word

        # If best match is none or same as the full word, add an empty string
        if best_match is None or best_match == full_word:
            translations.append('')
        else:
            # Othwerise, get the english for the best_match
            for entry in vocab_data:
                if entry["german"] == best_match:
                    translations.append(entry["english"])

    return translations

# Load all words
with open("raw_compounds.txt", "r") as file:
    word_list = file.read().split("\n")[:-1]

with open("/Users/niklas/Desktop/PROGRAMMING/PYTHON/GermanAppMkIII/word_list_new.json", "r") as file:
    vocab_data = json.load(file)

# Load prefixes and suffixes
# Put shortest ones first to prioritise long prefixes/suffixes

with open("prefixes.txt", "r") as file:
    prefixes = [line[:-1] for line in file.read().split("\n")]

prefixes.sort(key=lambda x: len(x), reverse=True)


# Add all words from list that are 6 letters or less - lower priority than prefixes
for word in word_list:
    if len(word) <= 5:
        prefixes.append(word.lower())

with open("suffixes.txt", "r") as file:
    suffixes = [line[1:] for line in file.read().split("\n")]
    suffixes.sort(key=lambda x: len(x), reverse=True)

# Load all prepositions into a dict
prepositions = {}
with open("prepositions.txt", "r") as file:
    for line in file.read().split("\n"):
        segments = line.split(" (")

        prepositions[segments[0]] = segments[1][:-1]

compound_data = []
count = 0

print(decompound("Vergangenheitsbewältigung"))
exit()

for word in word_list:
    count += 1
    word_parts = decompound(word)
    translations = translate_compounds(word_parts, word)

    # Match case of word
    if word[0].isupper():
        word_parts[0] = word_parts[0].capitalize()

    # Write data to dict
    part_dicts = []
    for i in range(len(word_parts)):
        part_dicts.append({
            "text": word_parts[i],
            "english": translations[i]
        })

    word_dict = {
        "fullWord": word,
        "parts": part_dicts
    }

    compound_data.append(word_dict)

    print(count, '-'.join(word_parts), word_dict)

# Write data to file
with open("compound_data.json", "w+") as file:
    json.dump(compound_data, file)

print("DONE!")