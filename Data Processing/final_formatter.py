# This creates the final json file which will be used in swift
import json

# Load vocab data and compound data
with open("word_list_new.json", "r") as file:
    vocab_data = json.load(file)
with open("Decompounding/compound_data.json", "r") as file:
    compound_data = json.load(file)

# Sort all vocab data by id
vocab_data.sort(key = lambda x: x["freq"])

final_data = []

count = 0

# Loop through each entry in vocab data and write a new dict to the final array
for entry in vocab_data:
    german_dict = {}

    # Look for entry in compound_data.json
    for compound_entry in compound_data:

        # Found compound entry corresponding to german word
        if compound_entry["fullWord"] == entry["german"]:
            # Set german_dict to the compound data for this word
            german_dict = compound_entry

    # If still none, alert
    if german_dict == {}:
        print(f"No compound data found for {entry['german']}!")
        exit()



    data_dict = {
        "id": count,
        "frequencyRank": entry["freq"],
        "article": entry["article"],
        "german": german_dict,
        "germanSentence": entry["germanSentence"],
        "english": entry["english"],
        "englishSentence": entry["englishSentence"]
    }

    print(data_dict)

    final_data.append(data_dict)

    count += 1


# Write final data to json file
with open("word_data.json", "w+") as file:
    json.dump(final_data, file)

print("DONE!")