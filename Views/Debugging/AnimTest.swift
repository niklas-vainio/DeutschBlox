//
//  AnimTest.swift
//  GermanLearning
//
//  Created by Niklas on 04/08/2021.
//

import SwiftUI

struct AnimTest: View {
    
    @State var xpos: CGFloat = -100
    
    var body: some View {
        GeometryReader {geometry in
            
            let width = geometry.size.width
            
            VStack {
                
                ForEach(0...5, id: \.self) {_ in
                    Rectangle()
                        .fill(Color.green)
                        .frame(width: 50, height: 50)
                        .position(x: xpos, y: 100)
                        .animation(.linear
                                    .speed(Double.random(in: 0.01...0.02))
                                    .repeatForever(autoreverses: false)
                                    .delay(Double.random(in: -1.0...1.0))
                        )
                        .onAppear {
                            xpos = CGFloat.random(in: 0...width)
                            
                            withAnimation {
                                xpos = width
                            }
                        }
                }
            }
        }
    }
}

struct AnimTest_Previews: PreviewProvider {
    static var previews: some View {
        AnimTest()
    }
}
