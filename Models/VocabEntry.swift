//
//  VocabEntry.swift
//  GermanLearning
//
//  Created by Niklas on 14/07/2021.
//  This file defines the model for a vocab entry to be shown on the screen
//  Contains multiple german forms, the article as well as english and space repetition data

import Foundation

struct VocabEntry : Codable, Identifiable {
    // Each word is given a unique id, with more frequent words being 0 and less freuent haveing higher ids
    let id: Int
    let frequencyRank: Int
    
    // Store the article
    let article: String
    
    // Store the german word for this vocab entry
    let german: CompoundWord
    
    // Store example sentences and english translation
    let germanSentence: String
    let englishSentence: String
    let english: String
}
