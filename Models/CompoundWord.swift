//
//  CompoundWord.swift
//  GermanLearning
//
//  Created by Niklas on 14/07/2021.
//  This file defines the model for word composed of compound words, which are composed of multiple word parts

import Foundation

struct CompoundWord: Codable {
    let fullWord: String
    let parts: [WordPart]
}
