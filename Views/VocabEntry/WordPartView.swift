//
//  WordPartView.swift
//  GermanLearning
//
//  Created by Niklas on 14/07/2021.
//  This file defines a view for a word part
//  Shows the word part itself with the definition underneath

import SwiftUI

struct WordPartView: View {
    // Stores a WordPart variable, which defines this view
    var wordPart: WordPart
    
    // Binding to show definition or not
    @Binding var showDefinition: Bool
    
    var body: some View {
        VStack {
            Text(wordPart.text)
                .font(.title)
                .fontWeight(.heavy)
                .foregroundColor(Color.white)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 3.0)
                .background(ColorManager.getWordColor(for: wordPart))
                .cornerRadius(8)
                .fixedSize(horizontal: true, vertical: false)
            
            // Show definition if enabled and not empty
            if (showDefinition && !(wordPart.english.isEmpty)) {
                Text(wordPart.english)
                    .fontWeight(.medium)
                    .multilineTextAlignment(.center)
                    .font(.caption)
                    .padding(.horizontal, 5.0)
                    .transition(.delayedDropAndFade)
            }
        }

    }
}

struct WordPartView_Previews: PreviewProvider {
    static var previews: some View {
        WordPartView(wordPart: WordPart(
                        text: "sellschaft",
                        english: "society/company"
        ), showDefinition: Binding.constant(true))
    }
}
