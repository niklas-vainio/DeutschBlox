//
//  VocabData.swift
//  GermanLearning
//
//  Created by Niklas on 14/07/2021.
//  This file loads all data from word_data.json into an array of VocabEntry objects

import Foundation

// Load the vocab data when starrting the app
var vocabData: [VocabEntry] = load("word_data.json")

// Function to load data from a json file
func load<T: Decodable>(_ filename: String) -> T {
    let data: Data
    
    guard let file = Bundle.main.url(forResource: filename, withExtension: nil) else {
        fatalError("Couldn't find \(filename) in main bundle!")
    }
    
    do {
        data = try Data(contentsOf: file)
    } catch {
        fatalError("Couldn't load \(filename) from main bundle:\n\(error)")
    }
    
    do {
        let decoder = JSONDecoder()
        return try decoder.decode(T.self, from: data)
    } catch {
        fatalError("Couldn't parse \(filename) as \(T.self):\n\(error)")
    }
}
