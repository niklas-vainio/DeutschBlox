//
//  WordListElementView.swift
//  GermanLearning
//
//  Created by Niklas on 28/07/2021.
//  This file defines the view for one element of the all words list view

import SwiftUI

struct WordListElementView: View {
    // Take in an SRSData object
    var srs: SRSData
    
    // Static date formatter property
    static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        
        return formatter
    }()
    
    var body: some View {
        HStack {
            
            VStack {
                // Compound word view
                CompoundWordView(
                    compoundWord: vocabData[Int(srs.vocabId)].german,
                    article: vocabData[Int(srs.vocabId)].article,
                    showDefinitions: Binding.constant(false)
                )
                .scaleEffect(0.6)
                .padding(.horizontal, -50)
                //.fixedSize(horizontal: true, vertical: false)
                
                // Word ID bubble
                Text("#\(srs.vocabId)")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding(.horizontal, 10.0)
                    .background(Color.black)
                    .cornerRadius(10.0)
                    .scaleEffect(0.8)
            }
            
            Spacer()
            
            // Various statistics
            VStack {
                // Times seen
                HStack(spacing: 5.0) {
                    Text("Seen")
                        .fontWeight(.semibold)
                    Text("\(Int(srs.timesWrong) + Int(srs.timesMaybe) + Int(srs.timesRight) + 1)")
                        .foregroundColor(.blue)
                        .fontWeight(.semibold)
                    Text("times")
                        .fontWeight(.semibold)
                }
                .font(.title2)
                
                // Number of X, ? and ticks
                HStack(spacing: 5.0) {
                    Image(systemName: "xmark.square.fill")
                        .foregroundColor(.red)
                    Text("\(srs.timesWrong)")
                        .fontWeight(.semibold)
                    
                    Image(systemName: "questionmark.diamond.fill")
                        .foregroundColor(.yellow)
                    Text("\(srs.timesMaybe)")
                        .fontWeight(.semibold)
                    
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(.green)
                    Text("\(srs.timesRight)")
                        .fontWeight(.semibold)
                }
                
                // Check if word is due to be reviewed
                if (srs.nextShowing != nil) && (srs.nextShowing! < Date()) {
                    // Due to review text
                    HStack (spacing: 5.0) {
                        Text("Due to review")
                            .fontWeight(.semibold)
                        
                        Image(systemName: "arrow.triangle.2.circlepath")
                            .font(.title3)
                    }
                    .foregroundColor(.blue)
                } else {
                    // Time of next showing
                    HStack (spacing: 5.0){
                        Image(systemName: "calendar")
                            .font(.title3)
                            .foregroundColor(.blue)
                        
                        if srs.nextShowing != nil {
                            Text("\(srs.nextShowing!, formatter: Self.dateFormatter)")
                                .fontWeight(.semibold)
                        } else {
                            Text("Unkown date")
                                .fontWeight(.semibold)
                        }
                    }
                }
                
                
            }
        }
    }
    
    
}

struct WordListElementView_Previews: PreviewProvider {
    static var previews: some View {
        // No preview due as srs data cannot be passed in
        // WordListElementView()
        Text("No preview available")
    }
}
