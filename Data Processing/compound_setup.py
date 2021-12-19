# This file turns the list of words with articles into a list of pure words for the decompounding process
import json

with open("dictionary.json", "r") as filename:
    data = json.load(filename)

data_new = []

for entry in data:
    german = entry["german"]
    words = german.split(" ")

    german_clean = ""

    # Remove article from entry
    if words[0] in ["der", "die", "das"]:
        german_clean = ' '.join(words[1:])
        article = words[0]
    elif words[0] == "der,":
        german_clean = ' '.join(words[2:])
        article = "der/die"
    else:
        german_clean = german
        article = ''

    new_dict = {"freq": entry["id"],
                "article": article,
                "german": german_clean.split(", ")[0],
                "germanSentence": entry["germanSentence"],
                "english": entry["english"],
                "englishSentence": entry["englishSentence"]}

    data_new.append(new_dict)

with open("word_list_new.json", "w+") as filename:
    json.dump(data_new, filename)

print("DONE!")