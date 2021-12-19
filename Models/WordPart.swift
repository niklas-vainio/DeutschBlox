//
//  WordPart.swift
//  GermanLearning
//
//  Created by Niklas on 14/07/2021.
//
//  This file defines the model for a single part of a word
//  Contains the word itself, the definiiton (if applicable) and the colour

import Foundation
import SwiftUI

struct WordPart: Codable {
    let text: String
    let english: String
    
    // Computed property for the color to draw the word, which calls functions in ColorManager
    var color: Color {
        return text.count % 2 == 0 ? Color.red : Color.blue
    }
}
