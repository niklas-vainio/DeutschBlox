# Reads json from word_list_new and simply puts all the words in a list for decompounding
import json

with open("word_list_new.json", "r") as filename:
    data = json.load(filename)

with open("raw_compounds.txt", "w+") as file:
    for entry in data:
        file.write(entry["german"] + "\n")

print("DONE!")