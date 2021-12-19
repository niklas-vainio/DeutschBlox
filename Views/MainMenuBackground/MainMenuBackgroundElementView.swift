//
//  MainMenuBackgroundElementView.swift
//  GermanLearning
//
//  Created by Niklas on 04/08/2021.
//  This view is for one compound word that moves across the screen repeatedly

import SwiftUI

struct MainMenuBackgroundElementView: View {
    
    @State var xpos: CGFloat = 0
    @State var opacity: Double = 0
    
    @State var speed: Double = Double.random(in: 0.1...0.2)
    @State var delay: Double = Double.random(in: 0...2.0)
    
    let vocabIndex: Int
    
    var body: some View {
        GeometryReader {geometry in
            let width = geometry.size.width
       
            CompoundWordView(
                compoundWord: vocabData[vocabIndex].german,
                article: vocabData[vocabIndex].article,
                showDefinitions: Binding.constant(false)
            )
            .position(x: xpos)
            .animation(nil)
            .opacity(opacity)
            .animation(.easeInOut.speed(speed).delay(delay).repeatForever(autoreverses: true))
            .onAppear {
                xpos = CGFloat.random(in: -100...(width + 100))
                
                withAnimation {
                    opacity = 1.0
                }
            }
        }
    }
}

struct MainMenuBackgroundElementView_Previews: PreviewProvider {
    static var previews: some View {
        MainMenuBackgroundElementView(
            vocabIndex: 50
        )
    }
}
