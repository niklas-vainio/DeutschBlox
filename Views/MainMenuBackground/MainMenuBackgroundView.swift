//
//  MainMenuBackgroundView.swift
//  GermanLearning
//
//  Created by Niklas on 04/08/2021.
//  This is the view for the main menu background
//  Normal background image with moving words on top

import SwiftUI

struct MainMenuBackgroundView: View {
    var body: some View {
        ZStack {
            // Background image
            Image("notebook")
                .resizable()
                .edgesIgnoringSafeArea(.all)
            
            // Show to compound word views
            VStack {
                ForEach(1...50, id: \.self) {_ in
                    MainMenuBackgroundElementView(vocabIndex: Int.random(in: 0..<vocabData.count))
                        .scaleEffect(0.7)
                }
            }
        }
        //.opacity(0.2)
    }
}

struct MainMenuBackgroundView_Previews: PreviewProvider {
    static var previews: some View {
        MainMenuBackgroundView()
    }
}
