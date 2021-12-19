//
//  NewWordContinueButton.swift
//  GermanLearning
//
//  Created by Niklas on 23/07/2021.
//  This button is shown at the bottom of the screen in the main vocab view
//  The user presses continue to acknowledge they have understood a new word

import SwiftUI

struct NewWordContinueButton: View {
    // Take in a function to be run on button press
    var pressAction: () -> Void
    
    var body: some View {
        Button(action: pressAction) {
            // Button content
            ZStack {
                // Background rectangle
                Rectangle()
                    .fill(Color.purple)
                    .frame(maxWidth: .infinity, maxHeight: 150)
                
                HStack {
                    // Show English and arrow sign
                    Text("Continue")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(Color.white)
                    
                    Image(systemName: "chevron.right.2")
                        .font(.system(size: 32, weight: .bold))
                        .padding(.leading, 10.0)
                        .foregroundColor(Color.white)
                }
            }
        }
    }
}

struct NewWordContinueButton_Previews: PreviewProvider {
    static var previews: some View {
        NewWordContinueButton(pressAction: {})
    }
}
