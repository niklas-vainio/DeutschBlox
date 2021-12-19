//
//  BackgroundImage.swift
//  GermanLearning
//
//  Created by Niklas on 02/08/2021.
//  A simple view that just shows the notebook background image, filling as much space as possible
//  Puts background data in one place so it can be easily changed

import SwiftUI

struct BackgroundImage: View {
    var body: some View {
        Image("notebook")
            .resizable()
            .edgesIgnoringSafeArea(.all)
            .opacity(0.2)
    }
}

struct BackgroundImage_Previews: PreviewProvider {
    static var previews: some View {
        BackgroundImage()
    }
}
