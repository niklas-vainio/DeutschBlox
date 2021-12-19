//
//  VocabPieChart.swift
//  GermanLearning
//
//  Created by Niklas on 28/07/2021.
//

import SwiftUI

struct VocabPieChart: View {
    
    // Take in a fraction to fill (from 0 to 1)
    let fillLevel: Double
    
    // Computed property which gives percent text
    var percentText: String {
        let percentFormatter = NumberFormatter()
        percentFormatter.numberStyle = .percent
        percentFormatter.maximumFractionDigits = 0
        return percentFormatter.string(from: NSNumber(value: fillLevel)) ?? "??"
    }
    
    var body: some View {
        GeometryReader {geometry in
            let width = geometry.size.width
            let height = geometry.size.height
            
            // Fit to box, using minimum dimension for width and height
            let radius = min(width, height) / 2
            
            ZStack {
                Group {
                    // Green filled arc
                    Path {path in
                        path.addArc(
                            center: CGPoint(
                                x: width / 2,
                                y: height / 2
                            ),
                            radius: radius,
                            startAngle: Angle(degrees: 0),
                            endAngle: Angle(degrees: 360 * fillLevel),
                            clockwise: false
                        )
                    }
                    .stroke(Color.green, lineWidth: 25)
                    
                    // Gray unfilled arc
                    Path {path in
                        path.addArc(
                            center: CGPoint(
                                x: width / 2,
                                y: height / 2
                            ),
                            radius: radius,
                            startAngle: Angle(degrees: 360 * fillLevel),
                            endAngle: Angle(degrees: 360),
                            clockwise: false
                        )
                    }
                    .stroke(Color.gray, lineWidth: 20)
                }
                .rotationEffect(Angle(degrees: -90.0))
                // Rotate left by 90º so arc starts at top
                
                Text("\(percentText)")
                    .fontWeight(.bold)
                    
            }
            
        }
    }
}

struct VocabPieChart_Previews: PreviewProvider {
    static var previews: some View {
        VocabPieChart(fillLevel: 0.8)
    }
}
