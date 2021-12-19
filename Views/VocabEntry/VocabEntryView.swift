//
//  VocabEntryView.swift
//  GermanLearning
//
//  Created by Niklas on 14/07/2021.
//  This file defines the view for a vocab entry
//  Has a state to determine whether or not the definitions are shown

import SwiftUI

struct VocabEntryView: View {
    var vocabEntry: VocabEntry
    
    // Stores a binding for whether to show the english
    @Binding var showEnglish: Bool
    
    // Store managed object context, and a fetch request to the srs data
    @Environment(\.managedObjectContext) var context
    @FetchRequest(
        entity: SRSData.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \SRSData.vocabId, ascending: true)]
    ) var srsElements: FetchedResults<SRSData>
    
    var body: some View {
        VStack {
            // Show German
            CompoundWordView(compoundWord: vocabEntry.german,
                             article: vocabEntry.article,
                             showDefinitions: $showEnglish)
                .padding(.horizontal, 5)
                .fixedSize(horizontal: false, vertical: true)
            
            // Dividing rectangle with frequency in the middle
            ZStack {
                // Only show divider if showing English
                // Make size really small if not shown
                Rectangle()
                    .fill(Color.black)
                    .frame(width: (showEnglish ? 300 : 1), height: 3)
                    .cornerRadius(5.0)
                    //.animation(.easeInOut)
                
                // Frequency text
                Text("#\(String(vocabEntry.id))")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding(.horizontal, 10.0)
                    .background(Color.black)
                    .cornerRadius(10.0)
            }

            if showEnglish {
                VStack {
                    // Number of ticks/crosses
                    HStack (spacing: 5.0) {
                        Image(systemName: "xmark.square.fill")
                            .foregroundColor(.red)
                        Text("\(getSRSData()?.timesWrong ?? 0)")
                            .fontWeight(.semibold)
                        
                        Image(systemName: "questionmark.diamond.fill")
                            .foregroundColor(.yellow)
                        Text("\(getSRSData()?.timesMaybe ?? 0)")
                            .fontWeight(.semibold)
                        
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundColor(.green)
                        Text("\(getSRSData()?.timesRight ?? 0)")
                            .fontWeight(.semibold)
                    }
                    
                    // English word
                    Text(vocabEntry.english)
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(Color.blue)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 20.0)
                        .padding(.bottom, 10.0)
                        .fixedSize(horizontal: false, vertical: true)
                    
                    // German example sentence
                    Text(vocabEntry.germanSentence)
                        .font(.title3)
                        .fontWeight(.semibold)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 20.0)
                        .padding(.bottom, 5.0)
                        .fixedSize(horizontal: false, vertical: true)
                    
                    // English example sentence
                    Text(vocabEntry.englishSentence)
                        .font(.title3)
                        .fontWeight(.semibold)
                        .foregroundColor(.blue)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 20.0)
                        .fixedSize(horizontal: false, vertical: true)
                }
                .transition(.riseAndFade)
            }
        }
    }
    
    func getSRSData() -> SRSData? {
        // Function to get the SRSData object associated with this vocab entry
        // Returns nil if no SRSData object is found
        return srsElements.first(where: {
            Int($0.vocabId) == vocabEntry.id
        })
    }
}

struct VocabEntryView_Previews: PreviewProvider {
    @Binding var animTest: Bool
    
    static var previews: some View {
        VocabEntryView(vocabEntry: vocabData[1909],
                       showEnglish: Binding.constant(true))
    }
}
