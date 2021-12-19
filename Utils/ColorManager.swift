//
//  ColorManager.swift
//  GermanLearning
//
//  Created by Niklas on 17/07/2021.
//  This file allows all colour data to be accesed from one place

import Foundation
import SwiftUI

let germanAlphabet: String = "abcdefghijklmnopqrstuvwxyzäüöß"

struct ColorManager {
    
    // Array of colors for word parts
    static let wordPartColors: [Color] = [
        .red,
        .green,
        Color(red: 1.0, green: 0.5, blue: 0.75), // Pink colour
        .purple,
        .orange,
        .blue,
    ]
    
    // Dict of colors for articles
    static let articleColors: [String: Color] = [
        "der": Color.blue,
        "die": Color.red,
        "das": Color.green,
        "der/die": Color.purple
    ]

    // Gets the color for a word part, which depends only on the first letter
    static func getWordColor(for wordPart: WordPart) -> Color {
        let lowercaseText: String = wordPart.text.lowercased()
        let startChar: Character = lowercaseText[lowercaseText.startIndex]
        
        // Return gray if character is not in the alphabet
        if !(germanAlphabet.contains(startChar)) {
            return Color.gray
        }
        
        // Otherwise, wrap alphabet indices around colour array
        let alphabetIndex: Int = germanAlphabet.distance(from: germanAlphabet.startIndex, to: germanAlphabet.firstIndex(of: startChar)!)
        let colorIndex = alphabetIndex % wordPartColors.count
        
        return wordPartColors[colorIndex]
    }
    
    // Gets the color for an article
    static func getArticleColor(for article: String) -> Color {
        // Return black if not in dictionary
        return articleColors[article] ?? Color.black
    }
}
