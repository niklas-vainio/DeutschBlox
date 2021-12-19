//
//  ShowEnglishButton.swift
//  GermanLearning
//
//  Created by Niklas on 19/07/2021.
//  This file defines the view for the "show english" button on the main vocab screen

import SwiftUI

struct ShowEnglishButton: View {
    // Take in a function to be run when the button is pressed
    var pressAction: () -> Void
    
    var body: some View {
        Button(action: pressAction) {
            // Button content
            ZStack {
                // Background rectangle
                Rectangle()
                    .fill(Color.blue)
                    .frame(maxWidth: .infinity, maxHeight: 150)
                
                HStack {
                    // Show English and arrow sign
                    Text("Show English")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(Color.white)
                    
                    Image(systemName: "arrow.2.squarepath")
                        .font(.system(size: 32, weight: .bold))
                        .padding(.leading, 10.0)
                        .foregroundColor(Color.white)
                }
            }
        }
    }
}

struct ShowEnglishButton_Previews: PreviewProvider {
    static var previews: some View {
        ShowEnglishButton(pressAction: {})
    }
}
