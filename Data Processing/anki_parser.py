# This file parses vocab data out of the anki deck I downloaded
import json

def remove_brackets(text):
    text_clean = ""
    in_bracket = False

    opening = "({[<"
    closing = ")]}>"

    for char in text:
        if char in opening:
            in_bracket = True

        if not in_bracket:
            text_clean += char

        if char in closing:
            in_bracket = False

    # Remove extra spaces
    parts = text_clean.split(' ')
    parts_clean = []
    for p in parts:
        if p != '':
            parts_clean.append(p)

    return ' '.join(parts_clean)

anki_file = open("anki_deck.txt", "r")
lines_raw = anki_file.read().split("\n")[:-1]
anki_file.close()

lines = [line.split("\t") for line in lines_raw]

word_data = []
indexes = []

for line in lines:
    # Add each line as a dictionary to a list
    try:
        dict_obj = {"id": int(line[2]),
                    "german": remove_brackets(line[0]),
                    "germanSentence": line[1],
                    "english": line[3],
                    "englishSentence": line[5]}

        word_data.append(dict_obj)
    except:
        print(f"Error with {line}")


# Write to output file
with open("dictionary.json", "w+") as filename:
    json.dump(word_data, filename)

print("DONE!")