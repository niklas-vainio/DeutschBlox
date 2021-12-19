//
//  UnderstandingButtons.swift
//  GermanLearning
//
//  Created by Niklas on 19/07/2021.
//  This file defines the view for the three buttons which the user uses to chose how well they have understood the word
//  Tick button, ? button and X button in a line

import SwiftUI

struct UnderstandingButtons: View {
    // Function top be run when button is pressed -> takes in button type as an argument
    var pressAction: (UnderstandingButtonType) -> Void
    
    var body: some View {
        HStack(spacing: 0.0) {
            // X button
            Button(action: {
                pressAction(.cross)
            }) {
                ZStack {
                    // Background rectangle
                    Rectangle()
                        .fill(Color.red)
                        .frame(maxWidth: .infinity, maxHeight: 150)
                    // Tick Image
                    Image(systemName: "xmark.square.fill")
                        .foregroundColor(Color.white)
                        .font(.system(size: 50, weight: .semibold))
                }
            }
            
            // ? button
            Button(action: {
                pressAction(.questionMark)
            }) {
                ZStack {
                    // Background rectangle
                    Rectangle()
                        .fill(Color.yellow)
                        .frame(maxWidth: .infinity, maxHeight: 150)
                    // Tick Image
                    Image(systemName: "questionmark.diamond.fill")
                        .foregroundColor(Color.white)
                        .font(.system(size: 50, weight: .semibold))
                }
            }
            
            // Tick button
            Button(action: {
                pressAction(.tick)
            }) {
                ZStack {
                    // Background rectangle
                    Rectangle()
                        .fill(Color.green)
                        .frame(maxWidth: .infinity, maxHeight: 150)
                    // Tick Image
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(Color.white)
                        .font(.system(size: 50, weight: .semibold))
                }
            }
        }
    }
}

struct UnderstandingButtons_Previews: PreviewProvider {
    static var previews: some View {
        UnderstandingButtons(
            pressAction: {_ in}
        )
    }
}
