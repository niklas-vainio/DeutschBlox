//
//  CompoundWordView.swift
//  GermanLearning
//
//  Created by Niklas on 14/07/2021.
//  This file defines a view that shows all the data for a compound word
//  SHows all parts in sequence with their definitions

import SwiftUI

struct CompoundWordView: View {
    var compoundWord: CompoundWord
    var article: String
    
    // Binding for whether to show definitions
    @Binding var showDefinitions: Bool
    
    var body: some View {
        VStack {
            HStack{
                // Article only if it exists
                if (!article.isEmpty) {
                    Text(article)
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(ColorManager.getArticleColor(for: article))
                        .padding(.bottom, -5.0)
                }
                
                // Full word text
                Text(compoundWord.fullWord)
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(.bottom, -5.0)
            }
            
            // Show views for each word part in an HStack
            HStack(alignment: .top, spacing: 0.0) {
                
                ForEach(compoundWord.parts, id: \.text){part in
                    WordPartView(wordPart: part,
                                 showDefinition: $showDefinitions)
                }

            }
            .frame(maxWidth: .infinity)
        }
    }
}

struct CompoundWordView_Previews: PreviewProvider {
    static var previews: some View {
        
        CompoundWordView(
            compoundWord: vocabData[1788].german,
            article: vocabData[576].article,
            showDefinitions: Binding.constant(true)
        )
        
        /*CompoundWordView(
            compoundWord: CompoundWord(
                fullWord: "gesellschaftlich",
                parts: [
                    WordPart(text: "ge", english: ""),
                    WordPart(text: "sellschaft", english: "definiton, and what happejns when it gets k"),
                    WordPart(text: "lich", english: ""),
                ]
            ),
            article: ""
        )*/
        
    }
}
